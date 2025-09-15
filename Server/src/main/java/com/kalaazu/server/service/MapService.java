package com.kalaazu.server.service;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.persistence.service.MapsService;
import com.kalaazu.server.entities.*;
import com.kalaazu.server.event.SendCommands;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.commands.out.settings.ClientSettingsCommand;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * Map Service.
 * ==========
 *
 * This service is responsible for managing the state of all game maps,
 * including the entities within them (NPCs, players, portals, etc.).
 * It handles the initial loading of map data from the database and the
 * process of initializing a player when they join a map.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Service
@RequiredArgsConstructor
public class MapService implements Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.MAP;

    private final ApplicationContext ctx;
    private final TaskScheduler taskScheduler;
    private final KalaazuConfig config;
    private final MapsService service;

    private final Map<Short, Map<Integer, Npc>> npcs = new HashMap<>();
    private final Map<Short, Map<Integer, Collectable>> collectables = new HashMap<>();
    private final Map<Short, Map<Integer, Station>> stations = new HashMap<>();
    private final Map<Short, Map<Integer, Portal>> portals = new HashMap<>();
    private final Map<Short, Map<Integer, Player>> players = new HashMap<>();

    private Map<Short, MapsEntity> maps;
    private boolean isInitialized = false;

    /**
     * Initializes the map service.
     *
     * This method loads all map configurations from the database and then calls
     * `initializeMap` for each one to populate them with their respective entities.
     */
    public void initialize() {
        if (isInitialized) {
            return;
        }
        isInitialized = true;

        info("Loading maps..");
        maps = service.findAll()
                .stream()
                .collect(Collectors.toMap(MapsEntity::getId, (v) -> v));

        maps.forEach(this::initializeMap);
    }

    /**
     * Initializes a single map with its entities.
     *
     * This method reads the configuration for a given map and creates all the
     * necessary NPCs, collectables, stations, and portals, assigning them
     * initial positions and unique IDs.
     *
     * @param mapId The ID of the map to initialize.
     * @param map   The map's entity data from the database.
     */
    private void initializeMap(Short mapId, MapsEntity map) {
        info("Initializing map {}", map.getName());

        var stationIdGenerator = new AtomicInteger();
        var portalIdGenerator = new AtomicInteger();

        var npcs = new HashMap<Integer, Npc>();
        map.getMapsNpcs()
                .forEach(npc -> {
                    for (int i = 0; i < npc.getAmount(); i++) {
                        var n = ctx.getBean(Npc.class);
                        n.setMap(map);
                        n.setNpc(npc.getNpcsByNpcsId());
                        n.setSpeed(n.getNpc().getSpeed());
                        n.setPosition(Vector.random(map.getLimits().margin()));

                        int id;
                        do {
                            id = ThreadLocalRandom.current().nextInt(Integer.MIN_VALUE, 0);
                        } while (npcs.containsKey(id));
                        n.setId(id);

                        npcs.put(id, n);
                    }
                });

        var collectables = new HashMap<Integer, Collectable>();
        map.getMapsCollectables()
                .forEach(collectable -> {
                    for (int i = 0; i < collectable.getAmount(); i++) {
                        var c = new Collectable(collectable.getCollectablesByCollectablesId(), map);
                        c.setPosition(Vector.random(collectable.getRegion()));

                        int id;
                        do {
                            id = ThreadLocalRandom.current().nextInt();
                        } while (collectables.containsKey(id));
                        c.setId(id);

                        collectables.put(id, c);
                    }
                });

        var stations = map.getMapsStations()
                .stream()
                .map(station -> {
                    var s = new Station(station, map);
                    s.setId(stationIdGenerator.getAndIncrement());
                    s.setPosition(station.getPosition());

                    return s;
                })
                .collect(Collectors.toMap(Station::getId, s -> s));

        var portals = map.getMapsPortals()
                .stream()
                .map(portal -> {
                    var p = new Portal(portal, map);
                    p.setId(portalIdGenerator.getAndIncrement());
                    p.setPosition(portal.getPosition());

                    return p;
                })
                .collect(Collectors.toMap(Portal::getId, p -> p));

        info("Initialized {} npcs, {} collectables, {} stations and {} portals", npcs.size(), collectables.size(), stations.size(), portals.size());

        this.npcs.put(mapId, npcs);
        this.collectables.put(mapId, collectables);
        this.stations.put(mapId, stations);
        this.portals.put(mapId, portals);
    }

    /**
     * Retrieves all NPCs for a given map.
     *
     * @param mapId The ID of the map.
     *
     * @return A `Collection` containing all NPCs on the map, or an empty collection if the map is not found.
     */
    public Collection<Npc> getNpcs(short mapId) {
        return npcs.getOrDefault(mapId, Map.of()).values();
    }

    /**
     * Retrieves all collectables for a given map.
     *
     * @param mapId The ID of the map.
     *
     * @return A `Collection` containing all collectables on the map, or an empty collection if the map is not found.
     */
    public Collection<Collectable> getCollectables(short mapId) {
        return collectables.getOrDefault(mapId, Map.of()).values();
    }

    /**
     * Retrieves all players for a given map.
     *
     * @param mapId The ID of the map.
     *
     * @return A `Collection` containing all players on the map, or an empty collection if the map is not found.
     */
    public Map<Integer, Player> getPlayers(short mapId) {
        return players.getOrDefault(mapId, Map.of());
    }

    /**
     * Handles the logic for initializing a player when they join a map.
     *
     * This method creates the player's `Player` entity, adds them to the map,
     * starts their server-side tick, and sends them the creation commands for
     * all visible entities on the map.
     *
     * @param session The game session of the player to initialize.
     */
    public void initializePlayer(GameSession session) {
        var account = session.getAccount();
        var ship = session.getShip();
        var config = session.getConfiguration();
        var map = session.getMapId();

        if (!maps.containsKey(map)) {
            info("Invalid map {}!", map);

            return;
        }

        info("Initializing player {}", account.getId());

        var player = ctx.getBean(Player.class);
        player.setGameSession(session);
        player.setMap(maps.get(map));
        player.setId(account.getId());
        player.setPosition(ship.getPosition());
        player.setSpeed(config.getSpeed());
        player.setAccount(account);
        player.setShip(ship);
        player.setConfig(config);

        session.setPlayer(player);
        this.players.computeIfAbsent(map, k -> new HashMap<>()).put(player.getId(), player);

        var commands = new ArrayList<OutCommand>();

        // Send only nearby entities to the player
        findNpcsInRadius(map, player.getPosition())
                .stream()
                .map(Npc::getEntityCreationCommand)
                .forEach(commands::add);
        findCollectablesInRadius(map, player.getPosition())
                .stream()
                .map(Collectable::getEntityCreationCommand)
                .forEach(commands::add);

        // Stations and portals are always sent
        getStations(map).forEach(s -> commands.add(s.getEntityCreationCommand()));
        getPortals(map).forEach(p -> commands.add(p.getEntityCreationCommand()));

        commands.add(new ClientSettingsCommand(ServerCommands.MAP_READY_HANDSHAKE, 0));

        taskScheduler.scheduleAtFixedRate(player::tick, Duration.ofSeconds(1));

        ctx.publishEvent(new SendCommands(session, commands));
    }

    private List<Npc> findNpcsInRadius(short mapId, Vector center) {
        return findInRadius(npcs.get(mapId), center, config.getGame().getRenderDistance());
    }

    private List<Collectable> findCollectablesInRadius(short mapId, Vector center) {
        return findInRadius(collectables.get(mapId), center, config.getGame().getRenderDistance());
    }

    /**
     * Retrieves all stations for a given map.
     *
     * @param mapId The ID of the map.
     *
     * @return A `Collection` containing all stations on the map, or an empty collection if the map is not found.
     */
    public Collection<Station> getStations(short mapId) {
        return stations.getOrDefault(mapId, Map.of()).values();
    }

    /**
     * Retrieves all portals for a given map.
     *
     * @param mapId The ID of the map.
     *
     * @return A `Collection` containing all portals on the map, or an empty collection if the map is not found.
     */
    public Collection<Portal> getPortals(short mapId) {
        return portals.getOrDefault(mapId, Map.of()).values();
    }

    /**
     * Finds all entities within a given radius of a central point.
     *
     * @param entities The entities to search through.
     * @param center   The center of the search radius.
     * @param radius   The search radius.
     * @param <T>      Type of the map entity.
     *
     * @return A list of entities within the radius.
     */
    private <T extends MapEntity> List<T> findInRadius(Map<Integer, T> entities, Vector center, double radius) {
        if (entities == null || entities.isEmpty()) {
            return Collections.emptyList();
        }

        // Use squared distance to avoid expensive square root operations
        double radiusSq = radius * radius;

        return entities.values().stream()
                .filter(entity -> entity.getPosition().dst2(center) <= radiusSq)
                .collect(Collectors.toList());
    }
}

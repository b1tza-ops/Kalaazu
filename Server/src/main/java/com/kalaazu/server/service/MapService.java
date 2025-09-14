package com.kalaazu.server.service;

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
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * Map service.
 * ============
 * <p>
 * Service for game maps.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Service
@RequiredArgsConstructor
public class MapService implements Logger {
    public static final double VISIBILITY_RADIUS = 3000;

    // Player IDs are their account ID, starting from 1 and going up.
    // We partition the rest of the integer space to prevent ID collisions.

    // Dynamic entities get huge random ranges to make collisions statistically impossible.
    private static final int NPC_ID_RANGE = 200_000_000;
    private static final int COLLECTABLE_ID_RANGE = 200_000_000;
    private static final int COLLECTABLE_ID_UPPER_BOUND = Integer.MAX_VALUE;
    private static final int NPC_ID_UPPER_BOUND = COLLECTABLE_ID_UPPER_BOUND - COLLECTABLE_ID_RANGE;
    private static final int NPC_ID_LOWER_BOUND = NPC_ID_UPPER_BOUND - NPC_ID_RANGE;
    private static final int COLLECTABLE_ID_LOWER_BOUND = COLLECTABLE_ID_UPPER_BOUND - COLLECTABLE_ID_RANGE;

    private final TaskScheduler taskScheduler;
    private final MapsService service;
    private final ApplicationContext ctx;

    @Getter
    private final LoggingCategory category = LoggingCategory.MAP;
    private final Map<Short, Map<Integer, Npc>> npcs = new HashMap<>();
    private final Map<Short, Map<Integer, Collectable>> collectables = new HashMap<>();
    private final Map<Short, Map<Integer, Station>> stations = new HashMap<>();
    private final Map<Short, Map<Integer, Portal>> portals = new HashMap<>();
    private final Map<Short, Map<Integer, Player>> players = new HashMap<>();
    private Map<Short, MapsEntity> maps;

    private boolean isInitialized = false;

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

    private void initializeMap(Short mapId, MapsEntity map) {
        info("Initializing map {}", map.getName());

        var r = new Random();
        var stationIdGenerator = new AtomicInteger();
        var portalIdGenerator = new AtomicInteger();

        var npcs = new HashMap<Integer, Npc>();
        map.getMapsNpcs()
                .stream()
                .flatMap(npc -> IntStream.range(0, npc.getAmount())
                        .mapToObj(i -> {
                            var n = ctx.getBean(Npc.class);
                            n.setMap(map);
                            n.setNpc(npc.getNpcsByNpcsId());
                            n.setSpeed(n.getNpc().getSpeed());
                            n.setPosition(Vector.random(map.getLimits().margin()));

                            return n;
                        }))
                .forEach(n -> {
                    int id;
                    do {
                        id = r.nextInt(NPC_ID_RANGE) + NPC_ID_LOWER_BOUND;
                    } while (npcs.containsKey(id));
                    n.setId(id);
                    npcs.put(id, n);
                });

        var collectables = new HashMap<Integer, Collectable>();
        map.getMapsCollectables()
                .stream()
                .flatMap(collectable -> IntStream.range(0, collectable.getAmount())
                        .mapToObj(i -> {
                            var c = new Collectable(collectable.getCollectablesByCollectablesId(), map);
                            c.setPosition(Vector.random(collectable.getRegion()));

                            return c;
                        }))
                .forEach(c -> {
                    int id;
                    do {
                        id = r.nextInt(COLLECTABLE_ID_RANGE) + COLLECTABLE_ID_LOWER_BOUND;
                    } while (collectables.containsKey(id));
                    c.setId(id);
                    collectables.put(id, c);
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

    public Collection<Npc> getNpcs(short mapId) {
        return npcs.getOrDefault(mapId, Map.of()).values();
    }

    public Collection<Collectable> getCollectables(short mapId) {
        return collectables.getOrDefault(mapId, Map.of()).values();
    }

    public Collection<Station> getStations(short mapId) {
        return stations.getOrDefault(mapId, Map.of()).values();
    }

    public Collection<Portal> getPortals(short mapId) {
        return portals.getOrDefault(mapId, Map.of()).values();
    }

    public List<Npc> findNpcsInRadius(short mapId, Vector center, double radius) {
        return findInRadius(npcs.get(mapId), center, radius);
    }

    public List<Collectable> findCollectablesInRadius(short mapId, Vector center, double radius) {
        return findInRadius(collectables.get(mapId), center, radius);
    }

    /**
     * Finds all entities within a given radius of a central point.
     *
     * @param entities The entities to search through.
     * @param center   The center of the search radius.
     * @param radius   The search radius.
     * @param <T>      Type of the map entity.
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
        player.setSpeed((short) (config.getSpeed() + 1000));
        player.setAccount(account);

        session.setPlayer(player);

        var commands = new ArrayList<OutCommand>();

        // Send only nearby entities to the player
        findNpcsInRadius(map, player.getPosition(), VISIBILITY_RADIUS)
                .stream()
                .map(Npc::getEntityCreationCommand)
                .forEach(commands::add);
        findCollectablesInRadius(map, player.getPosition(), VISIBILITY_RADIUS)
                .stream()
                .map(Collectable::getEntityCreationCommand)
                .forEach(commands::add);
        getStations(map)
                .stream()
                .map(Station::getEntityCreationCommand)
                .forEach(commands::add);
        getPortals(map)
                .stream()
                .map(Portal::getEntityCreationCommand)
                .forEach(commands::add);

        commands.add(new ClientSettingsCommand(ServerCommands.MAP_READY_HANDSHAKE, 0));

        taskScheduler.scheduleAtFixedRate(player::tick, Duration.ofSeconds(1));

        ctx.publishEvent(new SendCommands(session, commands));
    }
}

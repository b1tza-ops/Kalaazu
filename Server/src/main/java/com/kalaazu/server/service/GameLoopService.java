package com.kalaazu.server.service;

import com.artemis.*;
import com.artemis.utils.IntBag;
import com.kalaazu.KalaazuConfig;
import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.*;
import com.kalaazu.server.ecs.GameLoop;
import com.kalaazu.server.ecs.WorldAction;
import com.kalaazu.server.ecs.component.EntityTypeComponent;
import com.kalaazu.server.ecs.component.IdComponent;
import com.kalaazu.server.ecs.component.PlayerComponent;
import com.kalaazu.server.ecs.component.attack.HealthComponent;
import com.kalaazu.server.ecs.component.attack.TargetedByComponent;
import com.kalaazu.server.ecs.component.map.*;
import com.kalaazu.server.ecs.component.movement.MovementComponent;
import com.kalaazu.server.ecs.component.movement.SpeedComponent;
import com.kalaazu.server.ecs.component.npc.NpcAiComponent;
import com.kalaazu.server.ecs.component.npc.NpcComponent;
import com.kalaazu.server.ecs.component.view.ViewComponent;
import com.kalaazu.server.ecs.component.view.VisibleByComponent;
import com.kalaazu.server.ecs.entity.EntityType;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;

/**
 * Manages the game's core logic using an Entity-Component-System (ECS) architecture.
 *
 * This service is central to the game's operation. It is responsible for creating and managing
 * a separate ECS `World` for each game map. It discovers and registers all ECS `System` beans,
 * schedules the periodic execution of each world's game loop, and provides an interface
 * for creating and retrieving game entities (like players, NPCs, portals, etc.) within
 * these worlds. It also allows for scheduling actions to be executed safely within a
 * specific map's game loop tick.
 *
 * @author manulaiko
 * @example ```java
 * // This service is managed by Spring and should be injected.
 * // @Service
 * // public class SomeOtherService {
 * //
 * //     @Autowired
 * //     private GameLoopService gameLoopService;
 * //
 * //     public void initializeGame() {
 * //         MapsEntity firstMap = //... load map from database
 * //         gameLoopService.initializeMap(firstMap);
 * //     }
 * //
 * //     public void movePlayer(short mapId, int playerId, Vector destination) {
 * //         gameLoopService.addAction(mapId, (world) -> {
 * //             world.edit(playerId)
 * //                  .create(MovementIntentComponent.class)
 * //                  .setDestination(destination);
 * //         });
 * //     }
 * // }
 * ```
 * @see com.kalaazu.server.ecs.GameLoop
 * @see com.artemis.World
 * @see com.kalaazu.server.ecs.WorldAction
 */
@Service
@RequiredArgsConstructor
public class GameLoopService implements Logger {
    private final Map<Short, GameLoop> gameLoops = new HashMap<>();
    private final TaskScheduler taskScheduler;
    private final KalaazuConfig config;
    private final ApplicationContext ctx;
    @Getter
    private final LoggingCategory category = LoggingCategory.GAME_LOOP;

    /**
     * Initializes the ECS engine for a given map.
     * This method sets up a new `World` instance for the specified map, discovers all
     * `BaseSystem` beans from the Spring context, and adds them to the world. It then
     * creates and schedules a `GameLoop` to run at a fixed rate, effectively starting
     * the simulation for that map.
     *
     * @param map The database entity representing the map to initialize.
     *
     * @example ```java
     * MapsEntity spaceMap = mapRepository.findById(1);
     * gameLoopService.initializeMap(spaceMap);
     * ```
     */
    public void initializeMap(MapsEntity map) {
        var builder = new WorldConfigurationBuilder();

        // Get all system bean names from Spring and create new instances for the world.
        // This respects the @Scope("prototype") on stateful systems.
        var systemBeanNames = ctx.getBeanNamesForType(BaseSystem.class);
        for (var beanName : systemBeanNames) {
            builder.with(ctx.getBean(beanName, BaseSystem.class));
        }

        var config = builder.build();

        // Create and schedule the game loop on the shared scheduler
        var gameLoop = new GameLoop(map.getId(), new World(config));
        taskScheduler.scheduleAtFixedRate(gameLoop, Duration.ofMillis(this.config.getGame().getTickRate())); // 20 ticks/sec

        gameLoops.put(map.getId(), gameLoop);

        info("Initialized and started game loop for map {} ({})", map.getName(), map.getId());
    }

    /**
     * A private helper method to encapsulate the boilerplate logic of creating an entity.
     *
     * @param mapId          The ID of the map where the entity will be created.
     * @param entityIdForLog The ID used for logging purposes.
     * @param entityType     The type of the entity.
     * @param componentAdder A consumer that receives an `EntityEdit` to add the specific components.
     *
     * @return The integer ID of the newly created entity, or -1 on failure.
     */
    private int createEntity(short mapId, int entityIdForLog, EntityType entityType, Consumer<EntityEdit> componentAdder) {
        var world = this.getEngine(mapId);
        if (world == null) {
            error("Could not add {} {} to map {}: Engine not found.", entityType.name().toLowerCase(), entityIdForLog, mapId);
            return -1;
        }

        int entityId = world.create();
        var edit = world.edit(entityId);

        edit.create(EntityTypeComponent.class)
                .setType(entityType);

        componentAdder.accept(edit);

        return entityId;
    }

    /**
     * Adds an action to the specified map's game loop.
     * This method provides a thread-safe way to interact with the ECS world. The provided
     * `WorldAction` is queued and will be executed at the beginning of the next game
     * loop tick for the specified map, preventing concurrent modification issues.
     *
     * @param mapId  The ID of the map where the action should be executed.
     * @param action The `WorldAction` to execute, typically a lambda.
     *
     * @example ```java
     * short mapId = 1;
     * int entityId = 123;
     * gameLoopService.addAction(mapId, (world) -> {
     * world.delete(entityId);
     * });
     * ```
     */
    public void addAction(short mapId, WorldAction action) {
        var gameLoop = gameLoops.get(mapId);
        if (gameLoop == null) {
            error("Could not add action to map {}: Game loop not found.", mapId);
            return;
        }

        gameLoop.addAction(action);
    }

    /**
     * Creates a new player entity in the specified map's ECS world.
     * This method instantiates a new entity and populates it with all the necessary
     * components for a player, such as `PositionComponent`, `PlayerComponent`,
     * `IdComponent`, and `ViewComponent`, using data from the provided entities.
     *
     * @param map     The map entity where the player is being added.
     * @param session The player's active `GameSession`.
     * @param account The player's `AccountsEntity`.
     * @param ship    The player's `AccountsShipsEntity`.
     * @param config  The player's active `AccountsConfigurationsEntity`.
     *
     * @return The integer ID of the newly created entity in the ECS world, or -1 if the map's world was not found.
     *
     * @example ```java
     * int playerEntityId = gameLoopService.addPlayer(map, session, account, ship, config);
     * ```
     */
    public int addPlayer(MapsEntity map, GameSession session, AccountsEntity account, AccountsShipsEntity ship, AccountsConfigurationsEntity config) {
        return createEntity(map.getId(), account.getId(), EntityType.PLAYER, (edit) -> {
            // Create and add all necessary components
            edit.create(PositionComponent.class)
                    .setPosition(ship.getPosition());

            edit.create(SpeedComponent.class)
                    .setSpeed(config.getSpeed());

            edit.create(TargetedByComponent.class);

            edit.create(HealthComponent.class)
                    .setHealth(ship.getHealth())
                    .setMaxHealth(config.getHealth())
                    .setShield(ship.getShield())
                    .setMaxShield(ship.getShield());

            edit.create(PlayerComponent.class)
                    .setSession(session)
                    .setAccount(account)
                    .setShip(ship)
                    .setConfig(config)
                    .setMap(map);

            edit.create(IdComponent.class)
                    .setId(account.getId());

            edit.create(VisibleByComponent.class);
            edit.create(ViewComponent.class);
        });
    }

    public World getEngine(short mapId) {
        return gameLoops.get(mapId).getWorld();
    }

    /**
     * Creates a new collectable entity in the specified map's ECS world.
     * This method instantiates a new entity and populates it with components required
     * for a collectable item, such as `PositionComponent`, `IdComponent`, and `CollectableComponent`.
     *
     * @param mapId       The ID of the map where the collectable will be added.
     * @param collectable The `CollectablesEntity` defining the type of collectable.
     * @param position    The `Vector` position of the collectable on the map.
     * @param id          The unique ID to assign to this collectable entity.
     *
     * @example ```java
     * gameLoopService.addCollectable(map.getId(), bonusBox, new Vector(2500, 3000), 512);
     * ```
     */
    public void addCollectable(short mapId, CollectablesEntity collectable, Vector position, int id) {
        createEntity(mapId, id, EntityType.COLLECTABLE, (edit) -> {
            edit.create(PositionComponent.class)
                    .setPosition(position);

            edit.create(IdComponent.class)
                    .setId(id);

            edit.create(CollectableComponent.class)
                    .setType(collectable);
        });
    }

    /**
     * Creates a new station entity in the specified map's ECS world.
     * This method instantiates a new entity and populates it with components required
     * for a station, such as `PositionComponent`, `IdComponent`, and `StationComponent`.
     *
     * @param mapId   The ID of the map where the station will be added.
     * @param station The `MapsStationsEntity` containing the station's data and position.
     * @param id      The unique ID to assign to this station entity.
     *
     * @example ```java
     * gameLoopService.addStation(map.getId(), eicBaseStation, 1024);
     * ```
     */
    public void addStation(short mapId, MapsStationsEntity station, int id) {
        createEntity(mapId, id, EntityType.STATION, (edit) -> {
            edit.create(PositionComponent.class)
                    .setPosition(station.getPosition());

            edit.create(IdComponent.class)
                    .setId(id);

            edit.create(StationComponent.class)
                    .setStation(station);
        });
    }

    /**
     * Creates a new portal entity in the specified map's ECS world.
     * This method instantiates a new entity and populates it with components required
     * for a portal, such as `PositionComponent`, `IdComponent`, and `PortalComponent`.
     *
     * @param mapId  The ID of the map where the portal will be added.
     * @param portal The `MapsPortalsEntity` containing the portal's data and position.
     * @param id     The unique ID to assign to this portal entity.
     *
     * @example ```java
     * gameLoopService.addPortal(map.getId(), x1toX2Portal, 2048);
     * ```
     */
    public void addPortal(short mapId, MapsPortalsEntity portal, int id) {
        createEntity(mapId, id, EntityType.PORTAL, (edit) -> {
            edit.create(PositionComponent.class)
                    .setPosition(portal.getPosition());

            edit.create(IdComponent.class)
                    .setId(id);

            edit.create(PortalComponent.class)
                    .setPortal(portal);
        });
    }

    /**
     * Creates a new NPC entity in the specified map's ECS world.
     * This method instantiates a new entity and populates it with components required
     * for an NPC, such as `SpeedComponent`, `PositionComponent`, `IdComponent`, and `NpcComponent`.
     *
     * @param map      The map entity where the NPC is being added.
     * @param npc      The `NpcsEntity` containing the base stats and information for this NPC.
     * @param position The initial `Vector` position of the NPC on the map.
     * @param id       The unique ID to assign to this NPC entity.
     *
     * @example ```java
     * gameLoopService.addNpc(map, streunerNpc, new Vector(1000, 1000), 256);
     * ```
     */
    public void addNpc(MapsEntity map, NpcsEntity npc, Vector position, int id) {
        createEntity(map.getId(), id, EntityType.NPC, (edit) -> {
            edit.create(SpeedComponent.class)
                    .setSpeed(npc.getSpeed());

            edit.create(PositionComponent.class)
                    .setPosition(position);

            edit.create(IdComponent.class)
                    .setId(id);

            edit.create(NpcComponent.class)
                    .setNpc(npc);

            edit.create(MapComponent.class)
                    .setLimits(map.getLimits());

            edit.create(NpcAiComponent.class)
                    .setAi(npc.getAi());

            edit.create(VisibleByComponent.class);

            edit.create(MovementComponent.class);

            edit.create(HealthComponent.class)
                    .setHealth(npc.getHealth())
                    .setMaxHealth(npc.getHealth())
                    .setShield(npc.getShield())
                    .setMaxShield(npc.getShield());
        });
    }

    /**
     * Retrieves all NPC entities for a given map.
     * This is a convenience method that calls `getEntities` with an aspect for `NpcComponent`.
     *
     * @param mapId The ID of the map.
     *
     * @return An `IntBag` containing the entity IDs of all NPCs on the specified map.
     *
     * @example ```java
     * IntBag npcs = gameLoopService.getNpcs(mapId);
     * for (int i = 0; i < npcs.size(); i++) {
     * int npcEntityId = npcs.get(i);
     * // ... do something with the NPC entity
     * }
     * ```
     * @see #getEntities(short, com.artemis.Aspect.Builder)
     * @see NpcComponent
     */
    public IntBag getNpcs(short mapId) {
        return getEntities(mapId, Aspect.all(NpcComponent.class));
    }

    /**
     * Retrieves all entities from a map's world that match a given component aspect.
     *
     * @param mapId  The ID of the map from which to retrieve entities.
     * @param aspect The `Aspect.Builder` defining the component criteria for entities to match.
     *
     * @return An `IntBag` of entity IDs matching the aspect, or an empty bag if the world doesn't exist.
     *
     * @example ```java
     * Aspect.Builder movingEntities = Aspect.all(PositionComponent.class, MovementComponent.class);
     * IntBag entities = gameLoopService.getEntities(mapId, movingEntities);
     * ```
     */
    public IntBag getEntities(short mapId, Aspect.Builder aspect) {
        var world = this.getEngine(mapId);
        if (world == null) {
            return new IntBag();
        }

        return world.getAspectSubscriptionManager().get(aspect).getEntities();
    }

    /**
     * Retrieves all collectable entities for a given map.
     * This is a convenience method that calls `getEntities` with an aspect for `CollectableComponent`.
     *
     * @param mapId The ID of the map.
     *
     * @return An `IntBag` containing the entity IDs of all collectables on the specified map.
     *
     * @example ```java
     * IntBag collectables = gameLoopService.getCollectables(mapId);
     * ```
     * @see #getEntities(short, com.artemis.Aspect.Builder)
     * @see CollectableComponent
     */
    public IntBag getCollectables(short mapId) {
        return getEntities(mapId, Aspect.all(CollectableComponent.class));
    }

    /**
     * Retrieves all station entities for a given map.
     * This is a convenience method that calls `getEntities` with an aspect for `StationComponent`.
     *
     * @param mapId The ID of the map.
     *
     * @return An `IntBag` containing the entity IDs of all stations on the specified map.
     *
     * @example ```java
     * IntBag stations = gameLoopService.getStations(mapId);
     * ```
     * @see #getEntities(short, com.artemis.Aspect.Builder)
     * @see StationComponent
     */
    public IntBag getStations(short mapId) {
        return getEntities(mapId, Aspect.all(StationComponent.class));
    }

    /**
     * Retrieves all portal entities for a given map.
     * This is a convenience method that calls `getEntities` with an aspect for `PortalComponent`.
     *
     * @param mapId The ID of the map.
     *
     * @return An `IntBag` containing the entity IDs of all portals on the specified map.
     *
     * @example ```java
     * IntBag portals = gameLoopService.getPortals(mapId);
     * ```
     * @see #getEntities(short, com.artemis.Aspect.Builder)
     * @see PortalComponent
     */
    public IntBag getPortals(short mapId) {
        return getEntities(mapId, Aspect.all(PortalComponent.class));
    }

    /**
     * Retrieves all player entities for a given map.
     * This is a convenience method that calls `getEntities` with an aspect for `PlayerComponent`.
     *
     * @param mapId The ID of the map.
     *
     * @return An `IntBag` containing the entity IDs of all players on the specified map.
     *
     * @example ```java
     * IntBag players = gameLoopService.getPlayers(mapId);
     * ```
     * @see #getEntities(short, com.artemis.Aspect.Builder)
     * @see com.kalaazu.server.ecs.component.PlayerComponent
     */
    public IntBag getPlayers(short mapId) {
        return getEntities(mapId, Aspect.all(PlayerComponent.class));
    }
}

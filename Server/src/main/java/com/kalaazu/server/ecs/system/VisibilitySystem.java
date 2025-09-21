package com.kalaazu.server.ecs.system;

import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.systems.IntervalIteratingSystem;
import com.artemis.utils.IntBag;
import com.kalaazu.KalaazuConfig;
import com.kalaazu.server.ecs.component.*;
import com.kalaazu.server.event.SendCommandToSessions;
import com.kalaazu.server.event.SendCommands;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Visibility System.
 * ==================
 *
 * An ECS system that periodically checks which entities are within a player's visual range.
 * It is responsible for managing the lifecycle of entities on the client-side by sending
 * "create" and "remove" commands as other entities enter or leave the player's view.
 * This system is crucial for network performance, as it ensures that clients only receive
 * updates for entities they can actually see.
 *
 * The system processes players and determines which other players, NPCs, and collectables
 * are within a configured render distance. It then compares this with the state from the
 * previous tick to identify newly visible and out-of-view entities, dispatching the
 * appropriate commands.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * // Dependencies are typically injected by a framework like Spring.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(new VisibilitySystem(kalaazuConfig, eventPublisher, commandBuilder))
 * .build();
 * World world = new World(config);
 * ```
 * @see com.artemis.systems.IntervalIteratingSystem
 * @see com.kalaazu.server.ecs.component.ViewComponent
 * @see com.kalaazu.server.ecs.component.PositionComponent
 */
@Component
@Scope("prototype")
public class VisibilitySystem extends IntervalIteratingSystem {
    private final KalaazuConfig config;
    private final ApplicationEventPublisher publisher;
    private final CommandBuilder commandBuilder;

    // Reusable collections to avoid allocation in the game loop
    private final Set<Integer> helperSet = new HashSet<>();

    private final IntBag playersInView = new IntBag();
    private final IntBag playersOutOfView = new IntBag();
    private final IntBag npcsInView = new IntBag();
    private final IntBag npcsOutOfView = new IntBag();
    private final IntBag collectablesInView = new IntBag();
    private final IntBag collectablesOutOfView = new IntBag();
    private final IntBag newlyVisiblePlayers = new IntBag();
    private final IntBag newlyVisibleNpcs = new IntBag();
    private final IntBag newlyVisibleCollectables = new IntBag();

    private ComponentMapper<PositionComponent> positionMapper;
    private ComponentMapper<ViewComponent> viewMapper;
    private ComponentMapper<PlayerComponent> playerMapper;
    private ComponentMapper<EntityTypeComponent> entityTypeMapper;

    // Subscriptions to entity groups, managed by Artemis
    private IntBag allPlayers;
    private IntBag allNpcs;
    private IntBag allCollectables;

    /**
     * Constructor for the `VisibilitySystem`.
     *
     * Initializes the system with its dependencies and sets the processing interval.
     * The interval determines how frequently visibility checks are performed for each player.
     *
     * @param config         The application configuration, used to retrieve settings like render distance.
     * @param publisher      The application event publisher, used to send commands to player sessions.
     * @param commandBuilder The builder used to construct game commands (e.g., for entity creation/removal).
     *
     * @example ```java
     * VisibilitySystem system = new VisibilitySystem(config, publisher, commandBuilder);
     * ```
     */
    public VisibilitySystem(KalaazuConfig config, ApplicationEventPublisher publisher, CommandBuilder commandBuilder) {
        super(Aspect.all(PlayerComponent.class, PositionComponent.class, ViewComponent.class), 0.25f);
        this.config = config;
        this.publisher = publisher;
        this.commandBuilder = commandBuilder;
    }

    /**
     * Initializes the system after it's been added to the world.
     *
     * This method is called once by the Artemis-odb framework. It's used here to
     * subscribe to and cache collections of all relevant entity types (players, NPCs, collectables).
     * Caching these entity bags improves performance by avoiding repeated lookups in the main processing loop.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework. It is not meant to be called directly.
     * ```
     */
    @Override
    protected void initialize() {
        // Cache entity collections for quick access
        var am = world.getAspectSubscriptionManager();
        this.allPlayers = am.get(Aspect.all(PlayerComponent.class, PositionComponent.class)).getEntities();
        this.allNpcs = am.get(Aspect.all(NpcComponent.class, PositionComponent.class)).getEntities();
        this.allCollectables = am.get(Aspect.all(CollectableComponent.class, PositionComponent.class)).getEntities();
    }

    /**
     * Processes a single player entity to update its view of the world.
     *
     * This is the core logic of the system, executed for each player at a fixed interval.
     * It calculates which entities are currently in range, determines which have entered or left the view
     * since the last check, and dispatches commands to the player's client to reflect these changes.
     * It also notifies other players when this player enters or leaves their view.
     *
     * @param entity The ID of the player entity being processed.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework. It is not meant to be called directly.
     * ```
     */
    @Override
    protected void process(int entity) {
        var position = positionMapper.get(entity);
        var view = viewMapper.get(entity);
        var player = playerMapper.get(entity);
        var entityType = entityTypeMapper.get(entity).getType();

        final int renderDistance = config.getGame().getRenderDistance();
        final long renderDistanceSq = (long) renderDistance * renderDistance;

        List<OutCommand> commands = new ArrayList<>();

        // Process players
        processEntityType(allPlayers, newlyVisiblePlayers, view.getPlayers(), playersInView, playersOutOfView, position, renderDistanceSq, true, entity, commands);
        // Process NPCs
        processEntityType(allNpcs, newlyVisibleNpcs, view.getNpcs(), npcsInView, npcsOutOfView, position, renderDistanceSq, false, -1, commands);
        // Process collectables
        processEntityType(allCollectables, newlyVisibleCollectables, view.getCollectables(), collectablesInView, collectablesOutOfView, position, renderDistanceSq, false, -1, commands);

        if (!commands.isEmpty()) {
            publisher.publishEvent(new SendCommands(player.getSession(), commands));
        }

        // Notify other players about this player's appearance/disappearance
        if (!playersInView.isEmpty()) {
            var creationCommand = commandBuilder.buildCommands(CommandType.EntityCreationCommand, world, entity, entityType).getFirst();
            var sessions = getSessionsFromIntBag(playersInView);
            publisher.publishEvent(new SendCommandToSessions(sessions, creationCommand));
        }

        if (!playersOutOfView.isEmpty()) {
            var removalCommand = commandBuilder.buildCommands(CommandType.EntityRemoveCommand, world, entity, entityType).getFirst();
            var sessions = getSessionsFromIntBag(playersOutOfView);
            publisher.publishEvent(new SendCommandToSessions(sessions, removalCommand));
        }

        // Update the view component for the next tick
        view.setPlayers(newlyVisiblePlayers);
        view.setNpcs(newlyVisibleNpcs);
        view.setCollectables(newlyVisibleCollectables);
    }

    /**
     * Processes a specific category of entities (e.g., players, NPCs, or collectables).
     *
     * This helper method orchestrates the visibility check for a given entity type. It finds all entities
     * of that type within the player's range, compares them to the previously visible set to find what's
     * new and what's gone, and adds the necessary creation/removal commands to a list.
     *
     * @param allEntities       The bag of all entities of the type to be processed.
     * @param newlyVisible      The bag to populate with entities of this type that are currently in range.
     * @param previouslyVisible The bag of entities that were visible on the last tick.
     * @param inView            The bag to populate with entities that just entered the view.
     * @param outOfView         The bag to populate with entities that just left the view.
     * @param playerPosition    The position of the observing player.
     * @param renderDistanceSq  The squared render distance for efficient distance checking.
     * @param excludeSelf       A flag to indicate if the observing player should be excluded from the check.
     * @param selfEntityId      The ID of the observing player, used when `excludeSelf` is true.
     * @param commands          The list to which generated commands will be added.
     */
    private void processEntityType(
            IntBag allEntities, IntBag newlyVisible, IntBag previouslyVisible,
            IntBag inView, IntBag outOfView,
            PositionComponent playerPosition, long renderDistanceSq,
            boolean excludeSelf, int selfEntityId,
            List<OutCommand> commands
    ) {
        findNewlyVisibleEntities(allEntities, newlyVisible, playerPosition, renderDistanceSq, excludeSelf, selfEntityId);

        findInView(newlyVisible, previouslyVisible, inView);
        findOutOfView(newlyVisible, previouslyVisible, outOfView);

        addCommandsForEntities(inView, CommandType.EntityCreationCommand, commands);
        addCommandsForEntities(outOfView, CommandType.EntityRemoveCommand, commands);
    }

    /**
     * Retrieves the `GameSession` for each player entity in a given `IntBag`.
     *
     * This helper method iterates through a bag of player entity IDs, looks up the `PlayerComponent`
     * for each, and collects their associated `GameSession` into a list.
     *
     * @param bag An `IntBag` containing player entity IDs.
     *
     * @return A `List` of `GameSession` objects for the specified players.
     *
     * @example ```java
     * List<GameSession> sessionsToNotify = getSessionsFromIntBag(playersInView);
     * ```
     */
    private List<GameSession> getSessionsFromIntBag(IntBag bag) {
        var sessions = new ArrayList<GameSession>(bag.size());
        for (int i = 0, s = bag.size(); i < s; i++) {
            var player = playerMapper.get(bag.get(i));
            if (player != null) sessions.add(player.getSession());
        }
        return sessions;
    }

    /**
     * Finds all entities from a given set that are within the player's render distance.
     *
     * It iterates through a collection of entities, performs a distance check against the player's position,
     * and adds any entity within range to the result bag.
     *
     * @param allEntities        The bag of all entities to check.
     * @param newlyVisibleResult The bag to populate with entities that are in range.
     * @param playerPosition     The position of the observing player.
     * @param renderDistanceSq   The squared render distance for efficient comparison.
     * @param excludeSelf        A flag to exclude the player's own entity ID from the results.
     * @param selfEntityId       The player's own entity ID, to be excluded if `excludeSelf` is true.
     */
    private void findNewlyVisibleEntities(IntBag allEntities, IntBag newlyVisibleResult, PositionComponent playerPosition, long renderDistanceSq, boolean excludeSelf, int selfEntityId) {
        newlyVisibleResult.clear();
        for (int i = 0, s = allEntities.size(); i < s; i++) {
            int entity = allEntities.get(i);

            if (excludeSelf && selfEntityId == entity) {
                continue;
            }

            if (positionMapper.get(entity).getPosition().dst2(playerPosition.getPosition()) <= renderDistanceSq) {
                newlyVisibleResult.add(entity);
            }
        }
    }

    /**
     * Finds entities that are in the newly visible set but not in the previously visible set.
     *
     * This method calculates the difference `newlyVisible - previouslyVisible` to identify entities
     * that have just entered the player's range of vision.
     *
     * @param newlyVisible      The bag of entities currently in range.
     * @param previouslyVisible The bag of entities that were in range on the last tick.
     * @param resultInView      The bag to populate with entities that just came into view.
     *
     * @example ```java
     * findInView(currentVisiblePlayers, lastTickVisiblePlayers, playersWhoJustAppeared);
     * ```
     */
    private void findInView(IntBag newlyVisible, IntBag previouslyVisible, IntBag resultInView) {
        resultInView.clear();
        helperSet.clear();
        for (int i = 0, s = previouslyVisible.size(); i < s; i++) {
            helperSet.add(previouslyVisible.get(i));
        }

        for (int i = 0, s = newlyVisible.size(); i < s; i++) {
            int entityId = newlyVisible.get(i);
            if (!helperSet.contains(entityId)) {
                resultInView.add(entityId);
            }
        }
    }

    /**
     * Finds entities that are in the previously visible set but not in the newly visible set.
     *
     * This method calculates the difference `previouslyVisible - newlyVisible` to identify entities
     * that have just left the player's range of vision. It achieves this by reusing the `findInView`
     * logic with swapped arguments.
     *
     * @param newlyVisible      The bag of entities currently in range.
     * @param previouslyVisible The bag of entities that were in range on the last tick.
     * @param resultOutOfView   The bag to populate with entities that just went out of view.
     *
     * @example ```java
     * findOutOfView(currentVisibleNpcs, lastTickVisibleNpcs, npcsWhoJustVanished);
     * ```
     */
    private void findOutOfView(IntBag newlyVisible, IntBag previouslyVisible, IntBag resultOutOfView) {
        findInView(previouslyVisible, newlyVisible, resultOutOfView);
    }

    /**
     * Builds commands for a given set of entities and adds them to a command list.
     *
     * This utility method iterates over a bag of entity IDs, builds a command of the specified type
     * for each entity, and appends them to the output list.
     *
     * @param entities    The bag of entity IDs to process.
     * @param commandType The type of command to build for each entity (e.g., `EntityCreationCommand`).
     * @param commands    The list to which the generated commands will be added.
     */
    private void addCommandsForEntities(IntBag entities, CommandType commandType, List<OutCommand> commands) {
        for (int i = 0, s = entities.size(); i < s; i++) {
            int entityId = entities.get(i);
            var entityType = entityTypeMapper.get(entityId);
            commands.addAll(commandBuilder.buildCommands(commandType, world, entityId, entityType.getType()));
        }
    }
}

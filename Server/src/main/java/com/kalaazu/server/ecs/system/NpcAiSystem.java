package com.kalaazu.server.ecs.system;

import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.EntitySubscription;
import com.artemis.systems.IteratingSystem;
import com.artemis.utils.IntBag;
import com.kalaazu.math.Vector;
import com.kalaazu.server.ecs.component.PlayerComponent;
import com.kalaazu.server.ecs.component.map.MapComponent;
import com.kalaazu.server.ecs.component.map.PositionComponent;
import com.kalaazu.server.ecs.component.movement.MovementComponent;
import com.kalaazu.server.ecs.component.movement.MovementIntentComponent;
import com.kalaazu.server.ecs.component.npc.NpcAiComponent;
import com.kalaazu.server.ecs.component.npc.NpcComponent;
import com.kalaazu.server.ecs.component.view.ViewComponent;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.concurrent.ThreadLocalRandom;

/**
 * NPC AI System.
 * ============
 *
 * An ECS system that manages basic Artificial Intelligence for Non-Player Characters (NPCs).
 * Its primary function is to simulate simple wandering behavior. The system periodically
 * assigns a new random destination to an NPC within its map boundaries, creating a
 * `MovementIntentComponent` to trigger the movement.
 *
 * To optimize server performance, the AI is "frozen" (deactivated) if no player is
 * currently viewing the NPC. The AI becomes active again as soon as a player enters
 * its visibility range.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(new NpcAiSystem())
 * .build();
 * World world = new World(config);
 * ```
 * @see NpcAiComponent
 * @see MovementIntentComponent
 */
@Component
@Scope("prototype")
public class NpcAiSystem extends IteratingSystem {
    private static final int MIN_IDLE_TIME = 5_000;
    private static final int MAX_IDLE_TIME = 10_000;

    private ComponentMapper<NpcComponent> npcMapper;
    private ComponentMapper<NpcAiComponent> npcAiMapper;
    private ComponentMapper<PositionComponent> positionMapper;
    private ComponentMapper<MovementIntentComponent> movementIntentMapper;
    private ComponentMapper<MovementComponent> movementMapper;
    private ComponentMapper<MapComponent> mapMapper;
    private ComponentMapper<ViewComponent> viewMapper;

    private EntitySubscription playerSubscription;

    /**
     * Initializes the system.
     * <p>
     * Sets up the aspect to process entities that have `NpcComponent`, `NpcAiComponent`,
     * `PositionComponent`, and `MapComponent`. This ensures the system only operates on
     * NPCs that have all the necessary data for AI and movement.
     *
     * @example ```java
     * NpcAiSystem npcAiSystem = new NpcAiSystem();
     * ```
     */
    public NpcAiSystem() {
        super(Aspect.all(NpcComponent.class, NpcAiComponent.class, PositionComponent.class, MapComponent.class));
    }

    /**
     * Initializes the system after it's been added to the world.
     * <p>
     * This method is called once by the Artemis-odb framework. It's used here to
     * get and cache a subscription to all player entities. This subscription provides
     * an efficient way to access all players for the `isPlayerNearby` check.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework. It is not meant to be called directly.
     * ```
     */
    @Override
    protected void initialize() {
        playerSubscription = world.getAspectSubscriptionManager().get(Aspect.all(PlayerComponent.class, ViewComponent.class));
    }

    /**
     * Processes a single NPC entity.
     * <p>
     * This is the core logic of the AI system, executed for each NPC on every tick.
     * It first checks if any player is nearby to decide whether the AI should be active.
     * If active and not already moving, it checks if it's time for a new action. If so,
     * it generates a random destination on the map, creates a `MovementIntentComponent`
     * to initiate movement, and schedules the next action.
     *
     * @param entityId The ID of the NPC entity being processed.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework during its processing loop
     * // for each entity that matches the system's aspect. It is not meant to be called directly.
     * ```
     * @see NpcAiComponent#isFrozen()
     * @see MovementIntentComponent
     */
    @Override
    protected void process(int entityId) {
        var ai = npcAiMapper.get(entityId);

        ai.setFrozen(!isPlayerNearby(entityId));

        if (ai.isFrozen()) {
            return;
        }

        if (movementMapper.has(entityId) && movementMapper.get(entityId).isMoving()) {
            return;
        }

        var now = System.currentTimeMillis();
        if (now < ai.getNextAction()) {
            return;
        }

        var map = mapMapper.get(entityId);

        // Generate a new random destination anywhere within the map's boundaries.
        var destination = Vector.random(map.getLimits());

        movementIntentMapper.create(entityId)
                .setDestination(destination);

        var idleTime = ThreadLocalRandom.current().nextInt(MIN_IDLE_TIME, MAX_IDLE_TIME);
        ai.setNextAction(now + idleTime);
    }

    /**
     * Checks if any player has the specified NPC in their view.
     * <p>
     * This method iterates through all active players and checks their `ViewComponent`
     * to see if the given NPC entity ID is in their list of visible NPCs. This is used
     * to determine if the NPC's AI should be active or "frozen" to save resources.
     *
     * @param entityId The ID of the NPC entity to check for.
     *
     * @return `true` if at least one player can see the NPC, `false` otherwise.
     *
     * @example ```java
     * // Inside the process method for an NPC with entityId = 100
     * boolean isVisible = isPlayerNearby(100);
     * if (isVisible) {
     * // Activate AI logic
     * }
     * ```
     */
    private boolean isPlayerNearby(int entityId) {
        IntBag players = playerSubscription.getEntities();
        for (int i = 0, s = players.size(); i < s; i++) {
            int playerId = players.get(i);

            var view = viewMapper.get(playerId);

            if (view != null && view.getNpcs().contains(entityId)) {
                return true;
            }
        }

        return false;
    }
}

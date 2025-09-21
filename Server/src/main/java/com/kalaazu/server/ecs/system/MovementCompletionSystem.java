package com.kalaazu.server.ecs.system;

import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.systems.IntervalIteratingSystem;
import com.kalaazu.server.ecs.component.MovementComponent;
import com.kalaazu.server.ecs.component.PositionComponent;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

/**
 * Movement Completion System.
 * ===========================
 *
 * Runs at a fixed interval to efficiently check if an entity's movement
 * has finished and updates its state accordingly.
 *
 * When an entity's `endMovementTime` is reached, this system sets the entity's
 * position to its final destination and removes the `MovementComponent`,
 * effectively stopping the entity.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(
 * new MovementCompletionSystem()
 * )
 * .build();
 * World world = new World(config);
 * ```
 * @see com.artemis.systems.IntervalIteratingSystem
 * @see com.kalaazu.server.ecs.component.MovementComponent
 * @see com.kalaazu.server.ecs.component.PositionComponent
 */
@Component
@Scope("prototype")
public class MovementCompletionSystem extends IntervalIteratingSystem implements Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.GAME_LOOP;

    private ComponentMapper<MovementComponent> movementMapper;
    private ComponentMapper<PositionComponent> positionMapper;

    /**
     * Constructor for `MovementCompletionSystem`.
     *
     * Initializes the system to run at a fixed interval, processing entities
     * that have both a `PositionComponent` and a `MovementComponent`.
     *
     * @example ```java
     * // The system is typically instantiated and added to the world configuration.
     * MovementCompletionSystem system = new MovementCompletionSystem();
     * ```
     */
    public MovementCompletionSystem() {
        super(Aspect.all(PositionComponent.class, MovementComponent.class), 1.0f);
    }

    /**
     * Processes an entity to check if its movement is complete.
     *
     * This method is the core logic of the system. It checks if the entity is
     * marked as moving and if the current system time has surpassed the movement's
     * end time. If both conditions are true, it updates the entity's
     * `PositionComponent` to the final destination and removes the `MovementComponent`
     * to signify that the movement has concluded.
     *
     * @param entityId The ID of the entity being processed.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework. It is not meant to be called directly.
     * // An entity with a MovementComponent whose end time is in the past will be processed.
     * ```
     */
    @Override
    protected void process(int entityId) {
        var movement = movementMapper.get(entityId);
        if (!movement.isMoving()) {
            return;
        }

        if (System.currentTimeMillis() >= movement.getEndMovementTime()) {
            var position = positionMapper.get(entityId);
            position.setPosition(movement.getDestination().cpy());
            movementMapper.remove(entityId);
        }
    }
}
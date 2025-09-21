package com.kalaazu.server.ecs.system;

import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.systems.IteratingSystem;
import com.kalaazu.math.Vector;
import com.kalaazu.server.ecs.component.MovementComponent;
import com.kalaazu.server.ecs.component.PositionComponent;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

/**
 * Movement Update System.
 * ======================
 *
 * An ECS system that updates the position of entities with an active `MovementComponent`.
 * On each game tick, this system calculates the entity's current position along its
 * movement path through linear interpolation. It uses the start time, end time,
 * initial position, and destination stored in the `MovementComponent`.
 *
 * This ensures that an entity's `PositionComponent` is continuously updated
 * during movement, which is essential for rendering, collision detection, and
 * visibility checks.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(new MovementUpdateSystem())
 * .build();
 * World world = new World(config);
 * ```
 * @see com.artemis.systems.IteratingSystem
 * @see com.kalaazu.server.ecs.component.MovementComponent
 * @see com.kalaazu.server.ecs.component.PositionComponent
 */
@Component
@Scope("prototype")
public class MovementUpdateSystem extends IteratingSystem {

    // Injected by Artemis
    private ComponentMapper<PositionComponent> positionMapper;
    private ComponentMapper<MovementComponent> movementMapper;

    /**
     * Constructor for the `MovementUpdateSystem`.
     *
     * Initializes the system to process entities that have both a `MovementComponent`
     * and a `PositionComponent`, ensuring it only operates on entities that are
     * capable of moving and have a position to update.
     */
    public MovementUpdateSystem() {
        super(Aspect.all(MovementComponent.class, PositionComponent.class));
    }

    /**
     * Processes a single moving entity to update its position.
     *
     * This method is the core logic of the system. If the entity is moving, it
     * calculates the movement progress as a percentage (0.0 to 1.0) based on the
     * elapsed time versus the total movement duration. It then uses this progress
     * to linearly interpolate the new position between the start and destination points
     * and updates the entity's `PositionComponent`.
     *
     * @param entityId The ID of the entity being processed.
     */
    @Override
    protected void process(int entityId) {
        var movement = movementMapper.get(entityId);
        var position = positionMapper.get(entityId);

        if (!movement.isMoving()) {
            return;
        }

        long now = System.currentTimeMillis();
        long startTime = movement.getEndMovementTime() - movement.getTotalMovementTime();
        long elapsedTime = now - startTime;

        // Calculate progress, clamping between 0.0 and 1.0
        float progress = Math.max(0f, Math.min(1f, (float) elapsedTime / movement.getTotalMovementTime()));

        var startPos = movement.getInitialPosition();
        var endPos = movement.getDestination();

        // Linearly interpolate the new position
        var newX = startPos.getX() + (endPos.getX() - startPos.getX()) * progress;
        var newY = startPos.getY() + (endPos.getY() - startPos.getY()) * progress;

        position.setPosition(new Vector((int) newX, (int) newY));
    }
}
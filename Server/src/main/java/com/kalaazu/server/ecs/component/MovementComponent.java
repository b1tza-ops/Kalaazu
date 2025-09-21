package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.math.Vector;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Movement Component.
 * ===================
 *
 * Component that holds all data related to an entity's movement.
 * This includes the destination, the starting position, and timing information
 * for calculating the current position during movement.
 * The `justStarted` flag is used by systems like `MovementBroadcastSystem` to
 * detect when a movement has just been initiated.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 *
 * // Create and configure the movement component
 * MovementComponent movement = world.edit(entityId).create(MovementComponent.class);
 * movement.setDestination(new Vector(1000, 1000));
 * movement.setInitialPosition(new Vector(0, 0));
 * movement.setEndMovementTime(System.currentTimeMillis() + 5000); // 5 seconds to reach destination
 * movement.setTotalMovementTime(5000);
 * movement.setMoving(true);
 * movement.setJustStarted(true);
 *
 * // Later, a system can check if the entity is moving
 * MovementComponent retrieved = movementMapper.get(entityId);
 * if (retrieved.isMoving()) {
 * System.out.println("Entity is moving towards " + retrieved.getDestination());
 * }
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.server.ecs.system.MovementBroadcastSystem
 * @see com.kalaazu.server.ecs.system.MovementCompletionSystem
 * @see com.kalaazu.server.ecs.system.MovementIntentSystem
 * @see com.kalaazu.math.Vector
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MovementComponent extends PooledComponent {
    private volatile boolean moving;
    private volatile long endMovementTime;
    private volatile int totalMovementTime;
    private volatile Vector destination;
    private volatile Vector initialPosition;
    private volatile boolean justStarted;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies all fields to ensure that the recycled component doesn't hold stale data from a previous entity.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When an entity with a MovementComponent is deleted:
     * world.delete(entityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // movementComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        moving = false;
        endMovementTime = 0;
        totalMovementTime = 0;
        destination = null;
        initialPosition = null;
        justStarted = false;
    }
}

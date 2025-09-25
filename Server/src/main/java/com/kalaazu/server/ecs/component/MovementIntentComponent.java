package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.math.Vector;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Movement Intent Component.
 * =========================
 *
 * A temporary component added to an entity to signal the player's
 * intent to move to a new destination.
 * This component is typically processed by a system (like `MovementIntentSystem`) which then
 * calculates the path and timing, creates a `MovementComponent` with the full movement details,
 * and removes this `MovementIntentComponent`.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 *
 * // Signal that the entity wants to move to a new position
 * MovementIntentComponent intent = world.edit(entityId).create(MovementIntentComponent.class);
 * intent.setDestination(new Vector(2000, 3000));
 *
 * // A system will later process this intent.
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.server.ecs.component.MovementComponent
 * @see com.kalaazu.server.ecs.system.MovementIntentSystem
 * @see com.kalaazu.math.Vector
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class MovementIntentComponent extends PooledComponent {
    private Vector destination;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies the `destination` to ensure that the recycled component doesn't hold stale data.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // After a system processes the intent, it removes the component:
     * world.edit(entityId).remove(MovementIntentComponent.class);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // intentComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        destination = null;
    }
}

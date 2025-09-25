package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.persistence.entity.CollectablesEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Collectable Component.
 * =====================
 *
 * Component for collectable entities, such as bonus boxes or cargo.
 * This component stores the type of the collectable, which is defined by a `CollectablesEntity`.
 * The entity's properties, like rewards and appearance, are derived from this type.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * CollectablesEntity bonusBoxType = new CollectablesEntity(); // Assume this is loaded from the database
 * bonusBoxType.setName("Bonus Box");
 *
 * CollectableComponent collectableComponent = world.edit(entityId).create(CollectableComponent.class);
 * collectableComponent.setType(bonusBoxType);
 *
 * // Later, to retrieve it
 * CollectableComponent retrievedComponent = collectableComponentMapper.get(entityId);
 * String collectableName = retrievedComponent.getType().getName();
 * System.out.println("Entity is a: " + collectableName);
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.persistence.entity.CollectablesEntity
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class CollectableComponent extends PooledComponent {
    private CollectablesEntity type;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies the `type` to ensure that the recycled component doesn't hold a reference to a previous entity's data.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When an entity with a CollectableComponent is deleted:
     * world.delete(entityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // collectableComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        type = null;
    }
}

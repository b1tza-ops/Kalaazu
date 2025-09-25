package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.persistence.entity.MapsPortalsEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Portal Component.
 * ================
 *
 * Component for portal entities.
 * This component holds the `MapsPortalsEntity`, which defines the portal's properties
 * such as its destination map and position.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * MapsPortalsEntity portalData = new MapsPortalsEntity(); // Assume this is loaded from the database
 * portalData.setId(1);
 * portalData.setTargetMapsId((byte) 2);
 *
 * PortalComponent portalComponent = world.edit(entityId).create(PortalComponent.class);
 * portalComponent.setPortal(portalData);
 *
 * // Later, to retrieve it
 * PortalComponent retrievedComponent = portalComponentMapper.get(entityId);
 * byte destinationMapId = retrievedComponent.getPortal().getTargetMapsId();
 * System.out.println("This portal leads to map " + destinationMapId);
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.persistence.entity.MapsPortalsEntity
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class PortalComponent extends PooledComponent {
    private MapsPortalsEntity portal;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies the `portal` field to ensure that the recycled component doesn't hold stale data.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When a portal entity is deleted from the world:
     * world.delete(portalEntityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // portalComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        portal = null;
    }
}

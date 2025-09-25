package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.persistence.entity.MapsStationsEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Station component.
 * ==================
 *
 * Component for station entities.
 * This component holds the `MapsStationsEntity`, which defines the station's properties.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * MapsStationsEntity stationData = new MapsStationsEntity(); // Assume this is loaded from the database
 * stationData.setId(1);
 * stationData.setName("Main Base");
 *
 * StationComponent stationComponent = world.edit(entityId).create(StationComponent.class);
 * stationComponent.setStation(stationData);
 *
 * // Later, to retrieve it
 * StationComponent retrievedComponent = stationComponentMapper.get(entityId);
 * String stationName = retrievedComponent.getStation().getName();
 * System.out.println("Entity is at station: " + stationName);
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.persistence.entity.MapsStationsEntity
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class StationComponent extends PooledComponent {
    private MapsStationsEntity station;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies the `station` field to ensure that the recycled component doesn't hold stale data.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When a station entity is deleted from the world:
     * world.delete(stationEntityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // stationComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        station = null;
    }
}

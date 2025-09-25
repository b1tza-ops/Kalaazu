package com.kalaazu.server.ecs.component.map;

import com.artemis.PooledComponent;
import com.kalaazu.math.VectorRegion;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Component that holds information about the map an entity is on.
 * This component is used to store map-specific data for an entity, primarily
 * the boundaries of the map, which can be used for collision detection or
 * to constrain movement.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb system
 * ComponentMapper<MapComponent> mapMapper;
 *
 * // Get the map component from an entity
 * int entityId = //...
 * MapComponent mapComponent = mapMapper.get(entityId);
 *
 * if (mapComponent != null) {
 * VectorRegion boundaries = mapComponent.getLimits();
 * Vector newPosition = boundaries.clamp(currentPosition);
 * }
 *
 * // Create and add the component to a new entity
 * Entity newEntity = world.createEntity();
 * newEntity.edit().create(MapComponent.class)
 * .setLimits(new VectorRegion("0,0|21000,13000"));
 * ```
 * @see com.kalaazu.math.VectorRegion
 * @see com.artemis.PooledComponent
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class MapComponent extends PooledComponent {
    /**
     * The boundaries (limits) of the map.
     */
    private VectorRegion limits;

    /**
     * Resets the component to its initial state for object pooling.
     * This method is called by the Artemis-odb framework when the component is recycled.
     */
    @Override
    protected void reset() {
        limits = null;
    }
}
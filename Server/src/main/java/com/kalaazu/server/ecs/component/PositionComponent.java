package com.kalaazu.server.ecs.component;

import com.artemis.Component;
import com.kalaazu.math.Vector;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Position component.
 * =================
 *
 * Component that stores the 2D coordinates of an entity in the game world.
 * This component uses a `Vector` to represent the position. The `position` field is marked as `volatile`
 * to ensure that changes to an entity's position are visible across different threads, which is crucial
 * for thread-safe updates in the game loop.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * Vector initialPosition = Vector.of(1000, 2000);
 *
 * PositionComponent positionComponent = world.edit(entityId).create(PositionComponent.class);
 * positionComponent.setPosition(initialPosition);
 *
 * // Later, to retrieve it
 * PositionComponent retrievedComponent = positionComponentMapper.get(entityId);
 * Vector currentPosition = retrievedComponent.getPosition();
 * System.out.println("Entity is at: " + currentPosition.getX() + ", " + currentPosition.getY());
 * ```
 * @see com.artemis.Component
 * @see com.kalaazu.math.Vector
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class PositionComponent extends Component {
    private volatile Vector position;
}

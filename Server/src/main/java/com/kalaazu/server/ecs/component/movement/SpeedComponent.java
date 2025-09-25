package com.kalaazu.server.ecs.component.movement;

import com.artemis.Component;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Speed component.
 * ==============
 *
 * Component that stores the speed of an entity.
 * This value is used in movement calculations to determine how fast an entity travels across the game map.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 *
 * SpeedComponent speedComponent = world.edit(entityId).create(SpeedComponent.class);
 * speedComponent.setSpeed((short) 400);
 *
 * // Later, to retrieve it
 * SpeedComponent retrievedComponent = speedComponentMapper.get(entityId);
 * short currentSpeed = retrievedComponent.getSpeed();
 * System.out.println("Entity's speed is: " + currentSpeed);
 * ```
 * @see com.artemis.Component
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class SpeedComponent extends Component {
    private short speed;
}

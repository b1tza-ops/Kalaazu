package com.kalaazu.server.ecs.component;

import com.artemis.Component;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Id Component.
 * ============
 *
 * Component that stores a unique identifier for an entity.
 * This ID is often different from the entity's internal ID within the ECS world
 * and can correspond to a database ID or a session-specific ID.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * IdComponent idComponent = world.edit(entityId).create(IdComponent.class);
 * idComponent.setId(12345);
 *
 * // Later, to retrieve it
 * IdComponent retrievedComponent = idComponentMapper.get(entityId);
 * int uniqueId = retrievedComponent.getId();
 * System.out.println("Entity's unique ID is: " + uniqueId);
 * ```
 * @see com.artemis.Component
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class IdComponent extends Component {
    private int id;
}

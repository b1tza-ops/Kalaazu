package com.kalaazu.server.ecs.component;

import com.artemis.Component;
import com.kalaazu.server.ecs.entity.EntityType;
import lombok.Data;
import lombok.experimental.Accessors;

/**
 * Entity Type component.
 * ======================
 *
 * A component that holds the specific type of an entity, such as `PLAYER`, `NPC`,
 * or `COLLECTABLE`. This is crucial for systems that need to differentiate
 * behavior based on the entity's role in the game.
 *
 * @author manulaiko
 * @example ```java
 * // 'world' is an instance of com.artemis.World
 * // 'entityId' is the integer ID of an entity
 * EntityEdit edit = world.edit(entityId);
 *
 * // Add the component and set its type
 * EntityTypeComponent entityType = edit.create(EntityTypeComponent.class);
 * entityType.setType(EntityType.PLAYER);
 * ```
 * @see com.kalaazu.server.ecs.entity.EntityType
 * @see com.artemis.Component
 */
@Data
@Accessors(chain = true)
public class EntityTypeComponent extends Component {
    /**
     * The type of the entity.
     *
     * @param type The new `EntityType` to set for the entity.
     * @return The `EntityType` currently assigned to the entity.
     * @example ```java
     * // Assuming 'component' is an instance of EntityTypeComponent
     *
     * // Set the type
     * component.setType(EntityType.NPC);
     *
     * // Get the type
     * EntityType currentType = component.getType();
     * System.out.println("Entity is of type: " + currentType); // Prints: Entity is of type: NPC
     * ```
     * @see com.kalaazu.server.ecs.entity.EntityType
     */
    private EntityType type;
}

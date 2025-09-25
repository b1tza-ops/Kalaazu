package com.kalaazu.server.ecs.component;

import com.artemis.Component;
import lombok.Data;

/**
 * Represents the entity's current target.
 * ========================================
 *
 * This component stores the ID of the entity that is currently being targeted.
 * A value of -1 indicates that no entity is targeted. This is crucial for
 * combat and interaction systems, allowing an entity to focus its actions
 * on another specific entity.
 *
 * @author manulaiko
 * @example ```java
 * // Create a TargetComponent for an entity
 * TargetComponent target = new TargetComponent();
 *
 * // Set the target entity's ID
 * target.setTargetId(123);
 *
 * // Later, retrieve the target ID
 * int currentTargetId = target.getTargetId(); // 123
 * ```
 * @see com.kalaazu.server.game.v4.handler.SelectShipHandler
 */
@Data
public class TargetComponent extends Component {
    /**
     * The ID of the targeted entity.
     *
     * A value of -1 indicates no target.
     */
    private int targetId = -1;
}

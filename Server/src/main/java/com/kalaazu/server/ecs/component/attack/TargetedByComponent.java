package com.kalaazu.server.ecs.component.attack;

import com.artemis.PooledComponent;
import com.artemis.utils.IntBag;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Targeted By Component.
 * ======================
 *
 * Component for entities that are being targeted by other entities.
 * It maintains a list of entity IDs that are currently targeting this entity.
 *
 * @author manulaiko
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class TargetedByComponent extends PooledComponent {
    private IntBag targetedBy = new IntBag();

    @Override
    protected void reset() {
        targetedBy.clear();
    }
}

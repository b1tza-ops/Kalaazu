package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.persistence.entity.NpcsEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * NPC Component.
 * ============
 *
 * Component for NPC (Non-Player Character) entities.
 * This component holds the `NpcsEntity`, which defines the NPC's properties
 * such as name, health, speed, rewards, and behavior.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 * NpcsEntity npcType = new NpcsEntity(); // Assume this is loaded from the database
 * npcType.setName("Streuner");
 * npcType.setHealth(400);
 *
 * NpcComponent npcComponent = world.edit(entityId).create(NpcComponent.class);
 * npcComponent.setNpc(npcType);
 *
 * // Later, to retrieve it
 * NpcComponent retrievedComponent = npcComponentMapper.get(entityId);
 * String npcName = retrievedComponent.getNpc().getName();
 * System.out.println("Entity is an NPC: " + npcName);
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.persistence.entity.NpcsEntity
 * @see com.kalaazu.server.service.GameLoopService#addNpc(short, com.kalaazu.persistence.entity.NpcsEntity, com.kalaazu.math.Vector, int)
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class NpcComponent extends PooledComponent {
    private NpcsEntity npc;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies the `npc` field to ensure that the recycled component doesn't hold stale data.
     */
    @Override
    protected void reset() {
        npc = null;
    }
}

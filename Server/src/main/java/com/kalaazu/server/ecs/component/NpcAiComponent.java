package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import lombok.Data;

/**
 * Component that holds state information for an NPC's Artificial Intelligence (AI).
 * <p>
 * This component stores the type of AI behavior the NPC should exhibit,
 * a timestamp for scheduling its next action, and a flag to indicate
 * whether its AI is currently active or 'frozen'. It is typically used
 * by an `NpcAiSystem` to drive NPC behavior like movement and combat.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb system or entity factory
 * Entity npcEntity = world.createEntity();
 * EntityEdit edit = npcEntity.edit();
 *
 * // Create and configure the NpcAiComponent
 * NpcAiComponent ai = edit.create(NpcAiComponent.class);
 * ai.setAi((byte) 1); // Set to a specific AI type, e.g., passive roaming
 * ai.setFrozen(false); // AI is active
 * ai.setNextAction(world.getTime() + 2000); // Schedule next action in 2 seconds
 * ```
 * @see com.artemis.PooledComponent
 */
@Data
public class NpcAiComponent extends PooledComponent {
    private byte ai;
    private long nextAction = 0L;
    private boolean isFrozen = true;

    /**
     * Resets the component to its default state for object pooling.
     * <p>
     * This method is called automatically by the Artemis-odb framework when the
     * component is removed from an entity and returned to the pool. It ensures
     * that recycled components do not carry over state from their previous use.
     *
     * @example ```java
     * // This method is invoked automatically by the Artemis-odb framework.
     * // It is not meant to be called directly by the user.
     * world.delete(entityId); // The component's reset() is called internally.
     * ```
     */
    @Override
    protected void reset() {
        this.ai = 0;
        this.nextAction = 0L;
        this.isFrozen = true;
    }
}

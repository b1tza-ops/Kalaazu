package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.artemis.utils.IntBag;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * View Component.
 * ===============
 *
 * Component for entities that can see other entities.
 * It maintains lists of entity IDs for players, NPCs, and collectables that are currently within the entity's range of vision.
 * This is used by systems to manage visibility and interactions between entities.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int playerEntityId = world.create();
 * int otherPlayerId = 10;
 * int npcId = 20;
 *
 * ViewComponent viewComponent = world.edit(playerEntityId).create(ViewComponent.class);
 * viewComponent.getPlayers().add(otherPlayerId);
 * viewComponent.getNpcs().add(npcId);
 *
 * // Later, to retrieve it
 * ViewComponent retrievedComponent = viewComponentMapper.get(playerEntityId);
 * boolean isOtherPlayerVisible = retrievedComponent.getPlayers().contains(otherPlayerId);
 * System.out.println("Is other player visible? " + isOtherPlayerVisible);
 * ```
 * @see com.artemis.PooledComponent
 * @see com.artemis.utils.IntBag
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class ViewComponent extends PooledComponent {
    private IntBag players = new IntBag();
    private IntBag npcs = new IntBag();
    private IntBag collectables = new IntBag();

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It clears the `players`, `npcs`, and `collectables` bags to ensure that the recycled component doesn't hold stale data.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When an entity with a ViewComponent is deleted from the world:
     * world.delete(entityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // viewComponent.reset();
     * ```
     * @see com.artemis.PooledComponent#reset()
     */
    @Override
    protected void reset() {
        players.clear();
        npcs.clear();
        collectables.clear();
    }
}

package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.artemis.utils.IntBag;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * Component that acts as a reverse-lookup for visibility.
 * <p>
 * It is attached to any entity that can be seen by players (e.g., other players, NPCs).
 * It maintains a list of player entity IDs that currently have this entity in their `ViewComponent`.
 * This allows for highly efficient lookups to find all observers of an entity, which is
 * essential for broadcasting events like movement or attacks without iterating through all
 * players on the map. The `VisibilitySystem` is responsible for keeping this component's
 * data accurate.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb system that broadcasts entity movements
 * ComponentMapper<VisibleByComponent> visibleByMapper;
 * ComponentMapper<PlayerComponent> playerMapper;
 *
 * // Get all players observing a specific entity
 * int movingEntityId = //... an NPC or player that just moved
 * VisibleByComponent visibleBy = visibleByMapper.get(movingEntityId);
 * IntBag observers = visibleBy.getPlayers();
 *
 * // Now broadcast a movement command to all observers
 * for (int i = 0, s = observers.size(); i < s; i++) {
 * int observerId = observers.get(i);
 * GameSession session = playerMapper.get(observerId).getSession();
 * // sendMovementCommand(session, movingEntityId, newPosition);
 * }
 * ```
 * @see com.artemis.PooledComponent
 * @see com.artemis.utils.IntBag
 * @see com.kalaazu.server.ecs.system.VisibilitySystem
 * @see com.kalaazu.server.ecs.component.ViewComponent
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class VisibleByComponent extends PooledComponent {
    private final IntBag players = new IntBag();

    /**
     * Resets the component to its default state for object pooling.
     * <p>
     * This method is called automatically by the Artemis-odb framework when the
     * component is removed from an entity and returned to the pool. It clears
     * the list of observing players to ensure that recycled components do not
     * carry over state from their previous use.
     *
     * @example ```java
     * // This method is invoked automatically by the Artemis-odb framework.
     * // It is not meant to be called directly by the user.
     * world.delete(entityId); // The component's reset() is called internally.
     * ```
     */
    @Override
    protected void reset() {
        players.clear();
    }
}
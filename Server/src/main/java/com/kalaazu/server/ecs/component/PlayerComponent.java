package com.kalaazu.server.ecs.component;

import com.artemis.PooledComponent;
import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsShipsEntity;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.server.game.netty.GameSession;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Player Component.
 * ===============
 *
 * Component for player entities.
 * This component aggregates all essential data related to a player, including their
 * game session, account details, current ship, configuration, and the map they are on.
 *
 * As a `PooledComponent`, instances of this class are reused to reduce garbage collection overhead.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis World context
 * int entityId = world.create();
 *
 * PlayerComponent player = world.edit(entityId).create(PlayerComponent.class);
 * player.setSession(new GameSession(...)); // Assume a valid session
 * player.setAccount(new AccountsEntity(...)); // Assume loaded from DB
 * player.setShip(new AccountsShipsEntity(...));
 * player.setConfig(new AccountsConfigurationsEntity(...));
 * player.setMap(new MapsEntity(...));
 *
 * // Later, to retrieve it
 * PlayerComponent retrieved = playerMapper.get(entityId);
 * System.out.println("Player " + retrieved.getAccount().getName() + " is on map " + retrieved.getMap().getName());
 * ```
 * @see com.artemis.PooledComponent
 * @see com.kalaazu.server.game.netty.GameSession
 * @see com.kalaazu.persistence.entity.AccountsEntity
 * @see com.kalaazu.persistence.entity.AccountsShipsEntity
 * @see com.kalaazu.persistence.entity.AccountsConfigurationsEntity
 * @see com.kalaazu.persistence.entity.MapsEntity
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class PlayerComponent extends PooledComponent {
    private GameSession session;
    private AccountsEntity account;
    private AccountsShipsEntity ship;
    private AccountsConfigurationsEntity config;
    private MapsEntity map;

    /**
     * Resets the component for reuse.
     * This method is called by the ECS world when the component is removed from an entity and returned to the object pool.
     * It nullifies all fields to ensure that the recycled component doesn't hold stale data from a previous player.
     *
     * @example ```java
     * // This method is typically not called by the user, but by the Artemis-odb framework.
     * // When a player entity is deleted (e.g., on logout):
     * world.delete(playerEntityId);
     *
     * // The framework will internally call reset() on the component before pooling it.
     * // playerComponent.reset();
     * ```
     */
    @Override
    protected void reset() {
        session = null;
        account = null;
        ship = null;
        config = null;
        map = null;
    }
}

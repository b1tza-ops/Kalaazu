package com.kalaazu.server.game.netty;

import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsHangarsEntity;
import com.kalaazu.persistence.entity.AccountsShipsEntity;
import io.netty.channel.ChannelId;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Data
@Component
@Scope("prototype")
/**
 * Represents an active player's session in the game.
 *
 * This class holds all the state related to a connected player, such as their
 * account details, current ship, configuration, and their entity ID in the
 * game world. It is managed as a Spring prototype bean, ensuring that a new,
 * unique session instance is created for each connected player.
 *
 * The session's lifecycle is tied to the player's connection. When a player
 * disconnects, the `destroy` method is called as part of the `DisposableBean`
 * contract, allowing for cleanup.
 *
 * @example
 * ```java
 * // In a Spring-managed component
 * @Autowired
 * private ApplicationContext applicationContext;
 *
 * public GameSession createNewSession(io.netty.channel.Channel channel, AccountsEntity account) {
 *     // GameSession is a prototype bean, so a new instance is created each time.
 *     GameSession session = applicationContext.getBean(GameSession.class);
 *
 *     // ... then populate the session with player data
 *     session.setAccount(account);
 *     session.setChannelId(channel.id());
 *
 *     return session;
 * }
 * ```
 *
 * @see org.springframework.beans.factory.DisposableBean
 * @see com.kalaazu.persistence.entity.AccountsEntity
 * @see io.netty.channel.Channel
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public class GameSession implements DisposableBean {
    private final ApplicationContext ctx;

    private ChannelId channelId;

    private AccountsEntity account;
    private AccountsShipsEntity ship;
    private AccountsConfigurationsEntity configuration;
    private AccountsHangarsEntity hangar;
    private Short mapId;
    private int entityId = -1;

    /**
     * Cleans up session resources when the bean is destroyed.
     *
     * This method is part of the `DisposableBean` lifecycle and is automatically
     * invoked by the Spring container when the session bean is destroyed (e.g.,
     * when a player disconnects). It resets the `entityId` to an invalid state.
     * The actual removal of the entity from the game world is handled by other
     * systems that listen for player disconnection events.
     *
     * @example ```java
     * // This method is a lifecycle callback managed by the Spring framework
     * // and should not be called directly.
     * ```
     * @see org.springframework.beans.factory.DisposableBean#destroy()
     */
    @Override
    public void destroy() {
        entityId = -1;
    }
}

package com.kalaazu.server.event;

import com.kalaazu.server.game.netty.GameSession;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * Game session started event.
 * ===========================
 * <p>
 * Fired when a new game session connects to the server and the
 * initial packets are sent.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class GameSessionStartedEvent extends ApplicationEvent {
    private final GameSession session;

    public GameSessionStartedEvent(GameSession session) {
        super(new Object());

        this.session = session;
    }
}

package com.kalaazu.server.event;

import com.kalaazu.server.game.netty.GameSession;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * End game session event.
 * =======================
 * <p>
 * Ends the given game session.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class EndGameSession extends ApplicationEvent {
    private final GameSession session;

    public EndGameSession(GameSession session) {
        super(new Object());

        this.session = session;
    }
}

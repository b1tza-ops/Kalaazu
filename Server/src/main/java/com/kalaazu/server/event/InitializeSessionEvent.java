package com.kalaazu.server.event;

import com.kalaazu.server.game.netty.GameSession;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class InitializeSessionEvent extends ApplicationEvent {
    private final int userId;
    private final String sessionId;
    private final GameSession session;

    public InitializeSessionEvent(int userId, String sessionId, GameSession session, Object source) {
        super(source);

        this.userId = userId;
        this.sessionId = sessionId;
        this.session = session;
    }
}

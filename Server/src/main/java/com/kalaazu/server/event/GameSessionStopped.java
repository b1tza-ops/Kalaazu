package com.kalaazu.server.event;

import org.springframework.context.ApplicationEvent;

/**
 * Game session stopped event.
 * <p>
 * Fired when a session is closed.
 *
 * @author manulaiko
 */
public class GameSessionStopped extends ApplicationEvent {
    public GameSessionStopped() {
        super(new Object());
    }
}

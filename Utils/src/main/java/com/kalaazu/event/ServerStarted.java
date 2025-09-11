package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Server started event.
 * <p>
 * Fired when the game server has started successfully.
 *
 * @author manulaiko
 */
public class ServerStarted extends ApplicationEvent {
    public ServerStarted() {
        super(new Object());
    }
}

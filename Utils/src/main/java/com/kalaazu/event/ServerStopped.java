package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Server stopped event.
 * <p>
 * Fired when the server has been successfully stopped.
 *
 * @author manulaiko
 */
public class ServerStopped extends ApplicationEvent {
    public ServerStopped() {
        super(new Object());
    }
}

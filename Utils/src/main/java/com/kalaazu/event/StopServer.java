package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Stop kalaazu event.
 * <p>
 * Event fired to stop the application.
 *
 * @author manulaiko
 */
public class StopServer extends ApplicationEvent {
    public StopServer() {
        super(new Object());
    }
}

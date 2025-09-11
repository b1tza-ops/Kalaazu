package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Start kalaazu event.
 * <p>
 * Event fired to start the application.
 *
 * @author manulaiko
 */
public class StartServer extends ApplicationEvent {
    public StartServer() {
        super(new Object());
    }
}

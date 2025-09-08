package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Start kalaazu event.
 * <p>
 * Event fired to start the application.
 *
 * @author manulaiko
 */
public class StartKalaazuEvent extends ApplicationEvent {
    public StartKalaazuEvent(Object source) {
        super(source);
    }
}

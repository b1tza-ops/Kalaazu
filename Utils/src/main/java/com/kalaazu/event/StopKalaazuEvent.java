package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Stop kalaazu event.
 * <p>
 * Event fired to stop the application.
 *
 * @author manulaiko
 */
public class StopKalaazuEvent extends ApplicationEvent {
    public StopKalaazuEvent(Object source) {
        super(source);
    }
}

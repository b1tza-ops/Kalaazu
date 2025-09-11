package com.kalaazu.ui.event;

import org.springframework.context.ApplicationEvent;

/**
 * Show main screen event.
 * <p>
 * Event fired for showing the main screen in the Dashboard
 *
 * @author manulaiko
 */
public class ShowMainScreenEvent extends ApplicationEvent {
    public ShowMainScreenEvent() {
        super(new Object());
    }
}

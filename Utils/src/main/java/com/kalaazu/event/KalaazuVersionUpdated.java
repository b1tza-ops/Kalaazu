package com.kalaazu.event;

import org.springframework.context.ApplicationEvent;

/**
 * Kalaazu version updated.
 * <p>
 * Event fired when the user changes the version through the Combobox.
 *
 * @author manulaiko
 */
public class KalaazuVersionUpdated extends ApplicationEvent {
    public KalaazuVersionUpdated() {
        super(new Object());
    }
}

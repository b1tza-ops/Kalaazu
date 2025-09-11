package com.kalaazu.server.event;

import com.kalaazu.server.game.commands.OutCommand;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * Broadcast packet event.
 * =======================
 * <p>
 * Use this event to send packets to all available sessions.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class BroadcastCommand extends ApplicationEvent {
    private final OutCommand command;

    public BroadcastCommand(OutCommand command) {
        super(new Object());

        this.command = command;
    }
}

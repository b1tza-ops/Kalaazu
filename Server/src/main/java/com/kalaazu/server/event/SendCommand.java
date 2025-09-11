package com.kalaazu.server.event;

import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * Send command event.
 * ===================
 * <p>
 * Use this event to send commands to the given game session.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class SendCommand extends ApplicationEvent {
    private final GameSession session;
    private final OutCommand command;

    public SendCommand(GameSession session, OutCommand command) {
        super(new Object());

        this.session = session;
        this.command = command;
    }
}

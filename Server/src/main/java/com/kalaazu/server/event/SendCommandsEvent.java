package com.kalaazu.server.event;

import com.kalaazu.server.game.command.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

import java.util.List;

/**
 * Send packets event.
 * ===================
 * <p>
 * Use this event to send packets to the given game session.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class SendCommandsEvent extends ApplicationEvent {
    private final GameSession session;
    private final List<? extends OutCommand> commands;

    public SendCommandsEvent(GameSession session, List<? extends OutCommand> commands, Object source) {
        super(source);

        this.session = session;
        this.commands = commands;
    }
}

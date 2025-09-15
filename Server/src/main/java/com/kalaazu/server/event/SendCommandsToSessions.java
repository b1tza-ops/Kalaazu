package com.kalaazu.server.event;

import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import lombok.Data;
import org.springframework.context.ApplicationEvent;

import java.util.Collection;
import java.util.List;

/**
 * Send commands to sessions event.
 * ===============================
 *
 * Sends a list of commands to a collection of sessions.
 *
 * This event is published when multiple commands need to be sent to a specific
 * group of game sessions. The `ChannelManager` listens for this event and
 * efficiently handles the network dispatch by serializing each command only
 * once and writing the resulting packets to all target sessions.
 *
 * @author manulaiko <manulaiko@gmail.com>
 * @example ```java
 * // To publish this event:
 * applicationContext.publishEvent(new SendCommandsToSessions(
 * List.of(session1, session2),
 * List.of(command1, command2)
 * ));
 * ```
 * @see com.kalaazu.server.game.netty.ChannelManager#handleSendPacketsToSessions(SendCommandsToSessions)
 */
@Data
public class SendCommandsToSessions extends ApplicationEvent {
    private final Collection<GameSession> sessions;
    private final List<OutCommand> commands;

    public SendCommandsToSessions(Collection<GameSession> sessions, List<OutCommand> commands) {
        super(sessions);

        this.sessions = sessions;
        this.commands = commands;
    }
}
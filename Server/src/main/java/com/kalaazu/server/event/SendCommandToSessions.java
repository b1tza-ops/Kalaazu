package com.kalaazu.server.event;

import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import lombok.Data;
import org.springframework.context.ApplicationEvent;

import java.util.Collection;

/**
 * Send command to sessions event.
 * =============================
 *
 * Sends a command to a collection of sessions.
 *
 * This event is published when a single command needs to be sent to multiple,
 * specific game sessions (but not broadcast to all). The `ChannelManager`
 * listens for this event and efficiently handles the network dispatch.
 *
 * @author manulaiko <manulaiko@gmail.com>
 * @example ```java
 * // To publish this event:
 * applicationContext.publishEvent(new SendCommandToSessions(List.of(session1, session2), myCommand));
 * ```
 * @see com.kalaazu.server.game.netty.ChannelManager#handleSendPacketToSessions(SendCommandToSessions)
 */
@Data
public class SendCommandToSessions extends ApplicationEvent {
    private final Collection<GameSession> sessions;
    private final OutCommand command;

    public SendCommandToSessions(Collection<GameSession> sessions, OutCommand command) {
        super(sessions);

        this.sessions = sessions;
        this.command = command;
    }
}
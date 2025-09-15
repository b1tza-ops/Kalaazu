package com.kalaazu.server.game.netty;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.server.event.*;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import io.netty.channel.Channel;
import io.netty.channel.ChannelId;
import io.netty.channel.group.ChannelGroup;
import io.netty.channel.group.DefaultChannelGroup;
import io.netty.util.concurrent.GlobalEventExecutor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Channel manager.
 *
 * Manages all Netty channels and their associated game sessions. This class acts
 * as the central hub for network communication, bridging the gap between the
 * application's event-driven architecture and the low-level networking layer.
 *
 * It is responsible for:
 * - Processing incoming packets and delegating them to the appropriate {@link Handler}.
 * - Sending outgoing commands to single clients, multiple clients, or broadcasting to all.
 * - Managing the lifecycle of {@link GameSession}s.
 * - Listening for application-level events (e.g., {@link SendCommand}) and translating them into network actions.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component
@RequiredArgsConstructor
public class ChannelManager implements Logger {
    private final ChannelGroup channels = new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);
    private final Map<ChannelId, GameSession> sessions = new ConcurrentHashMap<>();

    private final ApplicationContext ctx;
    private final List<Handler<?>> packetHandlers;
    private final KalaazuConfig config;

    @Getter
    private final LoggingCategory category = LoggingCategory.NETWORK;

    /**
     * Registers a new game session and its associated channel.
     *
     * @param session The game session to start.
     * @param channel The Netty channel associated with the session.
     */
    public void startGameSession(GameSession session, Channel channel) {
        sessions.put(session.getChannelId(), session);
        channels.add(channel);
    }

    /**
     * Processes an incoming packet from a specific channel.
     *
     * It finds the corresponding {@link GameSession} and then identifies the correct
     * {@link Handler} to process the packet's content. If no handler is found for
     * a given packet, a warning is logged.
     *
     * @param packet    The received packet.
     * @param channelId The ID of the channel that received the packet.
     */
    public void processPacket(Packet packet, ChannelId channelId) {
        var connection = sessions.get(channelId);
        if (connection == null) {
            info("Invalid connection {}, packet: {}", channelId, packet);

            return;
        }

        packetHandlers.stream()
                .filter(h -> h.getVersion() == config.getGame().getVersion())
                .filter(h -> {
                    if (h.canHandle(packet)) {
                        return true;
                    }

                    packet.reset();

                    return false;
                })
                .findFirst()
                .ifPresentOrElse(
                        (h) -> h.handle(packet, connection),
                        () -> info("Received packet with no handler: {}", packet.toString())
                );
    }

    /**
     * Handles the {@link SendCommand} event to send a single command to a specific session.
     *
     * @param event The event containing the session and command.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new SendCommand(session, myCommand));
     * ```
     * @see SendCommand
     */
    @EventListener
    public void handleSendPacket(SendCommand event) {
        this.send(event.getSession().getChannelId(), event.getCommand());
    }

    /**
     * Sends a single command to a specific channel.
     *
     * @param channelId The ID of the channel to send the command to.
     * @param command   The command to send.
     */
    private void send(ChannelId channelId, OutCommand command) {
        var channel = channels.find(channelId);
        if (channel == null || command == null) {
            return;
        }

        var p = Packet.empty();
        command.write(p);

        if (config.getGame().getPackets().isPrintOut()) {
            info("Packet sent: >>>>> {} ({})", command, p);
        }

        channel.writeAndFlush(p);
    }

    /**
     * Handles the {@link SendCommands} event to send a list of commands to a specific session.
     *
     * @param event The event containing the session and the list of commands.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new SendCommands(session, List.of(command1, command2)));
     * ```
     * @see SendCommands
     */
    @EventListener
    public void handleSendPackets(SendCommands event) {
        this.send(event.getSession().getChannelId(), event.getCommands());
    }

    /**
     * Sends a list of commands to a specific channel.
     *
     * This method writes all commands to the channel's buffer before performing a single flush,
     * which is more efficient than calling `writeAndFlush` for each command.
     *
     * @param channelId The ID of the channel to send the commands to.
     * @param commands  The list of commands to send.
     */
    private void send(ChannelId channelId, List<? extends OutCommand> commands) {
        var channel = channels.find(channelId);
        if (channel == null || commands == null || commands.isEmpty()) {
            return;
        }

        commands.stream()
                .filter(Objects::nonNull)
                .map(c -> {
                    var p = Packet.empty();
                    c.write(p);

                    if (config.getGame().getPackets().isPrintOut()) {
                        info("Packet sent: >>>>> {} ({})", c, p);
                    }
                    return p;
                })
                .forEach(channel::write);
        channel.flush();
    }

    /**
     * Handles the {@link SendCommandToSessions} event to send a single command to a collection of sessions.
     *
     * @param event The event containing the target sessions and the command.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new SendCommandToSessions(List.of(session1, session2), myCommand));
     * ```
     * @see SendCommandToSessions
     */
    @EventListener
    public void handleSendPacketToSessions(SendCommandToSessions event) {
        this.send(event.getSessions(), event.getCommand());
    }

    /**
     * Sends a single command to a list of game sessions efficiently.
     *
     * This method writes the command to all channel buffers first and then
     * performs a single flush operation on the entire channel group, which is
     * more performant than calling `writeAndFlush` in a loop.
     *
     * @param sessions The list of game sessions to send the command to.
     * @param command  The command to send.
     */
    private void send(Collection<GameSession> sessions, OutCommand command) {
        if (command == null || sessions == null || sessions.isEmpty()) {
            return;
        }

        var packet = Packet.empty();
        command.write(packet);

        if (config.getGame().getPackets().isPrintOut()) {
            info("Packet sent to {} sessions: >>>>> {} ({})", sessions.size(), command, packet);
        }

        sessions.forEach(s -> channels.find(s.getChannelId()).write(packet));
        channels.flush();
    }

    public void endGameSession(ChannelId channelId) {
        var session = sessions.get(channelId);
        if (session != null) {
            session.destroy();
        }

        sessions.remove(channelId);
        channels.close(channel -> channel.id().equals(channelId));
        ctx.publishEvent(new GameSessionStopped());
    }

    /**
     * Handles the {@link SendCommandsToSessions} event to send a list of commands to a collection of sessions.
     *
     * @param event The event containing the target sessions and the list of commands.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new SendCommandsToSessions(List.of(session1, session2), List.of(command1, command2)));
     * ```
     * @see SendCommandsToSessions
     */
    @EventListener
    public void handleSendPacketsToSessions(SendCommandsToSessions event) {
        this.send(event.getSessions(), event.getCommands());
    }

    // Event Handlers //

    /**
     * Sends a list of commands to a collection of game sessions efficiently.
     *
     * This method iterates through each command and writes it to all specified channel buffers,
     * then performs a single flush at the end. This is significantly more performant
     * than sending each command individually.
     *
     * @param sessions The collection of game sessions to send the commands to.
     * @param commands The list of commands to send.
     */
    private void send(Collection<GameSession> sessions, List<? extends OutCommand> commands) {
        if (commands == null || commands.isEmpty() || sessions == null || sessions.isEmpty()) {
            return;
        }

        // Serialize each command into a packet only once.
        var packets = commands.stream()
                .filter(Objects::nonNull)
                .map(c -> {
                    var p = Packet.empty();
                    c.write(p);
                    if (config.getGame().getPackets().isPrintOut()) {
                        info("Packet to be sent to {} sessions: >>>>> {} ({})", sessions.size(), c, p);
                    }
                    return p;
                }).toList();

        // Write the pre-serialized packets to each session's channel.
        sessions.forEach(s -> {
            var channel = channels.find(s.getChannelId());
            if (channel != null) {
                packets.forEach(channel::write);
            }
        });

        // Flush all channels in the group at once.
        channels.flush();
    }

    /**
     * Handles the {@link BroadcastCommand} event to send a single command to all connected sessions.
     *
     * @param event The event containing the command to broadcast.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new BroadcastCommand(myCommand));
     * ```
     * @see BroadcastCommand
     */
    @EventListener
    public void handleBroadcastPacket(BroadcastCommand event) {
        this.send(event.getCommand());
    }

    /**
     * Broadcasts a single command to all connected channels.
     *
     * @param command The command to broadcast.
     */
    private void send(OutCommand command) {
        if (command == null) {
            return;
        }

        var packet = Packet.empty();
        command.write(packet);

        if (config.getGame().getPackets().isPrintOut()) {
            info("Packet sent: >>>>> {} ({})", command, packet);
        }

        channels.writeAndFlush(packet);
    }

    /**
     * Handles the {@link BroadcastCommands} event to send a list of commands to all connected sessions.
     *
     * @param event The event containing the list of commands to broadcast.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new BroadcastCommands(List.of(command1, command2)));
     * ```
     * @see BroadcastCommands
     */
    @EventListener
    public void handleBroadcastPacket(BroadcastCommands event) {
        this.send(event.getCommands());
    }

    /**
     * Broadcasts a list of commands to all connected channels.
     *
     * This method writes all commands to the channel group's buffer before performing a single flush,
     * which is more efficient than calling `writeAndFlush` for each command.
     *
     * @param commands The list of commands to broadcast.
     */
    private void send(List<? extends OutCommand> commands) {
        if (commands == null || commands.isEmpty()) {
            return;
        }

        commands.stream()
                .filter(Objects::nonNull)
                .map(c -> {
                    var p = Packet.empty();
                    c.write(p);

                    if (config.getGame().getPackets().isPrintOut()) {
                        info("Packet sent: >>>>> {} ({})", c, p);
                    }

                    return p;
                })
                .forEach(channels::write);
        channels.flush();
    }

    /**
     * Handles the {@link EndGameSessionIf} event to terminate sessions that match a given predicate.
     *
     * This is useful for kicking players based on certain criteria, such as inactivity or
     * having a specific status.
     *
     * @param event The event containing the condition to evaluate.
     *
     * @example ```java
     * // To kick all players from a certain faction:
     * applicationContext.publishEvent(new EndGameSessionIf(s -> s.getAccount().getFactionsId() == 1));
     * ```
     * @see EndGameSessionIf
     */
    @EventListener
    public void handleEndGameSessionIf(EndGameSessionIf event) {
        var condition = event.getCondition();

        sessions.entrySet()
                .stream()
                .filter(condition::apply)
                .map(Map.Entry::getKey)
                .forEach(this::endGameSession);
    }

    /**
     * Handles the {@link EndGameSession} event to terminate a specific game session.
     *
     * @param event The event containing the session to terminate.
     *
     * @example ```java
     * // To publish this event:
     * applicationContext.publishEvent(new EndGameSession(sessionToKick));
     * ```
     * @see EndGameSession
     */
    @EventListener
    public void handleEndGameSession(EndGameSession event) {
        this.endGameSession(event.getSession());
    }

    /**
     * Ends a game session, cleans up resources, and closes the associated channel.
     *
     * @param session The game session to end.
     */
    public void endGameSession(GameSession session) {
        endGameSession(session.getChannelId());
    }
}

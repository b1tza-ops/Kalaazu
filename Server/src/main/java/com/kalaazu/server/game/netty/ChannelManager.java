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

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Channel manager.
 * ================
 * <p>
 * Manages the actions related to channels.
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

    public void startGameSession(GameSession session, Channel channel) {
        sessions.put(session.getChannelId(), session);
        channels.add(channel);
    }

    public void endGameSession(GameSession session) {
        endGameSession(session.getChannelId());
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
     * Process the incoming packet.
     *
     * @param packet    Received packet.
     * @param channelId Channel that received the packet.
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

    // Event Handlers //

    @EventListener
    public void handleSendPacket(SendCommand event) {
        this.send(event.getSession().getChannelId(), event.getCommand());
    }

    @EventListener
    public void handleSendPackets(SendCommands event) {
        this.send(event.getSession().getChannelId(), event.getCommands());
    }

    @EventListener
    public void handleBroadcastPacket(BroadcastCommand event) {
        this.send(event.getCommand());
    }

    @EventListener
    public void handleBroadcastPacket(BroadcastCommands event) {
        this.send(event.getCommands());
    }

    @EventListener
    public void handleEndGameSessionIf(EndGameSessionIf event) {
        var condition = event.getCondition();

        sessions.entrySet()
                .stream()
                .filter(condition::apply)
                .map(Map.Entry::getKey)
                .forEach(this::endGameSession);
    }

    @EventListener
    public void handleEndGameSession(EndGameSession event) {
        this.endGameSession(event.getSession());
    }
}

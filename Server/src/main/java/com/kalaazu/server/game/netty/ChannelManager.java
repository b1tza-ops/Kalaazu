package com.kalaazu.server.game.netty;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.server.event.*;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.Handler;
import io.netty.channel.Channel;
import io.netty.channel.ChannelId;
import io.netty.channel.group.ChannelGroup;
import io.netty.channel.group.DefaultChannelGroup;
import io.netty.util.concurrent.GlobalEventExecutor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
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
@Slf4j
@RequiredArgsConstructor
public class ChannelManager {
    private final ChannelGroup channels = new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);
    private final Map<ChannelId, GameSession> sessions = new ConcurrentHashMap<>();

    private final ApplicationContext ctx;
    private final List<Handler<?>> packetHandlers;
    private final KalaazuConfig config;

    private void send(ChannelId channelId, OutCommand command) {
        var channel = channels.find(channelId);
        if (channel == null) {
            return;
        }

        if (config.getGame().getPackets().isPrintOut()) {
            log.info("Packet sent: >>>>> {}", command);
        }

        var p = Packet.empty();
        command.write(p);

        channel.writeAndFlush(p);
    }

    private void send(ChannelId channelId, List<? extends OutCommand> commands) {
        var channel = channels.find(channelId);
        if (channel == null) {
            return;
        }

        if (config.getGame().getPackets().isPrintOut()) {
            commands.forEach(p -> log.info("Packet sent: >>>>> {}", p));
        }

        commands.stream()
                .map(c -> {
                    var p = Packet.empty();
                    c.write(p);

                    return p;
                })
                .forEach(channel::write);
        channel.flush();
    }

    private void send(OutCommand command) {
        var packet = Packet.empty();
        command.write(packet);

        if (config.getGame().getPackets().isPrintOut()) {
            log.info("Packet sent: >>>>> {}", command);
        }

        channels.writeAndFlush(packet);
    }

    private void send(List<? extends OutCommand> packet) {
        packet.stream()
                .map(c -> {
                    var p = Packet.empty();
                    c.write(p);

                    if (config.getGame().getPackets().isPrintOut()) {
                        log.info("Packet sent: >>>>> {}", p);
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
            log.info("Invalid connection {}, packet: {}", channelId, packet);

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
                        () -> log.info("Received packet with no handler: {}", packet.toString())
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

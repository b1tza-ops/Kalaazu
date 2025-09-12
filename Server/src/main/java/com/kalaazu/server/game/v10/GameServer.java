package com.kalaazu.server.game.v10;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.InboundHandler;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.LengthFieldBasedFrameDecoder;
import io.netty.handler.codec.LengthFieldPrepender;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Socket server.
 * ==============
 * <p>
 * Listens for connections to the game socket server.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
@Component("v10GameServer")
@RequiredArgsConstructor
public class GameServer extends com.kalaazu.server.game.GameServer implements Logger {
    private final Version version = Version.V10;
    private final InboundHandler inboundHandler;
    private final KalaazuConfig config;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    @Override
    public Packet getEmptyPacket() {
        return new com.kalaazu.server.game.v10.Packet();
    }

    @Override
    protected ChannelHandler getChildHandler() {
        return new ChannelInitializer<SocketChannel>() {
            @Override
            public void initChannel(SocketChannel ch) {
                ch.pipeline().addLast(
                        new LengthFieldPrepender(2),
                        new LengthFieldBasedFrameDecoder(Integer.MAX_VALUE, 0, 2),
                        new PacketSerializer(),
                        inboundHandler
                );
            }
        };
    }
}

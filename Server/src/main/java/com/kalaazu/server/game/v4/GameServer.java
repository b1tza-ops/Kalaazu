package com.kalaazu.server.game.v4;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.InboundHandler;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.DelimiterBasedFrameDecoder;
import io.netty.handler.codec.string.StringDecoder;
import io.netty.handler.codec.string.StringEncoder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.nio.charset.Charset;


/**
 * Socket server.
 * ==============
 * <p>
 * Listens for connections to the game socket server.
 *
 * @author manulaiko
 */
@Getter
@Component("v4GameServer")
@RequiredArgsConstructor
public class GameServer extends com.kalaazu.server.game.GameServer implements Logger {
    private final Version version = Version.V4;
    private final InboundHandler inboundHandler;
    private final KalaazuConfig config;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    @Override
    public Packet getEmptyPacket() {
        return new com.kalaazu.server.game.v4.Packet();
    }

    @Override
    protected ChannelHandler getChildHandler() {
        return new ChannelInitializer<SocketChannel>() {
            @Override
            public void initChannel(SocketChannel ch) {
                ch.pipeline().addLast(
                        new DelimiterBasedFrameDecoder(
                                8192,
                                Unpooled.wrappedBuffer(new byte[]{'\n', '\0'})
                        ),
                        new StringDecoder(Charset.defaultCharset()),
                        new StringEncoder(Charset.defaultCharset()),
                        new PacketSerializer(),
                        inboundHandler
                );
            }
        };
    }
}

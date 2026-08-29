package com.kalaazu.server.game.browser;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.StartServer;
import com.kalaazu.event.StopServer;
import com.kalaazu.server.game.netty.InboundHandler;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.MultiThreadIoEventLoopGroup;
import io.netty.channel.nio.NioIoHandler;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpServerCodec;
import io.netty.handler.codec.http.websocketx.WebSocketServerProtocolHandler;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.event.EventListener;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Component;

/**
 * Loopback WebSocket transport for the clean HTML5 client.
 */
@Component
@RequiredArgsConstructor
public class BrowserGameServer implements Logger {
    private final InboundHandler inboundHandler;
    private final KalaazuConfig config;

    @Autowired
    @Qualifier("virtualThreadTaskExecutor")
    private TaskExecutor taskExecutor;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    private volatile boolean running;
    private Channel serverChannel;
    private EventLoopGroup bossGroup;
    private EventLoopGroup workerGroup;

    @EventListener
    public synchronized void start(StartServer event) {
        if (running) {
            return;
        }

        running = true;
        taskExecutor.execute(this::run);
    }

    @EventListener
    public synchronized void stop(StopServer event) {
        running = false;

        if (serverChannel != null) {
            serverChannel.close();
        }

        shutdownEventLoops();
    }

    private void run() {
        var port = config.getPort().getBrowser();
        info("Starting browser game gateway on port {}...", port);

        try {
            bossGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());
            workerGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());

            serverChannel = new ServerBootstrap()
                    .group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        protected void initChannel(SocketChannel channel) {
                            channel.pipeline().addLast(
                                    new HttpServerCodec(),
                                    new HttpObjectAggregator(65_536),
                                    new WebSocketServerProtocolHandler("/game", null, true),
                                    new BrowserPacketCodec(),
                                    inboundHandler
                            );
                        }
                    })
                    .bind(config.getBindAddress(), port)
                    .sync()
                    .channel();

            serverChannel.closeFuture().sync();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            error("Failed to start browser game gateway.", e);
        } finally {
            shutdownEventLoops();
            running = false;
        }
    }

    private void shutdownEventLoops() {
        if (workerGroup != null) {
            workerGroup.shutdownGracefully();
            workerGroup = null;
        }

        if (bossGroup != null) {
            bossGroup.shutdownGracefully();
            bossGroup = null;
        }

        serverChannel = null;
    }
}

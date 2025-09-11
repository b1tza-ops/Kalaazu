package com.kalaazu.server.game;

import com.kalaazu.KalaazuConfig;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioIoHandler;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.DelimiterBasedFrameDecoder;
import io.netty.handler.codec.Delimiters;
import io.netty.handler.codec.string.StringDecoder;
import io.netty.handler.codec.string.StringEncoder;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * Socket server.
 * ==============
 * <p>
 * Listens for connections to the game socket server.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@RequiredArgsConstructor
@Component
@Slf4j
public class PolicyServer implements Runnable {
    public static final String POLICY_RESPONSE = "<?xml version=\"1.0\"?><cross-domain-policy xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd\"><allow-access-from domain=\"*\" to-ports=\"*\" secure=\"false\" /><site-control permitted-cross-domain-policies=\"master-only\" /></cross-domain-policy>\r\n";

    private final KalaazuConfig config;

    private boolean isRunning;
    private Channel serverChannel;
    private EventLoopGroup bossGroup;
    private EventLoopGroup workerGroup;

    public void start() {
        if (isRunning) {
            return;
        }

        var serverThread = new Thread(this);
        serverThread.start();
    }

    public void run() {
        isRunning = true;

        log.info("Starting policy server on port {}...", config.getPort().getPolicy());
        try {
            bossGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());
            workerGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());

            var b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .handler(new LoggingHandler(LogLevel.TRACE))
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        public void initChannel(SocketChannel ch) {
                            ch.pipeline().addLast(
                                    new DelimiterBasedFrameDecoder(1024, Delimiters.nulDelimiter()),
                                    new StringDecoder(),
                                    new StringEncoder(),
                                    new InboundHandler()
                            );
                        }
                    })
                    .option(ChannelOption.SO_BACKLOG, 128)
                    .childOption(ChannelOption.SO_KEEPALIVE, true);

            // Bind and start to accept incoming connections.
            serverChannel = b.bind(config.getPort().getPolicy()).sync().channel();

            serverChannel.closeFuture().sync();
        } catch (Exception e) {
            log.warn("Couldn't start policy server!", e);
        } finally {
            workerGroup.shutdownGracefully();
            bossGroup.shutdownGracefully();
        }
    }

    /**
     * Stops the server gracefully.
     */
    public void stop() {
        log.info("Stopping policy server...");
        if (serverChannel != null) {
            serverChannel.close(); // trigger closeFuture
        }

        shutdownEventLoops();
        this.isRunning = false;
    }

    private void shutdownEventLoops() {
        try {
            workerGroup.shutdownGracefully().sync();
            bossGroup.shutdownGracefully().sync();
        } catch (InterruptedException e) {
            log.warn("Event loop shutdown interrupted", e);
            Thread.currentThread().interrupt();
        }
    }

    @Slf4j
    static class InboundHandler extends SimpleChannelInboundHandler<String> {

        @Override
        public void channelRegistered(ChannelHandlerContext ctx) throws Exception {
            log.debug("Received policy server connection!");

            super.channelRegistered(ctx);
        }

        /**
         * Is called for each message.
         *
         * @param ctx the {@link ChannelHandlerContext} which this {@link SimpleChannelInboundHandler}
         *            belongs to
         * @param msg the message to handle
         * @throws Exception is thrown if an error occurred
         */
        @Override
        protected void channelRead0(ChannelHandlerContext ctx, String msg) throws Exception {
            log.debug("Received policy server request! {}", msg);

            ctx.channel().writeAndFlush(PolicyServer.POLICY_RESPONSE);
            ctx.channel().close().sync();
        }
    }
}

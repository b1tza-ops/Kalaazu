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
    public static final String POLICY_RESPONSE =
            "<?xml version=\"1.0\"?><cross-domain-policy xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " +
                    "xsi:noNamespaceSchemaLocation=\"http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd\">" +
                    "<allow-access-from domain=\"*\" to-ports=\"*\" secure=\"false\" />" +
                    "<site-control permitted-cross-domain-policies=\"master-only\" /></cross-domain-policy>\r\n";

    private final KalaazuConfig config;

    private volatile boolean isRunning;
    private Thread serverThread;
    private Channel serverChannel;
    private EventLoopGroup bossGroup;
    private EventLoopGroup workerGroup;

    /**
     * Starts the server in a separate thread.
     */
    public synchronized void start() {
        if (isRunning) {
            log.warn("Policy server is already running.");
            return;
        }

        serverThread = new Thread(this, "PolicyServerThread");
        serverThread.start();
    }

    @Override
    public void run() {
        isRunning = true;
        int port = config.getPort().getPolicy();
        log.info("Starting policy server on port {}...", port);

        try {
            bossGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());
            workerGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());

            ServerBootstrap bootstrap = new ServerBootstrap();
            bootstrap.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .handler(new LoggingHandler(LogLevel.INFO))
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        protected void initChannel(SocketChannel ch) {
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

            serverChannel = bootstrap.bind(port).sync().channel();
            serverChannel.closeFuture().sync();
        } catch (InterruptedException e) {
            log.warn("Policy server thread interrupted.", e);
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            log.error("Failed to start policy server.", e);
        } finally {
            shutdownEventLoops();
            isRunning = false;
            log.info("Policy server stopped.");
        }
    }

    /**
     * Stops the server gracefully.
     */
    public synchronized void stop() {
        if (!isRunning) {
            log.warn("Policy server is not running.");
            return;
        }

        log.info("Stopping policy server...");
        isRunning = false;

        if (serverChannel != null && serverChannel.isOpen()) {
            serverChannel.close();
        }

        shutdownEventLoops();

        if (serverThread != null && serverThread.isAlive()) {
            serverThread.interrupt();
        }
    }

    /**
     * Gracefully shuts down Netty event loops.
     */
    private void shutdownEventLoops() {
        try {
            if (workerGroup != null) workerGroup.shutdownGracefully().sync();
            if (bossGroup != null) bossGroup.shutdownGracefully().sync();
        } catch (InterruptedException e) {
            log.warn("Event loop shutdown interrupted", e);
            Thread.currentThread().interrupt();
        } finally {
            serverChannel = null;
            workerGroup = null;
            bossGroup = null;
        }
    }

    /**
     * Handles inbound requests and sends the policy response.
     */
    @Slf4j
    static class InboundHandler extends SimpleChannelInboundHandler<String> {
        @Override
        public void channelRegistered(ChannelHandlerContext ctx) {
            log.debug("Received policy server connection!");
            ctx.fireChannelRegistered();
        }

        @Override
        protected void channelRead0(ChannelHandlerContext ctx, String msg) {
            log.debug("Received policy server request: {}", msg);
            ctx.writeAndFlush(POLICY_RESPONSE).addListener(ChannelFutureListener.CLOSE);
        }
    }
}

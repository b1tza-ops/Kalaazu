package com.kalaazu.server.game;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.model.Version;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioIoHandler;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import lombok.extern.slf4j.Slf4j;

/**
 * Game server interface.
 * ======================
 * <p>
 * Interface for all game server version implementations.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Slf4j
public abstract class GameServer implements Runnable {
    private static GameServer INSTANCE;

    private boolean isRunning;
    private Channel serverChannel;
    private EventLoopGroup bossGroup;
    private EventLoopGroup workerGroup;

    public static GameServer getInstance() {
        if (INSTANCE == null) {
            throw new IllegalStateException("GameServer has not been initialized");
        }

        return INSTANCE;
    }

    public void start() {
        if (isRunning) {
            return;
        }

        var serverThread = new Thread(this);
        serverThread.start();
    }

    public void run() {
        INSTANCE = this;
        isRunning = true;
        var port = getConfig().getPort().getServer();

        log.info("Starting emulator server on port {}...", port);
        try {
            bossGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());
            workerGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());

            var b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .handler(new LoggingHandler(LogLevel.TRACE))
                    .childHandler(getChildHandler())
                    .option(ChannelOption.SO_BACKLOG, 128)
                    .childOption(ChannelOption.SO_KEEPALIVE, true);

            // Bind and start to accept incoming connections.
            serverChannel = b.bind(port).sync().channel();

            // Wait until the server socket is closed.
            // In this example, this does not happen, but you can do that to gracefully
            // shut down your server.
            serverChannel.closeFuture().sync();
        } catch (Exception e) {
            log.warn("Couldn't start emulator server!", e);
        } finally {
            workerGroup.shutdownGracefully();
            bossGroup.shutdownGracefully();
        }
    }

    /**
     * Stops the server gracefully.
     */
    public void stop() {
        log.info("Stopping game {} server...", getVersion());
        isRunning = false;

        if (serverChannel != null) {
            serverChannel.close(); // trigger closeFuture
        }

        shutdownEventLoops();
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

    public abstract Packet getEmptyPacket();

    public abstract Version getVersion();

    protected abstract ChannelHandler getChildHandler();

    protected abstract KalaazuConfig getConfig();
}

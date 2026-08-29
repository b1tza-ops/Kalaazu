package com.kalaazu.server.game;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.model.Version;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioIoHandler;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import lombok.Getter;
import org.springframework.core.task.TaskExecutor;

/**
 * Game server interface.
 * ======================
 * <p>
 * Interface for all game server version implementations.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class GameServer implements Runnable, Logger {
    private static volatile GameServer INSTANCE;

    private volatile boolean isRunning = false;

    private Channel serverChannel;
    private EventLoopGroup bossGroup;
    private EventLoopGroup workerGroup;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    /**
     * Returns the singleton instance.
     */
    public static GameServer getInstance() {
        if (INSTANCE == null) {
            throw new IllegalStateException("GameServer has not been initialized");
        }
        return INSTANCE;
    }

    /**
     * Starts the server in a new thread if not already running.
     */
    public synchronized void start(TaskExecutor executor) {
        if (isRunning) {
            warn("Server {} is already running.", getVersion());
            return;
        }

        // Execute the server's run() method on the provided executor.
        executor.execute(this);
    }

    @Override
    public void run() {
        INSTANCE = this;
        isRunning = true;

        int port = getConfig().getPort().getServer();
        info("Starting {} server on port {}...", getVersion(), port);

        try {
            // Initialize Netty event loops
            bossGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());
            workerGroup = new MultiThreadIoEventLoopGroup(NioIoHandler.newFactory());

            ServerBootstrap bootstrap = new ServerBootstrap();
            bootstrap.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .handler(new LoggingHandler(LogLevel.INFO))
                    .childHandler(getChildHandler())
                    .option(ChannelOption.SO_BACKLOG, 128)
                    .childOption(ChannelOption.SO_KEEPALIVE, true);

            // Bind server and wait until closed
            serverChannel = bootstrap.bind(getConfig().getBindAddress(), port).sync().channel();
            serverChannel.closeFuture().sync();

        } catch (InterruptedException e) {
            warn("Server thread interrupted.", e);
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            error("Failed to start {} server.", getVersion(), e);
        } finally {
            shutdownEventLoops();
            isRunning = false;
            info("{} server stopped.", getVersion());
        }
    }

    /**
     * Stops the server gracefully.
     */
    public synchronized void stop() {
        if (!isRunning) {
            warn("{} server is not running.", getVersion());
            return;
        }

        info("Stopping {} server...", getVersion());
        isRunning = false;

        if (serverChannel != null && serverChannel.isOpen()) {
            serverChannel.close();
        }

        shutdownEventLoops();
    }

    /**
     * Gracefully shuts down event loops.
     */
    private void shutdownEventLoops() {
        try {
            if (workerGroup != null) workerGroup.shutdownGracefully().sync();
            if (bossGroup != null) bossGroup.shutdownGracefully().sync();
        } catch (InterruptedException e) {
            warn("Event loop shutdown interrupted", e);
            Thread.currentThread().interrupt();
        } finally {
            workerGroup = null;
            bossGroup = null;
            serverChannel = null;
        }
    }

    /**
     * Abstract methods to implement in subclasses
     **/

    public abstract Packet getEmptyPacket();
    public abstract Version getVersion();
    protected abstract ChannelHandler getChildHandler();
    protected abstract KalaazuConfig getConfig();
}

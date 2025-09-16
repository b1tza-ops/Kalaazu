package com.kalaazu.server;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.ServerStarted;
import com.kalaazu.event.ServerStopped;
import com.kalaazu.event.StartServer;
import com.kalaazu.event.StopServer;
import com.kalaazu.server.game.GameServer;
import com.kalaazu.server.game.PolicyServer;
import com.kalaazu.server.service.MapService;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component
@RequiredArgsConstructor
public class Server implements Logger {
    private final ApplicationContext ctx;
    private final List<GameServer> servers;
    private final PolicyServer policyServer;
    private final MapService mapService;
    private final KalaazuConfig config;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    @Autowired
    @Qualifier("virtualThreadTaskExecutor")
    private TaskExecutor virtualThreadTaskExecutor;

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @EventListener
    public void start(StartServer event) {
        var v = config.getGame().getVersion();
        mapService.initialize();

        info("Starting game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.start(virtualThreadTaskExecutor);
        policyServer.start(virtualThreadTaskExecutor);
        ctx.publishEvent(new ServerStarted());
        info("Started game server");
    }

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @EventListener
    public void stop(StopServer event) {
        var v = config.getGame().getVersion();

        info("Stopping game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.stop();
        policyServer.stop();
        ctx.publishEvent(new ServerStopped());
        info("Stopped game server");
    }
}

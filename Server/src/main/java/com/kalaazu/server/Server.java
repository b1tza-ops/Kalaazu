package com.kalaazu.server;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.ServerStarted;
import com.kalaazu.event.ServerStopped;
import com.kalaazu.event.StartServer;
import com.kalaazu.event.StopServer;
import com.kalaazu.server.game.GameServer;
import com.kalaazu.server.game.PolicyServer;
import com.kalaazu.server.service.MapService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class Server {
    private final ApplicationContext ctx;
    private final List<GameServer> servers;
    private final PolicyServer policyServer;
    private final MapService mapService;
    private final KalaazuConfig config;

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @EventListener
    public void start(StartServer event) {
        var v = config.getGame().getVersion();
        mapService.initialize();

        log.info("Starting game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.start();
        policyServer.start();
        ctx.publishEvent(new ServerStarted());
        log.info("Started game server");
    }

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @EventListener
    public void stop(StopServer event) {
        var v = config.getGame().getVersion();

        log.info("Stopping game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.stop();
        policyServer.stop();
        ctx.publishEvent(new ServerStopped());
        log.info("Stopped game server");
    }
}

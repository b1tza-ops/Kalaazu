package com.kalaazu.server;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.StartKalaazuEvent;
import com.kalaazu.event.StopKalaazuEvent;
import com.kalaazu.server.game.GameServer;
import com.kalaazu.server.game.PolicyServer;
import com.kalaazu.server.service.MapService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
    public void start(StartKalaazuEvent event) {
        var v = config.getGame().getVersion();
        mapService.initialize();

        log.info("Starting game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.start();
        policyServer.start();
        log.info("Started game server");
    }

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @EventListener
    public void stop(StopKalaazuEvent event) {
        var v = config.getGame().getVersion();

        log.info("Stopping game server for main.swf version {}", v);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == v)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + v + " not found!"));

        server.stop();
        policyServer.stop();
        log.info("Stopped game server");
    }
}

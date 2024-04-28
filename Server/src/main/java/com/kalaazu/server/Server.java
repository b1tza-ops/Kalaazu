package com.kalaazu.server;

import com.kalaazu.server.game.GameServer;
import com.kalaazu.server.game.PolicyServer;
import com.kalaazu.server.game.Version;
import com.kalaazu.server.service.MapService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class Server implements ApplicationListener<ApplicationReadyEvent> {
    private final List<GameServer> servers;
    private final PolicyServer policyServer;

    private final MapService mapService;

    @Value("${app.game.version}")
    private Version version;

    /**
     * Handle an application event.
     *
     * @param event the event to respond to
     */
    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        mapService.initialize();

        log.info("Starting game server for main.swf version {}", version);
        var server = servers.stream()
                .filter((s) -> s.getVersion() == version)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Game sever for version " + version + " not found!"));

        GameServer.INSTANCE = server;
        server.start();

        policyServer.start();
    }
}

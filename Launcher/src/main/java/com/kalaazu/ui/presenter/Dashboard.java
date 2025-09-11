package com.kalaazu.ui.presenter;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.*;
import com.kalaazu.persistence.service.AccountsService;
import com.kalaazu.persistence.service.MapsService;
import com.kalaazu.server.event.GameSessionStarted;
import com.kalaazu.server.event.GameSessionStopped;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * Dashboard presenter.
 * <p>
 * Presenter for the Dashboard page
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class Dashboard {
    private final KalaazuConfig kalaazuConfig;
    private final AccountsService accountsService;
    private final MapsService mapsService;

    public Label serverStatus;
    public Label serverVersion;
    public Label registeredUsers;
    public Label onlineUsers;
    public Label loadedMaps;
    public LineChart<Integer, Integer> memoryUsage;
    public LineChart<Integer, Integer> cpuUsage;
    public TextArea serverLogs;

    public AtomicInteger onlineUsersI = new AtomicInteger(0);

    @FXML
    public void initialize() {
        serverVersion.setText(kalaazuConfig.getGame().getVersion().toString());
        registeredUsers.setText(accountsService.countAll() + " users");
        loadedMaps.setText(mapsService.countAll() + " maps");
    }

    @EventListener
    public void sessionStarted(GameSessionStarted event) {
        Platform.runLater(() -> onlineUsers.setText(onlineUsersI.incrementAndGet() + " users"));
    }

    @EventListener
    public void sessionStopped(GameSessionStopped event) {
        Platform.runLater(() -> onlineUsers.setText(onlineUsersI.decrementAndGet() + " users"));
    }

    @EventListener
    public void updateVersion(KalaazuVersionUpdated event) {
        Platform.runLater(() -> serverVersion.setText(kalaazuConfig.getGame().getVersion().toString()));
    }

    @EventListener
    public void serverStarting(StartServer event) {
        Platform.runLater(() -> serverStatus.setText("Starting..."));
    }

    @EventListener
    public void serverStarted(ServerStarted event) {
        Platform.runLater(() -> serverStatus.setText("Running"));
    }

    @EventListener
    public void serverStopping(StopServer event) {
        Platform.runLater(() -> serverStatus.setText("Stopping..."));
    }

    @EventListener
    public void serverStopped(ServerStopped event) {
        Platform.runLater(() -> serverStatus.setText("Stopped"));
    }
}

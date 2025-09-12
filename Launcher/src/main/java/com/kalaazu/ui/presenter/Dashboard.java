package com.kalaazu.ui.presenter;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.*;
import com.kalaazu.persistence.service.AccountsService;
import com.kalaazu.persistence.service.MapsService;
import com.kalaazu.server.event.GameSessionStarted;
import com.kalaazu.server.event.GameSessionStopped;
import com.kalaazu.ui.component.TextAreaAppender;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.chart.AreaChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Component;

import java.lang.management.ManagementFactory;
import java.time.Duration;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Dashboard presenter.
 * <p>
 * Presenter for the Dashboard page
 */
@Component
@RequiredArgsConstructor
public class Dashboard implements Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.UI;
    private final KalaazuConfig kalaazuConfig;
    private final AccountsService accountsService;
    private final MapsService mapsService;
    private final TaskScheduler scheduler;

    private final int MAX_POINTS = 60;
    private final XYChart.Series<Number, Number> cpuSeries = new XYChart.Series<>();
    private final XYChart.Series<Number, Number> memSeries = new XYChart.Series<>();

    public Label serverStatus;
    public Label serverVersion;
    public Label registeredUsers;
    public Label onlineUsers;
    public Label loadedMaps;
    public AreaChart<Number, Number> memoryUsage;
    public AreaChart<Number, Number> cpuUsage;
    public TextArea serverLogs;
    public AtomicInteger onlineUsersI = new AtomicInteger(0);
    public Label memoryUsageLabel;
    public Label cpuUsageLabel;

    private int cpuSeriesData = 0;
    private int memSeriesData = 0;

    @FXML
    public void initialize() {
        // Attach custom appender
        var appender = new TextAreaAppender(serverLogs);
        var rootLogger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger(ch.qos.logback.classic.Logger.ROOT_LOGGER_NAME);
        appender.setContext(rootLogger.getLoggerContext());
        appender.start();
        rootLogger.addAppender(appender);

        serverVersion.setText(kalaazuConfig.getGame().getVersion().toString());
        registeredUsers.setText(accountsService.countAll() + " users");
        loadedMaps.setText(mapsService.countAll() + " maps");

        cpuUsage.getData().add(cpuSeries);
        memoryUsage.getData().add(memSeries);

        var osBean = ManagementFactory.getOperatingSystemMXBean();
        var runtime = Runtime.getRuntime();

        ((NumberAxis) memoryUsage.getYAxis()).setUpperBound((double) runtime.maxMemory() / (1024 * 1024));

        scheduler.scheduleAtFixedRate(() -> {
            double cpuLoad = 0;
            if (osBean instanceof com.sun.management.OperatingSystemMXBean) {
                cpuLoad = ((com.sun.management.OperatingSystemMXBean) osBean).getCpuLoad() * 100;
            }
            final double finalCpuLoad = cpuLoad;
            final long usedMemory = (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024);

            // Update chart on JavaFX Application Thread
            Platform.runLater(() -> {
                cpuSeries.getData().add(new XYChart.Data<>(cpuSeriesData++, finalCpuLoad));
                memSeries.getData().add(new XYChart.Data<>(memSeriesData++, usedMemory));

                cpuUsage.setTitle("CPU usage: " + (int) finalCpuLoad + "%");
                memoryUsage.setTitle("Memory usage: " + usedMemory + "MB");

                if (cpuSeries.getData().size() > MAX_POINTS) {
                    cpuSeries.getData().removeFirst();

                    // Shift X values of remaining points to start from 0 again
                    for (int i = 0; i < cpuSeries.getData().size(); i++) {
                        cpuSeries.getData().get(i).setXValue(i);
                    }

                    // Reset counter to match new series size
                    cpuSeriesData = cpuSeries.getData().size();
                }

                if (memSeries.getData().size() > MAX_POINTS) {
                    memSeries.getData().removeFirst();

                    // Shift X values of remaining points to start from 0 again
                    for (int i = 0; i < memSeries.getData().size(); i++) {
                        memSeries.getData().get(i).setXValue(i);
                    }

                    // Reset counter to match new series size
                    memSeriesData = memSeries.getData().size();
                }
            });
        }, Duration.ofSeconds(1));
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

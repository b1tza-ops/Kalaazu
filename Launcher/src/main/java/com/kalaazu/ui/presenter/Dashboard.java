package com.kalaazu.ui.presenter;

import javafx.scene.chart.LineChart;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * Dashboard presenter.
 * <p>
 * Presenter for the Dashboard page
 */
@Component
@Slf4j
public class Dashboard {
    public Label serverStatus;
    public Label serverVersion;
    public Label registeredUsers;
    public Label onlineUsers;
    public Label loadedMaps;
    public LineChart<Integer, Integer> memoryUsage;
    public LineChart<Integer, Integer> cpuUsage;
    public TextArea serverLogs;
}

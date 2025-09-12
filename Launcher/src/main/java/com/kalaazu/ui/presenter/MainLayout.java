package com.kalaazu.ui.presenter;

import atlantafx.base.controls.Breadcrumbs;
import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.*;
import com.kalaazu.model.Version;
import com.kalaazu.ui.SceneManager;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.geometry.Side;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Screen;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.kordamp.ikonli.feather.Feather;
import org.kordamp.ikonli.javafx.FontIcon;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Main layout.
 * <p>
 * Presenter for the main layout view.
 *
 * @author manulaiko
 */
@Component
@RequiredArgsConstructor
public class MainLayout {
    private final SceneManager sceneManager;
    private final ApplicationContext ctx;
    private final KalaazuConfig config;

    private final Delta delta = new Delta();
    private final ContextMenu windowIconContextMenu = new ContextMenu();
    private final List<String> breadcrumbsItems = new ArrayList<>();
    public Breadcrumbs<String> breadcrumbs;
    public Button windowIcon;
    public ComboBox<Version> version;
    public Button start;
    public Button stop;
    public StackPane page;
    private boolean maximized = false;
    private double prevX = 0;
    private double prevY = 0;
    private double prevWidth = 0;
    private double prevHeight = 0;
    private Breadcrumbs.BreadCrumbItem<String> rootBreadcrumbItem;

    @FXML
    public void initialize() {
        // Setup window bar
        windowIcon.setGraphic(new ImageView(
                sceneManager.getStage()
                        .getIcons()
                        .stream()
                        .filter(i -> i.getWidth() == 28)
                        .findFirst()
                        .orElse(null)
        ));

        windowIconContextMenu.getItems().addAll(
                // TODO Window Icon context menu items
        );

        version.getItems().addAll(Version.values());
        version.setValue(config.getGame().getVersion());
        version.setOnAction(event -> {
            config.getGame().setVersion(version.getValue());
            ctx.publishEvent(new KalaazuVersionUpdated());
        });

        start.setOnAction(e -> ctx.publishEvent(new StartServer()));
        stop.setOnAction(e -> ctx.publishEvent(new StopServer()));

        // Setup navigation
        breadcrumbsItems.add("Home");
        rootBreadcrumbItem = Breadcrumbs.buildTreeModel(breadcrumbsItems.toArray(String[]::new));
        breadcrumbs = new Breadcrumbs<>(rootBreadcrumbItem);
        breadcrumbs.setSelectedCrumb(getTreeItemByIndex(1));

        // Dashboard page
        var dashboard = sceneManager.buildScene(Dashboard.class);
        page.getChildren().add(dashboard.getRoot());

        if (config.isAutoStart()) {
            this.serverStarted(null);
        } else {
            this.serverStopped(null);
        }
    }

    public void titleBarMouseDragged(MouseEvent event) {
        sceneManager.getStage().setX(event.getScreenX() - delta.getX());
        sceneManager.getStage().setY(event.getScreenY() - delta.getY());
    }

    public void titleBarMousePressed(MouseEvent event) {
        delta.setX(event.getX());
        delta.setY(event.getY());
    }

    public void minimizeWindow(MouseEvent event) {
        sceneManager.getStage().setIconified(true);
    }

    public void closeWindow(MouseEvent event) {
        sceneManager.getStage().close();
    }

    public void toggleMaximizeWindow(MouseEvent event) {
        var stage = sceneManager.getStage();

        if (maximized) {
            stage.setX(prevX);
            stage.setY(prevY);
            stage.setWidth(prevWidth);
            stage.setHeight(prevHeight);
        } else {
            prevX = stage.getX();
            prevY = stage.getY();
            prevWidth = stage.getWidth();
            prevHeight = stage.getHeight();

            var screen = Screen.getScreensForRectangle(stage.getX(), stage.getY(), stage.getWidth(), stage.getHeight())
                    .stream()
                    .findFirst()
                    .orElse(Screen.getPrimary());

            stage.setX(0);
            stage.setY(0);
            stage.setWidth(screen.getVisualBounds().getWidth());
            stage.setHeight(screen.getVisualBounds().getHeight());
        }

        maximized = !maximized;
    }

    public void showWindowIconContextMenu(MouseEvent event) {
        windowIconContextMenu.show(windowIcon, Side.BOTTOM, 0, 0);
    }


    private Breadcrumbs.BreadCrumbItem<String> getTreeItemByIndex(int index) {
        var counter = index;
        var current = rootBreadcrumbItem;
        while (counter > 0 && current.getParent() != null) {
            current = (Breadcrumbs.BreadCrumbItem<String>) current.getParent();
            counter--;
        }
        return current;
    }

    @EventListener
    public void serverStarted(ServerStarted event) {
        Platform.runLater(() -> {
            start.setDisable(true);
            start.setGraphic(new FontIcon(Feather.PLAY));
            stop.setDisable(false);
        });
    }

    @EventListener
    public void serverStopped(ServerStopped event) {
        Platform.runLater(() -> {
            stop.setDisable(true);
            stop.setGraphic(new FontIcon(Feather.SQUARE));
            start.setDisable(false);
        });
    }

    @EventListener
    public void serverStarting(StartServer event) {
        Platform.runLater(() -> {
            start.setDisable(true);
            start.setGraphic(new FontIcon(Feather.MORE_HORIZONTAL));
        });
    }

    @EventListener
    public void serverStopping(StopServer event) {
        Platform.runLater(() -> {
            stop.setDisable(true);
            stop.setGraphic(new FontIcon(Feather.MORE_HORIZONTAL));
        });
    }

    @Data
    private static class Delta {
        private double x;
        private double y;
    }
}

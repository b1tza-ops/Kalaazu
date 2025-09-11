package com.kalaazu.ui.presenter;

import atlantafx.base.controls.Breadcrumbs;
import com.kalaazu.KalaazuConfig;
import com.kalaazu.event.StartKalaazuEvent;
import com.kalaazu.event.StopKalaazuEvent;
import com.kalaazu.model.Version;
import com.kalaazu.ui.SceneManager;
import javafx.fxml.FXML;
import javafx.geometry.Side;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.stage.Screen;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
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
@Slf4j
@RequiredArgsConstructor
public class MainLayout {
    private final SceneManager sceneManager;
    private final ApplicationContext ctx;
    private final KalaazuConfig config;

    private final Delta delta = new Delta();
    private final ContextMenu windowIconContextMenu = new ContextMenu();
    private final List<String> breadcrumbsItems = new ArrayList<>();

    @FXML
    private Breadcrumbs<String> breadcrumbs;

    @FXML
    private Button windowIcon;

    @FXML
    private ComboBox<Version> version;

    @FXML
    private Button start;

    @FXML
    private Button stop;

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
        version.setOnAction(event -> config.getGame().setVersion(version.getValue()));

        start.setOnAction(e -> ctx.publishEvent(new StartKalaazuEvent(this)));
        stop.setOnAction(e -> ctx.publishEvent(new StopKalaazuEvent(this)));

        // Setup navigation
        breadcrumbsItems.add("Home");
        rootBreadcrumbItem = Breadcrumbs.buildTreeModel(breadcrumbsItems.toArray(String[]::new));
        breadcrumbs = new Breadcrumbs<>(rootBreadcrumbItem);
        breadcrumbs.setSelectedCrumb(getTreeItemByIndex(1));
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

    @Data
    private static class Delta {
        private double x;
        private double y;
    }
}

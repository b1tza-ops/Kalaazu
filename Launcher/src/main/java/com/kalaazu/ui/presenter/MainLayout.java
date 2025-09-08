package com.kalaazu.ui.presenter;

import atlantafx.base.theme.Styles;
import atlantafx.base.theme.Tweaks;
import com.kalaazu.ui.SceneManager;
import javafx.fxml.FXML;
import javafx.geometry.Side;
import javafx.scene.control.Button;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.BorderPane;
import javafx.stage.Screen;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.kordamp.ikonli.feather.Feather;
import org.kordamp.ikonli.javafx.FontIcon;
import org.springframework.stereotype.Component;

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

    private final Delta delta = new Delta();
    private final ContextMenu windowIconContextMenu = new ContextMenu();
    @FXML
    private BorderPane titleBar;
    @FXML
    private Label windowTitle;
    @FXML
    private Button closeWindowButton;
    @FXML
    private Button maximizeWindowButton;
    @FXML
    private Button minimizeWindowButton;
    @FXML
    private Button windowIcon;
    private boolean maximized = false;
    private double prevX = 0;
    private double prevY = 0;
    private double prevWidth = 0;
    private double prevHeight = 0;

    @FXML
    public void initialize() {
        windowTitle.setText("Kalaazu");

        closeWindowButton.setGraphic(new FontIcon(Feather.X_SQUARE));
        closeWindowButton.getStyleClass().addAll(Styles.FLAT, Styles.BUTTON_ICON, Styles.DANGER);

        maximizeWindowButton.setGraphic(new FontIcon(Feather.MAXIMIZE));
        maximizeWindowButton.getStyleClass().addAll(Styles.BUTTON_ICON, Styles.FLAT);

        minimizeWindowButton.setGraphic(new FontIcon(Feather.MINIMIZE));
        minimizeWindowButton.getStyleClass().addAll(Styles.BUTTON_ICON, Styles.FLAT);

        windowIcon.setGraphic(new ImageView(
                sceneManager.getStage()
                        .getIcons()
                        .stream()
                        .filter(i -> i.getWidth() == 28)
                        .findFirst()
                        .orElse(null)
        ));
        windowIcon.getStyleClass().addAll(Styles.BUTTON_ICON, Styles.FLAT, Tweaks.NO_ARROW);

        windowIconContextMenu.getItems().addAll(
                // TODO Window Icon context menu items
        );
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

    @Data
    private static class Delta {
        private double x;
        private double y;
    }
}

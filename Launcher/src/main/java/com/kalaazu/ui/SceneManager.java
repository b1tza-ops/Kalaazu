package com.kalaazu.ui;

import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
@Data
@Slf4j
@RequiredArgsConstructor
public class SceneManager {
    private final Map<String, Scene> scenes = new HashMap<>();

    private final ApplicationContext ctx;

    @Value("classpath:styles/index.css")
    private Resource style;

    private Stage stage;
    private Class<?> rootScene;

    /**
     * Shows the window with the root scene.
     */
    public void show() {
        Platform.runLater(this::doShow);
    }

    /**
     * Shows the root scene in the FX thread.
     */
    @SneakyThrows
    private void doShow() {
        var scene = scenes.computeIfAbsent(this.getRootScene().getSimpleName(), this::buildScene);

        log.debug("Showing root scene...");
        this.getStage().setScene(scene);
        this.getStage().show();
    }

    /**
     * Switch to the given scene.
     *
     * @param view Scene's fxml to switch the stage to.
     */
    public void show(String view) {
        Platform.runLater(() -> this.doShow(view));
    }

    /**
     * Switch to the given scene.
     *
     * @param presenter View's presenter class, will use the name.
     */
    public void show(Class<?> presenter) {
        Platform.runLater(() -> this.doShow(presenter.getSimpleName()));
    }

    /**
     * Performs the scene switch in the FX thread.
     *
     * @param view Scene's view to switch the stage to.
     */
    private void doShow(String view) {
        var subScene = scenes.computeIfAbsent(view, this::buildScene);

        log.debug("Showing scene for " + view + " (" + subScene + ")");

        var scene = this.getStage().getScene();
        var root = (BorderPane) scene.getRoot();
        root.setCenter(subScene.getRoot());
    }

    /**
     * Builds and returns a new scene.
     *
     * @param view Scene's fxml.
     * @return New scene.
     */
    public Scene buildScene(String view) {
        log.debug("Building scene for " + view);
        try {
            var loader = new FXMLLoader(new ClassPathResource("ui/" + view + ".fxml").getURL());
            loader.setControllerFactory(ctx::getBean);

            var parent = (Parent) loader.load();

            var scene = new Scene(parent);
            scene.getStylesheets().add(style.getURI().toString());
            scene.setUserData(loader.getController());

            return scene;
        } catch (IOException e) {
            log.warn("Couldn't load scene!", e);

            throw new RuntimeException(e);
        }
    }

    /**
     * Builds and returns a new scene.
     *
     * @param presenter View's presenter, will use class name.
     * @return New scene.
     */
    public Scene buildScene(Class<?> presenter) {
        return buildScene(presenter.getSimpleName());
    }
}

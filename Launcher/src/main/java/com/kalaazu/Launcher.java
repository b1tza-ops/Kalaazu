package com.kalaazu;

import atlantafx.base.theme.PrimerDark;
import com.kalaazu.ui.LoadingScreen;
import com.kalaazu.ui.SceneManager;
import com.kalaazu.ui.event.ShowMainScreenEvent;
import com.kalaazu.ui.presenter.MainLayout;
import javafx.application.Application;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import lombok.Getter;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.io.IOException;
import java.util.Arrays;

/**
 * Launcher class.
 * ===============
 * <p>
 * The starting point of the application.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
@Slf4j
@SpringBootApplication
public class Launcher extends Application {
    private static final LoadingScreen loadingScreen = new LoadingScreen();

    @Getter
    private static Launcher instance;

    private ConfigurableApplicationContext ctx;

    /**
     * Main method.
     *
     * @param args Command line arguments.
     */
    public static void main(String[] args) {
        loadingScreen.show();
        Application.launch(Launcher.class, args);
    }

    @Override
    public void init() {
        log.info("Init Kalaazu...");
        ctx = new SpringApplicationBuilder(Launcher.class).run();
        instance = this;
        loadingScreen.close();
    }

    @Override
    @SneakyThrows
    public void start(Stage stage) {
        log.info("Starting Kalaazu...");
        var sceneManager = ctx.getBean(SceneManager.class);

        var resolver = new PathMatchingResourcePatternResolver();
        var icons = resolver.getResources("classpath:img/icon*.*");

        Arrays.stream(icons)
                .map(i -> {
                    try {
                        return new Image(i.getInputStream());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                })
                .forEach(stage.getIcons()::add);

        stage.setTitle("Kalaazu");
        stage.initStyle(StageStyle.UNDECORATED);

        Application.setUserAgentStylesheet(new PrimerDark().getUserAgentStylesheet());

        sceneManager.setStage(stage);
        sceneManager.setRootScene(MainLayout.class);

        ctx.publishEvent(new ShowMainScreenEvent());
    }

    /**
     * @inheritDoc
     */
    @Override
    public void stop() {
        System.exit(0);
    }
}

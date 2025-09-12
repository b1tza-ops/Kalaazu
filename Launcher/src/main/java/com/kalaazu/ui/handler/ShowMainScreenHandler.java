package com.kalaazu.ui.handler;

import com.kalaazu.ui.SceneManager;
import com.kalaazu.ui.event.ShowMainScreen;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * Show main screen handler.
 * <p>
 * Shows the main screen in the Dashboard.
 *
 * @author manulaiko
 */
@RequiredArgsConstructor
@Component
public class ShowMainScreenHandler implements ApplicationListener<ShowMainScreen>, Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.UI;
    private final SceneManager sceneManager;

    @Override
    public void onApplicationEvent(ShowMainScreen event) {
        info("Loading main screen");
        sceneManager.show();
    }
}

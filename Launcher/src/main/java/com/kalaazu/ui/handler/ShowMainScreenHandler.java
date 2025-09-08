package com.kalaazu.ui.handler;

import com.kalaazu.ui.SceneManager;
import com.kalaazu.ui.event.ShowMainScreenEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@Slf4j
@Component
public class ShowMainScreenHandler implements ApplicationListener<ShowMainScreenEvent> {
    private final SceneManager sceneManager;

    @Override
    public void onApplicationEvent(ShowMainScreenEvent event) {
        log.info("Loading main screen");
        sceneManager.show();
    }
}

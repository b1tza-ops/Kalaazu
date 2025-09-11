package com.kalaazu.ui.component;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.AppenderBase;
import javafx.application.Platform;
import javafx.scene.control.TextArea;

import java.util.ArrayDeque;
import java.util.Deque;

/**
 * Text area appender.
 * <p>
 * Adds the output logs to the text area.
 *
 * @author manulaiko
 */
public class TextAreaAppender extends AppenderBase<ILoggingEvent> {
    private final TextArea textArea;
    private final Deque<String> buffer = new ArrayDeque<>();
    private final int maxLines = 500;
    private volatile boolean pendingUpdate = false;

    public TextAreaAppender(TextArea textArea) {
        this.textArea = textArea;
    }

    @Override
    protected void append(ILoggingEvent eventObject) {
        var message = eventObject.getFormattedMessage();

        // maintain buffer
        synchronized (buffer) {
            if (buffer.size() >= maxLines) {
                buffer.removeFirst(); // drop oldest
            }
            buffer.addLast(message);
        }

        // coalesce UI updates
        if (!pendingUpdate) {
            pendingUpdate = true;
            Platform.runLater(() -> {
                pendingUpdate = false;
                var sb = new StringBuilder();
                synchronized (buffer) {
                    buffer.forEach(line -> sb.append(line).append("\n"));
                }
                textArea.setText(sb.toString());
                textArea.selectPositionCaret(textArea.getLength());
                textArea.deselect();
                textArea.setScrollTop(Double.MAX_VALUE);
            });
        }
    }
}
package com.kalaazu.ui;

import javax.swing.*;
import java.awt.*;
import java.util.Objects;

public class LoadingScreen {
    private final JWindow window;
    private final JPanel overlay;
    private float alpha = 1.0f;
    private boolean fadingOut = true;

    public LoadingScreen() {
        var spinnerIcon = new ImageIcon(Objects.requireNonNull(getClass().getResource("/img/loadingScreenSpinner.gif")));
        window = new JWindow();
        window.setBackground(new Color(0, 0, 0, 0)); // transparent background

        // Label for GIF spinner
        JLabel spinnerLabel = new JLabel(spinnerIcon);
        spinnerLabel.setOpaque(false);
        spinnerLabel.setHorizontalAlignment(SwingConstants.CENTER);
        spinnerLabel.setVerticalAlignment(SwingConstants.CENTER);

        // Panel to hold the spinner
        JPanel content = new JPanel(new BorderLayout());
        content.setOpaque(false);
        content.add(spinnerLabel, BorderLayout.CENTER);
        window.getContentPane().add(content);

        // Transparent overlay for dimming effect
        overlay = new JPanel() {
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                Graphics2D g2d = (Graphics2D) g.create();
                g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f - alpha));
                g2d.setColor(Color.BLACK);
                g2d.fillRect(0, 0, getWidth(), getHeight());
                g2d.dispose();
            }
        };
        overlay.setOpaque(false);
        window.getLayeredPane().add(overlay, JLayeredPane.DRAG_LAYER);
        overlay.setBounds(0, 0, spinnerIcon.getIconWidth(), spinnerIcon.getIconHeight());

        window.pack();

        // Center on screen
        Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
        window.setLocation(
                (screen.width - window.getWidth()) / 2,
                (screen.height - window.getHeight()) / 2
        );

        // Prevent system beep
        window.setFocusableWindowState(false);

        // Start pulsating effect
        Timer timer = new Timer(50, e -> updateAlpha());
        timer.start();
    }

    private void updateAlpha() {
        if (fadingOut) {
            alpha -= 0.01f;
            if (alpha <= 0.85f) fadingOut = false;
        } else {
            alpha += 0.01f;
            if (alpha >= 1.0f) fadingOut = true;
        }
        overlay.repaint();
    }


    public void show() {
        SwingUtilities.invokeLater(() -> window.setVisible(true));
    }

    public void close() {
        SwingUtilities.invokeLater(window::dispose);
    }
}
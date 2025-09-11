package com.kalaazu;

import com.kalaazu.model.Version;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties("app")
@Data
public class KalaazuConfig {
    private boolean autoStart;
    private GameConfig game;
    private Port port;

    @Data
    public static class GameConfig {
        private Version version;
        private Packets packets;

        @Data
        public static class Packets {
            private boolean printOut;
            private boolean printIn;
        }
    }

    @Data
    public static class Port {
        private int server;
        private int policy;
        private int chat;
    }
}

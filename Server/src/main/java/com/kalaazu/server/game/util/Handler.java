package com.kalaazu.server.game.util;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.InCommand;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;

/**
 * Abstract handler.
 * =================
 * <p>
 * Base class for all packet handlers.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class Handler<T extends InCommand> implements Logger {
    @Value("${app.game.packets.printIn}")
    private boolean printPackets;

    @Getter
    private final LoggingCategory category = LoggingCategory.NETWORK;

    @Async
    @SneakyThrows
    public void handle(Packet packet, GameSession session) {
        var command = getClazz().getDeclaredConstructor()
                .newInstance();
        command.read(packet);

        if (printPackets) {
            info("Packet received: <<<<< {}", command);
        }

        handle(command, session);
    }

    public abstract void handle(T packet, GameSession session);

    public abstract Class<T> getClazz();

    public abstract boolean canHandle(Packet packet);

    public abstract Version getVersion();
}

package com.kalaazu.server.game.v10.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.LegacyHandler;
import com.kalaazu.server.game.v10.commands.in.LegacyCommand;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Legacy packet handler.
 * ======================
 * <p>
 * Handler for the legacy packets.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Component("v10LegacyPacketHandler")
public class LegacyPacketHandler extends Handler<LegacyCommand> implements Logger {
    private final Version version = Version.V10;
    private final short id = LegacyCommand.ID;
    private final Class<LegacyCommand> clazz = LegacyCommand.class;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    private final List<LegacyHandler> handlers;

    @Override
    public void handle(LegacyCommand packet, GameSession session) {
        var p = packet.getPacket();

        var id = p.readString();

        handlers.stream()
                .filter(h -> h.getId().equalsIgnoreCase(id))
                .findFirst()
                .ifPresent(h -> h.handle(p, session));
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

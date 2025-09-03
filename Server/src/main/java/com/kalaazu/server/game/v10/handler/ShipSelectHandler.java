package com.kalaazu.server.game.v10.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.ShipSelectCommand;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.stereotype.Component;

/**
 * Ship select handler.
 * ====================
 * <p>
 * Handles the player selecting a ship.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Component("v10ShipSelectHandler")
public class ShipSelectHandler extends Handler<ShipSelectCommand> {
    private final Version version = Version.V10;
    private final short id = ShipSelectCommand.ID;
    private final Class<ShipSelectCommand> clazz = ShipSelectCommand.class;

    @Override
    public void handle(ShipSelectCommand packet, GameSession session) {
        packet.getId();
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

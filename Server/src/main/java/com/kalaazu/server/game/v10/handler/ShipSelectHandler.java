package com.kalaazu.server.game.v10.handler;

import com.kalaazu.server.game.v10.commands.in.ShipSelectCommand;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.stereotype.Component;

/**
 * Ship select handler.
 * ====================
 *
 * Handles the player selecting a ship.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Component
public class ShipSelectHandler extends Handler<ShipSelectCommand> {
    private final short id = ShipSelectCommand.ID;
    private final Class<ShipSelectCommand> clazz = ShipSelectCommand.class;

    @Override
    public void handle(ShipSelectCommand packet, GameSession session) {
        packet.getId();
    }
}

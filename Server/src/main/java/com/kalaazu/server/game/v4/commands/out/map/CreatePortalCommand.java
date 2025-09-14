package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * CreatePortalCommand
 * <p>
 * Command to create a portal.
 *
 * @author manulaiko
 */
@Data
@RequiredArgsConstructor
public class CreatePortalCommand extends OutCommand {
    private final String id = ServerCommands.CREATE_PORTAL;

    private final int entityId;
    private final int gfx;
    private final int x;
    private final int y;
    private final boolean isVisible;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId);
        packet.writeInt(gfx);
        packet.writeInt(0);
        packet.writeInt(x);
        packet.writeInt(y);
        packet.writeBoolean(isVisible);
    }
}

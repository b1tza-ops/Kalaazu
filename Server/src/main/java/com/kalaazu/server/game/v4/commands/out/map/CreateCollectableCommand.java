package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * CreateCollectableCommand
 * <p>
 * Command to create a collectable.
 *
 * @author manulaiko
 */
@Data
@RequiredArgsConstructor
public class CreateCollectableCommand extends OutCommand {
    private final String id = ServerCommands.CREATE_ORE;
    private final int entityId;
    private final int type;
    private final int x;
    private final int y;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId); // Collectable.hash
        packet.writeInt(type);
        packet.writeInt(x);
        packet.writeInt(y);
    }
}

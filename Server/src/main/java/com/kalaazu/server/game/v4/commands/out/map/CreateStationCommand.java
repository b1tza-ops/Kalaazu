package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * CreateStationCommand
 * <p>
 * Command to create a station.
 *
 * @author manulaiko
 */
@Data
@RequiredArgsConstructor
public class CreateStationCommand extends OutCommand {
    private final String id = ServerCommands.CREATE_STATION;

    private final int entityId;
    private final int factionsId;
    private final int x;
    private final int y;


    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId);
        packet.writeInt(1);
        packet.writeString(switch (factionsId) {
            case 1 -> "redStation";
            case 2 -> "blueStation";
            case 3 -> "greenStation";
            case 4 -> "healthStation";
            case 5 -> "relayStation";
            default -> "pirateStation";
        });
        packet.writeInt(factionsId);
        packet.writeInt(1500);
        packet.writeInt(x);
        packet.writeInt(y);
    }
}

package com.kalaazu.server.game.v4.commands.out.user;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PrimaryWeaponInfoCommand extends OutCommand {
    private final String id = ServerCommands.PRIMARY_WEAPON_INFO;

    private final long lcb10;
    private final long mcb25;
    private final long mcb50;
    private final long ucb100;
    private final long sab50;
    private final long rsb75;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeLong(lcb10);
        packet.writeLong(mcb25);
        packet.writeLong(mcb50);
        packet.writeLong(ucb100);
        packet.writeLong(sab50);
        packet.writeLong(rsb75);
    }
}

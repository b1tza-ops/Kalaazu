package com.kalaazu.server.game.v4.commands.out.user;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SecondaryWeaponInfoCommand extends OutCommand {
    private final String id = ServerCommands.SECONDARY_WEAPON_INFO;
    private final Version gameVersion = Version.V4;

    private final long r310;
    private final long plt2026;
    private final long plt2021;
    private final long plt3030;
    private final long pld8;
    private final long dcr_250;
    private final long wiz;
    private final long mine;
    private final long smartbomb;
    private final long instashield;
    private final long emp;
    private final long mine_emp;
    private final long mine_sab;
    private final long mine_ddm;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeLong(r310);
        packet.writeLong(plt2026);
        packet.writeLong(plt2021);
        packet.writeLong(plt3030);
        packet.writeLong(pld8);
        packet.writeLong(dcr_250);
        packet.writeLong(wiz);
        packet.writeLong(mine);
        packet.writeLong(smartbomb);
        packet.writeLong(instashield);
        packet.writeLong(emp);
        packet.writeLong(mine_emp);
        packet.writeLong(mine_sab);
        packet.writeLong(mine_ddm);
    }
}

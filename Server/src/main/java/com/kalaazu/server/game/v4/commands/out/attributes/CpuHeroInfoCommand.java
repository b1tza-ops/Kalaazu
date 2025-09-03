package com.kalaazu.server.game.v4.commands.out.attributes;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CpuHeroInfoCommand extends SetAttributeCommand {
    private final String attribute = ServerCommands.EXTRAS_INFO;

    private final long droneRepair;
    private final long radar;
    private final long jump;
    private final long ammobuy;
    private final long robot;
    private final long hm7;
    private final long smartbomb;
    private final long instashield;
    private final long mineturbo;
    private final long aim;
    private final long arol;
    private final long cloak;
    private final long rllb;
    private final long rocketbuy;
    private final long advancedJump;

    @Override
    public void subWrite(Packet packet) {
        packet.writeLong(droneRepair);
        packet.writeLong(radar);
        packet.writeLong(jump);
        packet.writeLong(ammobuy);
        packet.writeLong(robot);
        packet.writeLong(hm7);
        packet.writeLong(smartbomb);
        packet.writeLong(instashield);
        packet.writeLong(mineturbo);
        packet.writeLong(aim);
        packet.writeLong(arol);
        packet.writeLong(cloak);
        packet.writeLong(rllb);
        packet.writeLong(rocketbuy);
        packet.writeLong(advancedJump);
    }
}

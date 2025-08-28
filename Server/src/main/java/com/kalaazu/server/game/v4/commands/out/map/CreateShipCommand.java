package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CreateShipCommand extends OutCommand {
    private final String id = "C";

    private final int entityId;
    private final int shipId;
    private final int x;
    private final int y;
    private final String name;
    private final String clanTag;
    private final int factionId;
    private final int clanId;
    private final int clanDiplomacy;
    private final int rankId;
    private final int expansionStage;
    private final boolean warnIconOnMap;
    private final int galaxyGatesDone;
    private final boolean isNpc;
    private final boolean isCloaked;


    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId);
        packet.writeInt(shipId);
        packet.writeInt(expansionStage);
        packet.writeString(clanTag);
        packet.writeString(name);
        packet.writeInt(x);
        packet.writeInt(y);
        packet.writeInt(factionId);
        packet.writeInt(clanId);
        packet.writeInt(rankId);
        packet.writeBoolean(warnIconOnMap);
        packet.writeInt(clanDiplomacy);
        packet.writeInt(galaxyGatesDone);
        packet.writeBoolean(isNpc);
        packet.writeBoolean(isCloaked);
    }
}

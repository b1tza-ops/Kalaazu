package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.ArrayList;

@Data
@AllArgsConstructor
public class ShipInitializationCommand extends OutCommand {
    private final Version gameVersion = Version.V4;
    private final String id = ServerCommands.HERO_INIT;

    private final int userId;
    private final String username;
    private final int shipId;
    private final int speed;
    private final int shield;
    private final int maxShield;
    private final int health;
    private final int maxHealth;
    private final int cargo;
    private final int maxCargo;
    private final int x;
    private final int y;
    private final int mapId;
    private final int factionId;
    private final int clanId;
    private final long batteries;
    private final long rockets;
    private final int equipmentExpansion;
    private final boolean isPremium;
    private final long experience;
    private final long honor;
    private final int level;
    private final long credits;
    private final long uridium;
    private final int jackpot;
    private final int rank;
    private final String clanTag;
    private final int rings;
    private final boolean isCloacked;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(userId);
        packet.writeString(username);
        packet.writeInt(shipId);
        packet.writeInt(speed);
        packet.writeInt(shield);
        packet.writeInt(maxShield);
        packet.writeInt(health);
        packet.writeInt(maxHealth);
        packet.writeInt(cargo);
        packet.writeInt(maxCargo);
        packet.writeInt(x);
        packet.writeInt(y);
        packet.writeInt(mapId);
        packet.writeInt(factionId);
        packet.writeInt(clanId);
        packet.writeLong(batteries);
        packet.writeLong(rockets);
        packet.writeInt(equipmentExpansion);
        packet.writeBoolean(isPremium);
        packet.writeLong(experience);
        packet.writeLong(honor);
        packet.writeInt(level);
        packet.writeLong(credits);
        packet.writeLong(uridium);
        packet.writeInt(jackpot);
        packet.writeInt(rank);
        packet.writeString(clanTag);
        packet.writeInt(rings);
        packet.writeBoolean(false);
        packet.writeBoolean(isCloacked);
    }
}

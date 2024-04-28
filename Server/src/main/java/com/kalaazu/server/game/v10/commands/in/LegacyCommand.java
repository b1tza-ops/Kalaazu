package com.kalaazu.server.game.v10.commands.in;

import com.kalaazu.server.game.v10.commands.InCommand;
import com.kalaazu.server.game.v10.commands.LegacyPacket;
import com.kalaazu.server.game.Packet;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Legacy command.
 * ===============
 *
 * Command that uses the legacy string pipe-based format.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class LegacyCommand extends InCommand {
    public static final short ID = 4224;

    private final short id = ID;
    private LegacyPacket packet;


    @Override
    public void read(Packet packet) {
        this.packet = new LegacyPacket(packet.readString());
    }
}

package com.kalaazu.server.game.v4.commands.in;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v4.InCommand;
import lombok.Data;

/**
 * Spacemap loaded.
 *
 * @author manulaiko
 */
@Data
public class SpacemapLoaded extends InCommand {
    public static final String ID = "RDY";

    @Override
    public void read(Packet packet) {
    }
}

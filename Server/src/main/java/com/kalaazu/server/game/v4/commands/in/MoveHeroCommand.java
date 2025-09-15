package com.kalaazu.server.game.v4.commands.in;

import com.kalaazu.math.Vector;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.InCommand;
import lombok.Data;

/**
 * Move Hero Command.
 * =================
 *
 * An incoming command from the client that signals a player's intent to move
 * their ship from a starting position to a destination.
 *
 * The packet is expected to have the following structure:
 * `M|fromX|fromY|toX|toY`
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
public class MoveHeroCommand extends InCommand {
    public static final String ID = ServerCommands.SHIP_MOVEMENT;

    private Vector from;
    private Vector to;

    /**
     * Reads the command's data from a packet.
     *
     * It expects four integers representing the X and Y coordinates for the
     * `from` and `to` vectors, respectively.
     *
     * @param packet The packet to read from.
     */
    @Override
    public void read(Packet packet) {
        this.to = new Vector(packet.readInt(), packet.readInt());
        this.from = new Vector(packet.readInt(), packet.readInt());
    }
}

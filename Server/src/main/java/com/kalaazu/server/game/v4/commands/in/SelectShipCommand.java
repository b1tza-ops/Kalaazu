package com.kalaazu.server.game.v4.commands.in;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.InCommand;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Select Ship Command.
 * ====================
 *
 * An incoming command from the client that signals the player's
 * intent to select a ship on the map.
 *
 * The packet is expected to have the following structure:
 * `SEL|shipId`
 *
 * @author manulaiko
 * @example ```java
 * // Assuming 'packet' is a Packet instance containing "SEL|12345"
 * SelectShipCommand command = new SelectShipCommand();
 * command.read(packet);
 *
 * int selectedShipId = command.getShipId();
 * // selectedShipId is now 12345
 * ```
 * @see com.kalaazu.server.game.v4.InCommand
 * @see com.kalaazu.server.game.v4.commands.out.map.ShipSelectedCommand
 * @see com.kalaazu.server.game.Packet
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class SelectShipCommand extends InCommand {
    public static final String ID = ServerCommands.SELECT;

    private int shipId;

    /**
     * Reads the command's data from a packet.
     *
     * @param packet The packet to read from.
     */
    @Override
    public void read(Packet packet) {
        this.shipId = packet.readInt();
    }
}

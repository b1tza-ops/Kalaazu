package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;


/**
 * Ship Selected Command.
 * ======================
 *
 * This command is sent to the client to confirm the selection of a ship on the map,
 * providing its current status. The packet sent will have the following structure:
 * `S|shipId|health|maxHealth|shield|maxShield|isCloaked`
 *
 * @author manulaiko
 * @example ```java
 * // Create a ShipSelectedCommand for a ship with ID 123
 * ShipSelectedCommand command = new ShipSelectedCommand(
 * 123,      // shipId
 * 80000,    // health
 * 100000,   // maxHealth
 * 50000,    // shield
 * 60000,    // maxShield
 * false     // cloaked
 * );
 * ```
 * @see com.kalaazu.server.game.v4.commands.in.SelectShipCommand
 */
@Data
@AllArgsConstructor
public class ShipSelectedCommand extends OutCommand {
    private final String ID = ServerCommands.SHIP_SELECTED;

    private final int shipId;
    private final int health;
    private final int maxHealth;
    private final int shield;
    private final int maxShield;
    private final boolean cloaked;

    /**
     * Writes the command's data to a packet.
     *
     * @param packet The packet to write to.
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(ID);

        packet.writeInt(shipId);
        packet.writeInt(0);
        packet.writeInt(health);
        packet.writeInt(maxHealth);
        packet.writeInt(shield);
        packet.writeInt(maxShield);
        packet.writeBoolean(cloaked);
    }
}

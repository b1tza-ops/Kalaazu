package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * Command to remove a ship from the map.
 *
 * This command is sent from the server to the client to instruct it
 * to remove a specific ship entity (player or NPC) from the game view.
 *
 * @author manulaiko
 * @example ```java
 * // Create a command to remove a ship with ID 123
 * RemoveShipCommand command = new RemoveShipCommand(123);
 *
 * // The command can now be sent to the client.
 * // Upon receiving, the client will remove the ship with ID 123 from the map.
 * ```
 * @see com.kalaazu.server.game.v4.commands.builder.EntityRemoveCommandBuilder
 */
@Data
@RequiredArgsConstructor
public class RemoveShipCommand extends OutCommand {
    private final String id = ServerCommands.REMOVE_SHIP;

    private final int entityId;

    /**
     * Writes the command to the game packet.
     *
     * This method serializes the command's data into a format that the client can understand.
     * It first writes the command identifier, followed by the ID of the ship to be removed.
     *
     * @param packet The packet to write the data to.
     *
     * @example ```java
     * Packet packet = new Packet();
     * RemoveShipCommand command = new RemoveShipCommand(123);
     * command.write(packet);
     * // The packet now contains the data for the remove ship command.
     * ```
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId);
    }
}

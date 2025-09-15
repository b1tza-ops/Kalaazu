package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * Command to remove a collectable entity.
 * =======================================
 *
 * This command instructs the client to remove a specified collectable entity,
 * such as an ore or a bonus box, from the game map. The client identifies
 * the entity to remove using its unique ID.
 *
 * The server sends this command when a player collects an item or when an
 * item despawns for other reasons.
 *
 * @author manulaiko
 * @example ```java
 * // Assuming a collectable with ID 42 has been collected.
 * int entityIdToRemove = 42;
 * RemoveCollectableCommand command = new RemoveCollectableCommand(entityIdToRemove);
 *
 * // The command is now ready to be serialized and sent to the client.
 * // It will result in a packet like: "q|42"
 * ```
 * @see com.kalaazu.server.game.v4.commands.builder.EntityRemoveCommandBuilder
 * @see com.kalaazu.server.entities.Collectable
 */
@Data
@RequiredArgsConstructor
public class RemoveCollectableCommand extends OutCommand {
    private final String id = ServerCommands.REMOVE_ORE;

    private final int entityId;

    /**
     * Writes the command data to a packet for sending to the client.
     *
     * The packet will be formatted as `id|entityId`.
     *
     * @param packet The packet to write to.
     *
     * @example ```java
     * Packet packet = new Packet();
     * RemoveCollectableCommand command = new RemoveCollectableCommand(123);
     * command.write(packet);
     * // The packet's buffer now contains the data for "q|123".
     * ```
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId);
    }
}

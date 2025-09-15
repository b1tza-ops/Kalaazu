package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * Create Collectable Command.
 * ==========================
 *
 * This command is sent to the client to render a new collectable
 * item on the map, such as a bonus box, ore, or firework.
 *
 * The command ID (`id`) determines the type of collectable being created,
 * which corresponds to different `ServerCommands` constants.
 *
 * @example
 * ```java
 * // Create a command to spawn a bonus box
 * var command = new CreateCollectableCommand(
 *     ServerCommands.CREATE_BOX, // "c"
 *     12345, // Unique hash/ID for the collectable
 *     1,     // Type ID (e.g., GFX for the box)
 *     10500, // X coordinate
 *     6500   // Y coordinate
 * );
 *
 * // Send the command to the player's session
 * session.send(command);
 * ```
 *
 * @see com.kalaazu.server.game.v4.commands.builder.EntityCreationCommandBuilder
 * @see com.kalaazu.server.game.util.ServerCommands
 *
 * @author manulaiko
 */
@Data
@RequiredArgsConstructor
public class CreateCollectableCommand extends OutCommand {
    private final String id;
    private final int entityId;
    private final int type;
    private final int x;
    private final int y;

    /**
     * Writes the command to the given packet.
     *
     * @param packet The packet to write to.
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeInt(entityId); // Collectable.hash
        packet.writeInt(type);
        packet.writeInt(x);
        packet.writeInt(y);
    }
}

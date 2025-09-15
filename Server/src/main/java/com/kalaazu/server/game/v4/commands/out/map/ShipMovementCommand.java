package com.kalaazu.server.game.v4.commands.out.map;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;

/**
 * Ship movement command.
 * ======================
 *
 * This command is sent to the client to instruct it to move an entity (ship, pet, etc.)
 * from its current position to a new destination on the map. The client-side animation
 * (tweening) is handled based on the provided duration.
 *
 * The command is structured as `1|entityId|x|y|duration`.
 *
 * @author manulaiko
 * @example ```java
 * // Create a command to move entity with ID 1 to coordinates (2000, 3000) in 5 seconds.
 * int entityId = 1;
 * int destinationX = 2000;
 * int destinationY = 3000;
 * int movementDuration = 5000; // 5 seconds in milliseconds
 *
 * ShipMovementCommand command = new ShipMovementCommand(
 * entityId,
 * destinationX,
 * destinationY,
 * movementDuration
 * );
 *
 * // Now the command can be sent to the client.
 * ```
 * @see com.kalaazu.server.game.v4.commands.builder.MoveEntityCommandBuilder
 * @see com.kalaazu.server.entities.MovableMapEntity
 */
@Data
@RequiredArgsConstructor
public class ShipMovementCommand extends OutCommand {
    private final String id = ServerCommands.SHIP_MOVEMENT;

    private final int entityId;
    private final int x;
    private final int y;
    private final int duration;

    /**
     * Writes the command to the given packet.
     *
     * @param packet The packet to write to.
     *
     * @example ```java
     * Packet packet = new Packet();
     * ShipMovementCommand command = new ShipMovementCommand(1, 100, 200, 1000);
     *
     * command.write(packet);
     *
     * // The packet now contains the raw command data.
     * ```
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(id);

        packet.writeInt(entityId);
        packet.writeInt(x);
        packet.writeInt(y);
        packet.writeInt(duration);
    }
}

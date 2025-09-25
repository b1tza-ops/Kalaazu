package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.movement.MovementIntentComponent;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.MoveHeroCommand;
import com.kalaazu.server.service.GameLoopService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Handles incoming movement requests from the client.
 *
 * This handler is responsible for processing `MoveHeroCommand` packets, translating a
 * player's request to move into a `MovementIntentComponent` within the
 * Entity-Component-System (ECS) world. This intent is later processed by the
 * movement system to calculate the path and update the entity's position.
 *
 * @example
 * ```java
 * // MoveHeroHandler is managed by the Spring Framework and is not instantiated manually.
 * // It is automatically discovered and used by the server's command handling system.
 *
 * // Conceptual usage within the command dispatcher:
 *
 * // 1. A raw packet arrives from the client.
 * Packet rawPacket = new Packet("M|10000|10000");
 *
 * // 2. The dispatcher checks which handler can process it.
 * // Assuming 'moveHeroHandler' is an injected instance of MoveHeroHandler.
 * if (moveHeroHandler.canHandle(rawPacket)) {
 *     // It's important to reset the packet's position after canHandle
 *     rawPacket.setPosition(0);
 *
 *     // 3. The packet is deserialized into a specific command object.
 *     MoveHeroCommand command = moveHeroHandler.deserialize(rawPacket);
 *
 *     // 4. The handler's logic is executed with the player's session.
 *     moveHeroHandler.handle(command, playerSession);
 * }
 * ```
 *
 * @see com.kalaazu.server.game.v4.commands.in.MoveHeroCommand
 * @see MovementIntentComponent
 * @see com.kalaazu.server.service.GameLoopService
 * @see com.kalaazu.server.game.util.Handler
 *
 * @author manulaiko
 */
@Data
@Component("v4MoveHeroHandler")
@RequiredArgsConstructor
public class MoveHeroHandler extends Handler<MoveHeroCommand> {
    private final Class<MoveHeroCommand> clazz = MoveHeroCommand.class;
    private final String id = MoveHeroCommand.ID;
    private final Version version = Version.V4;

    private final GameLoopService gameLoopService;

    /**
     * Processes the `MoveHeroCommand` to initiate player movement.
     *
     * This method takes the deserialized command and the player's session, then adds an
     * action to the game loop. This action creates and attaches a `MovementIntentComponent`
     * to the player's entity in the ECS world. The movement system will then pick up this
     * component in a subsequent game tick to calculate the path and start the movement.
     *
     * @param packet  The deserialized `MoveHeroCommand` containing the target destination coordinates.
     * @param session The `GameSession` of the player who sent the request.
     *
     * @example
     * ```java
     * // Assuming 'handler' is an instance of MoveHeroHandler,
     * // 'moveCommand' is a populated MoveHeroCommand,
     * // and 'playerSession' is the active GameSession.
     *
     * handler.handle(moveCommand, playerSession);
     *
     * // This will schedule the creation of a MovementIntentComponent for the player's entity.
     * ```
     *
     * @see com.kalaazu.server.service.GameLoopService#addAction(short, com.kalaazu.server.ecs.WorldAction)
     * @see MovementIntentComponent
     */
    @Override
    public void handle(MoveHeroCommand packet, GameSession session) {
        var playerId = session.getEntityId();
        if (playerId == -1) {
            error("Could not move hero: Player entity not found in session.");
            return;
        }

        // Create an "intent" component and add it to the player's entity inside the game loop.
        gameLoopService.addAction(session.getMapId(), (world) -> {
            world.edit(playerId)
                    .create(MovementIntentComponent.class)
                    .setDestination(packet.getTo());
        });
    }

    /**
     * Determines if this handler is responsible for processing an incoming raw packet.
     *
     * It inspects the packet's content by reading the command identifier (a string) and
     * comparing it against the `ID` of the `MoveHeroCommand` this handler is designed
     * for. Note: This method consumes the part of the packet it reads, so the packet's
     * read position must be reset if it needs to be read again.
     *
     * @param packet The raw incoming packet.
     *
     * @return `true` if the packet's ID matches this handler's ID, `false` otherwise.
     *
     * @example
     * ```java
     * // Packet for a move command: "M|1000|2000"
     * Packet movePacket = new Packet("M|1000|2000");
     *
     * // Packet for another command: "L" (logout)
     * Packet logoutPacket = new Packet("L");
     *
     * // 'handler' is an instance of MoveHeroHandler
     * boolean canHandleMove = handler.canHandle(movePacket); // returns true
     * movePacket.setPosition(0); // Reset position for further processing
     *
     * boolean canHandleLogout = handler.canHandle(logoutPacket); // returns false
     * logoutPacket.setPosition(0);
     * ```
     *
     * @see com.kalaazu.server.game.Packet#readString()
     * @see com.kalaazu.server.game.v4.commands.in.MoveHeroCommand#ID
     */
    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

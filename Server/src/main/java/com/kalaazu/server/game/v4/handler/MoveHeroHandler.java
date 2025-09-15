package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.MoveHeroCommand;
import lombok.Data;
import org.springframework.stereotype.Component;

/**
 * Move Hero Handler.
 * =================
 *
 * Handles incoming movement requests from the client. This is the server-side
 * entry point for player-initiated movement.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@Component("v4MoveHeroHandler")
public class MoveHeroHandler extends Handler<MoveHeroCommand> {
    private final Class<MoveHeroCommand> clazz = MoveHeroCommand.class;
    private final String id = MoveHeroCommand.ID;
    private final Version version = Version.V4;

    /**
     * Executes the logic for the movement request.
     *
     * It retrieves the `Player` object from the `GameSession` and calls its
     * `move` method, passing the start and destination coordinates from the
     * command. This updates the player's state on the server, initiating the
     * movement logic that will be processed in subsequent server ticks.
     *
     * @param packet  The deserialized `MoveHeroCommand` containing the `from` and `to` vectors.
     * @param session The `GameSession` of the player who sent the request.
     */
    @Override
    public void handle(MoveHeroCommand packet, GameSession session) {
        session.getPlayer().move(packet.getFrom(), packet.getTo());
    }

    /**
     * Determines if this handler is responsible for processing the incoming raw packet.
     *
     * It reads the first string from the packet, which is expected to be the command
     * identifier (e.g., "M"), and compares it to this handler's ID.
     *
     * @param packet The raw incoming packet.
     *
     * @return `true` if the packet's ID matches this handler's ID, `false` otherwise.
     */
    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

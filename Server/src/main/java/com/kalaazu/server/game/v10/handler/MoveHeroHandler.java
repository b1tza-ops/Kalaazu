package com.kalaazu.server.game.v10.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.movement.MovementIntentComponent;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.MoveHero;
import com.kalaazu.server.service.GameLoopService;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

/**
 * Move hero handler.
 * ==================
 * <p>
 * Handles the player movement packet.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Component("v10MoveHeroHandler")
@Data
public class MoveHeroHandler extends Handler<MoveHero> {
    private final Version version = Version.V10;
    private final short id = MoveHero.ID;
    private final Class<MoveHero> clazz = MoveHero.class;

    private final ApplicationContext ctx;
    private final GameLoopService gameLoopService;

    @Override
    public void handle(MoveHero packet, GameSession session) {
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

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

package com.kalaazu.server.game.v10.handler;

import com.kalaazu.server.event.PlayerMovementStartedEvent;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.Version;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.MoveHero;
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

    @Override
    public void handle(MoveHero packet, GameSession session) {
        var player = session.getPlayer();

        player.move(packet.getFrom(), packet.getTo());
        ctx.publishEvent(new PlayerMovementStartedEvent(player, this));
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

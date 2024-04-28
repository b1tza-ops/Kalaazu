package com.kalaazu.server.game.v10.commands.builder;

import com.kalaazu.server.entities.*;
import com.kalaazu.server.game.Version;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v10.commands.out.map.CreateShipCommand;
import com.kalaazu.server.game.v10.commands.out.map.MinimapEntityDiplomacyStatusCommand;
import com.kalaazu.server.game.v10.commands.out.unknown.class_387;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * Entity creation command builder.
 * ================================
 * <p>
 * Builder for the commands for the map entity creation command.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component
@Getter
public class EntityCreationCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V10;
    private final CommandType commandType = CommandType.EntityCreationCommand;

    /**
     * Builds a single command for the given arguments.
     * <p>
     * Since there's no way to ensure type safety on the arguments
     * be careful of how you use it.
     *
     * @param arguments Command arguments.
     * @return Command for the given arguments.
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var entity = (MapEntity) arguments[0];

        return switch (entity) {
            case Collectable c -> buildCreateCollectable(c);
            case Npc n -> buildCreateNpc(n);
            case Player p -> buildCreatePlayer(p);
            case Portal p -> buildPortal(p);
            case Station s -> buildStation(s);
            default -> throw new IllegalStateException("Unexpected value: " + entity);
        };
    }

    private OutCommand buildStation(Station station) {
        // TODO create station entity
        return null;
    }

    private OutCommand buildPortal(Portal portal) {
        // TODO create portal entity
        return null;
    }

    private OutCommand buildCreatePlayer(Player player) {
        // TODO create player entity
        return null;
    }

    private OutCommand buildCreateCollectable(Collectable collectable) {
        // TODO create collectable entity
        return null;
    }

    private OutCommand buildCreateNpc(Npc npc) {
        return new CreateShipCommand(
                npc.getId(),
                npc.getNpc().getName(),
                0,
                0,
                0,
                MinimapEntityDiplomacyStatusCommand.ENEMY,
                3,
                npc.getPosition().getX(),
                npc.getPosition().getY(),
                MinimapEntityDiplomacyStatusCommand.ENEMY,
                String.valueOf(npc.getNpc().getGfx()),
                "",
                0,
                false,
                true,
                false,
                false,
                new ArrayList<>(),
                new MinimapEntityDiplomacyStatusCommand(MinimapEntityDiplomacyStatusCommand.ENEMY),
                new class_387(class_387.DEFAULT)
        );
    }
}

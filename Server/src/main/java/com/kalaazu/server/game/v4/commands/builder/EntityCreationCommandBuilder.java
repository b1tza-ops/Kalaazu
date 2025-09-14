package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.server.entities.*;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateCollectableCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreatePortalCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateShipCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateStationCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Entity creation command builder.
 * ================================
 * <p>
 * Builder for the commands for the map entity creation command.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component("v4EntityCreationCommandBuilder")
@Getter
public class EntityCreationCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
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
        return new CreateStationCommand(
                station.getId(),
                station.getStation().getFactionsId(),
                station.getPosition().getX(),
                station.getPosition().getY()
        );
    }

    private OutCommand buildPortal(Portal portal) {
        return new CreatePortalCommand(
                portal.getId(),
                portal.getPortal().getGfx(),
                portal.getPosition().getX(),
                portal.getPosition().getY(),
                portal.getPortal().isVisible()
        );
    }

    private OutCommand buildCreatePlayer(Player player) {
        // TODO create player entity
        return null;
    }

    private OutCommand buildCreateCollectable(Collectable collectable) {
        return new CreateCollectableCommand(
                collectable.getId(),
                collectable.getCollectable().getGfx(),
                collectable.getPosition().getX(),
                collectable.getPosition().getY()
        );
    }

    private OutCommand buildCreateNpc(Npc npc) {
        return new CreateShipCommand(
                npc.getId(),
                npc.getNpc().getGfx(),
                npc.getPosition().getX(),
                npc.getPosition().getY(),
                npc.getNpc().getName(),
                "",
                0,
                0,
                0,
                0,
                0,
                false,
                0,
                true,
                false
        );
    }
}

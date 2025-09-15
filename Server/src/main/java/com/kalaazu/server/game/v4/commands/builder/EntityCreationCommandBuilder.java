package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.server.entities.*;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.commands.out.map.CreateCollectableCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreatePortalCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateShipCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateStationCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Entity creation command builder.
 * ================================
 *
 * A specialized builder responsible for creating the network commands that
 * instruct the client to render a new entity on the map.
 *
 * This builder is selected when the {@link CommandBuilder}
 * receives a request with the type {@link CommandType#EntityCreationCommand}.
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
     *
     * This method uses a pattern-matching `switch` expression to determine the
     * concrete type of the provided {@link MapEntity} and delegates to the
     * appropriate private helper method to construct the specific command.
     *
     * @param arguments Command arguments, where `arguments[0]` is expected to be a {@link MapEntity}.
     *
     * @return The generated `OutCommand` for creating the entity.
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

    /**
     * Builds a `CreateCollectableCommand` for a given `Collectable` entity.
     *
     * @param collectable The collectable entity.
     *
     * @return The corresponding creation command.
     */
    private OutCommand buildCreateCollectable(Collectable collectable) {
        var id = switch (collectable.getCollectable().getType()) {
            case BOX -> ServerCommands.CREATE_BOX;
            case ORE -> ServerCommands.CREATE_ORE;
            case BEACON -> ServerCommands.BEACON;
            case FIREWORK -> ServerCommands.CREATE_MINE;
        };

        return new CreateCollectableCommand(
                id,
                collectable.getId(),
                collectable.getCollectable().getGfx(),
                collectable.getPosition().getX(),
                collectable.getPosition().getY()
        );
    }

    /**
     * Builds a `CreateShipCommand` for a given `Npc` entity.
     *
     * @param npc The NPC entity.
     *
     * @return The corresponding creation command.
     */
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

    /**
     * Builds a `CreateShipCommand` for a given `Player` entity.
     *
     * @param player The player entity.
     *
     * @return The corresponding creation command.
     */
    private OutCommand buildCreatePlayer(Player player) {
        var ship = player.getShip();
        var account = player.getAccount();

        return new CreateShipCommand(
                player.getId(),
                ship.getGfx(),
                player.getPosition().getX(),
                player.getPosition().getY(),
                account.getName(),
                account.getClansByClansId() != null ? account.getClansByClansId().getTag() : "",
                account.getFactionsId(),
                account.getClansId() != null ? account.getClansId() : 0,
                0, // TODO diplomacy status
                account.getRanksId(),
                1, // TODO equipment expansion
                false, // TODO check if enemy to player
                0, // TODO account rings
                false,
                false // TODO ship cloaked
        );
    }

    /**
     * Builds a `CreatePortalCommand` for a given `Portal` entity.
     *
     * @param portal The portal entity.
     *
     * @return The corresponding creation command.
     */
    private OutCommand buildPortal(Portal portal) {
        return new CreatePortalCommand(
                portal.getId(),
                portal.getPortal().getGfx(),
                portal.getPosition().getX(),
                portal.getPosition().getY(),
                portal.getPortal().isVisible()
        );
    }

    /**
     * Builds a `CreateStationCommand` for a given `Station` entity.
     *
     * @param station The station entity.
     *
     * @return The corresponding creation command.
     */
    private OutCommand buildStation(Station station) {
        return new CreateStationCommand(
                station.getId(),
                station.getStation().getFactionsId(),
                station.getPosition().getX(),
                station.getPosition().getY()
        );
    }
}

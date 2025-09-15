package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.server.entities.Collectable;
import com.kalaazu.server.entities.MapEntity;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.map.RemoveCollectableCommand;
import com.kalaazu.server.game.v4.commands.out.map.RemoveShipCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Entity Remove Command Builder.
 * ==============================
 *
 * This builder is responsible for creating the correct command to remove an entity
 * from the game map. It inspects the type of the entity and constructs either a
 * {@link RemoveShipCommand} for ships and NPCs, or a {@link RemoveCollectableCommand}
 * for collectable items like bonus boxes or ores.
 *
 * This class acts as a factory for entity removal commands within the V4 command protocol.
 *
 * @author manulaiko
 * @example ```java
 * // Assuming 'builder' is an injected instance of EntityRemoveCommandBuilder
 * // and 'shipToRemove' is a MapEntity instance representing a ship.
 * MapEntity shipToRemove = getSomeShipEntity(); // e.g., a Player or Npc instance
 * OutCommand removeShipCmd = builder.buildOne(new Object[]{shipToRemove});
 *
 * // 'removeShipCmd' is now a RemoveShipCommand for the given ship.
 *
 * // For a collectable
 * Collectable boxToRemove = getSomeCollectableEntity();
 * OutCommand removeBoxCmd = builder.buildOne(new Object[]{boxToRemove});
 *
 * // 'removeBoxCmd' is now a RemoveCollectableCommand for the given box.
 * ```
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.v4.commands.out.map.RemoveShipCommand
 * @see com.kalaazu.server.game.v4.commands.out.map.RemoveCollectableCommand
 * @see com.kalaazu.server.entities.MapEntity
 * @see com.kalaazu.server.entities.Collectable
 */
@Component("v4EntityRemoveCommandBuilder")
@Getter
public class EntityRemoveCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.EntityRemoveCommand;

    /**
     * Builds a specific removal command based on the entity's type.
     *
     * This method acts as a dispatcher. It checks if the provided entity is an
     * instance of {@link Collectable}. If so, it creates a {@link RemoveCollectableCommand}.
     * Otherwise, it defaults to creating a {@link RemoveShipCommand}, which is used
     * for players, NPCs, and other non-collectable map entities.
     *
     * @param arguments An array where the first element is the {@link MapEntity} to be removed.
     *
     * @return The appropriate {@link OutCommand} for removing the entity.
     *
     * @throws ClassCastException if the first element in `arguments` is not a {@link MapEntity}.
     * @example ```java
     * // Create a command to remove a ship entity
     * MapEntity ship = getShipById(123);
     * OutCommand command = builder.buildOne(new Object[]{ship});
     * // command is an instance of RemoveShipCommand
     *
     * // Create a command to remove a collectable entity
     * Collectable box = getCollectableById(456);
     * OutCommand command2 = builder.buildOne(new Object[]{box});
     * // command2 is an instance of RemoveCollectableCommand
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var entity = (MapEntity) arguments[0];

        if (entity instanceof Collectable c) {
            return buildRemoveCollectable(c);
        } else {
            return buildRemoveShip(entity);
        }
    }

    /**
     * Builds a command to remove a collectable entity.
     *
     * This is a helper method that constructs a {@link RemoveCollectableCommand}
     * using the ID of the provided collectable entity.
     *
     * @param collectable The collectable entity to remove.
     *
     * @return A new {@link RemoveCollectableCommand} instance.
     *
     * @example ```java
     * Collectable bonusBox = findBonusBoxById(789);
     * OutCommand command = buildRemoveCollectable(bonusBox);
     * // The command is now ready to be sent to remove the bonus box.
     * ```
     */
    private OutCommand buildRemoveCollectable(Collectable collectable) {
        return new RemoveCollectableCommand(
                collectable.getId()
        );
    }

    /**
     * Builds a command to remove a ship-like entity.
     *
     * This helper method constructs a {@link RemoveShipCommand}. It is used for any
     * {@link MapEntity} that is not a {@link Collectable}, such as players or NPCs.
     *
     * @param entity The map entity to remove.
     *
     * @return A new {@link RemoveShipCommand} instance.
     *
     * @example ```java
     * MapEntity npc = findNpcById(101);
     * OutCommand command = buildRemoveShip(npc);
     * // The command is now ready to be sent to remove the NPC.
     * ```
     */
    private OutCommand buildRemoveShip(MapEntity entity) {
        return new RemoveShipCommand(
                entity.getId()
        );
    }
}

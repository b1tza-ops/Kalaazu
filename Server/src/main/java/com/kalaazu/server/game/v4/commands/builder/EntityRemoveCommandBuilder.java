package com.kalaazu.server.game.v4.commands.builder;

import com.artemis.ComponentMapper;
import com.artemis.World;
import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.CollectableComponent;
import com.kalaazu.server.ecs.component.IdComponent;
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
 * <p>
 * This class acts as a factory for entity removal commands within the V4 command protocol.
 *
 * @author manulaiko
 * @example ```java
 * // Assuming 'builder' is an injected instance of EntityRemoveCommandBuilder
 * OutCommand removeShipCmd = builder.buildOne(new Object[]{world, shipId});
 * <p>
 * // 'removeShipCmd' is now a RemoveShipCommand for the given ship.
 * <p>
 * // For a collectable
 * OutCommand removeBoxCmd = builder.buildOne(new Object[]{world, boxId});
 * <p>
 * // 'removeBoxCmd' is now a RemoveCollectableCommand for the given box.
 * ```
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.v4.commands.out.map.RemoveShipCommand
 * @see com.kalaazu.server.game.v4.commands.out.map.RemoveCollectableCommand
 */
@Component("v4EntityRemoveCommandBuilder")
@Getter
public class EntityRemoveCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.EntityRemoveCommand;

    /**
     * Builds a specific removal command based on the entity's type.
     *
     * This method acts as a dispatcher. It checks if the provided entity has a
     * {@link CollectableComponent}. If so, it creates a {@link RemoveCollectableCommand}.
     * Otherwise, it defaults to creating a {@link RemoveShipCommand}, which is used for
     * players, NPCs, and other non-collectable map entities.
     *
     * @param arguments An array where `arguments[0]` is the {@link World} and `arguments[1]` is the entity ID.
     *
     * @return The appropriate {@link OutCommand} for removing the entity.
     *
     * @throws ClassCastException if the arguments are not of the expected type.
     * @example ```java
     * // Create a command to remove a ship entity
     * OutCommand command = builder.buildOne(new Object[]{world, shipId});
     * // command is an instance of RemoveShipCommand
     * <p>
     * // Create a command to remove a collectable entity
     * OutCommand command2 = builder.buildOne(new Object[]{world, boxId});
     * // command2 is an instance of RemoveCollectableCommand
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var world = (World) arguments[0];
        var entityId = (int) arguments[1];

        var idMapper = world.getMapper(IdComponent.class);
        var collectableMapper = world.getMapper(CollectableComponent.class);

        if (collectableMapper.has(entityId)) {
            return buildRemoveCollectable(entityId, idMapper);
        } else {
            return buildRemoveShip(entityId, idMapper);
        }
    }

    /**
     * Builds a command to remove a collectable entity.
     * <p>
     * This is a helper method that constructs a {@link RemoveCollectableCommand}
     * using the ID of the provided collectable entity.
     *
     * @param entityId The ID of the collectable entity to remove.
     * @param idMapper The mapper to access the {@link IdComponent}.
     *
     * @return A new {@link RemoveCollectableCommand} instance.
     *
     * @example ```java
     * OutCommand command = buildRemoveCollectable(bonusBoxId, idMapper);
     * // The command is now ready to be sent to remove the bonus box.
     * ```
     */
    private OutCommand buildRemoveCollectable(int entityId, ComponentMapper<IdComponent> idMapper) {
        var id = idMapper.get(entityId);
        return new RemoveCollectableCommand(
                id.getId()
        );
    }

    /**
     * Builds a command to remove a ship-like entity.
     * <p>
     * This helper method constructs a {@link RemoveShipCommand}. It is used for any
     * entity that does not have a {@link CollectableComponent}, such as players or NPCs.
     *
     * @param entityId The ID of the map entity to remove.
     * @param idMapper The mapper to access the {@link IdComponent}.
     *
     * @return A new {@link RemoveShipCommand} instance.
     *
     * @example ```java
     * OutCommand command = buildRemoveShip(npcId, idMapper);
     * // The command is now ready to be sent to remove the NPC.
     * ```
     */
    private OutCommand buildRemoveShip(int entityId, ComponentMapper<IdComponent> idMapper) {
        var id = idMapper.get(entityId);
        return new RemoveShipCommand(
                id.getId()
        );
    }
}

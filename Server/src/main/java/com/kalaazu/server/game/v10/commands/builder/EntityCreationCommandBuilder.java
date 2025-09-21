package com.kalaazu.server.game.v10.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Builds commands for creating entities on the client for game version V10.
 *
 * A specialized builder responsible for creating the network commands that
 * instruct the client to render a new entity on the map (e.g., ships, portals, collectables).
 * This builder is selected when the command building system
 * receives a request with the type {@link CommandType#EntityCreationCommand}.
 * It uses an entity-component-system (ECS) world to inspect an entity's components
 * and determine the correct creation command to build.
 *
 * NOTE: The implementation for V10 is currently a placeholder.
 *
 * @example
 * ```java
 * // In a Spring-managed component
 * // @Autowired
 * // private EntityCreationCommandBuilder builder;
 *
 * // 'world' is an instance of com.artemis.World
 * // 'entityId' is the integer ID of an existing entity in the world
 * Object[] args = new Object[]{world, entityId};
 *
 * // Build the command (currently returns null)
 * OutCommand command = builder.buildOne(args);
 *
 * // When implemented, the command can be sent to the client.
 * ```
 *
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.commands.CommandType
 * @see com.kalaazu.server.game.commands.OutCommand
 *
 * @author manulaiko
 */
@Component("v10EntityCreationCommandBuilder")
@Getter
public class EntityCreationCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V10;
    private final CommandType commandType = CommandType.EntityCreationCommand;

    /**
     * Builds a single entity creation command based on the entity's components.
     *
     * This method is intended to inspect an entity within the ECS world and build the
     * appropriate `OutCommand` to create it on the client. The entity's type (e.g., Player,
     * NPC, Portal) would be determined by checking for specific components.
     *
     * NOTE: This method is currently a placeholder and returns `null`.
     *
     * @param arguments Command arguments, expected to contain the `World` and the entity ID.
     *
     * @return The generated `OutCommand` for creating the entity, or `null` in the current implementation.
     *
     * @example
     * ```java
     * // 'world' is a valid World instance
     * // 'playerEntityId' is the ID of an entity with a PlayerComponent
     * Object[] args = new Object[]{world, playerEntityId};
     * OutCommand playerCreationCommand = builder.buildOne(args); // returns null for now
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        /*var entity = (MapEntity) arguments[0];

        return switch (entity) {
            case Collectable c -> buildCreateCollectable(c);
            case Npc n -> buildCreateNpc(n);
            case Player p -> buildCreatePlayer(p);
            case Portal p -> buildPortal(p);
            case Station s -> buildStation(s);
            default -> throw new IllegalStateException("Unexpected value: " + entity);
        };*/

        return null;
    }
/*
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
 */
}

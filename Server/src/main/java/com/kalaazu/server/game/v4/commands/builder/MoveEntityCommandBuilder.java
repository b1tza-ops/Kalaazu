package com.kalaazu.server.game.v4.commands.builder;

import com.artemis.World;
import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.IdComponent;
import com.kalaazu.server.ecs.component.movement.MovementComponent;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Builds commands for moving entities on the client.
 *
 * This builder is responsible for creating {@link com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand} instances.
 * It is designed to work within a command-building framework, identified by its
 * `gameVersion` and `commandType`. It takes an entity ID and an ECS {@link com.artemis.World}
 * as input, extracts the necessary movement data from the entity's components,
 * and constructs the corresponding movement command.
 *
 * @example
 * ```java
 * // In a Spring-managed component
 * // @Autowired
 * // private MoveEntityCommandBuilder builder;
 *
 * // 'world' is an instance of com.artemis.World
 * // 'movingEntityId' is the integer ID of an entity with IdComponent and MovementComponent
 * Object[] args = new Object[]{world, movingEntityId};
 *
 * // Build the command
 * OutCommand command = builder.buildOne(args);
 *
 * // The command is now ready to be serialized and sent to the client.
 * ```
 *
 * @see com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.commands.CommandType
 *
 * @author manulaiko
 */
@Getter
@Component("v4MoveEntityCommandBuilder")
public class MoveEntityCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.MoveEntityCommand;

    /**
     * Builds a {@link com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand} for a specific entity.
     *
     * This method extracts the entity's unique ID from its {@link com.kalaazu.server.ecs.component.IdComponent} and its
     * destination coordinates and total movement time from its {@link MovementComponent}.
     * It then uses this data to create a new {@link com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand}.
     *
     * @param arguments An array of objects where `arguments[0]` is the {@link com.artemis.World} instance
     *                  and `arguments[1]` is the integer ID of the entity to move.
     *
     * @return A new {@link com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand} instance populated with the entity's movement data.
     *
     * @throws ClassCastException if the arguments are not of the expected type (World, int).
     * @throws ArrayIndexOutOfBoundsException if a required component (IdComponent, MovementComponent) is missing from the entity.
     *
     * @example
     * ```java
     * // Assume 'builder' is an injected instance of MoveEntityCommandBuilder
     * // and 'world' is the active ECS world.
     * int movingEntityId = 123; // An entity with IdComponent and MovementComponent
     *
     * OutCommand moveCommand = builder.buildOne(new Object[]{world, movingEntityId});
     *
     * // 'moveCommand' is now a ShipMovementCommand ready to be sent.
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var world = (World) arguments[0];
        var entityId = (int) arguments[1];

        var idMapper = world.getMapper(IdComponent.class);
        var movementMapper = world.getMapper(MovementComponent.class);

        var id = idMapper.get(entityId);
        var movement = movementMapper.get(entityId);

        return new ShipMovementCommand(
                id.getId(),
                movement.getDestination().getX(),
                movement.getDestination().getY(),
                movement.getTotalMovementTime()
        );
    }
}

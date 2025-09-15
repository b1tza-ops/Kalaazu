package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.server.entities.MovableMapEntity;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand;
import lombok.Data;
import org.springframework.stereotype.Component;

/**
 * Move entity command builder.
 * ============================
 *
 * This class is a builder responsible for creating {@link ShipMovementCommand} instances.
 * It is designed to work within a command-building framework, identified by its
 * `gameVersion` and `commandType`. It takes a {@link MovableMapEntity} as input
 * and constructs the corresponding movement command.
 *
 * @author manulaiko
 * @example ```java
 * MoveEntityCommandBuilder builder = new MoveEntityCommandBuilder();
 *
 * // Create a mock MovableMapEntity that is moving.
 * MovableMapEntity movingShip = new MovableShip(); // Assuming MovableShip implements MovableMapEntity
 * movingShip.setId(1);
 * movingShip.setDestination(new Vector(10200, 5800));
 * // Assume getMovementDuration() is implemented to return a value like 5000ms
 *
 * // Build the command
 * ShipMovementCommand command = (ShipMovementCommand) builder.buildOne(new Object[]{movingShip});
 *
 * // The command is now ready to be serialized and sent to the client.
 * // It will contain: entityId=1, x=10200, y=5800, duration=5000
 * ```
 * @see com.kalaazu.server.game.v4.commands.out.map.ShipMovementCommand
 * @see com.kalaazu.server.entities.MovableMapEntity
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.commands.CommandType
 */
@Data
@Component
public class MoveEntityCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.MoveEntityCommand;

    /**
     * Builds a {@link ShipMovementCommand} from a {@link MovableMapEntity}.
     * <p>
     * This method extracts the entity's ID, destination coordinates, and the
     * remaining movement duration to create the command.
     *
     * @param arguments An array of objects where the first element is expected to be a {@link MovableMapEntity}.
     *
     * @return A new {@link ShipMovementCommand} instance populated with the entity's movement data.
     *
     * @example ```java
     * MoveEntityCommandBuilder builder = new MoveEntityCommandBuilder();
     * MovableMapEntity entity = getSomeMovingEntity(); // Assume this returns a valid entity
     *
     * OutCommand command = builder.buildOne(new Object[]{entity});
     * // command is now a ShipMovementCommand for the given entity.
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var entity = (MovableMapEntity) arguments[0];

        return new ShipMovementCommand(
                entity.getId(),
                entity.getDestination().getX(),
                entity.getDestination().getY(),
                entity.getMovementDuration()
        );
    }
}

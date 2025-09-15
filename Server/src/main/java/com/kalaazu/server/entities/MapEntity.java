package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;

/**
 * Map entity.
 * ==========
 *
 * Represents the base contract for any object that can be placed on a game map.
 *
 * This interface ensures that all entities in the game world share a common set
 * of properties, such as a unique ID, a position, and a reference to the map
 * they inhabit. It also provides default methods for generating standard network
 * commands related to entity lifecycle.
 *
 * @example
 * ```java
 * // A simplified implementation for a Player entity
 * public class Player implements MapEntity {
 *     private int id;
 *     private Vector position;
 *     private MapsEntity map;
 *
 *     // ... constructor and other methods
 *
 *     @Override
 *     public int getId() {
 *         return this.id;
 *     }
 *
 *     @Override
 *     public Vector getPosition() {
 *         return this.position;
 *     }
 *
 *     // ... other implemented methods
 * }
 * ```
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public interface MapEntity {
    /**
     * Gets the unique identifier of this entity.
     *
     * @return The entity's unique ID.
     */
    int getId();

    /**
     * Gets the current position of the entity on the map.
     *
     * @return The entity's position as a {@link Vector}.
     */
    Vector getPosition();

    /**
     * Sets the current position of the entity.
     *
     * @param position The new position for the entity.
     */
    void setPosition(Vector position);

    /**
     * Gets the map instance this entity belongs to.
     *
     * @return The {@link MapsEntity} this entity is on.
     */
    MapsEntity getMap();

    /**
     * Builds the network command required to create this entity on the client.
     *
     * This is a convenience method that uses the singleton {@link CommandBuilder}
     * to generate the appropriate creation command based on the entity's type.
     *
     * @return The `OutCommand` for creating the entity.
     */
    default OutCommand getEntityCreationCommand() {
        return CommandBuilder.getInstance()
                .buildCommands(CommandType.EntityCreationCommand, this)
                .getFirst();
    }

    /**
     * Builds the network command required to remove this entity from the client.
     *
     * This is a convenience method that uses the singleton {@link CommandBuilder}
     * to generate the appropriate removal command for this entity.
     *
     * @return The `OutCommand` for removing the entity.
     */
    default OutCommand getEntityRemoveCommand() {
        return CommandBuilder.getInstance()
                .buildCommands(CommandType.EntityRemoveCommand, this)
                .getFirst();
    }
}

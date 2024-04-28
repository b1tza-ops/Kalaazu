package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.server.game.command.CommandBuilder;
import com.kalaazu.server.game.command.CommandType;
import com.kalaazu.server.game.command.OutCommand;

/**
 * Map entity.
 * ===========
 * <p>
 * Represents an entity that can be placed in the map.
 * <p>
 * All map entities have a position.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public interface MapEntity {
    int getId();

    Vector getPosition();

    void setPosition(Vector position);

    MapsEntity getMap();

    default OutCommand getEntityCreationCommand() {
        return CommandBuilder.getInstance().buildCommands(CommandType.EntityCreationCommand, this).getFirst();
    }
}

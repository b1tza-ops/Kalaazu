package com.kalaazu.server.game.commands;

import com.kalaazu.model.Version;

/**
 * Command class.
 * ==============
 * <p>
 * Base class for all game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class Command {
    public abstract Version getGameVersion();
}

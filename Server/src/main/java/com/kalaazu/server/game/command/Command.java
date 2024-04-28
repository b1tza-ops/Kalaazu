package com.kalaazu.server.game.command;

import com.kalaazu.server.game.Version;

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
    public abstract short getId();
}

package com.kalaazu.server.game;

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

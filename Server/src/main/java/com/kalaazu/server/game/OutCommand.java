package com.kalaazu.server.game;

/**
 * Out Command.
 * ============
 * <p>
 * Base class for all outgoing game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class OutCommand extends Command {
    public abstract void write(Packet packet);
}

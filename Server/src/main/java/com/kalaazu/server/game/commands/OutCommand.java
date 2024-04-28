package com.kalaazu.server.game.commands;

import com.kalaazu.server.game.Packet;

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

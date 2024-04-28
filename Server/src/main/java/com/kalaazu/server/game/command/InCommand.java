package com.kalaazu.server.game.command;

import com.kalaazu.server.game.Packet;

/**
 * In Command.
 * ===========
 * <p>
 * Base class for all incoming game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class InCommand extends Command {
    public abstract void read(Packet packet);
}

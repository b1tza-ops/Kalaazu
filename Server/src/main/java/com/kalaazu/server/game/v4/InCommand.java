package com.kalaazu.server.game.v4;

import com.kalaazu.server.game.Version;

/**
 * In Command.
 * ===========
 * <p>
 * Base class for all incoming game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class InCommand extends com.kalaazu.server.game.commands.InCommand {
    public Version getGameVersion() {
        return Version.V4;
    }
}

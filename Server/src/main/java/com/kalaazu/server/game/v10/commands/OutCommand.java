package com.kalaazu.server.game.v10.commands;

import com.kalaazu.server.game.Version;

/**
 * Out Command.
 * ============
 * <p>
 * Base class for all outgoing game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class OutCommand extends com.kalaazu.server.game.OutCommand {
    public Version getGameVersion() {
        return Version.V10;
    }
}

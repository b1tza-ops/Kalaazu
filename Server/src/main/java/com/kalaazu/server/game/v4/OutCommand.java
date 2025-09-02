package com.kalaazu.server.game.v4;

import com.kalaazu.model.Version;

/**
 * Out Command.
 * ============
 * <p>
 * Base class for all outgoing game commands.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class OutCommand extends com.kalaazu.server.game.commands.OutCommand {
    public Version getGameVersion() {
        return Version.V4;
    }
}

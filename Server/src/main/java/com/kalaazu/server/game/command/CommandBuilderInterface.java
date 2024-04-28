package com.kalaazu.server.game.command;

import com.kalaazu.server.game.Version;

import java.util.Collections;
import java.util.List;

/**
 * Command builder interface.
 * ==========================
 * <p>
 * Interface for all command builders.
 * <p>
 * The builder would implement either `build` or `buildOne` method
 * if it needs to build just one or multiple commands.
 * <p>
 * Since there's no way to ensure type safety for the arguments you gotta
 * be extra careful when passing and reading the arguments array.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public interface CommandBuilderInterface {
    /**
     * Returns the game version of this command builder.
     *
     * @return Command game version.
     */
    Version getGameVersion();

    /**
     * Returns the command type of this builder.
     *
     * @return Command type.
     */
    CommandType getCommandType();

    /**
     * Builds the necessary commands for the given arguments.
     * <p>
     * Since there's no way to ensure type safety on the arguments
     * be careful of how you use it.
     *
     * @param arguments Command arguments.
     * @return Command for the given arguments.
     */
    default List<OutCommand> build(Object[] arguments) {
        var ret = buildOne(arguments);

        if (ret == null) {
            return Collections.emptyList();
        }

        return List.of(ret);
    }

    /**
     * Builds a single command for the given arguments.
     * <p>
     * Since there's no way to ensure type safety on the arguments
     * be careful of how you use it.
     *
     * @param arguments Command arguments.
     * @return Command for the given arguments.
     */
    default OutCommand buildOne(Object[] arguments) {
        return null;
    }
}

package com.kalaazu.server.game.commands;

/**
 * Enumerates the different categories of game commands.
 *
 * This enum is used to group related commands, allowing the `CommandBuilder`
 * to select the appropriate builder for a specific set of commands. Each
 * `CommandType` corresponds to a logical grouping of actions within the game,
 * such as initializing the player, creating entities, or handling player settings.
 *
 * @example
 * ```java
 * // In a service, using a CommandBuilder to get all initialization commands.
 * CommandBuilder commandBuilder = // ... injected instance
 *
 * // Build all commands associated with the InitCommands type.
 * List<OutCommand> initCommands = commandBuilder.buildCommands(
 *     CommandType.InitCommands,
 *     account, hangar, ship, config, clanId, clanTag
 * );
 *
 * // Send the commands to the player.
 * ctx.publishEvent(new SendCommands(session, initCommands));
 * ```
 *
 * @see com.kalaazu.server.game.commands.CommandBuilder
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 *
 * @author manulaiko
 */
public enum CommandType {
    /**
     * Commands related to player and client settings.
     */
    SettingsCommand,

    /**
     * Commands sent when the player session is initialized.
     */
    InitCommands,

    /**
     * Commands for creating a new entity on the map (e.g., ships, collectables).
     */
    EntityCreationCommand,

    /**
     * Commands for removing an entity from the map.
     */
    EntityRemoveCommand,

    /**
     * Commands for moving an entity on the map.
     */
    MoveEntityCommand,
}

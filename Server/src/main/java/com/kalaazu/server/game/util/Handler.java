package com.kalaazu.server.game.util;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.commands.InCommand;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;

/**
 * An abstract base class for processing incoming network packets.
 *
 * This class provides the foundational structure for all packet handlers in the game.
 * It defines a template for handling raw `Packet` data by decoding it into a specific
 * `InCommand` type and then delegating the command-specific logic to a concrete
 * implementation. The initial handling is performed asynchronously.
 *
 * @param <T> The specific type of `InCommand` this handler processes.
 *
 * @example
 * ```java
 * // Example of a concrete handler for a "Login" command.
 * public class LoginHandler extends Handler<LoginCommand> {
 *     private static final short LOGIN_PACKET_ID = 123;
 *
 *     @Override
 *     public void handle(LoginCommand command, GameSession session) {
 *         // Logic to handle the login command.
 *         System.out.println("Handling login for user: " + command.getUsername());
 *     }
 *
 *     @Override
 *     public Class<LoginCommand> getClazz() {
 *         return LoginCommand.class;
 *     }
 *
 *     @Override
 *     public boolean canHandle(Packet packet) {
 *         return packet.getId() == LOGIN_PACKET_ID;
 *     }
 *
 *     @Override
 *     public Version getVersion() {
 *         return Version.PRODUCTION;
 *     }
 * }
 * ```
 *
 * @see com.kalaazu.server.game.Packet
 * @see com.kalaazu.server.game.commands.InCommand
 * @see com.kalaazu.server.game.netty.GameSession
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public abstract class Handler<T extends InCommand> implements Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.NETWORK;

    @Value("${app.game.packets.printIn}")
    private boolean printPackets;

    /**
     * Asynchronously handles an incoming raw network packet.
     *
     * This method serves as the entry point for packet processing. It decodes the
     * raw `Packet` into the corresponding `InCommand` instance, logs the command
     * if packet printing is enabled, and then passes the decoded command to the
     * concrete `handle` implementation. Any exceptions during this process are
     * caught and logged.
     *
     * @param packet  The raw incoming network packet from the client.
     * @param session The game session associated with the client who sent the packet.
     *
     * @example ```java
     * // This method is typically invoked by a central packet dispatcher.
     * // Assuming 'loginHandler' is an instance of a concrete Handler.
     * if (loginHandler.canHandle(incomingPacket)) {
     * loginHandler.handle(incomingPacket, playerSession);
     * }
     * ```
     */
    @Async
    public void handle(Packet packet, GameSession session) {
        try {
            var command = getClazz().getDeclaredConstructor()
                    .newInstance();
            command.read(packet);

            if (printPackets) {
                info("Packet received: <<<<< {}", command);
            }

            handle(command, session);
        } catch (Exception e) {
            warn("Failed to handle packet.", e);
        }
    }

    /**
     * Returns the `Class` object of the `InCommand` this handler processes.
     *
     * This is used internally to instantiate the correct command object via reflection
     * before reading the packet data into it.
     *
     * @return The `Class` of the command type `T`.
     *
     * @example
     * ```java
     * // In a concrete LoginHandler class:
     * @Override
     * public Class<LoginCommand> getClazz() {
     *     return LoginCommand.class;
     * }
     * ```
     */
    public abstract Class<T> getClazz();

    /**
     * Handles the logic for a specific, decoded command.
     *
     * Concrete handler implementations must provide the logic for processing the
     * command's data and updating the game state accordingly.
     *
     * @param packet The decoded command object, ready for processing.
     * @param session The game session of the player who sent the command.
     *
     * @example
     * ```java
     * // In a concrete LoginHandler class:
     * @Override
     * public void handle(LoginCommand command, GameSession session) {
     *     // Authenticate user, load player data, etc.
     *     System.out.println("Processing login for: " + command.getUsername());
     * }
     * ```
     */
    public abstract void handle(T packet, GameSession session);

    /**
     * Determines whether this handler can process the given raw packet.
     *
     * This is typically implemented by checking if the packet's ID matches the
     * ID of the command this handler is responsible for.
     *
     * @param packet The raw incoming packet.
     * @return `true` if this handler should process the packet, `false` otherwise.
     *
     * @example
     * ```java
     * // In a concrete LoginHandler class, assuming the login packet ID is 100.
     * @Override
     * public boolean canHandle(Packet packet) {
     *     return packet.getId() == 100;
     * }
     * ```
     */
    public abstract boolean canHandle(Packet packet);

    /**
     * Specifies the game version this handler is associated with.
     *
     * This allows for version-specific packet handling logic, enabling different
     * handlers for the same command across different game client versions.
     *
     * @return The `Version` this handler supports.
     *
     * @example
     * ```java
     * // In a concrete LoginHandler class:
     * @Override
     * public Version getVersion() {
     *     return Version.PRODUCTION;
     * }
     * ```
     *
     * @see com.kalaazu.model.Version
     */
    public abstract Version getVersion();
}

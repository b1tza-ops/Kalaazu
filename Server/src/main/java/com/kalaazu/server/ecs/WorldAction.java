package com.kalaazu.server.ecs;

import com.artemis.World;

/**
 * A functional interface representing a deferred action to be executed on an Artemis-odb `World`.
 *
 * This interface is a key part of ensuring thread-safe interactions with the ECS world.
 * Actions can be created in any thread and queued for execution on the main game loop thread.
 * This pattern prevents concurrent modification issues and ensures that all changes to the
 * world state happen in a predictable, sequential order within a single tick.
 *
 * It is typically used as a lambda expression for conciseness.
 *
 * @author manulaiko
 * @example ```java
 * // Assuming 'gameLoop' is an instance of GameLoop
 * int entityToModify = 42;
 *
 * gameLoop.addAction(world -> {
 * // This code will be executed safely in the game loop's thread
 * world.edit(entityToModify).add(new SomeNewComponent());
 * });
 * ```
 * @see com.kalaazu.server.ecs.GameLoop
 * @see com.artemis.World
 */
@FunctionalInterface
public interface WorldAction {
    /**
     * Executes the action against the provided `World` instance.
     *
     * This method is called by the `GameLoop` during its update cycle for each queued action.
     * All world-mutating logic should be placed within this method's implementation.
     *
     * @param world The game world instance to operate on.
     *
     * @example ```java
     * // An action that deletes an entity with ID 123
     * WorldAction deleteAction = (w) -> w.delete(123);
     * ```
     */
    void execute(World world);
}

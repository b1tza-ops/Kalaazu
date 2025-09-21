package com.kalaazu.server.ecs;

import com.artemis.World;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * Represents one tick of a map's game world.
 *
 * This class implements `Runnable` and is designed to be executed by a scheduler at a fixed rate.
 * On each execution (`run()` call), it performs two main tasks:
 * 1. It executes all pending `WorldAction`s that have been queued. This is useful for making
 * thread-safe changes to the ECS world from other parts of the application.
 * 2. It calculates the time elapsed since the last tick (delta time) and processes the
 * Artemis-odb `World`, which in turn executes all registered ECS systems for that map.
 *
 * @author manulaiko
 * @example ```java
 * // Assuming a World instance has been configured and created
 * World world = new World(new WorldConfigurationBuilder().build());
 * short mapId = 1;
 *
 * // Create a GameLoop for a specific map
 * GameLoop gameLoop = new GameLoop(mapId, world);
 *
 * // Game loops are typically managed by a scheduler
 * ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
 * scheduler.scheduleAtFixedRate(gameLoop, 0, 100, TimeUnit.MILLISECONDS);
 *
 * // To interact with the world from another thread, add an action
 * gameLoop.addAction(w -> {
 * // This code will execute safely at the start of the next tick
 * w.edit(entityId).add(new SomeComponent());
 * });
 * ```
 * @see com.artemis.World
 * @see com.kalaazu.server.ecs.WorldAction
 * @see java.lang.Runnable
 */
@RequiredArgsConstructor
public class GameLoop implements Runnable, Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.GAME_LOOP;

    private final short mapId;
    private final World world;
    private final Queue<WorldAction> actions = new ConcurrentLinkedQueue<>();

    private long lastTick = System.nanoTime();

    /**
     * Adds a `WorldAction` to a thread-safe queue for execution at the beginning of the next tick.
     *
     * This method provides a safe way to enqueue operations on the `World` from external threads.
     * All actions in the queue are processed before the ECS systems are run for the tick.
     *
     * @param action The action to be executed on the `World`.
     *
     * @example ```java
     * GameLoop gameLoop = // ... obtain game loop instance
     * int entityToModify = 123;
     *
     * gameLoop.addAction(world -> {
     * // This logic will run in the game loop's thread
     * world.delete(entityToModify);
     * });
     * ```
     * @see com.kalaazu.server.ecs.WorldAction
     */
    public void addAction(WorldAction action) {
        actions.add(action);
    }

    /**
     * Executes a single tick of the game loop for the associated map.
     *
     * This method is the heart of the game loop. It first processes all queued `WorldAction`s,
     * ensuring that state changes from other threads are applied safely. It then calculates the
     * delta time since its last execution, sets it on the `World`, and calls `world.process()`
     * to run all the ECS systems.
     *
     * This method is intended to be called by a scheduler, not directly.
     *
     * @example ```java
     * // GameLoop is a Runnable, designed for a scheduler.
     * GameLoop gameLoop = // ... obtain game loop instance
     * ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
     *
     * // Schedule the run() method to be called at a fixed rate.
     * scheduler.scheduleAtFixedRate(gameLoop, 0, 100, TimeUnit.MILLISECONDS);
     * ```
     * @see java.lang.Runnable#run()
     * @see com.artemis.World#process()
     */
    @Override
    public void run() {
        try {
            // Process all queued actions
            while (!actions.isEmpty()) {
                try {
                    actions.poll().execute(world);
                } catch (Exception e) {
                    error("Error while executing action in game loop for map " + mapId, e);
                }
            }

            long now = System.nanoTime();
            float deltaTime = (now - lastTick) / 1_000_000_000.0f;

            world.setDelta(deltaTime);
            world.process();

            lastTick = now;
        } catch (Exception e) {
            error("Error in game loop for map " + mapId, e);
        }
    }
}

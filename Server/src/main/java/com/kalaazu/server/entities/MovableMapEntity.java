package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;

/**
 * Movable map entity.
 * ===================
 *
 * An extension of {@link MapEntity} that defines the contract for any entity
 * that has the ability to move across the map over time.
 *
 * This interface provides the necessary properties for movement, such as speed,
 * destination, and start time. It also includes default implementations for
 * initiating and processing movement ticks using linear interpolation.
 *
 * @example
 * ```java
 * // A simplified implementation for an NPC entity
 * public class Npc implements MovableMapEntity {
 *     // ... other MapEntity properties
 *
 *     private Vector destination;
 *     private Vector initialPosition;
 *     private short speed;
 *     private boolean isMoving;
 *     private long endMovementTime;
 *     private int totalMovementTime;
 *
 *     // ... getters and setters for the above fields
 *
 *     public void update() {
 *         // This would be called by a central game loop
 *         this.movementTick();
 *     }
 * }
 * ```
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public interface MovableMapEntity extends MapEntity {
    /**
     * Initiates a movement from a starting point to a destination.
     *
     * This method calculates the total duration of the movement based on the
     * distance and speed, and sets all the necessary state variables
     * (`isMoving`, `destination`, `endMovementTime`, etc.) to begin the move.
     *
     * @param from The starting vector.
     * @param to   The destination vector.
     */
    default void move(Vector from, Vector to) {
        if (getSpeed() <= 0) {
            setPosition(to);

            return;
        }

        var duration = (int) (from.dst(to) * 1000 / getSpeed());
        if (duration <= 0) {
            setPosition(to);

            return;
        }

        setMoving(true);

        setInitialPosition(from);
        setPosition(from);
        setDestination(to);

        setTotalMovementTime(duration);
        setEndMovementTime(System.currentTimeMillis() + duration);
    }

    /**
     * Gets the movement speed of the entity in game units per second.
     *
     * @return The entity's speed.
     */
    short getSpeed();

    /**
     * Processes a single tick of movement.
     *
     * This method should be called on every server tick for a moving entity.
     * It calculates the entity's current position along the path from its
     * initial position to its destination using linear interpolation based on
     * the elapsed time. When the movement is complete, it sets the entity's
     * position to the final destination and stops the movement.
     */
    default void movementTick() {
        if (!isMoving()) {
            return;
        }

        var timeLeft = getEndMovementTime() - System.currentTimeMillis();

        if (timeLeft <= 0) {
            setMoving(false);
            setPosition(getDestination());

            return;
        }

        var totalTime = getTotalMovementTime();
        if (totalTime <= 0) {
            setMoving(false);
            setPosition(getDestination());

            return;
        }

        var elapsedTime = totalTime - timeLeft;
        var ratio = (float) elapsedTime / totalTime;

        // Linear interpolation: P(t) = P0 + (P1 - P0) * t
        var travelVector = Vector.sub(getDestination(), getInitialPosition());
        var scaledVector = travelVector.scl(ratio);

        var newPosition = getInitialPosition().add(scaledVector);
        setPosition(newPosition);
    }

    /**
     * Checks if the entity is currently in the process of moving.
     *
     * @return `true` if the entity is moving, `false` otherwise.
     */
    boolean isMoving();

    /**
     * Sets the movement state of the entity.
     *
     * @param moving The new moving state.
     */
    void setMoving(boolean moving);

    /**
     * Gets the system timestamp (in milliseconds) when the current movement
     * is scheduled to end.
     *
     * @return The end-of-movement timestamp.
     */
    long getEndMovementTime();

    /**
     * Gets the target destination for the current movement.
     *
     * @return The destination vector.
     */
    Vector getDestination();

    /**
     * Sets the target destination for a movement.
     *
     * @param v The new destination vector.
     */
    void setDestination(Vector v);

    /**
     * Gets the total duration of the current movement in milliseconds.
     *
     * @return The total movement time.
     */
    int getTotalMovementTime();

    /**
     * Gets the position where the current movement began.
     *
     * @return The initial position vector.
     */
    Vector getInitialPosition();

    /**
     * Sets the starting position for a movement.
     *
     * @param v The initial position vector.
     */
    void setInitialPosition(Vector v);

    /**
     * Sets the total duration for the current movement.
     *
     * @param totalMovementTime The total movement time in milliseconds.
     */
    void setTotalMovementTime(int totalMovementTime);

    /**
     * Sets the system timestamp for when the current movement will end.
     *
     * @param l The end-of-movement timestamp.
     */
    void setEndMovementTime(long l);

    /**
     * Builds the network command required to signal this entity's movement
     * to the client.
     *
     * @return A {@link OutCommand} populated with this entity's ID,
     * destination, and remaining movement duration.
     */
    default OutCommand getMovementCommand() {
        return CommandBuilder.getInstance()
                .buildCommands(CommandType.MoveEntityCommand, this)
                .getFirst();
    }

    /**
     * Calculates the remaining duration of the current movement from the
     * entity's current position to its destination.
     *
     * @return The remaining movement time in milliseconds, or 0 if not moving.
     */
    default int getMovementDuration() {
        if (!isMoving()) {
            return 0;
        }

        return (int) (getPosition().dst(getDestination()) * 1000 / getSpeed());
    }
}

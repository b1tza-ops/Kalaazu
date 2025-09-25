package com.kalaazu.server.ecs.system.movement;

import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.systems.IteratingSystem;
import com.kalaazu.server.ecs.component.map.PositionComponent;
import com.kalaazu.server.ecs.component.movement.MovementComponent;
import com.kalaazu.server.ecs.component.movement.MovementIntentComponent;
import com.kalaazu.server.ecs.component.movement.SpeedComponent;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

/**
 * Movement Intent System.
 * ======================
 *
 * An ECS system that translates a `MovementIntentComponent` into an active `MovementComponent`.
 * It runs on every game tick, checking for entities that have a pending movement request.
 * When an intent is found, this system calculates the movement duration based on the entity's
 * current position, destination, and speed. It then creates or updates the `MovementComponent`
 * to initiate the movement, and finally removes the `MovementIntentComponent` to signify
 * that the request has been processed.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(new MovementIntentSystem())
 * .build();
 * World world = new World(config);
 * ```
 * @see com.artemis.systems.IteratingSystem
 * @see MovementIntentComponent
 * @see MovementComponent
 */
@Component
@Scope("prototype")
public class MovementIntentSystem extends IteratingSystem {

    // Injected by Artemis
    private ComponentMapper<PositionComponent> positionMapper;
    private ComponentMapper<SpeedComponent> speedMapper;
    private ComponentMapper<MovementComponent> movementMapper;
    private ComponentMapper<MovementIntentComponent> movementIntentMapper;

    /**
     * Constructor for the `MovementIntentSystem`.
     *
     * Initializes the system to process entities that have a `MovementIntentComponent`,
     * a `PositionComponent`, and a `SpeedComponent`. This ensures that any entity
     * with a movement request also has the necessary components to calculate and
     * execute the movement.
     *
     * @example ```java
     * // The system is typically instantiated and added to the world configuration.
     * MovementIntentSystem system = new MovementIntentSystem();
     * ```
     */
    public MovementIntentSystem() {
        super(Aspect.all(MovementIntentComponent.class, PositionComponent.class, SpeedComponent.class));
    }

    /**
     * Processes an entity with a `MovementIntentComponent`.
     *
     * This method is the core logic of the system. For a given entity, it retrieves the
     * movement intent, current position, and speed. It calculates the distance to the
     * destination and the time it will take to travel. It then configures the entity's
     * `MovementComponent` with the destination, start and end times, and flags the
     * movement as `justStarted`. After processing, the `MovementIntentComponent` is
     * removed to prevent reprocessing.
     *
     * @param entityId The ID of the entity being processed.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework. It is not meant to be called directly.
     * // An entity with a MovementIntentComponent will trigger this system.
     * world.edit(entityId).create(MovementIntentComponent.class).setDestination(new Vector2(1000, 1000));
     * // On the next world.process(), this system will execute for the entity.
     * ```
     */
    @Override
    protected void process(int entityId) {
        var position = positionMapper.get(entityId);
        var speed = speedMapper.get(entityId);
        var intent = movementIntentMapper.get(entityId);

        var from = position.getPosition();
        var to = intent.getDestination();

        var distance = from.dst(to);
        if (distance > 0) {
            var duration = (long) ((distance / speed.getSpeed()) * 1000);

            // create() will get the component if it exists, or create a new one if it doesn't.
            movementMapper.create(entityId)
                    .setDestination(to)
                    .setEndMovementTime(System.currentTimeMillis() + duration)
                    .setTotalMovementTime((int) duration)
                    .setJustStarted(true)
                    .setInitialPosition(from)
                    .setMoving(true);
        }

        // The intent has been processed, remove the component.
        movementIntentMapper.remove(entityId);
    }
}

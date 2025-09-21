package com.kalaazu.server.ecs.system;


import com.artemis.Aspect;
import com.artemis.ComponentMapper;
import com.artemis.systems.IteratingSystem;
import com.kalaazu.server.ecs.component.MovementComponent;
import com.kalaazu.server.ecs.component.PlayerComponent;
import com.kalaazu.server.ecs.component.ViewComponent;
import com.kalaazu.server.event.SendCommandToSessions;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * Movement Broadcast System.
 * ==========================
 *
 * An ECS system that runs every tick to broadcast the start of a player's movement to other players within their view.
 * It identifies players whose `MovementComponent` is flagged as `justStarted`, creates a movement command,
 * and sends it to all observers. This ensures that player movements are visualized by others in near real-time.
 *
 * @author manulaiko
 * @example ```java
 * // In an Artemis-odb WorldConfiguration, the system is added to the world.
 * // Dependencies like ApplicationEventPublisher and CommandBuilder are typically injected by Spring.
 * WorldConfiguration config = new WorldConfigurationBuilder()
 * .with(
 * new MovementBroadcastSystem(applicationEventPublisher, commandBuilder)
 * )
 * .build();
 * World world = new World(config);
 *
 * // When a player entity with a MovementComponent (where isJustStarted is true)
 * // is processed by the world, this system will automatically trigger.
 * ```
 */
@Component
@Scope("prototype")
public class MovementBroadcastSystem extends IteratingSystem implements Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.GAME_LOOP;

    private final ApplicationEventPublisher publisher;
    private final CommandBuilder commandBuilder;

    private ComponentMapper<MovementComponent> movementMapper;
    private ComponentMapper<PlayerComponent> playerMapper;
    private ComponentMapper<ViewComponent> viewMapper;

    /**
     * Constructor for the `MovementBroadcastSystem`.
     *
     * @param publisher      The application event publisher used to dispatch events, such as sending commands to sessions.
     * @param commandBuilder The builder used to construct game commands, like the `MoveEntityCommand`.
     *
     * @example ```java
     * ApplicationEventPublisher publisher = // ... obtain from Spring context
     * CommandBuilder commandBuilder = // ... obtain from Spring context
     * MovementBroadcastSystem system = new MovementBroadcastSystem(publisher, commandBuilder);
     * ```
     */
    public MovementBroadcastSystem(ApplicationEventPublisher publisher, CommandBuilder commandBuilder) {
        super(Aspect.all(PlayerComponent.class, MovementComponent.class, ViewComponent.class));
        this.publisher = publisher;
        this.commandBuilder = commandBuilder;
    }

    /**
     * Processes an entity that has a `MovementComponent`.
     * This method is the core logic of the system. It checks if the entity's movement has just started.
     * If so, it constructs a `MoveEntityCommand` and sends it to all players who currently have the moving entity
     * in their `ViewComponent`. Finally, it resets the `justStarted` flag on the `MovementComponent` to ensure
     * the broadcast only happens once per movement initiation.
     *
     * @param entityId The ID of the entity being processed.
     *
     * @example ```java
     * // This method is invoked by the Artemis-odb framework during its processing loop
     * // for each entity that matches the system's aspect. It is not meant to be called directly.
     *
     * // An entity that would trigger this method:
     * int movingPlayerId = world.create();
     * MovementComponent movement = world.edit(movingPlayerId)
     * .add(new PlayerComponent())
     * .add(new ViewComponent())
     * .create(MovementComponent.class);
     *
     * movement.setJustStarted(true);
     * // ... set other movement properties
     *
     * // On the next world.process(), this system will execute for movingPlayerId.
     * ```
     * @see com.kalaazu.server.ecs.component.MovementComponent#isJustStarted()
     * @see com.kalaazu.server.event.SendCommandToSessions
     */
    @Override
    protected void process(int entityId) {
        var movement = movementMapper.get(entityId);
        if (!movement.isJustStarted()) {
            return;
        }

        movement.setJustStarted(false);

        var view = viewMapper.get(entityId);
        if (view == null || view.getPlayers().isEmpty()) {
            return;
        }

        var moveCommand = commandBuilder.buildCommands(CommandType.MoveEntityCommand, world, entityId).getFirst();

        var playersInView = view.getPlayers();
        var sessionsToNotify = new ArrayList<GameSession>(playersInView.size());
        for (int i = 0, s = playersInView.size(); i < s; i++) {
            var player = playerMapper.get(playersInView.get(i));
            if (player != null) sessionsToNotify.add(player.getSession());
        }

        if (!sessionsToNotify.isEmpty()) {
            publisher.publishEvent(new SendCommandToSessions(sessionsToNotify, moveCommand));
        }
    }
}
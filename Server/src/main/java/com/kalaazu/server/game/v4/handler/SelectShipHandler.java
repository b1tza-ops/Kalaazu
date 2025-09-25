package com.kalaazu.server.game.v4.handler;

import com.artemis.World;
import com.artemis.utils.IntBag;
import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.HealthComponent;
import com.kalaazu.server.ecs.component.IdComponent;
import com.kalaazu.server.ecs.component.TargetComponent;
import com.kalaazu.server.ecs.component.ViewComponent;
import com.kalaazu.server.ecs.entity.EntityType;
import com.kalaazu.server.event.SendCommand;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.SelectShipCommand;
import com.kalaazu.server.game.v4.commands.out.map.ShipSelectedCommand;
import com.kalaazu.server.service.GameLoopService;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

/**
 * Handles the selection of a ship by a player.
 * ============================================
 *
 * This class processes an incoming `SelectShipCommand` from a client. It is responsible
 * for validating the selection request, finding the target entity within the player's
 * view, updating the player's `TargetComponent`, and sending a `ShipSelectedCommand`
 * back to the client with the target's current status (health, shield, etc.).
 *
 * The logic is executed within the game loop to ensure thread safety and consistency
 * with the entity-component system state.
 *
 * @author manulaiko
 * @example ```java
 * // In a Spring-managed environment, this handler is automatically invoked.
 * // The following shows the command it processes:
 * SelectShipCommand command = new SelectShipCommand();
 * command.setShipId(12345); // The ID of the ship to select
 *
 * // The system would then pass this command to the handler.
 * // handler.handle(command, session);
 * ```
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Component("v4SelectShipHandler")
@RequiredArgsConstructor
public class SelectShipHandler extends Handler<SelectShipCommand> {
    private final Class<SelectShipCommand> clazz = SelectShipCommand.class;
    private final String id = SelectShipCommand.ID;
    private final Version version = Version.V4;

    private final GameLoopService gameLoopService;
    private final ApplicationContext ctx;

    /**
     * Processes the incoming SelectShipCommand.
     *
     * This method schedules an action in the game loop to find and select the target
     * entity. It first verifies that the player and their view component exist. It then
     * searches for the target ship ID within the player's visible players and NPCs.
     * If found, it proceeds to select the entity.
     *
     * @param packet  The incoming `SelectShipCommand` containing the ID of the ship to select.
     * @param session The game session of the player making the request.
     *
     * @example ```java
     * handler.handle(selectShipCommand, gameSession);
     * ```
     */
    @Override
    public void handle(SelectShipCommand packet, GameSession session) {
        var playerId = session.getEntityId();
        if (playerId == -1) {
            return;
        }

        gameLoopService.addAction(session.getMapId(), (world) -> {
            var viewMapper = world.getMapper(ViewComponent.class);
            var view = viewMapper.get(playerId);
            if (view == null) {
                return;
            }

            // Find the target in the visible entities
            var targetEntityId = findTargetInBag(world, view.getPlayers(), packet.getShipId());
            var type = EntityType.PLAYER;
            if (targetEntityId == -1) {
                targetEntityId = findTargetInBag(world, view.getNpcs(), packet.getShipId());
                type = EntityType.NPC;
            }

            // If a target was found, proceed with selection
            if (targetEntityId != -1) {
                var command = selectEntity(world, playerId, targetEntityId, packet.getShipId(), type);

                ctx.publishEvent(new SendCommand(session, command));
            }
        });
    }

    /**
     * Searches for a target entity within a given collection of entities.
     *
     * Iterates through an `IntBag` of entity IDs and checks if any of them have an
     * `IdComponent` that matches the specified `shipIdToFind`.
     *
     * @param world        The ECS world instance.
     * @param entities     An `IntBag` containing the entity IDs to search through.
     * @param shipIdToFind The public-facing ship ID to find.
     *
     * @return The entity ID of the found target, or -1 if not found.
     *
     * @example ```java
     * int targetEntityId = findTargetInBag(world, visiblePlayers, 12345);
     * ```
     */
    private int findTargetInBag(World world, IntBag entities, int shipIdToFind) {
        var idMapper = world.getMapper(IdComponent.class);
        for (int i = 0, s = entities.size(); i < s; i++) {
            var entityId = entities.get(i);
            var idComponent = idMapper.get(entityId);
            if (idComponent != null && idComponent.getId() == shipIdToFind) {
                return entityId; // Found it
            }
        }
        return -1; // Not found
    }

    /**
     * Finalizes the entity selection process.
     *
     * This helper method is called once a target entity has been found. It checks if the
     * target is selectable (i.e., has a `HealthComponent`), updates the player's
     * `TargetComponent` to the new target, and sends a `ShipSelectedCommand` to the
     * client with the target's details.
     *
     * @param world          The ECS world instance.
     * @param playerId       The entity ID of the player performing the selection.
     * @param targetEntityId The entity ID of the target being selected.
     * @param shipId         The public-facing ID of the target ship.
     * @param entityType     The type of the target entity (e.g., PLAYER, NPC).
     *
     * @example ```java
     * // This is a private method and is called internally by the handle method.
     * // selectEntity(world, 1, 10, 12345, EntityType.PLAYER, session);
     * ```
     */
    private ShipSelectedCommand selectEntity(World world, int playerId, int targetEntityId, int shipId, EntityType entityType) {
        var healthMapper = world.getMapper(HealthComponent.class);
        var health = healthMapper.get(targetEntityId);
        if (health == null) {
            // Entity is not attackable, can't be selected.
            return null;
        }

        var targetMapper = world.getMapper(TargetComponent.class);
        var target = targetMapper.create(playerId);
        target.setTargetId(targetEntityId);

        return new ShipSelectedCommand(
                shipId,
                health.getHealth(),
                health.getMaxHealth(),
                health.getShield(),
                health.getMaxShield(),
                false
        );
    }

    /**
     * Checks if this handler can process the given packet.
     *
     * This method reads the command ID from the packet without advancing the reader's
     * index and checks if it matches the handler's expected command ID (`SEL`).
     *
     * @param packet The packet to check.
     *
     * @return `true` if the packet's command ID matches this handler's ID, `false` otherwise.
     *
     * @example ```java
     * boolean canProcess = handler.canHandle(packet); // Returns true if packet starts with "SEL"
     * ```
     */
    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

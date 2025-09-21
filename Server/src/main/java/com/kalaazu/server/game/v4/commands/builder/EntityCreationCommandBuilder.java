package com.kalaazu.server.game.v4.commands.builder;

import com.artemis.ComponentMapper;
import com.artemis.World;
import com.kalaazu.model.Version;
import com.kalaazu.server.ecs.component.*;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.commands.out.map.CreateCollectableCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreatePortalCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateShipCommand;
import com.kalaazu.server.game.v4.commands.out.map.CreateStationCommand;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * Builds commands for creating entities on the client.
 *
 * A specialized builder responsible for creating the network commands that
 * instruct the client to render a new entity on the map (e.g., ships, portals, collectables).
 * This builder is selected when the {@link com.kalaazu.server.game.commands.CommandBuilder}
 * receives a request with the type {@link CommandType#EntityCreationCommand}.
 * It uses an entity-component-system (ECS) world to inspect an entity's components
 * and determine the correct creation command to build.
 *
 * @author manulaiko
 * @example ```java
 * // In a Spring-managed component
 * // @Autowired
 * // private EntityCreationCommandBuilder builder;
 *
 * // 'world' is an instance of com.artemis.World
 * // 'entityId' is the integer ID of an existing entity in the world
 * Object[] args = new Object[]{world, entityId};
 *
 * // Build the command
 * OutCommand command = builder.buildOne(args);
 *
 * // The command can now be sent to the client.
 * ```
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.commands.CommandType
 * @see com.kalaazu.server.game.commands.OutCommand
 */
@Component("v4EntityCreationCommandBuilder")
@Getter
public class EntityCreationCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.EntityCreationCommand;

    /**
     * Builds a single entity creation command based on the entity's components.
     *
     * This method inspects the entity specified by `entityId` within the provided `world`.
     * It determines the entity's type (e.g., Player, NPC, Portal) by checking for the
     * presence of specific components and then delegates to a corresponding private
     * helper method to construct the appropriate `OutCommand`.
     *
     * @param arguments Command arguments. `arguments[0]` must be the `com.artemis.World` instance, and `arguments[1]` must be the integer entity ID.
     *
     * @return The generated `OutCommand` for creating the entity.
     *
     * @throws IllegalStateException if the entity type cannot be determined or a creation command cannot be built.
     * @example ```java
     * // 'world' is a valid World instance
     * // 'playerEntityId' is the ID of an entity with a PlayerComponent
     * Object[] args = new Object[]{world, playerEntityId};
     * OutCommand playerCreationCommand = builder.buildOne(args);
     *
     * // 'collectableEntityId' is the ID of an entity with a CollectableComponent
     * args = new Object[]{world, collectableEntityId};
     * OutCommand collectableCreationCommand = builder.buildOne(args);
     * ```
     */
    @Override
    public OutCommand buildOne(Object[] arguments) {
        var world = (World) arguments[0];
        var entityId = (int) arguments[1];

        // Get mappers from the world
        var idMapper = world.getMapper(IdComponent.class);
        var positionMapper = world.getMapper(PositionComponent.class);
        var playerMapper = world.getMapper(PlayerComponent.class);
        var npcMapper = world.getMapper(NpcComponent.class);
        var collectableMapper = world.getMapper(CollectableComponent.class);
        var portalMapper = world.getMapper(PortalComponent.class);
        var stationMapper = world.getMapper(StationComponent.class);

        // Determine entity type by checking for its main component
        if (playerMapper.has(entityId)) {
            return buildCreatePlayer(entityId, idMapper, positionMapper, playerMapper);
        } else if (npcMapper.has(entityId)) {
            return buildCreateNpc(entityId, idMapper, positionMapper, npcMapper);
        } else if (collectableMapper.has(entityId)) {
            return buildCreateCollectable(entityId, idMapper, positionMapper, collectableMapper);
        } else if (portalMapper.has(entityId)) {
            return buildPortal(entityId, idMapper, positionMapper, portalMapper);
        } else if (stationMapper.has(entityId)) {
            return buildStation(entityId, idMapper, positionMapper, stationMapper);
        }

        throw new IllegalStateException("Could not build creation command for entity: " + entityId);
    }

    /**
     * Builds a `CreateShipCommand` for a player entity.
     *
     * Gathers data from `IdComponent`, `PositionComponent`, and `PlayerComponent`
     * (which contains `Account` and `Ship` data) to create a command representing
     * another player's ship on the map.
     *
     * @param entityId       The ID of the player entity.
     * @param idMapper       The component mapper for `IdComponent`.
     * @param positionMapper The component mapper for `PositionComponent`.
     * @param playerMapper   The component mapper for `PlayerComponent`.
     *
     * @return A new `CreateShipCommand` instance configured for a player's ship.
     *
     * @example ```java
     * // This is a private helper method called from buildOne()
     * return buildCreatePlayer(entityId, idMapper, positionMapper, playerMapper);
     * ```
     */
    private OutCommand buildCreatePlayer(int entityId, ComponentMapper<IdComponent> idMapper, ComponentMapper<PositionComponent> positionMapper, ComponentMapper<PlayerComponent> playerMapper) {
        var player = playerMapper.get(entityId);
        var position = positionMapper.get(entityId);
        var id = idMapper.get(entityId);

        var ship = player.getShip();
        var account = player.getAccount();

        return new CreateShipCommand(
                id.getId(),
                ship.getGfx(),
                position.getPosition().getX(),
                position.getPosition().getY(),
                account.getName(),
                account.getClansByClansId() != null ? account.getClansByClansId().getTag() : "",
                account.getFactionsId(),
                account.getClansId() != null ? account.getClansId() : 0,
                0, // TODO diplomacy status
                account.getRanksId(),
                1, // TODO equipment expansion
                false, // TODO check if enemy to player
                0, // TODO account rings
                false,
                false // TODO ship cloaked
        );
    }

    /**
     * Builds a `CreateShipCommand` for an NPC entity.
     *
     * Retrieves the `IdComponent`, `PositionComponent`, and `NpcComponent` to populate
     * the command with details like ID, position, name, and graphics ID.
     *
     * @param entityId       The ID of the NPC entity.
     * @param idMapper       The component mapper for `IdComponent`.
     * @param positionMapper The component mapper for `PositionComponent`.
     * @param npcMapper      The component mapper for `NpcComponent`.
     *
     * @return A new `CreateShipCommand` instance configured for an NPC.
     *
     * @example ```java
     * // This is a private helper method called from buildOne()
     * return buildCreateNpc(entityId, idMapper, positionMapper, npcMapper);
     * ```
     */
    private OutCommand buildCreateNpc(int entityId, ComponentMapper<IdComponent> idMapper, ComponentMapper<PositionComponent> positionMapper, ComponentMapper<NpcComponent> npcMapper) {
        var npc = npcMapper.get(entityId);
        var position = positionMapper.get(entityId);
        var id = idMapper.get(entityId);

        return new CreateShipCommand(
                id.getId(),
                npc.getNpc().getGfx(),
                position.getPosition().getX(),
                position.getPosition().getY(),
                npc.getNpc().getName(),
                "",
                0,
                0,
                0,
                0,
                0,
                false,
                0,
                true,
                false
        );
    }

    /**
     * Builds a `CreateCollectableCommand` for a collectable entity.
     *
     * Retrieves the necessary components (`IdComponent`, `PositionComponent`, `CollectableComponent`)
     * for the given entity ID and uses their data to construct the command. It also determines
     * the specific server command ID (e.g., `CREATE_BOX`, `CREATE_ORE`) based on the collectable's type.
     *
     * @param entityId          The ID of the collectable entity.
     * @param idMapper          The component mapper for `IdComponent`.
     * @param positionMapper    The component mapper for `PositionComponent`.
     * @param collectableMapper The component mapper for `CollectableComponent`.
     *
     * @return A new `CreateCollectableCommand` instance populated with the entity's data.
     *
     * @example ```java
     * // This is a private helper method called from buildOne()
     * return buildCreateCollectable(entityId, idMapper, positionMapper, collectableMapper);
     * ```
     */
    private OutCommand buildCreateCollectable(int entityId, ComponentMapper<IdComponent> idMapper, ComponentMapper<PositionComponent> positionMapper, ComponentMapper<CollectableComponent> collectableMapper) {
        var collectable = collectableMapper.get(entityId);
        var position = positionMapper.get(entityId);
        var id = idMapper.get(entityId);

        var commandId = switch (collectable.getType().getType()) {
            case BOX -> ServerCommands.CREATE_BOX;
            case ORE -> ServerCommands.CREATE_ORE;
            case BEACON -> ServerCommands.BEACON;
            case FIREWORK -> ServerCommands.CREATE_MINE;
        };

        return new CreateCollectableCommand(
                commandId,
                id.getId(),
                collectable.getType().getGfx(),
                position.getPosition().getX(),
                position.getPosition().getY()
        );
    }

    /**
     * Builds a `CreatePortalCommand` for a portal entity.
     *
     * Uses `IdComponent`, `PositionComponent`, and `PortalComponent` to get the
     * portal's ID, position, graphics ID, and visibility status to construct the command.
     *
     * @param entityId       The ID of the portal entity.
     * @param idMapper       The component mapper for `IdComponent`.
     * @param positionMapper The component mapper for `PositionComponent`.
     * @param portalMapper   The component mapper for `PortalComponent`.
     *
     * @return A new `CreatePortalCommand` instance.
     *
     * @example ```java
     * // This is a private helper method called from buildOne()
     * return buildPortal(entityId, idMapper, positionMapper, portalMapper);
     * ```
     */
    private OutCommand buildPortal(int entityId, ComponentMapper<IdComponent> idMapper, ComponentMapper<PositionComponent> positionMapper, ComponentMapper<PortalComponent> portalMapper) {
        var portal = portalMapper.get(entityId);
        var position = positionMapper.get(entityId);
        var id = idMapper.get(entityId);

        return new CreatePortalCommand(
                id.getId(),
                portal.getPortal().getGfx(),
                position.getPosition().getX(),
                position.getPosition().getY(),
                portal.getPortal().isVisible()
        );
    }

    /**
     * Builds a `CreateStationCommand` for a station entity.
     *
     * Retrieves data from `IdComponent`, `PositionComponent`, and `StationComponent`
     * to construct the command for creating a station on the client.
     *
     * @param entityId       The ID of the station entity.
     * @param idMapper       The component mapper for `IdComponent`.
     * @param positionMapper The component mapper for `PositionComponent`.
     * @param stationMapper  The component mapper for `StationComponent`.
     *
     * @return A new `CreateStationCommand` instance.
     *
     * @example ```java
     * // This is a private helper method called from buildOne()
     * return buildStation(entityId, idMapper, positionMapper, stationMapper);
     * ```
     */
    private OutCommand buildStation(int entityId, ComponentMapper<IdComponent> idMapper, ComponentMapper<PositionComponent> positionMapper, ComponentMapper<StationComponent> stationMapper) {
        var station = stationMapper.get(entityId);
        var position = positionMapper.get(entityId);
        var id = idMapper.get(entityId);

        return new CreateStationCommand(
                id.getId(),
                station.getStation().getFactionsId(),
                position.getPosition().getX(),
                position.getPosition().getY()
        );
    }
}

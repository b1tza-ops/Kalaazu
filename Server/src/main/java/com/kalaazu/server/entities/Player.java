package com.kalaazu.server.entities;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsShipsEntity;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.server.event.SendCommandToSessions;
import com.kalaazu.server.event.SendCommands;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.service.MapService;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Player entity.
 * ============
 *
 * Represents a player in a map.
 * This class holds all the state for a player's character in the game world,
 * including their position, movement data, and what other entities they can see.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@Component
@Scope("prototype")
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Player implements MovableMapEntity, Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.USER;

    private final MapService mapService;
    private final ApplicationContext ctx;
    private final KalaazuConfig kalaazuConfig;

    @EqualsAndHashCode.Include
    private int id;
    private Vector initialPosition = Vector.ZERO.cpy();
    private Vector position = Vector.ZERO.cpy();
    private Vector destination = Vector.ZERO.cpy();
    private short speed;
    private boolean moving;
    private long endMovementTime;
    private int totalMovementTime;

    private GameSession gameSession;
    private MapsEntity map;
    private AccountsEntity account;
    private AccountsShipsEntity ship;
    private AccountsConfigurationsEntity config;

    private Set<Player> nearbyPlayers = new HashSet<>();
    private Set<Npc> nearbyNpcs = new HashSet<>();
    private Set<Collectable> nearbyCollectables = new HashSet<>();

    /**
     * Overrides the default move behavior to notify nearby players.
     *
     * This method first calls the base `move` logic from the interface, then
     * immediately sends a movement command to all players who can already see
     * this player, ensuring they witness the start of the movement.
     *
     * @param from The starting vector.
     * @param to   The destination vector.
     */
    @Override
    public void move(Vector from, Vector to) {
        MovableMapEntity.super.move(from, to);

        if (!this.nearbyPlayers.isEmpty()) {
            var sessions = this.nearbyPlayers.stream().map(Player::getGameSession).collect(Collectors.toList());
            ctx.publishEvent(new SendCommandToSessions(sessions, this.getMovementCommand()));
        }
    }

    /**
     * The main server-side tick for the player.
     *
     * This method is executed asynchronously on a fixed schedule and serves as the
     * entry point for all per-frame logic related to this player, such as
     * processing movement and updating their view of the game world.
     */
    @Async
    public void tick() {
        this.movementTick();
        this.updateNearbyEntities();
    }

    /**
     * Updates the player's view of nearby entities and notifies other players
     * of this player's state changes.
     *
     * This method is the core of the visibility system. On each tick, it:
     * 1.  Calculates the new set of entities that are within the player's `VIEW_DISTANCE`.
     * 2.  Compares the new set with the set from the previous tick to determine which entities have entered or left the player's view.
     * 3.  Sends `create` and `remove` commands to the player's client to synchronize their view.
     * 4.  Notifies other nearby players when this player enters or leaves their view, or moves within it.
     * 5.  Updates the internal sets (`nearbyPlayers`, `nearbyNpcs`, etc.) for the next tick's comparison.
     */
    private void updateNearbyEntities() {
        if (!isMoving()) {
            return;
        }

        var mapId = getMap().getId();
        final int renderDistance = kalaazuConfig.getGame().getRenderDistance();
        final long renderDistanceSq = (long) renderDistance * renderDistance;
        info("Updating nearby entities for player {} at {}. Render distance: {}", getId(), getPosition(), renderDistance);

        // Entities that are now in range
        var allPlayersOnMap = mapService.getPlayers(mapId);
        var newNearbyPlayers = new HashSet<Player>();
        allPlayersOnMap.forEach((k, v) -> {
            if (v.getId() == getId()) {
                return;
            }

            if (v.getPosition().dst2(this.getPosition()) <= renderDistanceSq) {
                newNearbyPlayers.add(v);
            }
        });

        var allNpcsOnMap = mapService.getNpcs(mapId);
        var newNearbyNpcs = allNpcsOnMap.stream()
                .filter(n -> n.getPosition().dst2(this.getPosition()) <= renderDistanceSq)
                .collect(Collectors.toSet());

        var allCollectablesOnMap = mapService.getCollectables(mapId);
        var newNearbyCollectables = allCollectablesOnMap.stream()
                .filter(c -> c.getPosition().dst2(this.getPosition()) <= renderDistanceSq)
                .collect(Collectors.toSet());

        info(
                "Entities on map (Total/Nearby): Players ({}/{}), NPCs ({}/{}), Collectables ({}/{})",
                allPlayersOnMap.size(), newNearbyPlayers.size(),
                allNpcsOnMap.size(), newNearbyNpcs.size(),
                allCollectablesOnMap.size(), newNearbyCollectables.size()
        );

        //region Update my client
        var commands = new ArrayList<OutCommand>();

        // --- Player Visibility ---
        var playersInView = new HashSet<>(newNearbyPlayers);
        playersInView.removeAll(this.nearbyPlayers); // Keep only the ones that are new
        if (!playersInView.isEmpty()) {
            info("Players entered view: {}", playersInView.stream().map(Player::getId).toList());
            playersInView.forEach(p -> commands.add(p.getEntityCreationCommand()));

            // If I'm moving, tell the new players about it.
            if (isMoving()) {
                var sessions = playersInView.stream().map(Player::getGameSession).collect(Collectors.toList());
                ctx.publishEvent(new SendCommandToSessions(sessions, this.getMovementCommand()));
            }
        }

        var playersOutOfView = new HashSet<>(this.nearbyPlayers);
        playersOutOfView.removeAll(newNearbyPlayers); // Keep only the ones that are no longer nearby
        if (!playersOutOfView.isEmpty()) {
            info("Players left view: {}", playersOutOfView.stream().map(Player::getId).toList());
            playersOutOfView.forEach(p -> commands.add(p.getEntityRemoveCommand()));
        }

        // --- NPC Visibility ---
        var npcsInView = new HashSet<>(newNearbyNpcs);
        npcsInView.removeAll(this.nearbyNpcs);
        if (!npcsInView.isEmpty()) {
            info("NPCs entered view: {}", npcsInView.stream().map(Npc::getId).toList());
            npcsInView.forEach(n -> commands.add(n.getEntityCreationCommand()));
        }

        var npcsOutOfView = new HashSet<>(this.nearbyNpcs);
        npcsOutOfView.removeAll(newNearbyNpcs);
        if (!npcsOutOfView.isEmpty()) {
            info("NPCs left view: {}", npcsOutOfView.stream().map(Npc::getId).toList());
            npcsOutOfView.forEach(n -> commands.add(n.getEntityRemoveCommand()));
        }

        // --- Collectable Visibility ---
        var collectablesInView = new HashSet<>(newNearbyCollectables);
        collectablesInView.removeAll(this.nearbyCollectables);
        if (!collectablesInView.isEmpty()) {
            info("Collectables entered view: {}", collectablesInView.stream().map(Collectable::getId).toList());
            collectablesInView.forEach(c -> commands.add(c.getEntityCreationCommand()));
        }

        var collectablesOutOfView = new HashSet<>(this.nearbyCollectables);
        collectablesOutOfView.removeAll(newNearbyCollectables);
        if (!collectablesOutOfView.isEmpty()) {
            info("Collectables left view: {}", collectablesOutOfView.stream().map(Collectable::getId).toList());
            collectablesOutOfView.forEach(c -> commands.add(c.getEntityRemoveCommand()));
        }
 
        if (!commands.isEmpty()) {
            info("Sending {} visibility commands to client.", commands.size());
            ctx.publishEvent(new SendCommands(getGameSession(), commands));
        }
        //endregion

        //region Update other clients
        // I entered their view
        if (!playersInView.isEmpty()) {
            var sessions = playersInView.stream().map(Player::getGameSession).collect(Collectors.toList());
            ctx.publishEvent(new SendCommandToSessions(sessions, this.getEntityCreationCommand()));
        }

        // I left their view
        if (!playersOutOfView.isEmpty()) {
            var sessions = playersOutOfView.stream().map(Player::getGameSession).collect(Collectors.toList());
            ctx.publishEvent(new SendCommandToSessions(sessions, this.getEntityRemoveCommand()));
        }
        //endregion

        this.nearbyPlayers = newNearbyPlayers;
        this.nearbyNpcs = newNearbyNpcs;
        this.nearbyCollectables = newNearbyCollectables;
    }
}

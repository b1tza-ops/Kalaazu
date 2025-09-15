package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.SpacemapLoaded;
import com.kalaazu.server.service.MapService;
import lombok.Data;
import org.springframework.stereotype.Component;

/**
 * Spacemap Loaded Handler.
 * ======================
 *
 * Handles the notification from the client that it has finished loading all
 * necessary assets for the spacemap.
 *
 * This is a crucial synchronization point. Once the client signals it is ready,
 * this handler triggers the server-side process of spawning the player's ship
 * on the map and sending them the initial state of the game world.
 */
@Component("v4SpacemapLoadedHandler")
@Data
public class SpacemapLoadedHandler extends Handler<SpacemapLoaded> {
    private final Class<SpacemapLoaded> clazz = SpacemapLoaded.class;
    private final Version version = Version.V4;
    private final String id = SpacemapLoaded.ID;

    private final MapService service;

    /**
     * Executes the logic when the client signals it's ready.
     *
     * It calls `mapService.initializePlayer(session)`, which is the main entry
     * point for placing a player into the game world and sending them the
     * initial entity data.
     *
     * @param packet  The deserialized `SpacemapLoaded` command (which contains no data).
     * @param session The `GameSession` of the player whose client is ready.
     */
    @Override
    public void handle(SpacemapLoaded packet, GameSession session) {
        service.initializePlayer(session);
    }

    /**
     * Determines if this handler is responsible for processing the incoming raw packet.
     *
     * @param packet The raw incoming packet.
     *
     * @return `true` if the packet's ID matches this handler's ID, `false` otherwise.
     */
    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

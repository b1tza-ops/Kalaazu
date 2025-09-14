package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.SpacemapLoaded;
import com.kalaazu.server.service.MapService;
import lombok.Data;
import org.springframework.stereotype.Component;

@Component("v4SpacemapLoadedHandler")
@Data
public class SpacemapLoadedHandler extends Handler<SpacemapLoaded> {
    private final Class<SpacemapLoaded> clazz = SpacemapLoaded.class;
    private final Version version = Version.V4;
    private final String id = SpacemapLoaded.ID;

    private final MapService service;

    @Override
    public void handle(SpacemapLoaded packet, GameSession session) {
        service.initializePlayer(session);
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

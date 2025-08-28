package com.kalaazu.server.game.v4.handler;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.Version;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.LoginRequest;
import com.kalaazu.server.service.SessionInitializationService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component("v4LoginRequestHandler")
@Data
@Slf4j
public class LoginRequestHandler extends Handler<LoginRequest> {
    private final Class<LoginRequest> clazz = LoginRequest.class;
    private final Version version = Version.V4;
    private final String id = LoginRequest.ID;

    private final SessionInitializationService service;

    @Override
    public void handle(LoginRequest packet, GameSession session) {
        service.initialize(packet.getUserId(), packet.getSessionId(), session);
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

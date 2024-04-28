package com.kalaazu.server.game.v10.handler;

import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.LoginRequest;
import com.kalaazu.server.service.SessionInitializationService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * Login request handler.
 * ======================
 * <p>
 * Handles an incoming login request packet.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class LoginRequestHandler extends Handler<LoginRequest> {
    @Getter
    private final short id = LoginRequest.ID;

    @Getter
    private final Class<LoginRequest> clazz = LoginRequest.class;

    private final SessionInitializationService service;

    @Override
    public void handle(LoginRequest packet, GameSession session) {
        service.initialize(packet.getUserId(), packet.getSessionId(), session);
    }
}

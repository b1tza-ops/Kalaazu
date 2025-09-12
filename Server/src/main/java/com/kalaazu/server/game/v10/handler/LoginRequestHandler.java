package com.kalaazu.server.game.v10.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.LoginRequest;
import com.kalaazu.server.service.SessionInitializationService;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Data;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Login request handler.
 * ======================
 * <p>
 * Handles an incoming login request packet.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component("v10LoginRequestHandler")
@RequiredArgsConstructor
@Data
public class LoginRequestHandler extends Handler<LoginRequest> implements Logger {
    private final short id = LoginRequest.ID;
    private final Version version = Version.V10;
    private final Class<LoginRequest> clazz = LoginRequest.class;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    private final SessionInitializationService service;

    @Override
    public void handle(LoginRequest packet, GameSession session) {
        service.initialize(packet.getUserId(), packet.getSessionId(), session);
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

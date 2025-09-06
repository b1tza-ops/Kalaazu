package com.kalaazu.server.game.v10.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.event.InitializeSessionEvent;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.LoginRequest;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
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
@Slf4j
@RequiredArgsConstructor
@Data
public class LoginRequestHandler extends Handler<LoginRequest> {
    private final short id = LoginRequest.ID;
    private final Version version = Version.V10;
    private final Class<LoginRequest> clazz = LoginRequest.class;

    private final ApplicationContext ctx;

    @Override
    public void handle(LoginRequest packet, GameSession session) {
        ctx.publishEvent(new InitializeSessionEvent(packet.getUserId(), packet.getSessionId(), session, this));
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.event.InitializeSessionEvent;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.commands.in.LoginRequest;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

@Component("v4LoginRequestHandler")
@Data
@Slf4j
public class LoginRequestHandler extends Handler<LoginRequest> {
    private final Class<LoginRequest> clazz = LoginRequest.class;
    private final Version version = Version.V4;
    private final String id = LoginRequest.ID;

    private final ApplicationContext ctx;

    @Override
    public void handle(LoginRequest packet, GameSession session) {
        ctx.publishEvent(new InitializeSessionEvent(packet.getUserId(), packet.getSessionId(), session, this));
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

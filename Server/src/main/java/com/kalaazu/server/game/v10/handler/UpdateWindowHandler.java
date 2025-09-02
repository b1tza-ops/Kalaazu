package com.kalaazu.server.game.v10.handler;

import com.kalaazu.server.game.Packet;
import com.kalaazu.model.Version;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v10.commands.in.UpdateWindow;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component("v10UpdateWindowHandler")
@Slf4j
@RequiredArgsConstructor
@Data
public class UpdateWindowHandler extends Handler<UpdateWindow> {
    private final Version version = Version.V10;
    private final short id = UpdateWindow.ID;
    private final Class<UpdateWindow> clazz = UpdateWindow.class;

    @Override
    public void handle(UpdateWindow packet, GameSession session) {
        log.info("Update window request received: {}", packet);
        // TODO Save window settings
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readShort() == this.getId();
    }
}

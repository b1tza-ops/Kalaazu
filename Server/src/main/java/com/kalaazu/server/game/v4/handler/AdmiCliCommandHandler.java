package com.kalaazu.server.game.v4.handler;

import com.kalaazu.model.Version;
import com.kalaazu.server.event.SendCommand;
import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.server.game.util.Handler;
import com.kalaazu.server.game.v4.OutCommand;
import com.kalaazu.server.game.v4.commands.in.AdminCliCommand;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

@Component("v4AdminCliCommandHandler")
@Slf4j
@Data
public class AdmiCliCommandHandler extends Handler<AdminCliCommand> {
    private final Class<AdminCliCommand> clazz = AdminCliCommand.class;
    private final Version version = Version.V4;
    private final String id = AdminCliCommand.ID;

    private final ApplicationContext ctx;

    @Override
    public void handle(AdminCliCommand packet, GameSession session) {
        switch(packet.getAction()) {
            case RESEND_PACKET -> ctx.publishEvent(new SendCommand(session, new OutCommand() {
                @Override
                public void write(Packet p) {
                    var bytes = packet.getPacket().getBytes();
                    var str = new String(bytes);

                    var args = str.split("\\|");
                    for (int i = 2; i < args.length; i++) {
                        p.writeString(args[i]);
                    }

                    log.info("Resending packet {}", p);
                }
            }));
        }
    }

    @Override
    public boolean canHandle(Packet packet) {
        return packet.readString().equals(this.getId());
    }
}

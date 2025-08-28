package com.kalaazu.server.game.v4.commands.in;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v4.InCommand;
import lombok.Data;

@Data
public class LoginRequest extends InCommand {
    public static final String ID = "LOGIN";

    private long userId;
    private String sessionId;
    private String version;

    @Override
    public void read(Packet packet) {
        this.userId = packet.readLong();
        this.sessionId = packet.readString();
        this.version = packet.readString();
    }
}

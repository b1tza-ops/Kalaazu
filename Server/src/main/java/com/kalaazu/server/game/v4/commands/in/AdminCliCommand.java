package com.kalaazu.server.game.v4.commands.in;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v4.InCommand;
import lombok.Data;

@Data
public class AdminCliCommand extends InCommand {
    public static final String ID = "admin";

    public enum Action {
        RESEND_PACKET
    }

    private Packet packet;
    private Action action;

    @Override
    public void read(Packet packet) {
        this.action = Action.values()[packet.readInt()];
        this.packet = packet;
    }
}

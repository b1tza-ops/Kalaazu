package com.kalaazu.server.game.v4.commands.out.attributes;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public abstract class SetAttributeCommand extends OutCommand {
    private final static String id = ServerCommands.SET_ATTRIBUTE;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeString(this.getAttribute());
        this.subWrite(packet);
    }

    public abstract void subWrite(Packet packet);
    public abstract String getAttribute();
}

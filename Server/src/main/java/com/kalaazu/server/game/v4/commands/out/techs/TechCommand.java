package com.kalaazu.server.game.v4.commands.out.techs;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public abstract class TechCommand extends OutCommand {
    private final String id = ServerCommands.TECHS;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeString(this.getAction());
    }

    public abstract void subWrite(Packet packet);

    public abstract String getAction();
}

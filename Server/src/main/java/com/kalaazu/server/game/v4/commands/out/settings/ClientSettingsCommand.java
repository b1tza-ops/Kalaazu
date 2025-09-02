package com.kalaazu.server.game.v4.commands.out.settings;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ClientSettingsCommand extends OutCommand {
    private final String id = ServerCommands.CLIENT_SETTING;
    private final String setting;
    private final Object value;

    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeString(this.getSetting());
        packet.writeString(this.getValue().toString());
    }
}

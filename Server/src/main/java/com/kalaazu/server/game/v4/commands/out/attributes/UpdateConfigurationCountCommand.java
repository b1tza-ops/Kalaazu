package com.kalaazu.server.game.v4.commands.out.attributes;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UpdateConfigurationCountCommand extends SetAttributeCommand {
    private final String attribute = ServerCommands.UPDATE_CONFIGURATION_COUNT;

    private final int configuration;

    @Override
    public void subWrite(Packet packet) {
        packet.writeInt(configuration);
    }
}

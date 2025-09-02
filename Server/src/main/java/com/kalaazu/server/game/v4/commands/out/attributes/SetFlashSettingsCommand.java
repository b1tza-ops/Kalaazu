package com.kalaazu.server.game.v4.commands.out.attributes;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SetFlashSettingsCommand extends SetAttributeCommand {
    private final String attribute = ServerCommands.SET_FLASH_SETTINGS;

    private final boolean autoBoost;
    private final boolean displayPlayerNames;
    private final boolean displayResources;
    private final boolean displayBonusBoxes;
    private final boolean playSound;
    private final boolean playMusic;
    private final boolean displayHitpointBubbles;
    private final int selectedLaser;
    private final int selectedRocket;
    private final boolean displayChat;
    private final boolean displayFreeCargoBoxes;
    private final boolean displayNotFreeCargoBoxes;
    private final boolean autoChangeAmmo;

    @Override
    public void subWrite(Packet packet) {
        packet.writeBoolean(autoBoost);
        packet.writeBoolean(false);
        packet.writeBoolean(false);
        packet.writeBoolean(false);
        packet.writeBoolean(displayPlayerNames);
        packet.writeBoolean(false);
        packet.writeBoolean(false);
        packet.writeBoolean(displayResources);
        packet.writeBoolean(displayBonusBoxes);
        packet.writeBoolean(false);
        packet.writeBoolean(false);
        packet.writeBoolean(playSound);
        packet.writeBoolean(playMusic);
        packet.writeBoolean(false);
        packet.writeBoolean(displayHitpointBubbles);
        packet.writeInt(selectedLaser);
        packet.writeInt(selectedRocket);
        packet.writeBoolean(false);
        packet.writeBoolean(displayChat);
        packet.writeBoolean(false);
        packet.writeBoolean(false);
        packet.writeBoolean(displayFreeCargoBoxes);
        packet.writeBoolean(displayNotFreeCargoBoxes);
        packet.writeBoolean(autoChangeAmmo);
    }
}

package com.kalaazu.server.game.v4.commands.out.settings;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class GameplaySettingsCommand extends OutCommand {
    private final static String id = ServerCommands.SET_ATTRIBUTE;

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

    /*
         Settings.autoBoost = Boolean(int(param1[0]));
         Settings.displayPlayerNames = Boolean(int(param1[4]));
         Settings.displayResources = Boolean(int(param1[7]));
         Settings.displayBonusBoxes = Boolean(int(param1[8]));
         Settings.displayHitpointBubbles = Boolean(int(param1[14]));
         Settings.playSFX = Boolean(int(param1[11]));
         Settings.playMusic = Boolean(int(param1[12]));
         Settings.selectedLaser = int(param1[15]);
         Settings.selectedRocket = int(param1[16]);
         Settings.displayChat = Boolean(int(param1[18]));
         Settings.displayFreeCargoBoxes = Boolean(int(param1[21]));
         Settings.displayNotFreeCargoBoxes = Boolean(int(param1[22]));
         Settings.autochangeAmmo = Boolean(int(param1[23]));
     */
    @Override
    public void write(Packet packet) {
        packet.writeString(id);
        packet.writeString(ServerCommands.SET);
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

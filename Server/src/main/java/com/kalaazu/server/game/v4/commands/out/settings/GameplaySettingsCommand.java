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

    private final boolean notSet;
    private final boolean autoRefinement;
    private final boolean quickSlotStopAttack;
    private final boolean autoBoost;
    private final boolean autoBuyBootyKeys;
    private final boolean doubleClickAttackEnabled;
    private final boolean autoChangeAmmo;
    private final boolean autoStartEnabled;
    private final boolean showBattlerayNotifications;
    private final boolean showLowHpWarn;

    @Override
    public void write(Packet packet) {
    }
}

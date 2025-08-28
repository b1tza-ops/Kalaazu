package com.kalaazu.server.game.v10.commands.out.settings;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.v10.commands.OutCommand;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class UpdateGameplaySettingsCommand extends OutCommand {
    private final short id = 20988;

    private boolean notSet;
    private boolean autoRefinement;
    private boolean quickSlotStopAttack;
    private boolean autoBoost;
    private boolean autoBuyBootyKeys;
    private boolean doubleClickAttackEnabled;
    private boolean autoChangeAmmo;
    private boolean autoStartEnabled;
    private boolean showBattlerayNotifications;
    private boolean showLowHpWarn;

    public void write(Packet packet) {
        packet.writeShort(id);

        packet.writeBoolean(notSet);
        packet.writeBoolean(autoRefinement);
        packet.writeBoolean(autoChangeAmmo);
        packet.writeBoolean(showLowHpWarn);
        packet.writeBoolean(autoBuyBootyKeys);
        packet.writeBoolean(autoStartEnabled);
        packet.writeBoolean(quickSlotStopAttack);
        packet.writeBoolean(showBattlerayNotifications);
        packet.writeBoolean(doubleClickAttackEnabled);
        packet.writeShort(0);
        packet.writeBoolean(autoBoost);
    }
}

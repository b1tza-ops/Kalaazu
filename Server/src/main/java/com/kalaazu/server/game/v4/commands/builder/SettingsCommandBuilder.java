package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.persistence.entity.AccountsSettingsEntity;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v4.commands.out.attributes.SetFlashSettingsCommand;
import com.kalaazu.server.game.v4.commands.out.settings.ClientSettingsCommand;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;

/**
 * Settings command builder.
 * =========================
 * <p>
 * Command builder for all the settings command.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@RequiredArgsConstructor
@Component("v4SettingsCommandBuilder")
public class SettingsCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.SettingsCommand;

    /**
     * Builds the necessary commands for the given arguments.
     * <p>
     * Since there's no way to ensure type safety on the arguments
     * be careful of how you use it.
     *
     * @param arguments Command arguments.
     * @return Command for the given arguments.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<OutCommand> build(Object[] arguments) {
        var settings = ((Collection<AccountsSettingsEntity>) arguments[0])
                .stream()
                .filter(s -> gameVersion.name().equalsIgnoreCase(s.getVersion()))
                .findFirst()
                .orElseThrow();

        return List.of(
                new SetFlashSettingsCommand(
                        settings.isAutoBoost(),
                        settings.isDisplayPlayerNames(),
                        settings.isDisplayResources(),
                        settings.isDisplayBonusBoxes(),
                        settings.getSound() > 0,
                        settings.getMusic() > 0,
                        settings.isDisplayHitpointBubbles(),
                        settings.getSelectedBattery(),
                        settings.getSelectedRocket(),
                        settings.isDisplayChat(),
                        settings.isDisplayFreeCargoBoxes(),
                        settings.isDisplayNotFreeCargoBoxes(),
                        settings.isAutoChangeAmmo()
                ),

                // in order, all settings from the SettingsAssembly, commented ones are already configured through SetFlashSettings
                new ClientSettingsCommand(ServerCommands.WINDOW_SETTINGS + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getWindowSettings()),
                new ClientSettingsCommand(ServerCommands.SET_SLOTMENU_POSITION + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getSlotMenuPosition()),
                new ClientSettingsCommand(ServerCommands.SET_MAINMENU_POSITION + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getMainMenuPosition()),
                new ClientSettingsCommand(ServerCommands.SET_SLOTMENU_ORDER + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getSlotMenuOrder()),
                new ClientSettingsCommand(ServerCommands.SET_RESIZABLE_WINDOWS + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getWindowSettings()),
                new ClientSettingsCommand(ServerCommands.SET_MINIMAP_SCALE + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), String.valueOf(settings.getMinimapScale())),
                new ClientSettingsCommand(ServerCommands.SET_BAR_STATUS, settings.getBarState()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_HITPOINT_BUBBLES, settings.isDisplayHitpointBubbles()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_PLAYER_NAMES, settings.isDisplayPlayerNames()),
                //new ClientSettingsCommand(ServerCommands.SET_PLAY_SFX, settings.getSound() > 0),
                //new ClientSettingsCommand(ServerCommands.SET_PLAY_MUSIC, settings.getMusic() > 0),
                new ClientSettingsCommand(ServerCommands.SET_DOUBLECLICK_ATTACK, settings.isDoubleClickAttackEnabled()),
                new ClientSettingsCommand(ServerCommands.SET_QUICKSLOT_STOP_ATTACK, settings.isQuickSlotStopAttack()),
                new ClientSettingsCommand(ServerCommands.SET_QUICKBAR_SLOT, settings.getQuickbarSlot()),
                new ClientSettingsCommand(ServerCommands.SET_SHOW_DRONES, settings.isDisplayDrones()),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_NOTIFICATIONS, settings.isDisplayNotifications()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_CHAT, settings.isDisplayChat()),
                new ClientSettingsCommand(ServerCommands.SET_AUTO_REFINEMENT, settings.isAutoRefinement()),
                //new ClientSettingsCommand(ServerCommands.SET_AUTO_BOOST, settings.isAutoBoost()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_ORE, settings.isDisplayResources()),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_BONUS_BOXES, settings.isDisplayBonusBoxes()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_FREE_CARGO_BOXES, settings.isDisplayFreeCargoBoxes()),
                //new ClientSettingsCommand(ServerCommands.SET_DISPLAY_NOT_FREE_CARGO_BOXES, settings.isDisplayNotFreeCargoBoxes()),
                //new ClientSettingsCommand(ServerCommands.SET_AUTO_AMMO_CHANGE, settings.isAutoChangeAmmo()),
                new ClientSettingsCommand(ServerCommands.SET_AUTO_START, settings.isAutoStartEnabled()),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND, settings.isDisplayWindowsBackground()),
                new ClientSettingsCommand(ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS, settings.isDragWindowsAlways()),
                new ClientSettingsCommand(ServerCommands.SET_PRELOAD_USER_SHIPS, settings.isPreloadUserShips()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_PRESETTING, settings.getQualityPresetting()),
                new ClientSettingsCommand(ServerCommands.SET_RESOLUTION, settings.getResolutionId()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_PRESETTING, settings.getQualityPresetting()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_CUSTOMIZED, settings.isQualityCustomized()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_BACKGROUND, settings.getQualityBackground()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_POIZONE, settings.getQualityPOIzone()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_SHIP, settings.getQualityShip()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_ENGINE, settings.getQualityEngine()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_COLLECTABLE, settings.getQualityCollectables()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_ATTACK, settings.getQualityAttack()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_EFFECT, settings.getQualityEffect()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_EXPLOSION, settings.getQualityExplosion())
                //new ClientSettingsCommand(ServerCommands.SET_SELECTED_BATTERY, settings.getSelectedBattery()),
                //new ClientSettingsCommand(ServerCommands.SET_SELECTED_ROCKET, settings.getSelectedRocket()),
        );
    }
}

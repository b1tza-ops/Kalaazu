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
                        1, // TODO selected laser
                        1, // TODO selected rocket
                        settings.isDisplayChat(),
                        settings.isDisplayFreeCargoBoxes(),
                        settings.isDisplayNotFreeCargoBoxes(),
                        settings.isAutoChangeAmmo()
                ),
                new ClientSettingsCommand(ServerCommands.SET_MINIMAP_SCALE + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), String.valueOf(settings.getMinimapScale())),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_PLAYER_NAMES, settings.isDisplayPlayerNames() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_CHAT, settings.isDisplayChat() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_PLAY_MUSIC, settings.getMusic() > 0 ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_PLAY_SFX, settings.getSound() > 0 ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_BAR_STATUS, settings.getBarState()),
                new ClientSettingsCommand(ServerCommands.WINDOW_SETTINGS + ServerCommands.SETTING_KEY_SEPERATOR + settings.getResolutionId(), settings.getWindowSettings()),
                new ClientSettingsCommand(ServerCommands.SET_AUTO_REFINEMENT, settings.isAutoRefinement() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_QUICKSLOT_STOP_ATTACK, settings.isQuickSlotStopAttack() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_DOUBLECLICK_ATTACK, settings.isDoubleClickAttackEnabled() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_AUTO_START, settings.isAutoStartEnabled() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_NOTIFICATIONS, settings.isDisplayNotifications() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_SHOW_DRONES, settings.isDisplayDrones() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND, settings.isDisplayWindowsBackground() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS, settings.isDragWindowsAlways() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_PRELOAD_USER_SHIPS, settings.isPreloadUserShips() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_PRESETTING, settings.getQualityPresetting()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_CUSTOMIZED, settings.isQualityCustomized() ? 1 : 0),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_BACKGROUND, settings.getQualityBackground()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_POIZONE, settings.getQualityPOIzone()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_SHIP, settings.getQualityShip()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_ENGINE, settings.getQualityEngine()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_COLLECTABLE, settings.getQualityCollectables()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_ATTACK, settings.getQualityAttack()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_EFFECT, settings.getQualityEffect()),
                new ClientSettingsCommand(ServerCommands.SET_QUALITY_EXPLOSION, settings.getQualityExplosion()),
                new ClientSettingsCommand(ServerCommands.SET_QUICKBAR_SLOT, settings.getQuickbarSlot()),
                new ClientSettingsCommand(ServerCommands.SET_MAINMENU_POSITION, settings.getMainMenuPosition()),
                new ClientSettingsCommand(ServerCommands.SET_SLOTMENU_POSITION, settings.getSlotMenuPosition()),
                new ClientSettingsCommand(ServerCommands.SET_SLOTMENU_ORDER, settings.getSlotMenuOrder())
        );
    }
}

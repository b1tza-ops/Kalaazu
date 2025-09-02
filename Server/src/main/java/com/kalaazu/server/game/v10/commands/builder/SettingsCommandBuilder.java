package com.kalaazu.server.game.v10.commands.builder;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kalaazu.model.Version;
import com.kalaazu.persistence.entity.AccountsSettingsEntity;
import com.kalaazu.persistence.entity.ItemCategory;
import com.kalaazu.persistence.entity.ItemType;
import com.kalaazu.persistence.entity.ItemsEntity;
import com.kalaazu.persistence.service.ItemsService;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v10.commands.out.settings.*;
import com.kalaazu.server.game.v10.commands.out.ui.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.*;

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
@Component
public class SettingsCommandBuilder implements CommandBuilderInterface {
    public static final boolean hideAllWindows = false;
    public static final int scale = 6;
    public static final String barState = "24,1|23,1|100,1|25,1|35,0|34,0|39,0|";
    public static final String gameFeatureBarPosition = "0,0";
    public static final String gameFeatureBarLayoutType = "0";
    public static final String genericFeatureBarPosition = "98.3,0";
    public static final String genericFeatureBarLayoutType = "0";
    public static final String categoryBarPosition = "50,85";
    public static final String standartSlotBarPosition = "50,85|0,40";
    public static final String standartSlotBarLayoutType = "0";
    public static final String premiumSlotBarPosition = "50,85|0,80";
    public static final String premiumSlotBarLayoutType = "0";
    public static final String proActionBarPosition = "50,85|0,120";
    public static final String proActionBarLayoutType = "0";

    public static final String STANDARD_SLOT_BAR = "standardSlotBar";
    public static final String PREMIUM_SLOT_BAR = "premiumSlotBar";
    public static final String PRO_ACTION_BAR = "proActionBar";

    private final Version gameVersion = Version.V10;
    private final CommandType commandType = CommandType.SettingsCommand;
    private final ObjectMapper mapper;
    private final ItemsService items;

    private static ClientUiTooltipCommand buildTooltip(short formatType, String tooltip, String replacementValue, String replacementWildcard) {
        var textReplacements = new ArrayList<ClientUiTextReplacementCommand>();

        var format = new ClientUiTooltipTextFormatCommand(formatType);

        if (replacementWildcard != null && replacementValue != null) {
            var typeReplacement = new ClientUiTextReplacementCommand(replacementValue, replacementWildcard, format);
            textReplacements.add(typeReplacement);
        }

        var formatLocalized = new ClientUiTooltipTextFormatCommand(ClientUiTooltipTextFormatCommand.LOCALIZED);

        return new ClientUiTooltipCommand(ClientUiTooltipCommand.STANDARD, formatLocalized, textReplacements, tooltip);
    }

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

        var cmds = new ArrayList<OutCommand>();
        cmds.add(buildKeybindingSettings(settings.getKeybindings()));
        cmds.add(buildUserSettings(settings));
        cmds.add(buildMenuBar());

        return cmds;
    }

    private UpdateUserKeybindingsCommand buildKeybindingSettings(List<AccountsSettingsEntity.Keybinding> keybindings) {
        var commands = keybindings.stream()
                .map(k -> {
                    var cmd = new KeybindingCommand();
                    cmd.setActionType(k.getActionType());
                    cmd.setParameter(k.getParameter());
                    cmd.setCharCode(k.getCharCode());
                    cmd.setKeys(k.getKeys());

                    return cmd;
                })
                .toList();

        return new UpdateUserKeybindingsCommand(false, commands);
    }

    private UpdateUserSettingsCommand buildUserSettings(AccountsSettingsEntity settings) {
        var qualitySettings = new UpdateQualitySettingsCommand(
                settings.isQualityNotSet(),
                settings.getQualityAttack(),
                settings.getQualityBackground(),
                settings.getQualityPresetting(),
                settings.isQualityCustomized(),
                settings.getQualityPOIzone(),
                settings.getQualityShip(),
                settings.getQualityEngine(),
                settings.getQualityExplosion(),
                settings.getQualityCollectables(),
                settings.getQualityEffect()
        );

        var questsSettings = new UpdateQuestsSettingsCommand(
                settings.isQuestsLevelOrderDescending(),
                settings.isQuestsAvailableFilter(),
                settings.isQuestsUnavailableFilter(),
                settings.isQuestsCompletedFilter()
        );

        var displaySettings = new UpdateDisplaySettingsCommand(
                settings.isDisplayNotSet(),
                settings.isDisplayPlayerNames(),
                settings.isDisplayResources(),
                settings.isShowPremiumQuickslotBar(),
                settings.isAllowAutoQuality(),
                settings.isPreloadUserShips(),
                settings.isDisplayHitpointBubbles(),
                settings.isShowNotOwnedItems(),
                settings.isDisplayChat(),
                settings.isDisplayWindowsBackground(),
                settings.isDisplayNotFreeCargoBoxes(),
                settings.isDragWindowsAlways(),
                settings.isDisplayNotifications(),
                settings.isHoverShips(),
                settings.isDisplayDrones(),
                settings.isDisplayBonusBoxes(),
                settings.isDisplayFreeCargoBoxes(),
                settings.isShowMinimapBackground(),
                settings.isForce2D(),
                settings.getDisplaySetting3DqualityAntialias(),
                settings.getQualityBackground(),
                settings.getDisplaySetting3DqualityEffects(),
                settings.getDisplaySetting3DqualityLights(),
                settings.getDisplaySetting3DqualityTextures(),
                settings.getQualityPOIzone(),
                settings.getDisplaySetting3DsizeTextures(),
                settings.getDisplaySetting3DtextureFiltering(),
                settings.isProActionBarEnabled(),
                settings.isProActionBarKeyboardInputEnabled(),
                settings.isProActionBarAutohideEnabled()
        );

        var windowSettings = new UpdateWindowSettingsCommand(
                settings.isHideAllWindows(),
                settings.getScale(),
                settings.getBarState()
        );

        var gameplaySettings = new UpdateGameplaySettingsCommand(
                settings.isGameplayNotSet(),
                settings.isAutoRefinement(),
                settings.isQuickSlotStopAttack(),
                settings.isAutoBoost(),
                settings.isAutoBuyBootyKeys(),
                settings.isDoubleClickAttackEnabled(),
                settings.isAutoChangeAmmo(),
                settings.isAutoStartEnabled(),
                settings.isShowBattlerayNotifications(),
                settings.isShowLowHpWarn()
        );

        var audioSettings = new UpdateAudioSettingsCommand(
                settings.isAudioNotSet(),
                settings.isPlayCombatMusic(),
                settings.getVoice(),
                settings.getSound(),
                settings.getMusic()
        );

        return new UpdateUserSettingsCommand(
                qualitySettings,
                questsSettings,
                displaySettings,
                windowSettings,
                gameplaySettings,
                audioSettings
        );
    }

    private MenuBarCommand buildMenuBar() {
        var menuBarCommands = new ArrayList<ClientUiMenuBarCommand>();
        var defaultWindows = this.getWindows();
        var defaultWindow = this.getDefaultWindow();

        var leftItems = new HashMap<String, String>();
        var rightItems = new HashMap<String, String>();

        leftItems.put("user", "title_user");
        leftItems.put("ship", "title_ship");
        leftItems.put("ship_warp", "ttip_shipWarp_btn");
        leftItems.put("chat", "title_chat");
        leftItems.put("group", "title_group");
        leftItems.put("minimap", "title_map");
        leftItems.put("spacemap", "title_spacemap");
        leftItems.put("log", "title_log");
        leftItems.put("pet", "title_pet");
        leftItems.put("spaceball", "title_spaceball");
        leftItems.put("booster", "title_booster");
        leftItems.put("traininggrounds", "title_traininggrounds");

        menuBarCommands.add(buildMenuBar(leftItems, defaultWindows, defaultWindow, true));

        rightItems.put("settings", "title_settings");
        rightItems.put("help", "title_help");
        rightItems.put("logout", "title_logout");
        rightItems.put("fullscreen", "ttip_fullscreen_btn");

        menuBarCommands.add(buildMenuBar(rightItems, defaultWindows, defaultWindow, false));

        return new MenuBarCommand(menuBarCommands);
    }

    private SlotBarsCommand buildSlotBar(HashMap<String, List<ClientUiSlotBarItemCommand>> slotbars) {
        var slotBars = new ArrayList<ClientUiSlotBarCommand>();

        slotBars.add(new ClientUiSlotBarCommand(
                standartSlotBarLayoutType,
                STANDARD_SLOT_BAR,
                standartSlotBarPosition,
                slotbars.getOrDefault(STANDARD_SLOT_BAR, new ArrayList<>()),
                true
        ));
        slotBars.add(new ClientUiSlotBarCommand(
                premiumSlotBarLayoutType,
                PREMIUM_SLOT_BAR,
                premiumSlotBarPosition,
                slotbars.getOrDefault(PREMIUM_SLOT_BAR, new ArrayList<>()),
                true
        ));
        slotBars.add(new ClientUiSlotBarCommand(
                proActionBarLayoutType,
                PRO_ACTION_BAR,
                proActionBarPosition,
                slotbars.getOrDefault(PRO_ACTION_BAR, new ArrayList<>()),
                true
        ));

        return new SlotBarsCommand(
                categoryBarPosition,
                slotBars,
                buildSlotBarCategories()
        );
    }

    private List<ClientUiSlotBarCategoryCommand> buildSlotBarCategories() {
        var categories = new ArrayList<ClientUiSlotBarCategoryCommand>();
        categories.add(buildCategory(ItemCategory.AMMUNITION, ItemType.LASER_AMMO, "lasers", "ttip_laser"));
        categories.add(buildCategory(ItemCategory.AMMUNITION, ItemType.ROCKET, "rockets", "ttip_rocket"));
        categories.add(buildCategory(ItemCategory.AMMUNITION, ItemType.HELLSTORM_ROCKET, "rocket_launchers", "ttip_rocket"));
        categories.add(buildCategory(ItemCategory.AMMUNITION, ItemType.SPECIAL_AMMO, "special_items", "ttip_explosive", false));
        categories.add(buildCategory(ItemCategory.AMMUNITION, ItemType.MINE, "mines", "ttip_explosive", false));
        categories.add(buildCategory(ItemCategory.EQUIPMENT, ItemType.EXTRA, "cpus", "ttip_cpu", false, false)); // TODO fix tooltips
        categories.add(buildCategory(ItemCategory.DRONES, ItemType.DRONE_FORMATION, "drone_formations", "ttip_btn_droneFormation_STD", false, false)); // TODO fix tooltips
        categories.add(buildBuyNowCategory());
        // TODO technofactory items
        // TODO Ship abilities

        return categories;
    }

    private ClientUiSlotBarCategoryCommand buildCategory(ItemCategory category, ItemType type, String tooltip, String tooltipId) {
        return buildCategory(category, type, tooltip, tooltipId, false);
    }

    private ClientUiSlotBarCategoryCommand buildCategory(ItemCategory category, ItemType type, String tooltip, String tooltipId, boolean doubleClick) {
        return buildCategory(category, type, tooltip, tooltipId, doubleClick, true);
    }

    private ClientUiSlotBarCategoryCommand buildCategory(ItemCategory category, ItemType type, String tooltip, String tooltipId, boolean doubleClick, boolean description) {
        var categoryItems = new ArrayList<ClientUiSlotBarCategoryItemCommand>();

        var items = this.items.findByCategoryAndType(category, type);
        items.stream()
                .sorted(Comparator.comparingInt(ItemsEntity::getSlotbarOrder))
                .forEach(l -> categoryItems.add(buildCategoryItem(l, tooltipId, description, doubleClick)));

        return new ClientUiSlotBarCategoryCommand(categoryItems, tooltip);
    }

    private ClientUiSlotBarCategoryCommand buildBuyNowCategory() {
        var categoryItems = new ArrayList<ClientUiSlotBarCategoryItemCommand>();

        this.items.findByCategoryAndType(ItemCategory.AMMUNITION, ItemType.LASER_AMMO)
                .stream()
                .sorted(Comparator.comparingInt(ItemsEntity::getSlotbarOrder))
                .forEach(l -> categoryItems.add(buildCategoryItem(l, "ttip_laser")));


        this.items.findByCategoryAndType(ItemCategory.AMMUNITION, ItemType.ROCKET)
                .stream()
                .sorted(Comparator.comparingInt(ItemsEntity::getSlotbarOrder))
                .forEach(l -> categoryItems.add(buildCategoryItem(l, "ttip_rocket")));


        this.items.findByCategoryAndType(ItemCategory.AMMUNITION, ItemType.HELLSTORM_ROCKET)
                .stream()
                .sorted(Comparator.comparingInt(ItemsEntity::getSlotbarOrder))
                .forEach(l -> categoryItems.add(buildCategoryItem(l, "ttip_rocket")));

        return new ClientUiSlotBarCategoryCommand(categoryItems, "buy_now");
    }

    private ClientUiSlotBarCategoryItemCommand buildCategoryItem(ItemsEntity l, String tooltipId) {
        return buildCategoryItem(l, tooltipId, true, false);
    }

    private ClientUiSlotBarCategoryItemCommand buildCategoryItem(ItemsEntity l, String tooltipId, boolean description, boolean doubleClickToFire) {
        var timer = new ClientUiSlotBarCategoryItemTimerCommand(
                new ClientUiSlotBarCategoryItemTimerStatusCommand(ClientUiSlotBarCategoryItemTimerStatusCommand.READY),
                l.getLootId(),
                false,
                0,
                l.getCooldown()
        );

        var itemBarStatusTooltip = new ClientUiTooltipsCommand(getStatusTooltip(l.getLootId(), tooltipId, description, doubleClickToFire, false, 0));
        var slotBarStatusTooltip = new ClientUiTooltipsCommand(getStatusTooltip(l.getLootId(), tooltipId, description, doubleClickToFire, false, 0));

        var status = new ClientUiSlotBarCategoryItemStatusCommand(
                true,
                0,
                false,
                false,
                0,
                false,
                l.getLootId(),
                true,
                true,
                ClientUiSlotBarCategoryItemStatusCommand.BLUE,
                l.getLootId(),
                itemBarStatusTooltip,
                slotBarStatusTooltip
        );

        return new ClientUiSlotBarCategoryItemCommand(
                ClientUiSlotBarCategoryItemCommand.NONE,
                timer,
                status,
                new CooldownTypeCommand((short) l.getCooldownType().ordinal()),
                ClientUiSlotBarCategoryItemCommand.SELECTION
        );
    }

    private List<ClientUiTooltipCommand> getStatusTooltip(String lootId, String tooltipId, boolean description, boolean doubleClickToFire, boolean countable, int count) {
        var tooltips = new ArrayList<ClientUiTooltipCommand>();

        tooltips.add(buildTooltip(ClientUiTooltipTextFormatCommand.const_2514, tooltipId, lootId, "%TYPE%"));

        if (countable) {
            tooltips.add(buildTooltip(ClientUiTooltipTextFormatCommand.PLAIN, "ttip_count", String.valueOf(count), "%COUNT%"));
        }

        if (description) {
            var replacement = new ArrayList<ClientUiTextReplacementCommand>();
            var format = new ClientUiTooltipTextFormatCommand(ClientUiTooltipTextFormatCommand.const_234);

            tooltips.add(new ClientUiTooltipCommand(ClientUiTooltipCommand.STANDARD, format, replacement, lootId));
        }

        if (doubleClickToFire) {
            tooltips.add(buildTooltip(ClientUiTooltipTextFormatCommand.LOCALIZED, "ttip_double_click_to_fire", null, null));
        }

        return tooltips;
    }

    private ClientUiMenuBarCommand buildMenuBar(HashMap<String, String> items, Map<String, Window> defaultWindows, Window defaultWindow, boolean isLeft) {
        var position = gameFeatureBarPosition;
        var type = ClientUiMenuBarCommand.GAME_FEATURE_BAR;
        if (!isLeft) {
            position = genericFeatureBarPosition;
            type = ClientUiMenuBarCommand.GENERIC_FEATURE_BAR;
        }

        var menuItems = new ArrayList<ClientUiMenuBarItemCommand>();

        items.forEach((k, v) -> {
            var tooltips = new ArrayList<ClientUiTooltipCommand>();
            tooltips.add(new ClientUiTooltipCommand(
                    ClientUiTooltipCommand.STANDARD,
                    new ClientUiTooltipTextFormatCommand(
                            ClientUiTooltipTextFormatCommand.LOCALIZED
                    ),
                    new ArrayList<>(),
                    v
            ));

            var tooltipsCommand = new ClientUiTooltipsCommand(tooltips);

            var window = defaultWindows.getOrDefault(k, defaultWindow);
            var item = new UpdateWindowItemCommand(
                    window.maximized(),
                    window.height(),
                    true,
                    window.y(),
                    window.x(),
                    tooltipsCommand,
                    v,
                    window.width(),
                    new ClientUiTooltipsCommand(new ArrayList<>()),
                    k
            );

            menuItems.add(item);
        });

        return new ClientUiMenuBarCommand(
                position,
                type,
                menuItems,
                gameFeatureBarLayoutType
        );
    }


    public Map<String, Window> getWindows() {
        var map = new HashMap<String, Window>();
        map.put("user", new Window(0, 97, 212, 88, true));
        map.put("ship", new Window(72, 97, 212, 88, true));
        map.put("ship_warp", new Window(50, 50, 300, 210, false));
        map.put("chat", new Window(0, 7, 370, 260, true));
        map.put("group", new Window(100, 30, 196, 200, true));
        map.put("minimap", new Window(100, 100, 238, 180, true));
        map.put("spacemap", new Window(10, 10, 650, 475, false));
        map.put("log", new Window(30, 30, 240, 150, false));
        map.put("pet", new Window(50, 50, 260, 130, false));
        map.put("spaceball", new Window(10, 10, 170, 70, false));
        map.put("booster", new Window(10, 10, 110, 150, false));
        map.put("traininggrounds", new Window(10, 10, 320, 320, false));
        map.put("settings", new Window(50, 50, 400, 470, false));
        map.put("help", new Window(10, 10, 219, 121, false));
        map.put("logout", new Window(50, 50, 200, 200, false));

        return map;
    }

    public Window getDefaultWindow() {
        return new Window(30, 30, 200, 100, false);
    }

    public record Window(
            int x,
            int y,
            int width,
            int height,
            boolean maximized
    ) {
    }
}

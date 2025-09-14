package com.kalaazu.persistence.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

/**
 * Accounts settings entity.
 * =========================
 * <p>
 * Entity for the `accounts_settings` entity.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
@Entity
@Table(name = "accounts_settings", schema = "kalaazu")
@Data
public class AccountsSettingsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "accounts_id", referencedColumnName = "id", nullable = false)
    private AccountsEntity accountsByAccountsId;

    @Basic
    @Column(name = "accounts_id", nullable = false, insertable = false, updatable = false)
    private int accountsId = 0;

    @Basic
    @Column(name = "version", nullable = false, length = 32)
    private String version = "V4";

    @Basic
    @Column(name = "keybindings", nullable = false, columnDefinition = "TEXT")
    @Convert(converter = AccountsSettingsKeybindingConverter.class)
    private List<Keybinding> keybindings;

    // Quality settings
    @Column(name = "quality_not_set", nullable = false)
    private boolean qualityNotSet;

    @Column(name = "quality_attack", nullable = false)
    private byte qualityAttack = 3;

    @Column(name = "quality_background", nullable = false)
    private byte qualityBackground = 3;

    @Column(name = "quality_presetting", nullable = false)
    private byte qualityPresetting = 3;

    @Column(name = "quality_customized", nullable = false)
    private boolean qualityCustomized;

    @Column(name = "quality_poizone", nullable = false)
    private byte qualityPOIzone = 3;

    @Column(name = "quality_ship", nullable = false)
    private byte qualityShip = 1;

    @Column(name = "quality_engine", nullable = false)
    private byte qualityEngine = 1;

    @Column(name = "quality_explosion", nullable = false)
    private byte qualityExplosion = 1;

    @Column(name = "quality_collectables", nullable = false)
    private byte qualityCollectables = 1;

    @Column(name = "quality_effect", nullable = false)
    private byte qualityEffect = 1;

    // Display settings
    @Column(name = "display_not_set", nullable = false)
    private boolean displayNotSet;

    @Column(name = "display_player_names", nullable = false)
    private boolean displayPlayerNames = true;

    @Column(name = "display_resources", nullable = false)
    private boolean displayResources = true;

    @Column(name = "display_hitpoint_bubbles", nullable = false)
    private boolean displayHitpointBubbles = true;

    @Column(name = "display_chat", nullable = false)
    private boolean displayChat = true;

    @Column(name = "display_setting_3d_quality_antialias", nullable = false)
    private byte displaySetting3DqualityAntialias = 4;

    @Column(name = "display_setting_3d_quality_effects", nullable = false)
    private byte displaySetting3DqualityEffects = 4;

    @Column(name = "display_setting_3d_quality_lights", nullable = false)
    private byte displaySetting3DqualityLights = 3;

    @Column(name = "display_setting_3d_quality_textures", nullable = false)
    private byte displaySetting3DqualityTextures = 3;

    @Column(name = "display_setting_3d_size_textures", nullable = false)
    private byte displaySetting3DsizeTextures = 3;

    @Column(name = "display_setting_3d_texture_filtering", nullable = false)
    private byte displaySetting3DtextureFiltering = -1;

    @Column(name = "display_windows_background", nullable = false)
    private boolean displayWindowsBackground = true;

    @Column(name = "display_not_free_cargo_boxes", nullable = false)
    private boolean displayNotFreeCargoBoxes = true;

    @Column(name = "drag_windows_always", nullable = false)
    private boolean dragWindowsAlways = true;

    @Column(name = "display_notifications", nullable = false)
    private boolean displayNotifications = true;

    @Column(name = "display_drones", nullable = false)
    private boolean displayDrones = true;

    @Column(name = "display_bonus_boxes", nullable = false)
    private boolean displayBonusBoxes = true;

    @Column(name = "display_free_cargo_boxes", nullable = false)
    private boolean displayFreeCargoBoxes = true;

    @Column(name = "show_minimap_background", nullable = false)
    private boolean showMinimapBackground = true;

    @Column(name = "show_not_owned_items", nullable = false)
    private boolean showNotOwnedItems = true;

    @Column(name = "show_premium_quickslot_bar", nullable = false)
    private boolean showPremiumQuickslotBar = true;

    @Column(name = "hover_ships", nullable = false)
    private boolean hoverShips = true;

    @Column(name = "hide_all_windows", nullable = false)
    private boolean hideAllWindows;

    @Column(name = "preload_user_ships", nullable = false)
    private boolean preloadUserShips = true;

    @Column(name = "allow_auto_quality", nullable = false)
    private boolean allowAutoQuality = true;

    @Column(name = "force_2d", nullable = false)
    private boolean force2D;

    @Column(name = "pro_action_bar_enabled", nullable = false)
    private boolean proActionBarEnabled = true;

    @Column(name = "pro_action_bar_keyboard_input_enabled", nullable = false)
    private boolean proActionBarKeyboardInputEnabled = true;

    @Column(name = "pro_action_bar_autohide_enabled", nullable = false)
    private boolean proActionBarAutohideEnabled = true;

    @Column(name = "scale", nullable = false)
    private byte scale = 1;

    @Column(name = "bar_state", nullable = false)
    private String barState = "23,1,24,1,25,1,26,1,27,1";

    //Gameplay settings
    @Column(name = "gameplay_not_set", nullable = false)
    private boolean gameplayNotSet;

    @Column(name = "auto_refinement", nullable = false)
    private boolean autoRefinement = true;

    @Column(name = "quick_slot_stop_attack", nullable = false)
    private boolean quickSlotStopAttack = true;

    @Column(name = "auto_boost", nullable = false)
    private boolean autoBoost = true;

    @Column(name = "auto_buy_booty_keys", nullable = false)
    private boolean autoBuyBootyKeys = true;

    @Column(name = "double_click_attack_enabled", nullable = false)
    private boolean doubleClickAttackEnabled = true;

    @Column(name = "auto_change_ammo", nullable = false)
    private boolean autoChangeAmmo = true;

    @Column(name = "auto_start_enabled", nullable = false)
    private boolean autoStartEnabled = true;

    @Column(name = "show_battleray_notifications", nullable = false)
    private boolean showBattlerayNotifications = true;

    @Column(name = "show_low_hp_warn", nullable = false)
    private boolean showLowHpWarn = true;

    @Column(name = "selected_battery", nullable = false)
    private byte selectedBattery = 1;

    @Column(name = "selected_rocket", nullable = false)
    private byte selectedRocket = 1;

    // Audio settings
    @Column(name = "audio_not_set", nullable = false)
    private boolean audioNotSet;

    @Column(name = "play_combat_music", nullable = false)
    private boolean playCombatMusic = true;

    @Column(name = "voice", nullable = false)
    private byte voice;

    @Column(name = "sound", nullable = false)
    private byte sound;

    @Column(name = "music", nullable = false)
    private byte music;

    @Column(name = "quests_level_order_descending", nullable = false)
    private boolean questsLevelOrderDescending;

    @Column(name = "quests_available_filter", nullable = false)
    private boolean questsAvailableFilter = true;

    @Column(name = "quests_unavailable_filter", nullable = false)
    private boolean questsUnavailableFilter;

    @Column(name = "quests_completed_filter", nullable = false)
    private boolean questsCompletedFilter;

    // Window settings
    @Column(name = "resolution_id", nullable = false)
    private byte resolutionId = 3;

    @Column(name = "minimap_scale", nullable = false)
    private byte minimapScale = 1;

    @Column(name = "window_settings", nullable = false)
    private String windowSettings = "0,9,4,1,1,232,3,1,3,780,388,1,5,5,5,0,10,5,288,0,13,187,50,0,20,5,402,1,22,347,188,0,23,458,1,1,24,284,25,0";

    @Column(name = "quickbar_slot", nullable = false)
    private String quickbarSlot = "3,4,5,6,7,39,11,12,13,23";

    @Column(name = "main_menu_position", nullable = false)
    private String mainMenuPosition = "806,830";

    @Column(name = "slot_menu_position", nullable = false)
    private String slotMenuPosition = "769,798";

    @Column(name = "slot_menu_order", nullable = false)
    private byte slotMenuOrder;

    @Data
    @AllArgsConstructor
    public static class Keybinding {
        private short actionType;
        private short charCode;
        private short parameter;
        private List<Integer> keys;
    }
}

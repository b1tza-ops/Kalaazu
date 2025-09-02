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
    @Column(name= "accounts_id", nullable = false, insertable = false, updatable = false)
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
    private byte qualityAttack;

    @Column(name = "quality_background", nullable = false)
    private byte qualityBackground;

    @Column(name = "quality_presetting", nullable = false)
    private byte qualityPresetting;

    @Column(name = "quality_poizone", nullable = false)
    private byte qualityPOIzone;

    @Column(name = "quality_ship", nullable = false)
    private byte qualityShip;

    @Column(name = "quality_engine", nullable = false)
    private byte qualityEngine;

    @Column(name = "quality_explosion", nullable = false)
    private byte qualityExplosion;

    @Column(name = "quality_collectables", nullable = false)
    private byte qualityCollectables;

    @Column(name = "quality_effect", nullable = false)
    private byte qualityEffect;

    @Column(name = "quality_customized", nullable = false)
    private boolean qualityCustomized;

    // Display settings
    @Column(name = "display_not_set", nullable = false)
    private boolean displayNotSet;

    @Column(name = "display_player_names", nullable = false)
    private boolean displayPlayerNames;

    @Column(name = "display_resources", nullable = false)
    private boolean displayResources;

    @Column(name = "display_hitpoint_bubbles", nullable = false)
    private boolean displayHitpointBubbles;

    @Column(name = "display_chat", nullable = false)
    private boolean displayChat;

    @Column(name = "display_setting_3d_quality_antialias", nullable = false)
    private byte displaySetting3DqualityAntialias;

    @Column(name = "display_setting_3d_quality_effects", nullable = false)
    private byte displaySetting3DqualityEffects;

    @Column(name = "display_setting_3d_quality_lights", nullable = false)
    private byte displaySetting3DqualityLights;

    @Column(name = "display_setting_3d_quality_textures", nullable = false)
    private byte displaySetting3DqualityTextures;

    @Column(name = "display_setting_3d_size_textures", nullable = false)
    private byte displaySetting3DsizeTextures;

    @Column(name = "display_setting_3d_texture_filtering", nullable = false)
    private byte displaySetting3DtextureFiltering;

    @Column(name = "display_windows_background", nullable = false)
    private boolean displayWindowsBackground;

    @Column(name = "display_not_free_cargo_boxes", nullable = false)
    private boolean displayNotFreeCargoBoxes;

    @Column(name = "drag_windows_always", nullable = false)
    private boolean dragWindowsAlways;

    @Column(name = "display_notifications", nullable = false)
    private boolean displayNotifications;

    @Column(name = "display_drones", nullable = false)
    private boolean displayDrones;

    @Column(name = "display_bonus_boxes", nullable = false)
    private boolean displayBonusBoxes;

    @Column(name = "display_free_cargo_boxes", nullable = false)
    private boolean displayFreeCargoBoxes;

    @Column(name = "show_minimap_background", nullable = false)
    private boolean showMinimapBackground;

    @Column(name = "show_not_owned_items", nullable = false)
    private boolean showNotOwnedItems;

    @Column(name = "show_premium_quickslot_bar", nullable = false)
    private boolean showPremiumQuickslotBar;

    @Column(name = "hover_ships", nullable = false)
    private boolean hoverShips;

    @Column(name = "hide_all_windows", nullable = false)
    private boolean hideAllWindows;

    @Column(name = "preload_user_ships", nullable = false)
    private boolean preloadUserShips;


    @Column(name = "allow_auto_quality", nullable = false)
    private boolean allowAutoQuality;

    @Column(name = "force_2d", nullable = false)
    private boolean force2D;

    @Column(name = "pro_action_bar_enabled", nullable = false)
    private boolean proActionBarEnabled;

    @Column(name = "pro_action_bar_keyboard_input_enabled", nullable = false)
    private boolean proActionBarKeyboardInputEnabled;

    @Column(name = "pro_action_bar_autohide_enabled", nullable = false)
    private boolean proActionBarAutohideEnabled;

    @Column(name = "scale", nullable = false)
    private byte scale;

    @Column(name = "bar_state", nullable = false)
    private String barState;

    //Gameplay settings
    @Column(name = "gameplay_not_set", nullable = false)
    private boolean gameplayNotSet;


    @Column(name = "auto_refinement", nullable = false)
    private boolean autoRefinement;


    @Column(name = "quick_slot_stop_attack", nullable = false)
    private boolean quickSlotStopAttack;


    @Column(name = "auto_boost", nullable = false)
    private boolean autoBoost;


    @Column(name = "auto_buy_booty_keys", nullable = false)
    private boolean autoBuyBootyKeys;


    @Column(name = "double_click_attack_enabled", nullable = false)
    private boolean doubleClickAttackEnabled;


    @Column(name = "auto_change_ammo", nullable = false)
    private boolean autoChangeAmmo;


    @Column(name = "auto_start_enabled", nullable = false)
    private boolean autoStartEnabled;


    @Column(name = "show_battleray_notifications", nullable = false)
    private boolean showBattlerayNotifications;


    @Column(name = "show_low_hp_warn", nullable = false)
    private boolean showLowHpWarn;

    // Audio settings
    @Column(name = "audio_not_set", nullable = false)
    private boolean audioNotSet;

    @Column(name = "play_combat_music", nullable = false)
    private boolean playCombatMusic;

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

    @Data
    @AllArgsConstructor
    public static class Keybinding {
        private short actionType;
        private short charCode;
        private short parameter;
        private List<Integer> keys;
    }
}

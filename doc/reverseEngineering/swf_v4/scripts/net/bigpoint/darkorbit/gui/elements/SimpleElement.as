package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class SimpleElement extends Sprite
   {
      
      public static const TYPE_SIMPLE_BUTTON:int = 0;
      
      public static const TYPE_CHECKBOX:int = 1;
      
      public static const TYPE_LOG_TEXTAREA:int = 2;
      
      public static const TYPE_LOGOUT_TEXT:int = 3;
      
      public static const TYPE_ORE_MODULE:int = 4;
      
      public static const TYPE_WEBLINK_MODULE:int = 5;
      
      public static const TYPE_MINIMAP_LABEL:int = 6;
      
      public static const TYPE_RESOLUTION_CHANGER:int = 7;
      
      public static const TYPE_CONNECTION_LOST:int = 8;
      
      public static const TYPE_SPACEMAP:int = 9;
      
      public static const TYPE_TEXT:int = 10;
      
      public static const TYPE_CONNECTION:int = 11;
      
      public static const TYPE_BOOSTER:int = 12;
      
      public static const TYPE_SPACEBALL_SCORE:int = 13;
      
      public static const TYPE_INVASION_SCORE:int = 14;
      
      public static const TYPE_CTB_SCORE:int = 15;
      
      public static const TYPE_CTB_SCORE_GRID:int = 16;
      
      public static const TYPE_OPONNENT_USERID:int = 17;
      
      public static const TYPE_OPONNENT_SHIPTYPE:int = 18;
      
      public static const TYPE_OPONNENT_HITPOINTS:int = 19;
      
      public static const TYPE_OPONNENT_SHIELD:int = 18;
      
      public static const TYPE_OPONNENT_CARGO:int = 19;
      
      public static const TYPE_EXPERIENCE:int = 20;
      
      public static const TYPE_LEVEL:int = 21;
      
      public static const TYPE_HONOR:int = 22;
      
      public static const TYPE_HITPOINTS:int = 23;
      
      public static const TYPE_SHIELD:int = 24;
      
      public static const TYPE_CARGO:int = 25;
      
      public static const TYPE_LASER:int = 26;
      
      public static const TYPE_ROCKETS:int = 27;
      
      public static const TYPE_CONFIGURATION:int = 28;
      
      public static const TYPE_CREDITS:int = 29;
      
      public static const TYPE_JACKPOT:int = 30;
      
      public static const TYPE_URIDIUM:int = 31;
      
      public static const TYPE_BOOTY_KEYS:int = 86;
      
      public static const TYPE_JUMP_VOUCHERS:int = 87;
      
      public static const TYPE_BOOSTER_1:int = 32;
      
      public static const TYPE_BOOSTER_2:int = 33;
      
      public static const TYPE_BOOSTER_3:int = 34;
      
      public static const TYPE_BOOSTER_4:int = 35;
      
      public static const TYPE_BOOSTER_5:int = 36;
      
      public static const TYPE_BOOSTER_6:int = 37;
      
      public static const TYPE_BOOSTER_7:int = 38;
      
      public static const TYPE_BOOSTER_8:int = 39;
      
      public static const TYPE_BOOSTER_9:int = 83;
      
      public static const TYPE_BOOSTER_10:int = 84;
      
      public static const TYPE_TDM_TIMER:int = 40;
      
      public static const TYPE_TDM_GAMES:int = 41;
      
      public static const TYPE_TDM_QUEUE:int = 42;
      
      public static const TYPE_TDM_LEFT_SCORE:int = 43;
      
      public static const TYPE_TDM_RIGHT_SCORE:int = 44;
      
      public static const TYPE_CHAT:int = 45;
      
      public static const TYPE_REFINEMENT_MODULE:int = 46;
      
      public static const TYPE_COMBO_BOX_ELEMENT:int = 47;
      
      public static const TYPE_DEFAULT_ELEMENT:int = 48;
      
      public static const TYPE_VIDEO_ELEMENT:int = 49;
      
      public static const TYPE_ACHIEVEMENT:int = 50;
      
      public static const TYPE_TECH:int = 51;
      
      public static const CURRENT_IP:int = 52;
      
      public static const NEXT_IP:int = 53;
      
      public static const CURRENT_MAP:int = 54;
      
      public static const NEXT_MAP:int = 55;
      
      public static const CURRENT_PORT:int = 56;
      
      public static const CONNECTION_STATUS:int = 57;
      
      public static const NUMBER_OF_TRIES:int = 58;
      
      public static const CONNECT_PENDING_STATUS:int = 59;
      
      public static var PET_WINDOW_HP_BAR:int = 60;
      
      public static var PET_WINDOW_XP_BAR:int = 61;
      
      public static var PET_WINDOW_SHIELD_BAR:int = 62;
      
      public static var PET_WINDOW_FUEL_BAR:int = 63;
      
      public static var PET_WINDOW_PETNAME_TEXT:int = 64;
      
      public static const PET_WINDOW_PLAY_BTN:int = 65;
      
      public static const PET_WINDOW_STOP_BTN:int = 66;
      
      public static const PET_WINDOW_REPAIR_BTN:int = 67;
      
      public static const PET_WINDOW_FUEL_BTN:int = 68;
      
      public static const PET_WINDOW_EXPAND_BTN:int = 69;
      
      public static const PET_WINDOW_BUFF_CONTAINER:int = 70;
      
      public static const PET_WINDOW_IMAGE_CONTAINER:int = 71;
      
      public static const PET_WINDOW_GEAR_COMBO_CONTAINER:int = 72;
      
      public static const PET_WINDOW_BANNER_CONTAINER:int = 73;
      
      public static const ADVANCED_SPACEMAP_SYSTEM_1:int = 74;
      
      public static const ADVANCED_SPACEMAP_SYSTEM_2:int = 75;
      
      public static const ADVANCED_SPACEMAP_SYSTEM_SWITCHER:int = 76;
      
      public static const ADVANCED_SPACEMAP_BOTTOM_BAR:int = 77;
      
      public static const ADVANCED_SPACEMAP_JUMP_INFO_DISPLAY:int = 78;
      
      public static const ADVANCED_SPACEMAP_JUMP_PRICE_DISPLAY:int = 79;
      
      public static const ADVANCED_SPACEMAP_JUMP_BUTTON:int = 80;
      
      public static const ADVANCED_SPACEMAP_JUMP_VOUCHER_LABEL:int = 85;
      
      public static const TYPE_RANKED_HUNT_POINTS:int = 81;
      
      public static const TYPE_CLAN_RANKED_CLAN_POINTS:int = 82;
      
      public static const TYPE_COMBOBOX:int = 88;
      
      public static const TYPE_SLIDER:int = 89;
      
      protected var id:int;
      
      public function SimpleElement(param1:int)
      {
         super();
         this.id = param1;
         this.cacheAsBitmap = true;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function getParent() : DisplayObject
      {
         return this.parent;
      }
   }
}


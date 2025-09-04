package net.bigpoint.darkorbit.settings
{
   import flash.geom.Point;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.gui.InstantLogViewConfig;
   
   public class Settings
   {
      
      public static var selectedLaser:int;
      
      public static var selectedRocket:int;
      
      public static var displayChat:Boolean;
      
      public static var playSFX:Boolean;
      
      public static var playMusic:Boolean;
      
      public static var displayHitpointBubbles:Boolean;
      
      public static var displayPlayerNames:Boolean;
      
      public static var displayResources:Boolean;
      
      public static var displayBonusBoxes:Boolean;
      
      public static var displayFreeCargoBoxes:Boolean;
      
      public static var displayNotFreeCargoBoxes:Boolean;
      
      public static var autoBoost:Boolean;
      
      public static var autochangeAmmo:Boolean;
      
      public static var showAmmunitionNumeric:Boolean;
      
      public static var autoRefinement:Boolean;
      
      public static var enemyCount:int;
      
      public static var resolutionID:int;
      
      public static var initialResolutionID:int;
      
      public static var fastRepair:int;
      
      public static var instantLogViewConfig:InstantLogViewConfig;
      
      public static var pixelPerfectCollisionWithLayers:Boolean;
      
      public static var fireworksModeIndependenceDay:Boolean;
      
      public static var chatServerIP:String;
      
      public static var projectID:int;
      
      public static var chatHost:String;
      
      public static var nextMapID:int;
      
      public static var boardLink:String;
      
      public static var basePath:String;
      
      public static var language:String;
      
      public static var staticHost:String;
      
      public static var defaultGameServer:String;
      
      public static var fireworksLoaded:int;
      
      public static var lastAutoStartEnabled:Boolean;
      
      public static var specialOffersPrepared:Boolean;
      
      public static const logger:ILogger = Log.getLogger("Settings");
      
      public static const QUALITY_LOW:int = 0;
      
      public static const QUALITY_MEDIUM:int = 1;
      
      public static const QUALITY_GOOD:int = 2;
      
      public static const QUALITY_HIGH:int = 3;
      
      public static var lastSelectedLaser:int = -1;
      
      public static var selectedExplosive:int = 1;
      
      public static var selectedLauncherRocket:int = 6;
      
      public static var selectedConfiguration:int = 1;
      
      public static var selectedQuickBuyIcon:int = 1;
      
      public static var displayNotifications:Boolean = true;
      
      public static var displayDrones:Boolean = true;
      
      public static var quickSlotStopAttack:Boolean = true;
      
      public static var lastDisplayDronesSetting:Boolean = true;
      
      public static var lastResolutionID:int = -1;
      
      public static var SHOW_HP_NUMBERS_ON_MAP:Boolean = false;
      
      public static var JS_EVENT_TRACKING_ENABLED:Boolean = false;
      
      public static var doubleclickAttackEnabled:Boolean = false;
      
      public static var autoStartEnabled:Boolean = false;
      
      public static var showInstantLog:Boolean = false;
      
      public static const createLensflares:Boolean = true;
      
      public static const createCollectables:Boolean = true;
      
      public static const createOpponents:Boolean = true;
      
      public static const createMeteors:Boolean = false;
      
      public static var createChat:Boolean = true;
      
      public static const createMinimap:Boolean = true;
      
      public static const createHero:Boolean = true;
      
      public static const createStarfield:Boolean = true;
      
      public static const createMusic:Boolean = true;
      
      public static const createPortals:Boolean = true;
      
      public static var unloadResources:Boolean = true;
      
      public static var droneShoots:Boolean = false;
      
      public static var mapID:int = -1;
      
      public static var lastMapID:int = -1;
      
      public static var currency:String = "EUR";
      
      public static var dynamicHost:String = "/";
      
      public static var rocketSmoke:Boolean = true;
      
      public static var showPilots:Boolean = false;
      
      public static var rocketLauncherType:int = 0;
      
      public static var rocketLauncherRocketsLoaded:int = 0;
      
      public static var showWindowsBackground:Boolean = true;
      
      public static var maxWindowsTransparency:Number = 1;
      
      public static var gridSize:int = 10;
      
      public static var dragWindowsAlways:Boolean = true;
      
      public static var preloadUserShips:Boolean = false;
      
      public static var qualityPresetting:int = 3;
      
      public static var qualityCustomized:Boolean = false;
      
      public static var qualityBackground:int = QUALITY_HIGH;
      
      public static var qualityPoizone:int = QUALITY_HIGH;
      
      public static var qualityShip:int = QUALITY_HIGH;
      
      public static var qualityEngine:int = QUALITY_HIGH;
      
      public static var qualityExplosion:int = QUALITY_HIGH;
      
      public static var qualityCollectable:int = QUALITY_HIGH;
      
      public static var qualityAttack:int = QUALITY_HIGH;
      
      public static var qualityEffect:int = QUALITY_HIGH;
      
      private var chatPosition:Point;
      
      private var chatSize:Point;
      
      public function Settings()
      {
         super();
      }
      
      public static function getQualitySettingLevel() : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = [qualityBackground,qualityPoizone,qualityShip,qualityEngine,qualityExplosion,qualityCollectable];
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ += _loc3_;
         }
         return int(Math.round(_loc2_ / _loc1_.length));
      }
   }
}


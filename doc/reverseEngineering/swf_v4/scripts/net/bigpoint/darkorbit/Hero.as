package net.bigpoint.darkorbit
{
   import flash.external.ExternalInterface;
   import net.bigpoint.darkorbit.data.RankedHuntingEventData;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.menu.TopMenu;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RepairInfo;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Hero
   {
      
      public static var username:String;
      
      public static var userID:int;
      
      public static var sessionID:String;
      
      public static var rankedHuntingEventData:RankedHuntingEventData;
      
      public static var creditsAmount:Number;
      
      public static var uridiumAmount:Number;
      
      public static var jackpotAmount:Number;
      
      public static var maxLaserCapacity:Number;
      
      public static var maxRocketCapacity:Number;
      
      public static var experiencePoints:Number;
      
      public static var level:int;
      
      public static var honorPoints:Number;
      
      public static var premium:Boolean;
      
      public static var admin:Boolean;
      
      public static var inTradeArea:Boolean;
      
      public static var inJumpArea:Boolean;
      
      public static var demilitarizedZone:Boolean;
      
      public static var showSkinShieldRandomly:Boolean;
      
      public static var repairInfo:RepairInfo;
      
      public static var isKilled:Boolean;
      
      public static var jumpVouchersAmount:int;
      
      public static var bootyKeysAmount:Number;
      
      public static var clan:String = "noclan";
      
      public static var factionID:int = 0;
      
      public static var laserBatteryAmounts:Array = [];
      
      public static var rocketAmounts:Array = [];
      
      public static var explosiveAmounts:Array = [];
      
      public static var fireworksAmounts:Array = [];
      
      public static var cpuItems:Array = [];
      
      public static var skills:Array = [];
      
      public static var repairSkillId:int = -1;
      
      public static var minSkinShieldTwinkle:int = 10;
      
      public static var maxSkinShieldTwinkle:int = 100;
      
      public function Hero()
      {
         super();
      }
      
      public static function setInTradeArea(param1:Boolean, param2:Main) : void
      {
         var _loc5_:GuiManager = null;
         var _loc6_:SimpleWindow = null;
         var _loc7_:TopMenu = null;
         var _loc3_:Boolean = inTradeArea;
         var _loc4_:CPUItem = Hero.cpuItems[CPUItem.TYPE_HM7];
         if(_loc4_ != null)
         {
            param1 = true;
         }
         inTradeArea = param1;
         if(inTradeArea)
         {
            if(Settings.JS_EVENT_TRACKING_ENABLED && _loc3_ != inTradeArea)
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("clientEvent","tradePossible");
               }
            }
         }
         else
         {
            if(Settings.JS_EVENT_TRACKING_ENABLED && _loc3_ != inTradeArea)
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("clientEvent","tradeNotPossible");
               }
            }
            _loc5_ = param2.getGuiManager();
            _loc6_ = _loc5_.getWindow(SimpleWindow.WINDOW_CLASS_TRADE);
            if(_loc6_ != null && _loc6_.isMaximized())
            {
               _loc6_.minimize();
            }
         }
         _loc5_ = param2.getGuiManager();
         if(_loc5_ != null)
         {
            _loc7_ = _loc5_.getTopMenu();
            if(_loc7_ != null)
            {
               _loc7_.setWindowAccess(SimpleWindow.WINDOW_CLASS_TRADE,inTradeArea);
            }
         }
      }
      
      public static function setInJumpArea(param1:Boolean) : void
      {
         var _loc2_:Boolean = inJumpArea;
         inJumpArea = param1;
         if(Settings.JS_EVENT_TRACKING_ENABLED && _loc2_ != inJumpArea)
         {
            if(inJumpArea)
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("clientEvent","jumpPossible");
               }
            }
            else if(ExternalInterface.available)
            {
               ExternalInterface.call("clientEvent","jumpNotPossible");
            }
         }
      }
      
      public static function setDemilitarizedZone(param1:Boolean, param2:Main) : void
      {
         demilitarizedZone = param1;
         if(demilitarizedZone)
         {
            param2.getGuiManager().displayNAZ(true);
            if(param2.getProfiler().isNotificationInQueue)
            {
               param2.getProfiler().showNotification();
            }
         }
         else
         {
            param2.getGuiManager().displayNAZ(false);
         }
      }
      
      public static function getOres(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:OrePattern = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = int(param1[_loc3_]);
            _loc5_ = PatternManager.orePatterns[_loc4_];
            _loc2_.push(_loc5_);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}


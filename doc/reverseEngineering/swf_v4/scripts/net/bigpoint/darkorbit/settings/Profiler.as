package net.bigpoint.darkorbit.settings
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.gui.windows.VideoWindow;
   
   public class Profiler
   {
      
      public static var QUALITY_LOW_LIMIT:int = 10;
      
      public static var INTERVAL_LENGTH:int = 20000;
      
      public static var NOTIFICATION_STEPS:Array = [3,4,6];
      
      private var main:Main;
      
      public var FPSCollection:Array = [];
      
      private var t:Timer;
      
      private var notificationOutputs:int = 0;
      
      private var lowFPSInTurn:int = 0;
      
      public var isNotificationInQueue:Boolean = false;
      
      public function Profiler(param1:Main)
      {
         super();
         this.main = param1;
         this.t = new Timer(INTERVAL_LENGTH);
      }
      
      public function start() : void
      {
         if(!this.t.running)
         {
            this.t.addEventListener(TimerEvent.TIMER,this.profileFPS);
            this.t.start();
         }
      }
      
      public function stop() : void
      {
         this.t.stop();
         this.t.removeEventListener(TimerEvent.TIMER,this.profileFPS);
      }
      
      public function addFPS(param1:int) : void
      {
         if(this.t.running && this.FPSCollection.length <= 100)
         {
            this.FPSCollection.push(param1);
         }
      }
      
      private function profileFPS(param1:TimerEvent) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = int(NOTIFICATION_STEPS.length);
         if(this.notificationOutputs >= _loc2_ || !Settings.displayNotifications)
         {
            this.stop();
            return;
         }
         if(this.FPSCollection.length == 0)
         {
            return;
         }
         var _loc3_:Boolean = this.main.screenManager.map.getCombatManager().isTruce();
         if(this.isNotificationInQueue && _loc3_)
         {
            this.showNotification();
            return;
         }
         var _loc5_:int = 0;
         for each(_loc6_ in this.FPSCollection)
         {
            _loc5_ += _loc6_;
         }
         _loc4_ = Math.round(_loc5_ / this.FPSCollection.length);
         this.FPSCollection = [];
         _loc7_ = Settings.getQualitySettingLevel();
         if(_loc4_ < QUALITY_LOW_LIMIT)
         {
            ++this.lowFPSInTurn;
            _loc8_ = int(NOTIFICATION_STEPS[this.notificationOutputs]);
            if(this.lowFPSInTurn >= _loc8_ && _loc7_ > Settings.QUALITY_LOW)
            {
               if(_loc3_)
               {
                  this.showNotification();
               }
               else
               {
                  this.lowFPSInTurn = 0;
                  this.isNotificationInQueue = true;
               }
            }
         }
         else
         {
            this.lowFPSInTurn = 0;
         }
         if(this.notificationOutputs >= _loc2_)
         {
            this.stop();
         }
      }
      
      public function showNotification() : void
      {
         this.main.getGuiManager().createVideoWindow(["notification_low_performance"],VideoWindow.NOTIFICATION_FPS,2,VideoElement.CLASS_HELPMOVIE,true,"nw");
         this.lowFPSInTurn = 0;
         ++this.notificationOutputs;
         this.isNotificationInQueue = false;
      }
   }
}


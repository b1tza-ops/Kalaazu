package net.bigpoint.darkorbit.ctb
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class HomeZone extends MovieClip
   {
      
      private var fromCompanyID:int;
      
      private var toCompanyID:int;
      
      private var beaconID:int;
      
      private var direction:int = 1;
      
      private var ctbManager:CTBManager;
      
      private var rings:Array = [];
      
      private var timer:Timer;
      
      public function HomeZone(param1:CTBManager, param2:int, param3:int, param4:int)
      {
         super();
         this.ctbManager = param1;
         this.beaconID = param2;
         this.x = param3;
         this.y = param4;
         this.setCompanyID();
         this.setGraphics();
      }
      
      private function setCompanyID() : void
      {
         var _loc1_:Array = this.beaconID.toString().split("");
         this.fromCompanyID = _loc1_[1];
         this.toCompanyID = _loc1_[2];
      }
      
      public function getX() : int
      {
         return x;
      }
      
      public function getY() : int
      {
         return y;
      }
      
      public function getCompanyID() : int
      {
         return this.toCompanyID;
      }
      
      private function setGraphics() : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc1_:int = 1;
         while(_loc1_ < 4)
         {
            _loc2_ = "homezone_" + this.fromCompanyID + "_" + _loc1_;
            if(_loc1_ != 2)
            {
               _loc2_ = "homezone_" + this.toCompanyID + "_" + _loc1_;
            }
            _loc3_ = ResourceManager.getMovieClip("ui",_loc2_);
            this.rings.push(_loc3_);
            this.addChild(_loc3_);
            _loc1_++;
         }
      }
      
      public function startRotateTimer() : void
      {
         this.timer = new Timer(20,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.timer.start();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:MovieClip = this.rings[0];
         _loc2_.rotation += this.direction;
         if(_loc2_.rotation > 360)
         {
            _loc2_.rotation = 0;
         }
         _loc2_ = this.rings[2];
         _loc2_.rotation += this.direction;
         if(_loc2_.rotation > 360)
         {
            _loc2_.rotation = 0;
         }
      }
      
      public function setDirection(param1:int) : void
      {
         this.direction = param1;
      }
      
      public function cleanup() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
   }
}


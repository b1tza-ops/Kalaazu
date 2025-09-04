package com.pixelwelders.fx
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Earthquake
   {
      
      private static const FRAME_RATE:int = 25;
      
      private var timer:Timer;
      
      private var object:DisplayObject;
      
      private var originalX:int;
      
      private var originalY:int;
      
      private var intensity:int;
      
      private var intensityOffset:int;
      
      public function Earthquake(param1:DisplayObject, param2:Number = 10, param3:Number = -1)
      {
         super();
         if(this.timer)
         {
            this.timer.stop();
         }
         this.object = param1;
         this.originalX = this.object.x;
         this.originalY = this.object.y;
         this.intensity = param2;
         this.intensityOffset = param2 / 2;
         var _loc4_:int = int(1000 / FRAME_RATE);
         var _loc5_:int = 0;
         if(param3 != -1)
         {
            _loc5_ = int(param3 * 1000 / _loc4_);
         }
         this.timer = new Timer(_loc4_,_loc5_);
         this.timer.addEventListener(TimerEvent.TIMER,this.quake);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.resetImage);
         this.timer.start();
      }
      
      public function killQuake() : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.quake);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.resetImage);
         this.timer.stop();
         this.resetImage();
      }
      
      private function quake(param1:TimerEvent) : void
      {
         var _loc2_:int = this.originalX + Math.random() * this.intensity - this.intensityOffset;
         var _loc3_:int = this.originalY + Math.random() * this.intensity - this.intensityOffset;
         this.object.x = _loc2_;
         this.object.y = _loc3_;
      }
      
      private function resetImage(param1:TimerEvent = null) : void
      {
         this.object.x = this.originalX;
         this.object.y = this.originalY;
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         this.timer = null;
         this.object = null;
      }
   }
}


package com.pixelwelders.fx
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RotationQuiver
   {
      
      private static const FRAME_RATE:int = 4;
      
      private var timer:Timer;
      
      private var object:DisplayObject;
      
      private var quiverIntensity:int;
      
      private var intensityOffset:int;
      
      private var originalRotation:Number;
      
      private var upperQuiverLimit:Number;
      
      private var lowerQuiverLimit:Number;
      
      public function RotationQuiver(param1:DisplayObject, param2:Number = 10)
      {
         super();
         if(this.timer)
         {
            this.timer.stop();
         }
         this.object = param1;
         this.originalRotation = this.object.rotation;
         this.quiverIntensity = param2;
         this.upperQuiverLimit = this.originalRotation + this.quiverIntensity;
         this.lowerQuiverLimit = this.originalRotation - this.quiverIntensity;
         this.intensityOffset = param2 / 2;
         var _loc3_:int = int(1000 / FRAME_RATE);
         var _loc4_:int = 0;
         this.timer = new Timer(_loc3_,_loc4_);
         this.timer.addEventListener(TimerEvent.TIMER,this.quiver);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.resetImage);
         this.timer.start();
      }
      
      public function killQuiver() : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.quiver);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.resetImage);
         this.timer.stop();
         this.resetImage();
      }
      
      private function quiver(param1:TimerEvent) : void
      {
         this.upperQuiverLimit = this.object.rotation + this.quiverIntensity;
         this.lowerQuiverLimit = this.object.rotation - this.quiverIntensity;
         var _loc2_:Number = Math.random() * (this.upperQuiverLimit - this.lowerQuiverLimit + 1) + this.lowerQuiverLimit;
         this.object.rotation = _loc2_;
      }
      
      private function resetImage(param1:TimerEvent = null) : void
      {
         this.object.rotation = this.originalRotation;
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         this.timer = null;
         this.object = null;
      }
   }
}


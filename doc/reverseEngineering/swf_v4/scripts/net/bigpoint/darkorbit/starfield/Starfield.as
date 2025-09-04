package net.bigpoint.darkorbit.starfield
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Starfield extends Sprite
   {
      
      private var elements:Array;
      
      private var fieldWidth:int;
      
      private var fieldHeight:int;
      
      private var timer:Timer;
      
      private var xSpeed:Number;
      
      private var ySpeed:Number;
      
      private var fps:int = 40;
      
      public var color:int;
      
      public function Starfield(param1:int, param2:int, param3:uint, param4:int = 100)
      {
         var _loc6_:StarElement = null;
         super();
         this.fieldWidth = param1;
         this.fieldHeight = param2;
         this.elements = [];
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
         var _loc5_:int = 0;
         while(_loc5_ < param4)
         {
            _loc6_ = new StarElement(param3);
            this.elements.push(_loc6_);
            _loc6_.x = Math.random() * param1;
            _loc6_.y = Math.random() * param2;
            _loc6_.speed = Math.random() * 3 + 0.5;
            this.addChild(_loc6_);
            _loc5_++;
         }
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.timer = new Timer(1000 / this.fps,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.timer.start();
      }
      
      public function moveField(param1:Number, param2:Number) : void
      {
         this.xSpeed = param1;
         this.ySpeed = param2;
      }
      
      public function onTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:StarElement = null;
         for each(_loc5_ in this.elements)
         {
            _loc2_ = Number(_loc5_.speed);
            _loc3_ = _loc5_.x = _loc5_.x + _loc2_ * this.xSpeed;
            _loc4_ = _loc5_.y = _loc5_.y + _loc2_ * this.ySpeed;
            if(_loc3_ < 0)
            {
               _loc5_.x += this.fieldWidth;
            }
            else if(_loc3_ > this.fieldWidth)
            {
               _loc5_.x -= this.fieldWidth;
            }
            if(_loc4_ < 0)
            {
               _loc5_.y += this.fieldHeight;
            }
            else if(_loc4_ > this.fieldHeight)
            {
               _loc5_.y -= this.fieldHeight;
            }
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:StarElement = null;
         for each(_loc1_ in this.elements)
         {
            this.removeChild(_loc1_);
         }
         this.elements = null;
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         }
      }
   }
}


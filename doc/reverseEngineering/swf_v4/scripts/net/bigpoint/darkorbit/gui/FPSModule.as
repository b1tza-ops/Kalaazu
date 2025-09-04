package net.bigpoint.darkorbit.gui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.settings.Profiler;
   
   public class FPSModule
   {
      
      private var frameTicks:int;
      
      private var timerTicks:int;
      
      private var FPS:TextField;
      
      private var format:TextFormat = new TextFormat();
      
      private var t1:Timer = new Timer(1000);
      
      private var camPos:TextField;
      
      private var socketByteCount:int = 0;
      
      private var megaByteCoefficient:Number;
      
      private var params:Dictionary = new Dictionary();
      
      private var joinedParams:String = "";
      
      public var currentFPS:Number = 0;
      
      public var averageFPS:Number = 0;
      
      public var minFPS:Number = 0;
      
      public var maxFPS:Number = 0;
      
      public var currentMem:Number = 0;
      
      public var averageMem:Number = 0;
      
      public var minMem:Number = 0;
      
      public var maxMem:Number = 0;
      
      public var view:Sprite;
      
      private var isTrackingRunning:Boolean = false;
      
      private var main:Main;
      
      public function FPSModule(param1:Main, param2:int = 0, param3:int = 0)
      {
         super();
         this.view = new Sprite();
         this.view.x = param2;
         this.view.y = param3;
         this.main = param1;
         this.createText();
         this.megaByteCoefficient = 1 / 1024 / 1024;
         this.t1.addEventListener(TimerEvent.TIMER,this.updateFPS);
         this.view.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         this.t1.start();
      }
      
      private function createText() : void
      {
         this.format.font = "Verdana";
         this.format.size = 9;
         this.FPS = new TextField();
         this.FPS.defaultTextFormat = this.format;
         this.FPS.autoSize = TextFieldAutoSize.LEFT;
         this.FPS.textColor = 16777215;
         this.FPS.background = true;
         this.FPS.backgroundColor = 6710886;
         this.FPS.antiAliasType = "advanced";
         this.FPS.selectable = false;
         this.FPS.text = "FPS: ";
         this.camPos = new TextField();
         this.camPos.defaultTextFormat = this.format;
         this.camPos.autoSize = TextFieldAutoSize.LEFT;
         this.camPos.textColor = 16777215;
         this.camPos.background = true;
         this.camPos.backgroundColor = 6710886;
         this.camPos.antiAliasType = "advanced";
         this.camPos.selectable = false;
         this.camPos.text = "CamPos: ";
         this.camPos.y = -15;
         this.view.addChild(this.FPS);
         this.view.addChild(this.camPos);
      }
      
      public function refreshTracking() : void
      {
         this.averageFPS = 0;
         this.minFPS = 0;
         this.maxFPS = 0;
         this.averageMem = 0;
         this.minMem = 0;
         this.maxMem = 0;
         this.timerTicks = 0;
         this.isTrackingRunning = true;
      }
      
      private function updateFPS(param1:TimerEvent) : void
      {
         if(this.isTrackingRunning)
         {
            ++this.timerTicks;
            if(this.currentFPS > this.maxFPS)
            {
               this.maxFPS = this.currentFPS;
            }
            if(this.currentFPS < this.minFPS || this.minFPS == 0)
            {
               this.minFPS = this.currentFPS;
            }
            if(this.currentMem > this.maxMem)
            {
               this.maxMem = this.currentMem;
            }
            if(this.currentMem < this.minMem || this.minMem == 0)
            {
               this.minMem = this.currentMem;
            }
            this.averageFPS = (this.averageFPS * (this.timerTicks - 1) + this.currentFPS) / this.timerTicks;
            this.averageMem = (this.averageMem * (this.timerTicks - 1) + this.currentMem) / this.timerTicks;
         }
         this.currentFPS = this.frameTicks;
         var _loc2_:Profiler = this.main.getProfiler();
         if(_loc2_ != null)
         {
            _loc2_.addFPS(this.currentFPS);
         }
         this.currentMem = Number(System.totalMemory * this.megaByteCoefficient);
         var _loc3_:* = this.currentMem.toFixed(2) + "MB";
         this.FPS.text = "FPS: " + this.currentFPS + " | MEM: " + _loc3_ + this.joinedParams;
         this.socketByteCount = 0;
         this.frameTicks = 0;
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         ++this.frameTicks;
      }
      
      public function setParam(param1:String, param2:String) : void
      {
         this.params[param1] = param2;
         this.joinParams();
      }
      
      public function unsetParam(param1:String) : void
      {
         delete this.params[param1];
         this.joinParams();
      }
      
      private function joinParams() : void
      {
         var _loc1_:String = null;
         this.joinedParams = "";
         for(_loc1_ in this.params)
         {
            this.joinedParams += " | " + _loc1_ + ": " + this.params[_loc1_];
         }
      }
   }
}


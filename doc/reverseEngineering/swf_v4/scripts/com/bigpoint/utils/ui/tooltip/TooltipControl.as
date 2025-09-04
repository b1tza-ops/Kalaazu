package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   
   public class TooltipControl
   {
      
      private static var _instance:TooltipControl;
      
      private var toolTipsList:Array;
      
      private var stickyToolTipsList:Array;
      
      private var stickyToolTipFlag:Boolean;
      
      private var bounds:Rectangle;
      
      private var scaleFactor:Number;
      
      private var t:Timer;
      
      public function TooltipControl(param1:Function)
      {
         var _loc2_:String = null;
         super();
         if(param1 !== hidden)
         {
            _loc2_ = "TooltipControl is a Singleton and can only be accessed through TooltipControl.getInstance()";
            throw new Error(_loc2_);
         }
         this.init();
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : TooltipControl
      {
         if(_instance == null)
         {
            _instance = new TooltipControl(hidden);
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.toolTipsList = [];
         this.stickyToolTipsList = [];
      }
      
      public function addToolTip(param1:InteractiveObject, param2:String) : ToolTipHook
      {
         if(param2.length < 1)
         {
            return null;
         }
         var _loc3_:ToolTipHook = new ToolTipHook(param1,param2);
         _loc3_.setBounds(this.bounds);
         this.toolTipsList.push(_loc3_);
         return _loc3_;
      }
      
      public function addStickyToolTip(param1:DisplayObject, param2:String, param3:int, param4:int, param5:int = 220) : StickyToolTipHook
      {
         if(param2.length < 1)
         {
            return null;
         }
         var _loc6_:StickyToolTipHook = new StickyToolTipHook(param1,param2,param3,param4,param5);
         _loc6_.setBounds(this.bounds);
         this.stickyToolTipsList.push(_loc6_);
         return _loc6_;
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      public function setScaleFactor(param1:Number) : void
      {
         this.scaleFactor = param1;
      }
      
      public function removeToolTip(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.toolTipsList.length)
         {
            if(ToolTipHook(this.toolTipsList[_loc2_]).getTargetObject() == param1)
            {
               ToolTipHook(this.toolTipsList[_loc2_]).suicide();
               this.toolTipsList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function hideAllToolTips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.toolTipsList.length)
         {
            if(this.toolTipsList[_loc1_] != undefined && this.toolTipsList[_loc1_] != null)
            {
               ToolTipHook(this.toolTipsList[_loc1_]).hideTooltip();
            }
            _loc1_++;
         }
      }
      
      public function showAllStickyToolTips() : void
      {
         this.t = new Timer(1000,1);
         this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.showAllStickyToolTips2);
         this.t.start();
      }
      
      public function showAllStickyToolTips2(param1:Event = null) : void
      {
         var _loc3_:StickyToolTipHook = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:SimpleWindow = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.stickyToolTipsList.length)
         {
            _loc3_ = StickyToolTipHook(this.stickyToolTipsList[_loc2_]);
            _loc4_ = _loc3_.getTargetObject();
            if(_loc4_ is SimpleWindow)
            {
               _loc5_ = SimpleWindow(_loc4_);
               if(_loc5_.isMaximized())
               {
                  StickyToolTipHook(this.stickyToolTipsList[_loc2_]).showTooltip();
               }
            }
            else
            {
               StickyToolTipHook(this.stickyToolTipsList[_loc2_]).showTooltip();
            }
            _loc2_++;
         }
         this.removeTimer();
      }
      
      private function removeTimer() : void
      {
         if(this.t != null)
         {
            this.t.stop();
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showAllStickyToolTips2);
            this.t = null;
         }
      }
      
      public function hideAllStickyToolTips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.stickyToolTipsList.length)
         {
            StickyToolTipHook(this.stickyToolTipsList[_loc1_]).hideTooltip();
            _loc1_++;
         }
      }
      
      public function toggleStickyToolTips() : void
      {
         if(!this.stickyToolTipFlag)
         {
            this.showAllStickyToolTips();
            this.stickyToolTipFlag = true;
         }
         else
         {
            this.hideAllStickyToolTips();
            this.stickyToolTipFlag = false;
            this.removeTimer();
         }
      }
      
      public function getScaleFactor() : Number
      {
         return this.scaleFactor;
      }
   }
}


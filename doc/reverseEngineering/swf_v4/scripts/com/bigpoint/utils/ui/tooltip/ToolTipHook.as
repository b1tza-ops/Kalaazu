package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Styles;
   
   public class ToolTipHook
   {
      
      private static var tooltipText:TextField;
      
      private static const MAX_TOOLTIP_WIDTH:int = 300;
      
      private static const SHOW_DELAY:int = 500;
      
      private static const HIDE_DELAY:int = 100;
      
      private var targetObject:InteractiveObject;
      
      private var text:String;
      
      private var t:Timer;
      
      private var toolTipVisible:Boolean;
      
      private var bounds:Rectangle;
      
      public var showImmediately:Boolean = false;
      
      public function ToolTipHook(param1:InteractiveObject, param2:String)
      {
         super();
         this.targetObject = param1;
         this.text = param2;
         this.targetObject.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      public function updateText(param1:String) : void
      {
         this.text = param1;
         if(this.toolTipVisible && tooltipText != null)
         {
            tooltipText.text = param1;
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(this.showImmediately)
         {
            this.showTooltip();
         }
         else
         {
            this.t = new Timer(SHOW_DELAY,1);
            this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t.start();
         }
      }
      
      private function onRollOut(param1:MouseEvent = null) : void
      {
         if(this.t != null)
         {
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t.stop();
            this.t = null;
         }
         if(this.toolTipVisible)
         {
            this.t = new Timer(HIDE_DELAY,1);
            this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.start();
         }
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      private function showTooltip(param1:TimerEvent = null) : void
      {
         var event:TimerEvent = param1;
         if(tooltipText == null)
         {
            this.createToolTipTextField();
         }
         tooltipText.text = this.text;
         this.updateTextFieldWidth();
         tooltipText.x = this.targetObject.stage.mouseX + 10;
         tooltipText.y = this.targetObject.stage.mouseY - tooltipText.height - 10;
         if(tooltipText.x + tooltipText.width > this.bounds.width)
         {
            tooltipText.x = this.targetObject.stage.mouseX - tooltipText.width - 10;
         }
         if(tooltipText.y - tooltipText.height < this.bounds.height)
         {
            tooltipText.y = this.targetObject.stage.mouseY + 10;
         }
         try
         {
            this.targetObject.stage.addChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      public function hideTooltip(param1:TimerEvent = null) : void
      {
         var event:TimerEvent = param1;
         if(this.t != null)
         {
            this.t.stop();
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t = null;
         }
         try
         {
            this.targetObject.stage.removeChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function hide2() : void
      {
         try
         {
            this.targetObject.stage.removeChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function getTargetObject() : InteractiveObject
      {
         return this.targetObject;
      }
      
      internal function suicide() : void
      {
         try
         {
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOut);
            this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         tooltipText = new TextField();
         tooltipText.defaultTextFormat = Styles.tooltipFmt;
         tooltipText.embedFonts = Styles.tooltipEmbed;
         tooltipText.autoSize = TextFieldAutoSize.LEFT;
         tooltipText.textColor = 13421772;
         tooltipText.backgroundColor = 0;
         tooltipText.background = true;
         tooltipText.antiAliasType = AntiAliasType.ADVANCED;
         tooltipText.selectable = false;
         tooltipText.text = this.text;
         tooltipText.mouseEnabled = false;
         return tooltipText;
      }
      
      private function updateTextFieldWidth() : void
      {
         tooltipText.wordWrap = false;
         tooltipText.multiline = false;
         tooltipText.autoSize = TextFieldAutoSize.LEFT;
         if(tooltipText.width > MAX_TOOLTIP_WIDTH)
         {
            tooltipText.width = MAX_TOOLTIP_WIDTH;
            tooltipText.wordWrap = true;
            tooltipText.multiline = true;
         }
      }
      
      public function getText() : String
      {
         return tooltipText.text;
      }
   }
}


package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.Styles;
   
   public class StickyToolTipHook
   {
      
      private static const SHOW_DELAY:int = 500;
      
      private static const HIDE_DELAY:int = 100;
      
      private var targetObject:DisplayObject;
      
      private var text:String;
      
      public var toolTipVisible:Boolean;
      
      private var MAX_TOOLTIP_WIDTH:int = 220;
      
      private var tooltipText:TextField;
      
      private var bounds:Rectangle;
      
      private var xGap:Number = 0;
      
      private var yGap:Number = 0;
      
      public function StickyToolTipHook(param1:DisplayObject, param2:String, param3:int, param4:int, param5:int)
      {
         super();
         this.targetObject = param1;
         this.text = param2;
         this.xGap = param3;
         this.yGap = param4;
         this.MAX_TOOLTIP_WIDTH = param5;
         this.createToolTipTextField();
      }
      
      public function updateText(param1:String) : void
      {
         this.text = param1;
         this.tooltipText.text = param1;
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      public function showTooltip() : void
      {
         this.tooltipText.x = this.targetObject.x + this.xGap + this.targetObject.stage.x;
         this.tooltipText.y = this.targetObject.y + this.yGap + this.targetObject.stage.y;
         try
         {
            this.targetObject.stage.addChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      public function showTooltip2() : void
      {
         this.tooltipText.x = this.targetObject.x;
         this.tooltipText.y = this.targetObject.y;
         try
         {
            this.targetObject.parent.addChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      public function hideTooltip(param1:TimerEvent = null) : void
      {
         var event:TimerEvent = param1;
         try
         {
            this.targetObject.stage.removeChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function hideTooltip2() : void
      {
         try
         {
            this.targetObject.parent.removeChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function getTargetObject() : DisplayObject
      {
         return this.targetObject;
      }
      
      public function suicide() : void
      {
         try
         {
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         this.tooltipText = new TextField();
         this.tooltipText.multiline = true;
         this.tooltipText.defaultTextFormat = Styles.tooltipFmt;
         this.tooltipText.embedFonts = Styles.tooltipEmbed;
         this.tooltipText.autoSize = TextFieldAutoSize.LEFT;
         this.tooltipText.textColor = 13421772;
         this.tooltipText.backgroundColor = 0;
         this.tooltipText.background = true;
         this.tooltipText.antiAliasType = AntiAliasType.ADVANCED;
         this.tooltipText.selectable = false;
         this.tooltipText.text = this.text;
         this.tooltipText.mouseEnabled = false;
         if(this.tooltipText.width > this.MAX_TOOLTIP_WIDTH)
         {
            this.tooltipText.width = this.MAX_TOOLTIP_WIDTH;
            this.tooltipText.wordWrap = true;
         }
         return this.tooltipText;
      }
   }
}


package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.net.models.techs.TechItem;
   import net.bigpoint.darkorbit.net.models.techs.TechNames;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.TechDefault;
   
   public class TechSlotElement extends SimpleElement
   {
      
      private static const logger:ILogger = Log.getLogger("TechSlotElement");
      
      private var slotBitmap:Bitmap;
      
      private var icon:Bitmap;
      
      private var hoverClip:Sprite;
      
      private var type:int;
      
      private var slotID:int;
      
      private var baseTooltipText:String;
      
      private var techDefault:TechDefault;
      
      public var secondsLeft:int = 0;
      
      public var isCountingDown:Boolean;
      
      public var handleClickCallBack:Function;
      
      private var toolTipHook:ToolTipHook;
      
      private var activeAnimationMask:Bitmap;
      
      public var cooldownSecondsLeft:int;
      
      private var isCoolingDown:Boolean;
      
      private var amountDisplay:TextField;
      
      private var main:Main;
      
      public function TechSlotElement(param1:Main)
      {
         super(SimpleElement.TYPE_TECH);
         this.main = param1;
         this.init();
         TweenPlugin.activate([ColorTransformPlugin]);
      }
      
      private function init() : void
      {
         this.slotBitmap = ResourceManager.getBitmap("techs","slot");
         addChild(this.slotBitmap);
         this.hoverClip = new Sprite();
         this.hoverClip.addChild(ResourceManager.getBitmap("techs","layer_hover"));
         this.hoverClip.alpha = 0;
         TweenLite.to(this.hoverClip,0.3,{"colorTransform":{
            "tint":15658734,
            "tintAmount":0.6
         }});
         this.baseTooltipText = BPLocale.getText("tech_slot_empty");
         this.toolTipHook = TooltipControl.getInstance().addToolTip(this,this.baseTooltipText);
      }
      
      public function update(param1:TechItem) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.slotID = param1.slot;
         if((param1.type == 0 || param1.status == TechItem.STATE_DEFAULT) && this.icon != null)
         {
            this.clear();
         }
         if(this.type != param1.type)
         {
            this.clear();
            this.type = param1.type;
         }
         if(this.type != 0 && param1.status != TechItem.STATE_DEFAULT)
         {
            this.techDefault = PatternManager.techDefaults[param1.type] as TechDefault;
            this.baseTooltipText = BPLocale.getText("tech_" + TechNames.getNameByType(this.type) + "_name");
            if(param1.status == TechItem.STATE_ACTIVE && this.techDefault.hasDuration)
            {
               this.baseTooltipText += "\n%TIME%";
            }
            if(this.icon != null && contains(this.icon))
            {
               removeChild(this.icon);
            }
            this.icon = ResourceManager.getBitmap("techs",this.techDefault.linkageID);
            addChildAt(this.icon,1);
            if(param1.status == TechItem.STATE_INACTIVE)
            {
               if(param1.hasRunningCooldown)
               {
                  this.icon.alpha = 0.4;
                  this.cooldownSecondsLeft = param1.cooldownSeconds;
                  this.baseTooltipText += "\n%TIME%";
                  if(this.cooldownSecondsLeft > 0 && !this.isCoolingDown)
                  {
                     this.isCoolingDown = true;
                     this.tickCooldown();
                  }
                  this.removeListeners();
               }
            }
            else if(param1.status == TechItem.STATE_READY)
            {
               this.icon.alpha = 1;
               if(!contains(this.hoverClip))
               {
                  addChild(this.hoverClip);
               }
               this.addListeners();
            }
            else
            {
               if(param1.status != TechItem.STATE_ACTIVE)
               {
                  this.icon.alpha = 0.4;
               }
               else
               {
                  if(!contains(this.hoverClip))
                  {
                     addChild(this.hoverClip);
                  }
                  this.hoverClip.alpha = 1;
                  TweenLite.to(this.icon,0.3,{"colorTransform":{
                     "tint":15658734,
                     "tintAmount":0.3
                  }});
                  TweenLite.to(this.hoverClip,0.3,{"glowFilter":{
                     "color":15658734,
                     "alpha":0.7,
                     "blurX":4,
                     "blurY":4
                  }});
                  this.secondsLeft = param1.secondsLeft + 1;
                  if(this.secondsLeft > 1 && !this.isCountingDown)
                  {
                     this.isCountingDown = true;
                     this.tick();
                  }
               }
               this.removeListeners();
            }
         }
         else
         {
            this.clear();
            this.baseTooltipText = BPLocale.getText("tech_state_" + TechItem.getNameByStatus(param1.status));
         }
         this.toolTipHook.updateText(this.baseTooltipText);
         this.updateAmountDisplay(param1.amount);
      }
      
      private function updateAmountDisplay(param1:int) : void
      {
         var _loc2_:TextFormat = null;
         var _loc3_:DropShadowFilter = null;
         if(this.amountDisplay == null)
         {
            _loc2_ = new TextFormat(Styles.logFmt.font,11,16777215);
            _loc3_ = new DropShadowFilter(1,0,1,1,1);
            _loc2_.align = TextFormatAlign.RIGHT;
            this.amountDisplay = new TextField();
            this.amountDisplay.height = Styles.logFontHeight + 5;
            this.amountDisplay.filters = [_loc3_];
            this.amountDisplay.mouseEnabled = false;
            this.amountDisplay.selectable = false;
            this.amountDisplay.defaultTextFormat = _loc2_;
            this.amountDisplay.embedFonts = Styles.logEmbed;
            this.amountDisplay.wordWrap = false;
            this.amountDisplay.antiAliasType = AntiAliasType.ADVANCED;
            this.amountDisplay.width = this.slotBitmap.width - 3;
            this.amountDisplay.text = "-";
            this.amountDisplay.y = this.slotBitmap.height - this.amountDisplay.height;
            addChild(this.amountDisplay);
         }
         if(param1 == 0)
         {
            this.amountDisplay.text = "";
         }
         else
         {
            this.amountDisplay.text = String(param1);
         }
      }
      
      private function addListeners() : void
      {
         this.hoverClip.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.hoverClip.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.hoverClip.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.hoverClip.buttonMode = true;
      }
      
      private function removeListeners() : void
      {
         this.hoverClip.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.hoverClip.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.hoverClip.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.hoverClip.buttonMode = false;
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(this.hoverClip,0.2,{"alpha":0});
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         TweenLite.to(this.hoverClip,0.2,{"alpha":1});
      }
      
      private function tick() : void
      {
         --this.secondsLeft;
         if(this.secondsLeft > 0)
         {
            TweenMax.delayedCall(1,this.tick);
         }
         else
         {
            this.isCountingDown = false;
         }
         this.toolTipHook.updateText(this.baseTooltipText.replace(/%TIME%/,TimeFormatter.formatTime(this.secondsLeft)));
      }
      
      private function tickCooldown() : void
      {
         this.toolTipHook.updateText(this.baseTooltipText.replace(/%TIME%/,TimeFormatter.formatTime(this.cooldownSecondsLeft)));
         --this.cooldownSecondsLeft;
         if(this.cooldownSecondsLeft > 0)
         {
            TweenMax.delayedCall(1,this.tickCooldown);
         }
         else
         {
            this.isCoolingDown = false;
         }
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(this.handleClickCallBack != null)
         {
            this.handleClickCallBack(this.slotID);
         }
      }
      
      private function clear() : void
      {
         if(this.icon != null)
         {
            removeChild(this.icon);
            this.icon = null;
         }
         TweenLite.killTweensOf(this.hoverClip);
         this.hoverClip.alpha = 0;
         this.removeListeners();
      }
   }
}


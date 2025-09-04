package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import mx.utils.StringUtil;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.BarStatus;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class InfoField extends SimpleElement
   {
      
      public static var FIELD_SEPERATOR:String = "|";
      
      public static var MODE_BAR:int = 0;
      
      public static var MODE_TEXT:int = 1;
      
      private var guiManager:GuiManager;
      
      private var icon:Bitmap;
      
      private var textField:TextField;
      
      private var viewMode:int = MODE_BAR;
      
      public var languageKey:String;
      
      private var textFieldWidth:int;
      
      private var barKeys:Array;
      
      private var counterBars:Array = [];
      
      private var barMask:Sprite = new Sprite();
      
      private var toolTipHook:ToolTipHook;
      
      private var bg:Bitmap;
      
      private var textColor:int;
      
      public var amountSearchPattern:RegExp;
      
      public function InfoField(param1:GuiManager, param2:int, param3:Bitmap, param4:int = -1, param5:Array = null, param6:String = null, param7:int = 0)
      {
         super(param2);
         this.guiManager = param1;
         this.icon = param3;
         if(param6 != null)
         {
            this.createTooltip(BPLocale.getText(param6));
         }
         this.languageKey = param6;
         this.barKeys = param5;
         this.textFieldWidth = param4;
         this.viewMode = param7;
         this.init();
      }
      
      public function setCounterbarVisibility(param1:int, param2:Boolean) : void
      {
         var _loc3_:Bitmap = this.counterBars[param1];
         _loc3_.visible = param2;
      }
      
      public function createTooltip(param1:String) : void
      {
         this.toolTipHook = TooltipControl.getInstance().addToolTip(this,param1);
      }
      
      public function updateIcon(param1:Bitmap) : void
      {
         this.removeChild(this.icon);
         this.icon = param1;
         this.addChild(this.icon);
      }
      
      public function setTextfieldPulse(param1:Number) : void
      {
         TweenMax.to(this.textField,param1,{
            "yoyo":true,
            "repeat":-1,
            "alpha":1,
            "ease":Linear.easeNone,
            "startAt":{"alpha":0.2}
         });
      }
      
      public function removeTextfieldPulse() : void
      {
         TweenMax.killTweensOf(this.textField);
         this.textField.alpha = 1;
      }
      
      public function init() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:String = null;
         var _loc3_:Bitmap = null;
         addChild(this.icon);
         if(id == TYPE_CLAN_RANKED_CLAN_POINTS)
         {
            _loc1_ = ResourceManager.getBitmap("ui","cbInfoIcon_timer");
            _loc1_.name = "CLOCK_ICON";
            _loc1_.x = this.icon.width + 5;
            _loc1_.visible = false;
            addChild(_loc1_);
         }
         this.textField = new TextField();
         this.textField.defaultTextFormat = Styles.infoFieldFmt;
         this.textField.embedFonts = Styles.infoFieldEmbed;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.mouseEnabled = false;
         this.textField.selectable = false;
         this.textColor = int(Styles.infoFieldFmt.color);
         if(this.textFieldWidth == -1)
         {
            this.textField.autoSize = TextFieldAutoSize.LEFT;
         }
         else
         {
            this.textField.width = this.textFieldWidth;
            this.textField.defaultTextFormat = Styles.infoFieldFixedFmt;
         }
         this.textField.textColor = this.textColor;
         this.textField.height = 20;
         this.textField.x = this.icon.width + 5;
         this.textField.y = 2;
         if(this.barKeys != null)
         {
            this.bg = ResourceManager.getBitmap("ui","bar_background");
            this.bg.x = this.icon.width + 5;
            this.bg.y = this.icon.height / 2 - 13 / 2;
            this.addChild(this.bg);
            this.barMask.graphics.beginFill(16777215);
            this.barMask.graphics.drawRect(0,0,62,14);
            this.barMask.graphics.endFill();
            this.barMask.x = this.icon.width + 5;
            this.barMask.y = this.icon.height / 2 - 13 / 2;
            this.addChild(this.barMask);
            for each(_loc2_ in this.barKeys)
            {
               _loc3_ = ResourceManager.getBitmap("ui",_loc2_);
               _loc3_.x = this.icon.width + 5;
               _loc3_.y = this.icon.height / 2 - _loc3_.height / 2;
               this.counterBars.push(_loc3_);
            }
            this.addEventListener(MouseEvent.CLICK,this.onClick);
            this.buttonMode = true;
            this.guiManager.setBarListInfoField(this);
         }
         if(id == TYPE_CONFIGURATION)
         {
            this.addEventListener(MouseEvent.CLICK,this.handleConfigurationChange);
            this.buttonMode = true;
         }
         this.updateView();
      }
      
      public function cleanup() : void
      {
         if(this.id == TYPE_CONFIGURATION)
         {
            this.removeEventListener(MouseEvent.CLICK,this.handleConfigurationChange);
         }
         if(this.toolTipHook != null)
         {
            TooltipControl.getInstance().removeToolTip(this);
         }
      }
      
      private function handleConfigurationChange(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Map = this.guiManager.getMain().screenManager.map;
         if(_loc2_ != null)
         {
            _loc3_ = Settings.selectedConfiguration;
            if(_loc3_ == 1)
            {
               _loc2_.getEventManager().selectConfiguration(2);
            }
            else if(_loc3_ == 2)
            {
               _loc2_.getEventManager().selectConfiguration(1);
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.viewMode == MODE_BAR)
         {
            this.viewMode = MODE_TEXT;
         }
         else if(this.viewMode == MODE_TEXT)
         {
            this.viewMode = MODE_BAR;
         }
         this.updateView();
         this.guiManager.saveBarView();
         var _loc2_:BarStatus = this.guiManager.getBarStatus(this.id);
         if(_loc2_ != null)
         {
            _loc2_.status = this.viewMode;
         }
      }
      
      public function getViewMode() : int
      {
         return this.viewMode;
      }
      
      public function updateView() : void
      {
         var _loc1_:Bitmap = null;
         if(this.viewMode == MODE_BAR && this.barKeys != null)
         {
            for each(_loc1_ in this.counterBars)
            {
               this.addChild(_loc1_);
               _loc1_.alpha = 0;
               TweenLite.to(_loc1_,0.25,{"alpha":1});
            }
            if(this.bg != null)
            {
               if(!this.contains(this.bg))
               {
                  this.addChild(this.bg);
                  this.setChildIndex(this.bg,0);
               }
            }
            if(this.contains(this.textField))
            {
               this.removeChild(this.textField);
            }
         }
         else
         {
            for each(_loc1_ in this.counterBars)
            {
               if(_loc1_ != null && this.contains(_loc1_))
               {
                  this.removeChild(_loc1_);
               }
            }
            if(this.bg != null)
            {
               if(this.contains(this.bg))
               {
                  this.removeChild(this.bg);
               }
            }
            addChild(this.textField);
            this.textField.alpha = 0;
            TweenMax.to(this.textField,0.25,{"alpha":1});
         }
         if(this.textFieldWidth == -1)
         {
            this.textField.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      public function setLabel(param1:String) : void
      {
         this.textField.text = StringUtil.trim(param1);
      }
      
      public function setColor(param1:int) : void
      {
         this.textColor = param1;
         this.textField.textColor = this.textColor;
      }
      
      public function setText(param1:String, param2:Boolean = true) : void
      {
         if(this.toolTipHook != null)
         {
            if(param2)
            {
               this.toolTipHook.updateText(BPLocale.getText(this.languageKey) + "\n" + param1);
            }
            else if(this.amountSearchPattern != null)
            {
               this.toolTipHook.updateText(BPLocale.getText(this.languageKey).replace(this.amountSearchPattern,param1));
            }
            else
            {
               this.toolTipHook.updateText(BPLocale.getText(this.languageKey));
            }
         }
      }
      
      public function updateTooltip(param1:String) : void
      {
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(param1);
         }
      }
      
      public function setCounterbar(param1:int, param2:int, param3:Boolean = true, param4:int = 0) : void
      {
         var _loc6_:Number = NaN;
         var _loc5_:Bitmap = this.counterBars[param4];
         _loc5_.mask = this.barMask;
         if(_loc5_ != null)
         {
            if(param2 == 0)
            {
               this.barMask.width = 62;
               return;
            }
            _loc6_ = param1 * 62 / param2;
            if(param3)
            {
               TweenLite.to(this.barMask,0.5,{"width":_loc6_});
            }
            else
            {
               this.barMask.width = _loc6_;
            }
         }
      }
   }
}


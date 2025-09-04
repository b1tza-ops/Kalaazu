package net.bigpoint.darkorbit.achievement
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.pattern.AchievementPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class AchievementElement extends SimpleElement
   {
      
      private static const USER_NOT_ELIGIBLE_YET:int = 0;
      
      private static const READY:int = 1;
      
      private static const USED:int = 2;
      
      private static const NO_OFFER:int = 3;
      
      private var background_active:Bitmap;
      
      private var priceField:Bitmap;
      
      private var background_inactive:Bitmap;
      
      private var achievement_grey:Bitmap;
      
      private var achievement_gold:Bitmap;
      
      private var button_inactive:Sprite;
      
      private var button_active:Bitmap;
      
      private var button_rollover:Bitmap;
      
      private var flashCount:int;
      
      public var questID:int;
      
      public var achievementDone:Boolean;
      
      public var bargainState:int;
      
      private var toolTipHook:ToolTipHook;
      
      private var achievementTextField:TextField;
      
      private var rewardTextField:TextField;
      
      public var _order:int = 0;
      
      public var achievementID:int;
      
      private var connectionManager:ConnectionManager;
      
      private var mouseOverSprite:Sprite;
      
      private var localPrice:Number;
      
      private var localCurrency:String;
      
      public function AchievementElement(param1:ConnectionManager, param2:int, param3:int, param4:Boolean, param5:int)
      {
         super(TYPE_ACHIEVEMENT);
         this.connectionManager = param1;
         this.achievementID = param2;
         this.questID = param3;
         this.achievementDone = param4;
         this.bargainState = param5;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:TextFormat = null;
         this.mouseOverSprite = new Sprite();
         this.mouseOverSprite.graphics.beginFill(16711680);
         if(this.bargainState == NO_OFFER)
         {
            this.background_active = ResourceManager.getBitmap("achievement","background_active_full.png");
            this.background_inactive = ResourceManager.getBitmap("achievement","background_inactive_full.png");
            this.mouseOverSprite.graphics.drawRect(0,0,this.background_inactive.width,this.background_inactive.height);
         }
         else
         {
            this.background_active = ResourceManager.getBitmap("achievement","background_active.png");
            this.background_inactive = ResourceManager.getBitmap("achievement","background_inactive.png");
            this.mouseOverSprite.graphics.drawRect(0,0,this.background_inactive.width,this.background_inactive.height);
         }
         this.addChild(this.background_inactive);
         if(this.achievementDone)
         {
            this.background_active.visible = true;
         }
         else
         {
            this.background_active.visible = false;
         }
         this.addChild(this.background_active);
         this.achievement_grey = ResourceManager.getBitmap("achievement","achievement_grey.png");
         this.achievement_grey.x = 4;
         this.achievement_grey.y = (this.background_active.height - this.achievement_grey.height) * 0.5 - 3;
         this.addChild(this.achievement_grey);
         this.achievement_gold = ResourceManager.getBitmap("achievement","achievement_gold.png");
         this.achievement_gold.x = this.achievement_grey.x;
         this.achievement_gold.y = (this.background_active.height - this.achievement_gold.height) * 0.5 - 3;
         if(this.achievementDone)
         {
            this.achievement_gold.visible = true;
         }
         else
         {
            this.achievement_gold.visible = false;
         }
         this.addChild(this.achievement_gold);
         if(this.bargainState != NO_OFFER)
         {
            this.button_inactive = new Sprite();
            this.button_inactive.addChild(ResourceManager.getBitmap("achievement","button_inactive.png"));
            if(this.bargainState == READY)
            {
               this.button_inactive.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
               this.button_inactive.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
               this.button_inactive.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
               this.button_inactive.buttonMode = true;
            }
            this.button_inactive.x = this.background_inactive.width - this.button_inactive.width - 5;
            this.button_inactive.y = this.background_inactive.height / 2 - this.button_inactive.height / 2 - 1;
            this.button_active = ResourceManager.getBitmap("achievement","button_active.png");
            this.button_active.x = this.button_inactive.x;
            this.button_active.y = this.button_inactive.y;
            if(this.bargainState != READY)
            {
               this.button_active.visible = false;
            }
            this.button_rollover = ResourceManager.getBitmap("achievement","button_rollover.png");
            this.button_rollover.x = this.button_inactive.x;
            this.button_rollover.y = this.button_inactive.y;
            this.button_rollover.visible = false;
         }
         _loc1_ = new TextFormat(Styles.logFmt.font,11,16777215);
         var _loc2_:DropShadowFilter = new DropShadowFilter(1,0,1,1,1);
         this.achievementTextField = new TextField();
         _loc1_.align = TextFormatAlign.LEFT;
         this.achievementTextField.defaultTextFormat = _loc1_;
         this.achievementTextField.embedFonts = Styles.logEmbed;
         this.achievementTextField.wordWrap = true;
         this.achievementTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.achievementTextField.autoSize = TextFieldAutoSize.LEFT;
         this.achievementTextField.width = 200;
         this.achievementTextField.selectable = false;
         this.achievementTextField.x = 40;
         this.achievementTextField.filters = [_loc2_];
         this.addChild(this.achievementTextField);
         this.rewardTextField = new TextField();
         _loc1_.align = TextFormatAlign.LEFT;
         this.rewardTextField.defaultTextFormat = _loc1_;
         this.rewardTextField.embedFonts = Styles.logEmbed;
         this.rewardTextField.wordWrap = true;
         this.rewardTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.rewardTextField.autoSize = TextFieldAutoSize.LEFT;
         this.rewardTextField.width = 104;
         this.rewardTextField.selectable = false;
         this.rewardTextField.x = 260;
         this.rewardTextField.filters = [_loc2_];
         this.addChild(this.rewardTextField);
         this.mouseOverSprite.alpha = 0;
         this.addChild(this.mouseOverSprite);
         if(this.bargainState != NO_OFFER)
         {
            this.addChild(this.button_inactive);
            this.addChild(this.button_active);
            this.addChild(this.button_rollover);
         }
         this.updatePriceField();
      }
      
      public function updatePriceField() : void
      {
         var _loc1_:AchievementPattern = null;
         var _loc2_:uint = 0;
         var _loc3_:TextFormat = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TextField = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Matrix = null;
         if(this.bargainState != NO_OFFER)
         {
            _loc1_ = PatternManager.achievementPatterns[this.achievementID];
            if(_loc1_ == null)
            {
               return;
            }
            if(this.priceField != null && this.contains(this.priceField))
            {
               this.removeChild(this.priceField);
            }
            _loc2_ = 9539985;
            if(this.bargainState == READY)
            {
               _loc2_ = 15646765;
            }
            _loc3_ = new TextFormat(Styles.achievementOfferFmt.font,24,_loc2_,true);
            _loc3_.align = TextFormatAlign.CENTER;
            if(_loc1_.priceValue <= 0)
            {
               _loc4_ = BPLocale.getText("label_buy_achievement_reward_no_price");
            }
            else
            {
               this.localPrice = _loc1_.priceValue;
               this.localCurrency = _loc1_.priceCurrency;
               _loc4_ = BPLocale.replaceWithFormattedPrice(this.localPrice,this.localCurrency,/%PRICE(.*?)%/,BPLocale.getText("label_buy_achievement_reward"));
            }
            _loc5_ = _loc4_.split("\n");
            _loc6_ = 16;
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc8_ = new TextField();
               _loc8_.defaultTextFormat = _loc3_;
               _loc8_.embedFonts = Styles.simpleEmbed;
               _loc8_.text = _loc5_[_loc7_];
               _loc8_.wordWrap = true;
               _loc8_.multiline = true;
               _loc8_.width = 96;
               _loc8_.autoSize = TextFieldAutoSize.CENTER;
               _loc8_.antiAliasType = AntiAliasType.ADVANCED;
               _loc9_ = new BitmapData(_loc8_.width / 2,_loc8_.height / 2,true,0);
               _loc10_ = new Matrix();
               _loc10_.identity();
               _loc10_.scale(0.5,0.5);
               _loc9_.draw(_loc8_,_loc10_);
               this.priceField = new Bitmap(_loc9_);
               this.priceField.x = this.button_active.x + (this.button_active.width - this.priceField.width) * 0.5 - 1;
               this.priceField.y = _loc6_;
               _loc6_ += this.priceField.height - 4;
               this.addChild(this.priceField);
               _loc7_++;
            }
         }
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openPayment","ACHIEVEMENT",this.achievementID);
         }
      }
      
      public function setAchievementText(param1:String, param2:String) : void
      {
         this.achievementTextField.text = BPLocale.getText(param1) + "\n" + BPLocale.getText(param2);
         this.achievementTextField.y = this.background_active.height / 2 - this.achievementTextField.height / 2;
      }
      
      public function setRewardText(param1:String) : void
      {
         this.rewardTextField.text = BPLocale.getText("title_reward") + "\n" + BPLocale.getText(param1);
         this.rewardTextField.y = this.background_active.height / 2 - this.rewardTextField.height / 2;
      }
      
      public function setTooltip(param1:String) : void
      {
         this.toolTipHook = TooltipControl.getInstance().addToolTip(this.mouseOverSprite,BPLocale.getText(param1));
      }
      
      public function activateBackground() : void
      {
         if(!this.background_active.visible)
         {
            this.background_active.alpha = 0;
            this.background_active.visible = true;
            TweenLite.to(this.background_active,0.25,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
      }
      
      public function cleanup() : void
      {
         TooltipControl.getInstance().removeToolTip(this.mouseOverSprite);
         if(this.button_inactive != null)
         {
            this.button_inactive.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            this.button_inactive.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            this.button_inactive.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         }
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.button_rollover.alpha = 0;
         this.button_rollover.visible = true;
         TweenLite.to(this.button_rollover,0.25,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(this.button_rollover.visible)
         {
            TweenLite.to(this.button_rollover,0.25,{
               "ease":Linear.easeNone,
               "alpha":0,
               "onComplete":this.setDisplayObjectVisibility,
               "onCompleteParams":[this.button_rollover,false]
            });
         }
      }
      
      private function setDisplayObjectVisibility(param1:DisplayObject, param2:Boolean) : void
      {
         param1.visible = param2;
      }
      
      public function deactivateBackground() : void
      {
         TweenLite.to(this.background_active,0.25,{
            "ease":Linear.easeNone,
            "alpha":0,
            "onComplete":this.setBitmapInvisible,
            "onCompleteParams":[this.background_active]
         });
      }
      
      private function setBitmapInvisible(param1:Bitmap) : void
      {
         param1.visible = false;
      }
      
      public function deactivate() : void
      {
         this.achievementDone = false;
         this.flashCount = 0;
         TweenMax.killTweensOf(this.achievement_gold);
         if(this.achievement_gold.visible)
         {
            this.fadeOutStar();
         }
      }
      
      public function activate(param1:int = 4) : void
      {
         this.achievementDone = true;
         this.flashCount = param1;
         this.achievement_gold.alpha = 0;
         this.achievement_gold.visible = true;
         TweenLite.to(this.achievement_gold,0.25,{
            "ease":Linear.easeNone,
            "alpha":1,
            "onComplete":this.handleFlashSymbol
         });
         this.background_active.alpha = 0;
         this.background_active.visible = true;
         TweenLite.to(this.background_active,0.25,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      private function handleFlashSymbol() : void
      {
         if(this.flashCount == -1 || this.flashCount > 1)
         {
            this.fadeOutStar();
         }
      }
      
      private function fadeOutStar() : void
      {
         TweenLite.to(this.achievement_gold,0.25,{
            "ease":Linear.easeNone,
            "alpha":0,
            "onComplete":this.handleFlashSymbol2
         });
         TweenLite.to(this.background_active,0.25,{
            "ease":Linear.easeNone,
            "alpha":0
         });
      }
      
      private function handleFlashSymbol2() : void
      {
         this.achievement_gold.visible = false;
         this.background_active.visible = false;
         if(this.flashCount == -1)
         {
            this.activate(this.flashCount);
         }
         else if(this.flashCount > 1)
         {
            --this.flashCount;
            this.activate(this.flashCount);
         }
      }
      
      public function update(param1:Boolean, param2:int) : void
      {
         if(this.achievementDone != param1)
         {
            if(param1)
            {
               this.activate(4);
            }
            else
            {
               this.deactivate();
            }
         }
      }
      
      public function get order() : int
      {
         return this._order;
      }
      
      public function set order(param1:int) : void
      {
         this._order = param1;
      }
      
      private function formatPrice() : String
      {
         var _loc2_:String = null;
         var _loc8_:Boolean = false;
         var _loc3_:* = "isoprice";
         var _loc4_:String = "%CODE%";
         var _loc5_:* = "isocode";
         var _loc6_:String = "";
         var _loc7_:String = arguments[1];
         if(_loc7_.length > 0)
         {
            if(_loc7_.charAt(0) == "|")
            {
               _loc7_ = _loc7_.substring(1,_loc7_.length);
            }
            _loc6_ = _loc7_;
            if(_loc6_.search(/WORD/) > -1)
            {
               _loc3_ = "price_word";
               _loc4_ = "%WORD%";
               _loc5_ = "word";
               if(_loc6_.search(/CAPS/) > -1)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc6_.search(/ISO/) > -1)
            {
               _loc3_ = "isoprice";
               _loc4_ = "%CODE%";
               _loc5_ = "isocode";
            }
            else if(_loc6_.search(/SYMBOL/) > -1)
            {
               _loc3_ = "pricetag_symbol";
               _loc4_ = "%SYMBOL%";
               _loc5_ = "symbol";
            }
         }
         if(this.localPrice < 1 && _loc4_ != "%CODE%")
         {
            _loc3_ += "_sub";
            _loc5_ += "sub";
         }
         if(_loc8_)
         {
            _loc5_ += "caps";
         }
         _loc2_ = BPLocale.getText(_loc3_);
         var _loc9_:String = "currency_" + _loc5_ + "_" + this.localCurrency;
         _loc2_ = _loc2_.replace(_loc4_,BPLocale.getText(_loc9_));
         _loc2_ = _loc2_.replace(/%FULL%/,BPLocale.roundInteger(Math.floor(this.localPrice)));
         var _loc10_:String = this.localPrice.toFixed(2);
         return _loc2_.replace(/%SUB%/,_loc10_.substring(_loc10_.indexOf(".") + 1,_loc10_.length));
      }
   }
}


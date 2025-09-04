package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.pattern.BannerAdPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class BannerAd extends Sprite
   {
      
      public static const CLOSE_BANNER_WINDOW:String = "CLOSE_BANNER_WINDOW";
      
      private var pattern:BannerAdPattern;
      
      public var bannerAdClip:MovieClip;
      
      public var sizerClip:MovieClip;
      
      private var buttonIdleClip:MovieClip;
      
      private var buttonStd:MovieClip;
      
      private var contentWidth:int;
      
      private var contentHeight:int;
      
      private var footerPaddingX:int = 5;
      
      private var footerPaddingY:int = 5;
      
      private var callBack:Function;
      
      public var allTextsWrapper:DisplayObject;
      
      public function BannerAd(param1:BannerAdPattern)
      {
         super();
         this.pattern = param1;
         var _loc2_:String = param1.getSWFLibID();
         this.bannerAdClip = ResourceManager.getMovieClip(_loc2_,"bannerAd");
         this.sizerClip = ResourceManager.getMovieClip(_loc2_,"sizer");
         this.init();
      }
      
      private function init() : void
      {
         ScreenManager.playAnimation(this.bannerAdClip,24,false,1,false);
         var _loc1_:DisplayObject = this.bannerAdClip.getChildByName("slotFlashesClip");
         if(_loc1_ != null)
         {
            ScreenManager.playAnimation(_loc1_ as MovieClip,24,true,1,false);
         }
         this.setTexts();
         this.initClickArea();
      }
      
      private function initClickArea() : void
      {
         var _loc1_:DisplayObject = this.bannerAdClip.getChildByName("clickButton");
         if(_loc1_ != null)
         {
            this.buttonIdleClip = _loc1_["buttonIdleClip"] as MovieClip;
            this.buttonIdleClip.mouseEnabled = false;
            this.buttonIdleClip.mouseChildren = false;
            this.buttonStd = _loc1_["buttonStdClip"] as MovieClip;
            this.buttonStd.buttonMode = true;
            this.buttonStd.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
            this.buttonStd.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            this.buttonStd.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            this.startBlinking();
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(this.buttonIdleClip,0.25,{
            "alpha":1,
            "onComplete":this.startBlinking
         });
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.stopBlinking();
      }
      
      private function startBlinking() : void
      {
         TweenMax.to(this.buttonIdleClip,0.5,{
            "alpha":0,
            "yoyo":true,
            "repeat":9
         });
      }
      
      private function stopBlinking() : void
      {
         TweenMax.killTweensOf(this.buttonIdleClip);
         TweenLite.to(this.buttonIdleClip,0.25,{"alpha":0});
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openPayment","SPECIALOFFER",this.pattern.id);
         }
         TweenMax.delayedCall(2,this.closeBannerAd);
      }
      
      private function closeBannerAd() : void
      {
         dispatchEvent(new Event(CLOSE_BANNER_WINDOW));
      }
      
      public function overrideMouseClick(param1:Function) : void
      {
         if(this.buttonStd.hasEventListener(MouseEvent.CLICK))
         {
            this.buttonStd.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         }
         this.callBack = param1;
         this.buttonStd.addEventListener(MouseEvent.CLICK,this.overriddenHandleMouseClick);
      }
      
      private function overriddenHandleMouseClick(param1:MouseEvent) : void
      {
         this.callBack.call();
      }
      
      public function setButtonText(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:TextField = null;
         var _loc2_:DisplayObject = this.bannerAdClip.getChildByName("buttonLabelWrapper");
         if(_loc2_ != null)
         {
            if((_loc2_ as MovieClip).getChildByName("label") != null)
            {
               _loc3_ = BPLocale.getText(param1);
               _loc4_ = (_loc2_ as MovieClip).getChildByName("label") as TextField;
               _loc4_.autoSize = TextFieldAutoSize.CENTER;
               _loc4_.text = _loc3_;
            }
         }
      }
      
      private function setTexts() : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:TextFormat = null;
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         this.allTextsWrapper = this.bannerAdClip.getChildByName("allTextsWrapper");
         var _loc1_:String = this.pattern.getImageLibID(Settings.language);
         if(this.allTextsWrapper != null)
         {
            if(ResourceManager.fileCollection.isLoaded(_loc1_))
            {
               _loc3_ = ResourceManager.getImage(_loc1_) as Bitmap;
               this.contentWidth = _loc3_.width;
               this.contentHeight = _loc3_.height;
               (this.allTextsWrapper as MovieClip).addChild(_loc3_);
               (this.allTextsWrapper as MovieClip).mouseEnabled = false;
               (this.allTextsWrapper as MovieClip).mouseChildren = false;
            }
         }
         var _loc2_:DisplayObject = this.bannerAdClip.getChildByName("buttonLabelWrapper");
         if(_loc2_ != null)
         {
            if((_loc2_ as MovieClip).getChildByName("label") != null)
            {
               (_loc2_ as MovieClip).mouseEnabled = false;
               (_loc2_ as MovieClip).mouseChildren = false;
               _loc5_ = (_loc2_ as MovieClip).getChildByName("label") as TextField;
               _loc5_.embedFonts = Styles.baseEmbed;
               _loc4_ = _loc5_.defaultTextFormat;
               _loc4_.font = Styles.baseFont;
               _loc5_.antiAliasType = AntiAliasType.ADVANCED;
               _loc5_.defaultTextFormat = _loc4_;
               _loc5_.selectable = false;
               _loc6_ = BPLocale.getText("btn_label_bannerad_" + this.pattern.baseKey);
               _loc6_ = BPLocale.replaceWithFormattedPrice(this.pattern.price,Settings.currency,/%PRICE(.*?)%/,_loc6_);
               _loc5_.text = _loc6_;
               _loc7_ = _loc5_.width;
               _loc5_.multiline = false;
               _loc5_.wordWrap = false;
               _loc5_.autoSize = TextFieldAutoSize.LEFT;
               if(_loc5_.width > _loc7_)
               {
                  _loc5_.scaleX *= _loc7_ / _loc5_.width;
               }
               else
               {
                  _loc5_.x += int((_loc7_ - _loc5_.width) * 0.5);
               }
               _loc5_.mouseEnabled = false;
            }
         }
         if(this.pattern.footerKey != null)
         {
            this.setFooterText();
         }
      }
      
      private function setFooterText() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter(1,45,0,0.8,1,1,1,3,false,false,false);
         var _loc2_:TextFormat = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFontHeight);
         _loc2_.align = TextFormatAlign.CENTER;
         _loc2_.color = 14540253;
         _loc2_.leading = 1;
         var _loc3_:TextField = new TextField();
         _loc3_.mouseEnabled = false;
         _loc3_.selectable = false;
         _loc3_.antiAliasType = AntiAliasType.ADVANCED;
         _loc3_.width = this.contentWidth - 2 * this.footerPaddingX;
         _loc3_.height = Styles.plainStdFontHeight;
         _loc3_.embedFonts = Styles.plainStdEmbed;
         _loc3_.filters = [_loc1_];
         _loc3_.defaultTextFormat = _loc2_;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         _loc3_.text = BPLocale.getText(this.pattern.footerKey);
         this.bannerAdClip.addChild(_loc3_);
         _loc3_.x = this.footerPaddingX;
         _loc3_.y = this.bannerAdClip.height - _loc3_.height;
         _loc3_.alpha = 0;
         TweenLite.to(_loc3_,0.25,{
            "alpha":1,
            "delay":2
         });
      }
      
      public function cleanup() : void
      {
         TweenMax.killTweensOf(this.bannerAdClip);
         if(this.buttonIdleClip != null)
         {
            TweenMax.killTweensOf(this.buttonIdleClip);
         }
         var _loc1_:DisplayObject = this.bannerAdClip.getChildByName("slotFlashesClip");
         if(_loc1_ != null)
         {
            TweenMax.killTweensOf(_loc1_);
         }
      }
   }
}


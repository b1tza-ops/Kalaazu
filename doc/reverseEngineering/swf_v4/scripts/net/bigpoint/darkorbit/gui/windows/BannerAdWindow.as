package net.bigpoint.darkorbit.gui.windows
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.BannerAd;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.lazyload.BannerAdLazyLoader;
   import net.bigpoint.darkorbit.pattern.BannerAdPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class BannerAdWindow extends SimpleWindow
   {
      
      public static const BANNERAD_X_BORDER:int = 10;
      
      public static const BANNERAD_Y_BORDER:int = 30;
      
      public var startX:int = 0;
      
      public var startY:int = 0;
      
      public var targetX:int = 0;
      
      public var targetY:int = 0;
      
      public var align:String = "n";
      
      public var scrollSpeed:Number = 0.5;
      
      private var simpleContainer:SimpleContainer;
      
      public var bannerAdId:int;
      
      private var noiseChannel:SoundChannel;
      
      private var valid:Boolean;
      
      private var bannerAdPattern:BannerAdPattern;
      
      private var loader:BannerAdLazyLoader;
      
      private var price:Number;
      
      private var enumKey:String;
      
      private var bannerAd:BannerAd;
      
      public function BannerAdWindow(param1:GuiManager, param2:int, param3:String, param4:String)
      {
         super(param1,param2,SWFFinisher(ResourceManager.fileCollection.getFinisher("window1")),false,true,false,true,false,false,SimpleWindow.SLOT_TYPE_NO_SLOT,true,"comb02_std.png","comb02_hover.png",SimpleWindow.WINDOW_TYPE_NORMAL,false);
         this.align = param4;
         this.enumKey = param3;
         this.bannerAdPattern = PatternManager.bannerAdPatterns[param3] as BannerAdPattern;
         this.bannerAdId = this.bannerAdPattern.id;
         this.price = this.bannerAdPattern.price;
         this.loader = new BannerAdLazyLoader(this.bannerAdPattern);
         if(this.price == -1)
         {
            BannerAdLazyLoader.loadBannerAdPatternAddon();
         }
      }
      
      public function init() : void
      {
         this.simpleContainer = new SimpleContainer(guiManager,SimpleContainer.CLASS_DEFAULT);
         addContainer(this.simpleContainer);
         this.simpleContainer.x = 15;
         this.simpleContainer.y = 35;
         var _loc1_:Point = dimensions[0];
         var _loc2_:int = _loc1_.x;
         var _loc3_:int = _loc1_.y;
         switch(this.align)
         {
            case "n":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = -_loc3_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = 5;
               break;
            case "ne":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = 5;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = 5;
               break;
            case "e":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               break;
            case "se":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "s":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = ScreenManager.getScreenHeight() - 10;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "sw":
               this.startX = -_loc2_ - 10;
               this.startY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               this.targetX = 5;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "w":
               this.startX = -_loc2_ - 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               this.targetX = 5;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               break;
            case "nw":
               this.startX = -_loc2_ - 10;
               this.startY = 5;
               this.targetX = 5;
               this.targetY = 5;
               break;
            case "c":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = -_loc3_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
         }
         this.x = this.startX;
         this.y = this.startY;
         ScreenManager.getWindowLayer().addChild(this);
      }
      
      public function attemptToShow() : void
      {
         var _loc1_:String = this.bannerAdPattern.getImageLibID(Settings.language);
         if(!this.loader.isLoaded())
         {
            this.loader.addEventListener(BannerAdLazyLoader.BANNERAD_LOADED,this.addBanner);
            this.loader.loadBannerAd();
         }
         else
         {
            this.addBanner();
         }
      }
      
      private function addBanner(param1:Event = null) : void
      {
         if(this.loader.hasEventListener(BannerAdLazyLoader.BANNERAD_LOADED))
         {
            this.loader.removeEventListener(BannerAdLazyLoader.BANNERAD_LOADED,this.addBanner);
         }
         this.bannerAd = new BannerAd(this.bannerAdPattern);
         this.bannerAd.addEventListener(BannerAd.CLOSE_BANNER_WINDOW,this.closeBannerAd);
         addWindowDimension(new Point(this.bannerAd.sizerClip.width + BANNERAD_X_BORDER,this.bannerAd.sizerClip.height + BANNERAD_Y_BORDER));
         setPredefinedDimension();
         this.show();
         this.simpleContainer.addElement(this.bannerAd.bannerAdClip);
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         guiManager.getMain().getConnectionManager().sendCommand("UI|WD|AD|" + this.bannerAdPattern.paymentKey);
         this.bannerAd.cleanup();
      }
      
      private function closeBannerAd(param1:Event = null) : void
      {
         guiManager.closeWindow(this);
      }
      
      private function show() : void
      {
         this.init();
         this.x = this.startX;
         this.y = this.startY;
         TweenLite.to(this,this.scrollSpeed,{
            "x":this.targetX,
            "y":this.targetY,
            "onComplete":this.handleShowComplete
         });
      }
      
      public function hide() : void
      {
         this.valid = false;
         this.x = this.targetX;
         this.y = this.targetY;
         TweenLite.to(this,this.scrollSpeed,{
            "ease":Linear.easeNone,
            "x":this.startX,
            "y":this.startY,
            "onComplete":this.handleHideComplete
         });
         this.noiseChannel = AudioManager.playSoundEffect(42);
         TweenMax.delayedCall(0.25,this.stopSound);
      }
      
      private function stopSound() : void
      {
         if(this.noiseChannel != null)
         {
            AudioManager.removeLoop(this.noiseChannel);
         }
      }
      
      private function handleHideComplete() : void
      {
         this.simpleContainer.removeAllElements();
         this.cleanup();
      }
      
      private function handleShowComplete() : void
      {
         this.noiseChannel = AudioManager.playSoundEffect(42);
         TweenMax.delayedCall(0.25,this.stopSound);
      }
   }
}


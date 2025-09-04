package net.bigpoint.darkorbit.lensflare
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class LensflareManager
   {
      
      private var map:Map;
      
      private var lensflares:Array = [];
      
      private var camera:Point;
      
      public var speedX:Number;
      
      public var speedY:Number;
      
      public var halfScreenWidth:Number;
      
      public var halfScreenHeight:Number;
      
      private var timer:Timer;
      
      private var fps:int = 25;
      
      public function LensflareManager(param1:Map)
      {
         super();
         this.map = param1;
         this.camera = ScreenManager.camera;
         this.halfScreenWidth = ScreenManager.halfScreenWidth;
         this.halfScreenHeight = ScreenManager.halfScreenHeight;
         this.timer = new Timer(1000 / this.fps,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.timer.start();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc3_:LensFlare = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.lensflares.length)
         {
            _loc3_ = this.lensflares[_loc2_];
            if(_loc3_ != null && _loc3_.visible)
            {
               _loc3_.x = -this.camera.x / _loc3_.pFactor + this.halfScreenWidth + _loc3_.xGap;
               _loc3_.y = -this.camera.y / _loc3_.pFactor + this.halfScreenHeight + _loc3_.yGap;
               _loc4_ = this.camera.x / _loc3_.pFactor + this.halfScreenWidth - _loc3_.xGap;
               _loc5_ = this.camera.y / _loc3_.pFactor + this.halfScreenHeight - _loc3_.yGap;
               _loc3_.updateLens(_loc4_,_loc5_);
               if(_loc3_.star != null && this.speedX != 0 && this.speedY != 0)
               {
                  _loc3_.rotate();
               }
            }
            _loc2_++;
         }
      }
      
      public function createLensFlare(param1:int, param2:int, param3:int, param4:Number, param5:Boolean = false, param6:int = 0) : void
      {
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         var _loc7_:LensFlare = new LensFlare(this,param1,param2 * 10,param3 * 10,new Rectangle(0,0,this.map.getMain().screenManager.getScaledScreenWidth(),this.map.getMain().screenManager.getScaledScreenHeight()),param4);
         var _loc8_:ResourcePattern = PatternManager.lensflarePatterns[int(param6)];
         var _loc9_:String = _loc8_.getResKey();
         var _loc10_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc9_));
         if(param5)
         {
            _loc12_ = MovieClip(_loc10_.getEmbededMovieClip("star"));
            _loc7_.addStar(_loc12_);
         }
         _loc7_.addCollisionDetection();
         var _loc11_:int = 0;
         while(_loc11_ < 6)
         {
            _loc13_ = MovieClip(_loc10_.getEmbededMovieClip("lens" + _loc11_));
            _loc7_.addLensFlare(_loc13_);
            _loc11_++;
         }
         if(Settings.qualityBackground <= Settings.QUALITY_MEDIUM)
         {
            _loc7_.visible = false;
         }
         this.lensflares.push(_loc7_);
         _loc7_.initLensflare();
         this.map.getMain().screenManager.getLensflareLayer().addChild(_loc7_);
      }
      
      public function updateLensflareQuality(param1:int) : void
      {
         var _loc2_:LensFlare = null;
         if(Settings.qualityBackground != param1)
         {
            for each(_loc2_ in this.lensflares)
            {
               if(_loc2_ != null)
               {
                  switch(Settings.qualityBackground)
                  {
                     case Settings.QUALITY_LOW:
                     case Settings.QUALITY_MEDIUM:
                        _loc2_.visible = false;
                        break;
                     case Settings.QUALITY_GOOD:
                     case Settings.QUALITY_HIGH:
                        _loc2_.visible = true;
                        break;
                  }
               }
            }
         }
      }
      
      public function cleanup() : void
      {
         var _loc2_:LensFlare = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.lensflares.length)
         {
            _loc2_ = this.lensflares[_loc1_];
            _loc2_.cleanup();
            this.map.getMain().screenManager.getLensflareLayer().removeChild(_loc2_);
            _loc1_++;
         }
         this.lensflares = [];
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         }
         this.map = null;
      }
      
      public function getMap() : Map
      {
         return this.map;
      }
   }
}


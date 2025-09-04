package net.bigpoint.darkorbit.fireworks
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.FireworkPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class FireworksManager
   {
      
      public static const FIREWORK_SMALL:int = 0;
      
      public static const FIREWORK_MEDIUM:int = 1;
      
      public static const FIREWORK_LARGE:int = 2;
      
      public static const logger:ILogger = Log.getLogger("FireworksManager");
      
      private var map:Map;
      
      private var colorsHashmap:Array;
      
      private var independenceDayAssetsLoaded:Boolean;
      
      private var useBitmapClip:Boolean;
      
      public function FireworksManager(param1:Map)
      {
         super();
         this.map = param1;
         this.updateColorsHashmap();
      }
      
      public function showFirework(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Array = this.getResKeys(param1);
         this.attachClip(this.map.getMain().screenManager.getExplosionLayer(),_loc4_,param2,param3);
      }
      
      public function updateColorsHashmap() : void
      {
         var _loc1_:Array = null;
         if(Settings.fireworksModeIndependenceDay)
         {
            if(this.independenceDayAssetsLoaded)
            {
               this.colorsHashmap = ["null","independence_day","independence_day","independence_day"];
               this.useBitmapClip = (PatternManager.fireworkPatterns[0] as FireworkPattern).useBitmapClip;
               return;
            }
            _loc1_ = ["firework_small_independence_day","firework_medium_independence_day","firework_large_independence_day"];
            new FireworksAddons().load(_loc1_,this.handleAddonAssetsLoaded);
            if(this.independenceDayAssetsLoaded)
            {
               return;
            }
         }
         this.colorsHashmap = ["null","red","blue","green"];
         this.useBitmapClip = false;
      }
      
      private function handleAddonAssetsLoaded() : void
      {
         this.independenceDayAssetsLoaded = true;
         this.updateColorsHashmap();
      }
      
      private function getResKeys(param1:int) : Array
      {
         var _loc2_:Array = ["firework_","firework_"];
         var _loc3_:int = int(param1 / 100);
         var _loc4_:int = param1 % 10;
         var _loc5_:int = (param1 - _loc3_ * 100 - _loc4_) / 10;
         if(param1 > 300)
         {
            _loc2_[0] += "large_";
            _loc2_[1] += "medium_";
            _loc2_[2] = "firework_large_";
         }
         else if(param1 > 200)
         {
            _loc2_[0] += "small_";
            _loc2_[1] += "medium_";
         }
         else
         {
            _loc2_[0] += "small_";
            _loc2_[1] += "small_";
         }
         if(param1 > 300)
         {
            _loc2_[0] += this.colorsHashmap[_loc3_ - 2];
            _loc2_[1] += this.colorsHashmap[_loc5_];
            _loc2_[2] += this.colorsHashmap[_loc4_];
         }
         else
         {
            _loc2_[0] += this.colorsHashmap[_loc5_];
            _loc2_[1] += this.colorsHashmap[_loc4_];
         }
         return _loc2_;
      }
      
      private function attachClip(param1:Sprite, param2:Array, param3:int, param4:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(param2.length > 0)
         {
            _loc5_ = param2.shift();
            if(this.useBitmapClip)
            {
               _loc6_ = new BitmapClip(ResourceManager.getMovieClip(_loc5_,"mc"),_loc5_);
               _loc7_ = (_loc6_ as BitmapClip).framesLoaded;
            }
            else
            {
               _loc6_ = ResourceManager.getMovieClip(_loc5_,"mc");
               (_loc6_ as MovieClip).mouseEnabled = Main.mouseEventsEnabled;
               (_loc6_ as MovieClip).mouseChildren = Main.mouseEventsEnabled;
               _loc7_ = (_loc6_ as MovieClip).framesLoaded;
            }
            _loc6_.x = param3;
            _loc6_.y = param4;
            param1.addChild(_loc6_);
            _loc8_ = _loc7_ / 30;
            TweenLite.to(_loc6_,_loc8_,{
               "ease":Linear.easeNone,
               "frame":_loc7_,
               "onComplete":this.handleAnimationFinished,
               "onCompleteParams":[_loc6_,param2,param3,param4]
            });
            AudioManager.playSoundEffect(34);
         }
      }
      
      private function handleAnimationFinished(param1:DisplayObject, param2:Array, param3:int, param4:int) : void
      {
         var _loc5_:Sprite = param1.parent as Sprite;
         _loc5_.removeChild(param1);
         this.attachClip(_loc5_,param2,param3,param4);
      }
   }
}


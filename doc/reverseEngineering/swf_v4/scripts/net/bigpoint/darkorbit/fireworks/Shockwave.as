package net.bigpoint.darkorbit.fireworks
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ShockwavePattern;
   
   public class Shockwave extends Sprite
   {
      
      private static var shockwaveBitmaps:Array = [];
      
      private static var coordMultiplier:Array = [];
      
      private var map:Map;
      
      private var shockwaveID:int;
      
      public var radius:int = 300;
      
      public var duration:Number = 2;
      
      public var beginScale:Number = 1;
      
      public var endScale:Number = 0.3;
      
      public var maxShockwaves:int = 40;
      
      public var shakeScreen:Boolean = true;
      
      public function Shockwave(param1:Map, param2:int)
      {
         super();
         this.map = param1;
         this.shockwaveID = param2;
         var _loc3_:ShockwavePattern = PatternManager.shockwavePatterns[param2];
         if(shockwaveBitmaps[param2] == null)
         {
            shockwaveBitmaps[param2] = ResourceManager.getBitmapData("shockwaves",_loc3_.resKey);
         }
         this.radius = _loc3_.radius;
         this.duration = _loc3_.duration;
         this.beginScale = _loc3_.beginScale;
         this.endScale = _loc3_.endScale;
         this.maxShockwaves = _loc3_.maxShockwaves;
         this.shakeScreen = _loc3_.shakeScreen;
      }
      
      public function impact(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Bitmap = null;
         var _loc7_:Sprite = null;
         var _loc8_:int = 0;
         var _loc3_:Sprite = this.map.getMain().screenManager.getExplosionLayer();
         if(shockwaveBitmaps != null)
         {
            _loc4_ = 360 / this.maxShockwaves;
            _loc5_ = 0;
            while(_loc5_ < this.maxShockwaves)
            {
               _loc6_ = new Bitmap(shockwaveBitmaps[this.shockwaveID]);
               _loc7_ = new Sprite();
               _loc7_.mouseEnabled = false;
               _loc7_.mouseChildren = false;
               _loc7_.addChild(_loc6_);
               _loc6_.y = -_loc6_.height / 2;
               _loc7_.scaleX = this.beginScale;
               _loc7_.scaleY = this.beginScale;
               _loc7_.x = param1;
               _loc7_.y = param2;
               _loc8_ = _loc5_ * _loc4_;
               _loc7_.rotation = _loc8_ + 180;
               if(coordMultiplier[this.maxShockwaves] == null)
               {
                  coordMultiplier[this.maxShockwaves] = [];
               }
               if(coordMultiplier[this.maxShockwaves][_loc5_] == null)
               {
                  coordMultiplier[this.maxShockwaves][_loc5_] = [];
                  coordMultiplier[this.maxShockwaves][_loc5_][0] = Math.cos(_loc8_ * Math.PI / 180);
                  coordMultiplier[this.maxShockwaves][_loc5_][1] = Math.sin(_loc8_ * Math.PI / 180);
               }
               _loc3_.addChild(_loc7_);
               TweenLite.to(_loc7_,this.duration,{
                  "ease":Quint.easeOut,
                  "x":param1 + this.radius * coordMultiplier[this.maxShockwaves][_loc5_][0],
                  "y":param2 + this.radius * coordMultiplier[this.maxShockwaves][_loc5_][1],
                  "scaleX":this.endScale,
                  "scaleY":this.endScale,
                  "alpha":0,
                  "onComplete":this.handleShockwaveCompleted,
                  "onCompleteParams":[_loc7_]
               });
               _loc5_++;
            }
         }
      }
      
      private function handleShockwaveCompleted(param1:Sprite) : void
      {
         var _loc2_:Sprite = this.map.getMain().screenManager.getExplosionLayer();
         if(_loc2_.contains(param1))
         {
            _loc2_.removeChild(param1);
         }
      }
   }
}


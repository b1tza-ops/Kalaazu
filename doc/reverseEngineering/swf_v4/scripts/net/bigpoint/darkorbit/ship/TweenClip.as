package net.bigpoint.darkorbit.ship
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   
   public class TweenClip extends Sprite
   {
      
      public static const logger:ILogger = Log.getLogger("TweenClip");
      
      public var clip:DisplayObject;
      
      public var fps:int;
      
      private var currentStartFrame:int;
      
      public function TweenClip(param1:DisplayObject = null, param2:int = 30)
      {
         super();
         this.clip = param1;
         this.fps = param2;
      }
      
      public function setClip(param1:DisplayObject, param2:Boolean = true) : void
      {
         this.clip = param1;
         this.clip.visible = false;
         if(param2)
         {
            this.addChild(param1);
         }
         this.resetMovieClip();
      }
      
      private function resetMovieClip() : void
      {
         if(this.clip is MovieClip)
         {
            MovieClip(this.clip).gotoAndStop(this.currentStartFrame);
         }
         else if(this.clip is BitmapClip)
         {
            BitmapClip(this.clip).gotoAndStop(this.currentStartFrame);
         }
      }
      
      public function playAnimation(param1:Boolean = true, param2:int = 1, param3:Boolean = true, param4:Boolean = false) : void
      {
         var _loc5_:int = 0;
         this.stopAnimation();
         this.currentStartFrame = param2;
         if(this.clip is MovieClip)
         {
            _loc5_ = MovieClip(this.clip).framesLoaded;
            MovieClip(this.clip).gotoAndStop(param2);
         }
         else if(this.clip is BitmapClip)
         {
            _loc5_ = BitmapClip(this.clip).framesLoaded;
            BitmapClip(this.clip).gotoAndStop(param2);
         }
         var _loc6_:Number = _loc5_ / this.fps;
         var _loc7_:Number = 0;
         this.clip.visible = true;
         if(param3)
         {
            _loc7_ = 0.5;
            this.clip.alpha = 0;
            TweenLite.to(this.clip,_loc7_,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
         if(param1)
         {
            this.loopAnimation(_loc6_,_loc5_);
         }
         else if(param4)
         {
            this.animateAndRemoveObject(_loc6_,_loc5_);
         }
         else
         {
            this.animateAndFadeOut(_loc6_,_loc5_);
         }
      }
      
      public function playInstantAnimation(param1:int = 1, param2:Boolean = true, param3:Boolean = false, param4:int = 3) : void
      {
         var _loc5_:int = 0;
         var _loc7_:Number = NaN;
         this.stopAnimation();
         if(this.clip is MovieClip)
         {
            _loc5_ = MovieClip(this.clip).framesLoaded;
            MovieClip(this.clip).gotoAndStop(param1);
         }
         else if(this.clip is BitmapClip)
         {
            _loc5_ = BitmapClip(this.clip).framesLoaded;
            BitmapClip(this.clip).gotoAndStop(param1);
         }
         var _loc6_:Number = _loc5_ / this.fps;
         _loc7_ = 0;
         this.clip.visible = true;
         if(param2)
         {
            _loc7_ = 0.5;
            this.clip.alpha = 0;
            TweenLite.to(this.clip,_loc7_,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
         this.instantAnimation(_loc6_,_loc5_,param4);
      }
      
      private function instantAnimation(param1:Number, param2:int, param3:int) : void
      {
         this.resetMovieClip();
         if(param3 > 0)
         {
            TweenLite.to(this.clip,param1,{
               "ease":Linear.easeNone,
               "frame":param2,
               "onComplete":this.instantAnimation,
               "onCompleteParams":[param1,param2,--param3]
            });
         }
         else
         {
            this.fadeInClip(0.5);
         }
      }
      
      private function loopAnimation(param1:Number, param2:int) : void
      {
         this.resetMovieClip();
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.loopAnimation,
            "onCompleteParams":[param1,param2]
         });
      }
      
      private function animateAndRemoveObject(param1:Number, param2:int) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.onRemoveDisplayObject,
            "onCompleteParams":[this.clip]
         });
      }
      
      private function animateAndFadeOut(param1:Number, param2:int) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "frame":param2,
            "onComplete":this.fadeOutClip,
            "onCompleteParams":[0.5]
         });
      }
      
      public function stopAnimation() : void
      {
         TweenLite.killTweensOf(this.clip);
         this.fadeOutClip(0.5);
      }
      
      public function fadeInClip(param1:Number) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      public function fadeOutClip(param1:Number) : void
      {
         TweenLite.to(this.clip,param1,{
            "ease":Linear.easeNone,
            "alpha":0
         });
      }
      
      public function onRemoveDisplayObject(param1:DisplayObject) : void
      {
         param1.parent.removeChild(param1);
      }
   }
}


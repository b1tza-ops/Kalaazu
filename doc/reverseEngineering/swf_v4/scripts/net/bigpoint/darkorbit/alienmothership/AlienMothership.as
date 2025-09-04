package net.bigpoint.darkorbit.alienmothership
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.media.SoundChannel;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   
   public class AlienMothership extends Sprite
   {
      
      public static const logger:ILogger = Log.getLogger("AlienMothership");
      
      private static var PLAY_DEFAULT:int = 0;
      
      private static var PLAY_LOOP:int = 1;
      
      private static var PLAY_AND_SET_INVISIBLE:int = 2;
      
      private var id:int;
      
      private var alienMothership:MovieClip;
      
      private var idleBitmap:Bitmap;
      
      private var resKey:String = "alienMothership";
      
      private var screenManager:ScreenManager;
      
      private var rotateSound:SoundChannel;
      
      public var clipLoaded:Boolean;
      
      public function AlienMothership(param1:int, param2:ScreenManager)
      {
         super();
         this.id = param1;
         this.screenManager = param2;
      }
      
      public function init() : void
      {
         if(ResourceManager.fileCollection.isLoaded(this.resKey))
         {
            this.attachClip();
         }
         else
         {
            ResourceManager.fileCollection.load(this.resKey,this.onClipLoaded);
         }
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         this.attachClip();
      }
      
      private function attachClip() : void
      {
         this.alienMothership = ResourceManager.getMovieClip(this.resKey,"alienMothership");
         this.addChild(this.alienMothership);
         this.idleBitmap = ResourceManager.getBitmap(this.resKey,"idleBitmap");
         this.idleBitmap.x = -this.idleBitmap.width / 2;
         this.idleBitmap.y = -this.idleBitmap.height / 2;
         this.idleBitmap.visible = false;
         this.addChild(this.idleBitmap);
         this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,27,42);
         AudioManager.playSoundEffect(52);
         this.clipLoaded = true;
      }
      
      public function playAnimation(param1:MovieClip, param2:int, param3:int = 0, param4:int = 1, param5:int = -1) : void
      {
         if(param5 == -1)
         {
            param5 = param1.framesLoaded;
         }
         param1.gotoAndStop(param4);
         var _loc6_:Number = 0;
         if(param5 > param4)
         {
            _loc6_ = (param5 - param4) / param2;
         }
         else
         {
            _loc6_ = (param4 - param5) / param2;
         }
         switch(param3)
         {
            case PLAY_DEFAULT:
               param1.visible = true;
               TweenLite.to(param1,_loc6_,{
                  "ease":Linear.easeNone,
                  "frame":param5
               });
               break;
            case PLAY_LOOP:
               param1.visible = true;
               TweenLite.to(param1,_loc6_,{
                  "ease":Linear.easeNone,
                  "frame":param5,
                  "onComplete":this.playAnimation,
                  "onCompleteParams":[param1,param2,param3,param4,param5]
               });
               break;
            case PLAY_AND_SET_INVISIBLE:
               TweenLite.to(param1,_loc6_,{
                  "ease":Linear.easeNone,
                  "frame":param5,
                  "onComplete":this.setClipInvisible,
                  "onCompleteParams":[param1]
               });
         }
      }
      
      private function setClipInvisible(param1:MovieClip) : void
      {
         param1.visible = false;
      }
      
      public function startIdle() : void
      {
         TweenMax.killTweensOf(this.alienMothership);
         this.alienMothership.gotoAndStop(58);
         this.idleBitmap.alpha = 0;
         this.idleBitmap.visible = true;
         TweenLite.to(this.idleBitmap,0.5,{
            "ease":Linear.easeNone,
            "alpha":1,
            "onComplete":this.handleIdle,
            "onCompleteParams":[this.idleBitmap]
         });
      }
      
      public function stopAnimations() : void
      {
         TweenMax.killTweensOf(this.alienMothership);
         TweenMax.killTweensOf(this.idleBitmap);
         this.idleBitmap.visible = false;
         if(this.rotateSound != null)
         {
            AudioManager.removeLoop(this.rotateSound);
         }
      }
      
      private function handleIdle(param1:Bitmap) : void
      {
         TweenLite.to(param1,0.5,{
            "ease":Linear.easeNone,
            "alpha":0,
            "onComplete":this.startIdle
         });
      }
      
      public function prepareAttack(param1:int) : void
      {
         this.stopAnimations();
         if(param1 == 0)
         {
            this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,17,26);
         }
         else if(param1 == 1)
         {
            this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,26,17);
         }
         AudioManager.playSoundEffect(54);
      }
      
      public function prepareBigAttack(param1:int) : void
      {
         this.stopAnimations();
         if(param1 == 0)
         {
            this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,1,16);
         }
         else if(param1 == 1)
         {
            this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,16,1);
         }
         AudioManager.playSoundEffect(54);
      }
      
      public function cloak(param1:int) : void
      {
         this.stopAnimations();
         if(param1 == 0)
         {
            this.playAnimation(this.alienMothership,15,PLAY_AND_SET_INVISIBLE,42,27);
         }
         else if(param1 == 1)
         {
            this.visible = true;
            this.playAnimation(this.alienMothership,15,PLAY_DEFAULT,27,42);
         }
         AudioManager.playSoundEffect(52);
      }
      
      public function startRotation(param1:int) : void
      {
         this.stopAnimations();
         if(param1 == 0)
         {
            this.playAnimation(this.alienMothership,15,PLAY_LOOP,43,57);
         }
         else if(param1 == 1)
         {
            this.playAnimation(this.alienMothership,15,PLAY_LOOP,57,43);
         }
         this.rotateSound = AudioManager.playSoundEffect(53,true);
      }
   }
}


package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SaboteurEffect extends RotationEffect
   {
      
      private var clipStationary:MovieClip;
      
      private var clipMoving:MovieClip;
      
      public function SaboteurEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.clipStationary = MovieClip(this.clip).stationary;
         this.clipMoving = MovieClip(this.clip).moving;
         addRotationTick();
         this.start();
         this.clipStationary.alpha = 0;
         this.clipMoving.alpha = 0;
      }
      
      override public function start() : void
      {
         var _loc1_:AssetLazyLoader = null;
         if(this.clip != null)
         {
            this.clip.visible = true;
            ScreenManager.playAnimation(this.clipMoving,15,true);
            ScreenManager.playAnimation(this.clipStationary,15,true);
         }
         else
         {
            _loc1_ = new AssetLazyLoader();
            _loc1_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handlePlayOnLoaded);
            _loc1_.loadAsset(pattern.resKey);
         }
      }
      
      private function handlePlayOnLoaded(param1:Event) : void
      {
         this.clip.visible = true;
         ScreenManager.playAnimation(this.clipMoving,15,true);
         ScreenManager.playAnimation(this.clipStationary,15,true);
      }
      
      override public function stop() : void
      {
         this.stopAnimation();
      }
      
      override public function actionOnMovingRotation() : void
      {
         TweenLite.to(this.clipMoving,1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
         TweenLite.to(this.clipStationary,0.7,{
            "ease":Linear.easeNone,
            "alpha":0
         });
         TweenLite.to(this.clip,0.25,{"shortRotation":{"rotation":associatedMapObject.movementDirection}});
      }
      
      override public function actionOnStationaryRotation() : void
      {
         TweenLite.to(this.clipMoving,0.7,{
            "ease":Linear.easeNone,
            "alpha":0
         });
         TweenLite.to(this.clipStationary,1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
         TweenLite.to(this.clip,0.25,{"shortRotation":{"rotation":associatedMapObject.shipRotation}});
      }
   }
}


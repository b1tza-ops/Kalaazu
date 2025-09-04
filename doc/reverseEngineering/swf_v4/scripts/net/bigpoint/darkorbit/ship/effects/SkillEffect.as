package net.bigpoint.darkorbit.ship.effects
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class SkillEffect extends EffectBase
   {
      
      private const NUMBER_OF_LIGHT_FLASHES_SOLACE:int = 11;
      
      public function SkillEffect(param1:int, param2:EffectPattern, param3:MapObject, param4:Boolean = false, param5:Array = null, param6:Boolean = true)
      {
         this.associatedMapObject = param3;
         super(param1,param2,param4,param5,param6);
      }
      
      override public function initEffectVisuals() : void
      {
         resizeMC(Math.max(associatedMapObject.shipClip.height,associatedMapObject.shipClip.width) * 0.5 / 65);
      }
      
      public function startSolaceInstantAnimation() : void
      {
         var _loc1_:AssetLazyLoader = null;
         if(this.clip != null)
         {
            playInstantAnimation();
         }
         else
         {
            _loc1_ = new AssetLazyLoader();
            _loc1_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handlePlayOnLoaded);
            _loc1_.loadAsset(pattern.resKey);
         }
         if(associatedMapObject.shipLightDecorator.numberOfFlashes < 0)
         {
            associatedMapObject.shipLightDecorator.startFlashes(this.NUMBER_OF_LIGHT_FLASHES_SOLACE);
         }
      }
      
      private function handlePlayOnLoaded(param1:Event) : void
      {
         playInstantAnimation();
      }
   }
}


package net.bigpoint.darkorbit.ship.effects
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class PetEffect extends EffectBase
   {
      
      public function PetEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.petSpawnOnePlay();
      }
      
      public function petSpawnOnePlay() : void
      {
         var _loc1_:AssetLazyLoader = null;
         if(this.clip != null)
         {
            this.playInstantAnimation(1,true,false,1);
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
         this.playInstantAnimation(1,true,false,1);
      }
   }
}


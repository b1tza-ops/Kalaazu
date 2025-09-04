package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class EnergyLeechTechEffect extends EffectBase
   {
      
      public function EnergyLeechTechEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.playAnimation();
         TweenMax.delayedCall(2,this.handleEnergyLeechPause);
      }
      
      private function handleEnergyLeechPause() : void
      {
         TweenMax.to(effectMc,1,{"alpha":0});
         TweenMax.delayedCall(7,this.handleEnergyLeechContinueAnimating);
      }
      
      private function handleEnergyLeechContinueAnimating() : void
      {
         TweenMax.to(effectMc,1,{"alpha":1});
         TweenMax.delayedCall(2,this.handleEnergyLeechPause);
      }
   }
}


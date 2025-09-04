package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class ShieldBackupTechEffect extends EffectBase
   {
      
      public function ShieldBackupTechEffect(param1:int, param2:EffectPattern, param3:Boolean = true, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
         this.fps = 15;
      }
      
      override public function initEffectVisuals() : void
      {
         this.playAnimation();
         AudioManager.playSoundEffect(37);
         effectMc.alpha = 0;
         TweenLite.to(effectMc,0.25,{
            "alpha":1,
            "onComplete":this.handleShield
         });
      }
      
      private function handleShield() : void
      {
         TweenMax.delayedCall(1,this.handleFadeOutShield);
      }
      
      private function handleFadeOutShield() : void
      {
         TweenLite.to(effectMc,0.25,{
            "alpha":0,
            "onComplete":this.handleTimeoutEventDispatch
         });
      }
      
      private function handleTimeoutEventDispatch() : void
      {
         dispatchEvent(new EntityEffectEvent(EntityEffectEvent.EFFECT_TIMEOUT,id));
      }
   }
}


package net.bigpoint.darkorbit.ship.effects
{
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SkullEffect extends EffectBase
   {
      
      public function SkullEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.start();
      }
   }
}


package net.bigpoint.darkorbit.ship.effects
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class BattleRepBotTechEffect extends EffectBase
   {
      
      public function BattleRepBotTechEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         MovieClip(this.clip).robot.gotoAndPlay(2);
         MovieClip(this.clip).gotoAndPlay(2);
         this.clip.visible = true;
      }
   }
}


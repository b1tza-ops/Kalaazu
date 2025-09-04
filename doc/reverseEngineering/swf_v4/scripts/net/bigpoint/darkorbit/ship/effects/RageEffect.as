package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class RageEffect extends EffectBase
   {
      
      private var ship:MapObject;
      
      private var tween:TweenMax;
      
      public function RageEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.ship = args[0] as MapObject;
         var _loc1_:Sprite = this.ship.getShipContainer();
         if(_loc1_ != null)
         {
            this.tween = TweenMax.to(_loc1_,0.5,{
               "yoyo":true,
               "repeat":-1,
               "glowFilter":{
                  "color":16711680,
                  "alpha":1,
                  "blurX":60,
                  "blurY":60
               }
            });
         }
      }
      
      override public function stop() : void
      {
         var _loc1_:Sprite = null;
         if(this.ship != null)
         {
            if(this.tween != null)
            {
               this.tween.kill();
               this.tween = null;
            }
            _loc1_ = this.ship.getShipContainer();
            if(_loc1_ != null)
            {
               _loc1_.filters = null;
            }
         }
      }
   }
}


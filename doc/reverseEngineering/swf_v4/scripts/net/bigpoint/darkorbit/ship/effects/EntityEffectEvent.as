package net.bigpoint.darkorbit.ship.effects
{
   import flash.events.Event;
   
   public class EntityEffectEvent extends Event
   {
      
      public static const EFFECT_TIMEOUT:String = "EFFECT_TIMEOUT";
      
      public static const EFFECT_FINISHED:String = "EFFECT_FINISHED";
      
      public static const EFFECT_CANCELLED:String = "EFFECT_CANCELLED";
      
      public var effectID:int;
      
      public function EntityEffectEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.effectID = param2;
      }
   }
}


package net.bigpoint.darkorbit.ship.pet
{
   import net.bigpoint.darkorbit.pattern.GearPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class GearFactory
   {
      
      public function GearFactory()
      {
         super();
      }
      
      public static function getGear(param1:int, param2:int, param3:int) : Gear
      {
         var _loc4_:GearPattern = PatternManager.petGearPatterns[param1];
         return new Gear(param1,param2,param3,_loc4_);
      }
   }
}


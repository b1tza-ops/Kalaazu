package net.bigpoint.darkorbit.ship.pet
{
   import net.bigpoint.darkorbit.pattern.GearPattern;
   
   public class Gear
   {
      
      public var type:int;
      
      public var level:int;
      
      public var quantity:int;
      
      public var pattern:GearPattern;
      
      public function Gear(param1:int, param2:int, param3:int, param4:GearPattern)
      {
         super();
         this.type = param1;
         this.level = param2;
         this.quantity = param3;
         this.pattern = param4;
      }
   }
}


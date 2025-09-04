package net.bigpoint.darkorbit.ship
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ship.pet.Pet;
   
   public class Ship extends MapObject
   {
      
      public var pet:Pet;
      
      public function Ship(param1:ShipManager, param2:int, param3:String, param4:Sprite)
      {
         super(param1,param2,param3,param4);
      }
   }
}


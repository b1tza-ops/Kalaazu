package net.bigpoint.darkorbit.ship.pet
{
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.ShipManager;
   
   public class Pet extends MapObject
   {
      
      private static const logger:ILogger = Log.getLogger("Pet");
      
      public var owner:int;
      
      public var level:int = 0;
      
      public var currentFuel:int;
      
      public var maxFuel:int;
      
      public var gears:Array = [];
      
      public var evasionProtocolEquiped:Boolean = false;
      
      public function Pet(param1:ShipManager, param2:int, param3:String, param4:int, param5:int, param6:Sprite)
      {
         super(param1,param2,param3,param6);
         this.owner = param4;
         this.level = param5;
      }
      
      public function setFuel(param1:int, param2:int) : void
      {
         this.maxFuel = param2;
         this.currentFuel = param1;
      }
      
      public function hasEvasionProtocol() : Boolean
      {
         return this.evasionProtocolEquiped;
      }
   }
}


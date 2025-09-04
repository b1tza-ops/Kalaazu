package net.bigpoint.darkorbit.drone
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class DronePattern extends ResourcePattern
   {
      
      private var level:int;
      
      private var droneRadius:int;
      
      public function DronePattern(param1:int, param2:String, param3:int, param4:int)
      {
         super(param1,param2);
         this.level = param3;
         this.droneRadius = param4;
      }
      
      public function getDroneRadius() : int
      {
         return this.droneRadius;
      }
      
      public function getLevel() : int
      {
         return this.level;
      }
   }
}


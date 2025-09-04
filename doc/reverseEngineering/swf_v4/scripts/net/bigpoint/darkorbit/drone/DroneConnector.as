package net.bigpoint.darkorbit.drone
{
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class DroneConnector
   {
      
      public static var POSITION_TOP:int = 0;
      
      public static var POSITION_RIGHT:int = 1;
      
      public static var POSITION_DOWN:int = 2;
      
      public static var POSITION_LEFT:int = 3;
      
      public static var POSITION_CENTER:int = 4;
      
      public var droneGroups:Array = [];
      
      public function DroneConnector()
      {
         super();
      }
      
      public function addDroneGroup(param1:DroneGroup) : void
      {
         this.droneGroups.push(param1);
      }
      
      public function getDroneGroup(param1:int) : DroneGroup
      {
         var _loc3_:DroneGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.droneGroups.length)
         {
            _loc3_ = this.droneGroups[_loc2_];
            if(_loc3_.position == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function cleanup(param1:MapObject) : void
      {
         var _loc2_:DroneGroup = null;
         for each(_loc2_ in this.droneGroups)
         {
            _loc2_.cleanup();
            param1.getDroneDisplayClipContainer().removeChild(_loc2_.getClip());
         }
      }
   }
}


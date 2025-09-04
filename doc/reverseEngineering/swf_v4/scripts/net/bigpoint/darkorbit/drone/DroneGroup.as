package net.bigpoint.darkorbit.drone
{
   import flash.display.MovieClip;
   
   public class DroneGroup
   {
      
      public var position:int;
      
      private var clip:MovieClip;
      
      public var drones:Array = [];
      
      private var _droneGroupRotation:int;
      
      private var _droneGroupDimension:int;
      
      public var lastDroneGroupRotation:int;
      
      public function DroneGroup(param1:int, param2:MovieClip, param3:int)
      {
         super();
         this.position = param1;
         this.clip = param2;
         this._droneGroupDimension = param3;
      }
      
      public function cleanup() : void
      {
         var _loc1_:Drone = null;
         for each(_loc1_ in this.drones)
         {
            this.clip.removeChild(_loc1_.clip);
            _loc1_ = null;
         }
      }
      
      public function addDrone(param1:Drone) : void
      {
         this.drones.push(param1);
      }
      
      public function getDrone(param1:int) : Drone
      {
         var _loc3_:Drone = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.drones.length)
         {
            _loc3_ = this.drones[_loc2_];
            if(_loc3_.position == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getClip() : MovieClip
      {
         return this.clip;
      }
      
      public function get droneGroupRotation() : int
      {
         return this._droneGroupRotation;
      }
      
      public function set droneGroupRotation(param1:int) : void
      {
         this._droneGroupRotation = param1;
         this.clip.x = int(this._droneGroupDimension * Math.cos(this._droneGroupRotation * Math.PI / 180));
         this.clip.y = int(this._droneGroupDimension * Math.sin(this._droneGroupRotation * Math.PI / 180));
      }
      
      public function get droneGroupDimension() : int
      {
         return this._droneGroupDimension;
      }
      
      public function set droneGroupDimension(param1:int) : void
      {
         this._droneGroupDimension = param1;
         this.clip.x = int(this._droneGroupDimension * Math.cos(this._droneGroupRotation * Math.PI / 180));
         this.clip.y = int(this._droneGroupDimension * Math.sin(this._droneGroupRotation * Math.PI / 180));
      }
   }
}


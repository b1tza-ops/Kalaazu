package net.bigpoint.darkorbit.drone
{
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   
   public class Drone
   {
      
      public var position:int;
      
      private var _clip:BitmapClip;
      
      private var _droneRotation:int;
      
      private var _droneDimension:int;
      
      public var lastDroneRotation:int;
      
      public function Drone(param1:int, param2:int, param3:BitmapClip)
      {
         super();
         this.position = param1;
         this._clip = param3;
         this._droneDimension = param2 * 2;
      }
      
      public function get droneRotation() : int
      {
         return this._droneRotation;
      }
      
      public function set droneRotation(param1:int) : void
      {
         this._droneRotation = param1;
      }
      
      public function get droneDimension() : int
      {
         return this._droneDimension;
      }
      
      public function get clip() : BitmapClip
      {
         return this._clip;
      }
   }
}


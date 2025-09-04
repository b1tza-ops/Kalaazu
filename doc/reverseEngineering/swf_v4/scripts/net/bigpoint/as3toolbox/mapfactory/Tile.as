package net.bigpoint.as3toolbox.mapfactory
{
   public class Tile
   {
      
      private var _id:int;
      
      public function Tile(param1:int)
      {
         super();
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}


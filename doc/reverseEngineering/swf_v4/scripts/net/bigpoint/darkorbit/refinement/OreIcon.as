package net.bigpoint.darkorbit.refinement
{
   import flash.display.MovieClip;
   
   public class OreIcon extends MovieClip
   {
      
      private var _id:int;
      
      public function OreIcon(param1:int)
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


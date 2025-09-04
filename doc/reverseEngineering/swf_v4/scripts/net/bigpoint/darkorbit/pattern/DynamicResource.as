package net.bigpoint.darkorbit.pattern
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class DynamicResource
   {
      
      private var typeID:int;
      
      private var _clip:MovieClip;
      
      private var _scaleSize:Point = new Point();
      
      public function DynamicResource(param1:int)
      {
         super();
         this.typeID = param1;
      }
      
      public function removeClip() : void
      {
         this.clip = null;
      }
      
      public function getTypeID() : int
      {
         return this.typeID;
      }
      
      public function get clip() : MovieClip
      {
         return this._clip;
      }
      
      public function set clip(param1:MovieClip) : void
      {
         this._clip = param1;
      }
      
      public function get scaleSize() : Point
      {
         return this._scaleSize;
      }
      
      public function set scaleSize(param1:Point) : void
      {
         this._scaleSize = param1;
      }
   }
}


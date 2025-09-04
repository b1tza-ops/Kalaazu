package net.bigpoint.darkorbit.questfm.conditions
{
   public class CoordinatesCondition extends Condition
   {
      
      private var _x_pos:int;
      
      private var _y_pos:int;
      
      private var _z_pos:int;
      
      private var _radius:int;
      
      public function CoordinatesCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         var _loc2_:Array = param1.split(",");
         this._x_pos = parseInt(_loc2_.shift());
         this._y_pos = parseInt(_loc2_.shift());
         this._z_pos = parseInt(_loc2_.shift());
         this._radius = parseInt(_loc2_.shift());
         _description = description.replace(/%x%/,this._x_pos / 100);
         _description = description.replace(/%y%/,this._y_pos / 100);
      }
   }
}


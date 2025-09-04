package net.bigpoint.darkorbit.pattern
{
   public class RefinerInfo
   {
      
      private var _oreID:int;
      
      private var _count:int;
      
      public function RefinerInfo(param1:int, param2:int)
      {
         super();
         this._oreID = param1;
         this._count = param2;
      }
      
      public function get oreID() : int
      {
         return this._oreID;
      }
      
      public function get count() : int
      {
         return this._count;
      }
   }
}


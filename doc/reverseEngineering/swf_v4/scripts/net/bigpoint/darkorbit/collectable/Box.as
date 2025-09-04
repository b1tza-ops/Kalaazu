package net.bigpoint.darkorbit.collectable
{
   public class Box extends Collectable
   {
      
      public static var TYPE_NOT_FREE_CARGO_BOX:int = 0;
      
      public static var TYPE_FREE_CARGO_BOX:int = 1;
      
      public static var TYPE_BONUS_BOX:int = 2;
      
      private var _remainingLootTime:int = -1;
      
      public function Box(param1:int, param2:CollectablePattern, param3:String, param4:int, param5:int)
      {
         super(CollectablePattern.TYPE_BOX,param2,param1,param3,param4,param5);
      }
      
      public function get remainingLootTime() : int
      {
         return this._remainingLootTime;
      }
      
      public function set remainingLootTime(param1:int) : void
      {
         this._remainingLootTime = param1;
      }
   }
}


package net.bigpoint.darkorbit.collectable
{
   public class Beacon extends Collectable
   {
      
      private var fromCompanyID:int;
      
      private var toCompanyID:int;
      
      public function Beacon(param1:int, param2:CollectablePattern, param3:String, param4:int, param5:int)
      {
         super(CollectablePattern.TYPE_BEACON,param2,param1,param3,param4,param5);
         this.setCompanyID();
      }
      
      private function setCompanyID() : void
      {
         var _loc1_:Array = typeID.toString().split("");
         this.fromCompanyID = _loc1_[1];
         this.toCompanyID = _loc1_[2];
      }
      
      public function getFromCompanyID() : int
      {
         return this.fromCompanyID;
      }
      
      public function getToCompanyID() : int
      {
         return this.toCompanyID;
      }
   }
}


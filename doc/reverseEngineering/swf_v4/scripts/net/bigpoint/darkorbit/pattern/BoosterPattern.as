package net.bigpoint.darkorbit.pattern
{
   public class BoosterPattern extends ResourcePattern
   {
      
      private var infoFieldID:int;
      
      private var barKey:String;
      
      public function BoosterPattern(param1:int, param2:int, param3:String, param4:String)
      {
         super(param1,param3);
         this.infoFieldID = param2;
         this.barKey = param4;
      }
      
      public function getInfoFieldID() : int
      {
         return this.infoFieldID;
      }
      
      public function getBarKey() : String
      {
         return this.barKey;
      }
   }
}


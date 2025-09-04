package net.bigpoint.darkorbit.pattern
{
   public class TechDefault
   {
      
      public var id:int;
      
      public var linkageID:String;
      
      public var hasDuration:Boolean;
      
      public var hasCharges:Boolean;
      
      public function TechDefault(param1:int, param2:String)
      {
         super();
         this.linkageID = param2;
         this.id = param1;
      }
   }
}


package net.bigpoint.darkorbit.ship
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class ExpansionPattern extends ResourcePattern
   {
      
      private var expansionClass:int;
      
      public var salvosData:Array;
      
      public function ExpansionPattern(param1:int, param2:int, param3:String, param4:Array)
      {
         super(param2,param3);
         this.salvosData = param4;
         this.expansionClass = param1;
      }
      
      public function getExpansionClass() : int
      {
         return this.expansionClass;
      }
   }
}


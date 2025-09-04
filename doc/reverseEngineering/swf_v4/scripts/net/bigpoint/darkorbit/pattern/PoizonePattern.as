package net.bigpoint.darkorbit.pattern
{
   public class PoizonePattern
   {
      
      public var id:int;
      
      public var backgroundIDs:Vector.<int>;
      
      public var resKey:String;
      
      public var avWidth:int;
      
      public var avHeight:int;
      
      public function PoizonePattern(param1:int, param2:String, param3:String, param4:int, param5:int)
      {
         var _loc7_:int = 0;
         super();
         this.id = param1;
         this.backgroundIDs = new Vector.<int>();
         var _loc6_:Array = param2.split(",");
         for each(_loc7_ in _loc6_)
         {
            this.backgroundIDs.push(_loc7_);
         }
         this.resKey = param3;
         this.avWidth = param4;
         this.avHeight = param5;
      }
   }
}


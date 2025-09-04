package net.bigpoint.darkorbit.station
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class StationPattern extends ResourcePattern
   {
      
      private var width:int;
      
      private var height:int;
      
      public function StationPattern(param1:int, param2:String, param3:int, param4:int)
      {
         super(param1,param2);
         this.width = param3;
         this.height = param4;
      }
      
      public function getWidth() : int
      {
         return this.width;
      }
      
      public function getHeight() : int
      {
         return this.height;
      }
   }
}


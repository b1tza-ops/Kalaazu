package net.bigpoint.darkorbit.ship
{
   import net.bigpoint.darkorbit.pattern.Pattern;
   
   public class EnginePositionPattern extends Pattern
   {
      
      public var enginePositions:Array;
      
      public function EnginePositionPattern(param1:int, param2:Array)
      {
         super(param1,Pattern.CONTENT_CUSTOM);
         this.enginePositions = param2;
      }
      
      public function getEnginePositions() : Array
      {
         return this.enginePositions;
      }
   }
}


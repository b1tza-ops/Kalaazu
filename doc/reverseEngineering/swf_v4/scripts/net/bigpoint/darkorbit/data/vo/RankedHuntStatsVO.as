package net.bigpoint.darkorbit.data.vo
{
   public class RankedHuntStatsVO
   {
      
      public var targetList:Array;
      
      public var targetVerbose:String;
      
      public var bountyPoints:int;
      
      public var bountyDelta:int = 0;
      
      public var clanBountyPoints:int = 0;
      
      public var clanBountyPointsInSync:Boolean;
      
      public function RankedHuntStatsVO()
      {
         super();
      }
   }
}


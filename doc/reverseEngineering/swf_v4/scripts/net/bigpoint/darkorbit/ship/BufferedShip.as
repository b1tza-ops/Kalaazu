package net.bigpoint.darkorbit.ship
{
   public class BufferedShip
   {
      
      public var typeID:int;
      
      public var userID:int;
      
      public var xPos:int;
      
      public var yPos:int;
      
      public var speed:int;
      
      public var username:String;
      
      public var clanTag:String;
      
      public var fractionID:int;
      
      public var clanID:int;
      
      public var clanDiplomacy:int;
      
      public var dailyRank:int;
      
      public var expansionstage:int;
      
      public var warnIconOnMap:Boolean;
      
      public var galaxyGatesFinished:int;
      
      public var cloaked:Boolean;
      
      public var isNPC:Boolean;
      
      public function BufferedShip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String, param7:String, param8:int, param9:int, param10:int, param11:int, param12:int, param13:Boolean, param14:int, param15:Boolean, param16:Boolean)
      {
         super();
         this.typeID = param1;
         this.userID = param2;
         this.xPos = param3;
         this.yPos = param4;
         this.speed = param5;
         this.username = param6;
         this.clanTag = param7;
         this.fractionID = param8;
         this.clanID = param9;
         this.clanDiplomacy = param10;
         this.dailyRank = param11;
         this.expansionstage = param12;
         this.warnIconOnMap = param13;
         this.galaxyGatesFinished = param14;
         this.isNPC = param15;
         this.cloaked = param16;
      }
   }
}


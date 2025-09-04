package net.bigpoint.darkorbit.groupsystem
{
   public class GroupMember
   {
      
      public var id:int;
      
      public var nickName:String;
      
      public var factionID:int;
      
      public var gameLevel:int;
      
      public var clanTag:String;
      
      public var online:Boolean = true;
      
      public var alive:Boolean = true;
      
      public var shipType:int;
      
      public var hitPointsCurrent:int;
      
      public var hitPointsMax:int;
      
      public var shieldCurrent:int;
      
      public var shieldMax:int;
      
      public var mapID:int;
      
      public var posX:int;
      
      public var posY:int;
      
      public var targetID:int;
      
      public var targetObject:StubShip;
      
      public var activity:Boolean;
      
      public var fightState:Boolean;
      
      public var isCloaked:Boolean;
      
      public var orderID:int;
      
      public var isLead:Boolean;
      
      public var isOffline:Boolean;
      
      public function GroupMember()
      {
         super();
         this.nickName = "";
      }
      
      public function init(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:int = 0, param15:int = 0, param16:String = "", param17:int = 0, param18:Boolean = false) : void
      {
         this.id = param1;
         this.nickName = param2;
         this.hitPointsCurrent = param3;
         this.hitPointsMax = param4;
         this.shieldCurrent = param5;
         this.shieldMax = param6;
         this.mapID = param7;
         this.posX = param8;
         this.posY = param9;
         this.gameLevel = param10;
         this.activity = param11;
         this.isCloaked = param12;
         this.fightState = param13;
         this.factionID = param14;
         this.targetID = param15;
         this.clanTag = param16;
         this.shipType = param17;
         this.isOffline = param18;
      }
   }
}


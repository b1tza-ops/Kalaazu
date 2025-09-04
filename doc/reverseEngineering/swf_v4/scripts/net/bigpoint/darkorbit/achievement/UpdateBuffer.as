package net.bigpoint.darkorbit.achievement
{
   public class UpdateBuffer
   {
      
      public var achievementID:int;
      
      public var achievementDone:Boolean;
      
      public var bargainState:int;
      
      public function UpdateBuffer(param1:int, param2:Boolean, param3:int)
      {
         super();
         this.achievementID = param1;
         this.achievementDone = param2;
         this.bargainState = param3;
      }
   }
}


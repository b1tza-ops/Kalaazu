package net.bigpoint.darkorbit.gui
{
   import flash.events.Event;
   
   public class ActionEvent extends Event
   {
      
      public static const ACTION:String = "ActionEvent.action";
      
      private var actionID:int;
      
      private var environment:int;
      
      public function ActionEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function getActionID() : int
      {
         return this.actionID;
      }
      
      public function setActionID(param1:int) : void
      {
         this.actionID = param1;
      }
      
      public function getEnvironment() : int
      {
         return this.environment;
      }
      
      public function setEnvironment(param1:int) : void
      {
         this.environment = param1;
      }
      
      override public function toString() : String
      {
         return "ActionEvent " + "actionID " + this.actionID + " env " + this.environment;
      }
   }
}


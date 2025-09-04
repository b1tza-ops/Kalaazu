package net.bigpoint.darkorbit.questfm
{
   import net.bigpoint.darkorbit.questfm.conditions.ConditionTypeDefinition;
   
   public interface ICondition extends IQuestBaseObject
   {
      
      function toTextTree() : String;
      
      function get current() : int;
      
      function set current(param1:int) : void;
      
      function set definition(param1:ConditionTypeDefinition) : void;
      
      function get definition() : ConditionTypeDefinition;
      
      function init(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean, param6:int, param7:String) : void;
      
      function get description() : String;
      
      function get targetVerbose() : String;
      
      function get currentVerbose() : String;
      
      function get children() : Array;
      
      function get visibility() : int;
      
      function set visibility(param1:int) : void;
      
      function get id() : uint;
      
      function set id(param1:uint) : void;
      
      function get mandatory() : Boolean;
      
      function get runstate() : Boolean;
      
      function set runstate(param1:Boolean) : void;
      
      function get helpIconsClipIds() : Array;
      
      function set helpIconsClipIds(param1:Array) : void;
      
      function isSubcondition() : Boolean;
      
      function markAsSubCondition() : void;
      
      function updateCondtition(param1:int, param2:int, param3:int, param4:Boolean) : Boolean;
   }
}


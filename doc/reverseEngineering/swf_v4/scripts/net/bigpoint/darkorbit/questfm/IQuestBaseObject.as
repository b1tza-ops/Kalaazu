package net.bigpoint.darkorbit.questfm
{
   public interface IQuestBaseObject
   {
      
      function addConditionAt(param1:ICondition, param2:uint) : void;
      
      function addCondition(param1:ICondition) : void;
      
      function set showLong(param1:Boolean) : void;
      
      function get showLong() : Boolean;
   }
}


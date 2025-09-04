package net.bigpoint.darkorbit.questfm
{
   public interface ICase extends IQuestBaseObject
   {
      
      function get visibility() : int;
      
      function set visibility(param1:int) : void;
      
      function get mandatory() : Boolean;
      
      function get mandatory_child_count() : int;
      
      function toTextTree() : String;
      
      function get children() : Array;
   }
}


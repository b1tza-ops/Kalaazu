package net.bigpoint.darkorbit.questfm
{
   import flash.display.BitmapData;
   
   public interface IQuestTreeUIClip
   {
      
      function init(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void;
      
      function set state(param1:int) : void;
      
      function set visible(param1:Boolean) : void;
      
      function get visible() : Boolean;
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function get type() : int;
      
      function set type(param1:int) : void;
   }
}


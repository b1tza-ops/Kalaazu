package net.bigpoint.darkorbit
{
   public interface ICommandLogTarget
   {
      
      function writeOutput(param1:String) : void;
      
      function initOutput(param1:String) : void;
      
      function passFullInCommand(param1:String) : void;
   }
}


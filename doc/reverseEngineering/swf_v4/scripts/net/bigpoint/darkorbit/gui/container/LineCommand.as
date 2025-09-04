package net.bigpoint.darkorbit.gui.container
{
   public class LineCommand
   {
      
      public var value:String = "";
      
      public var next:LineCommand = null;
      
      public var previous:LineCommand = null;
      
      public function LineCommand()
      {
         super();
      }
   }
}


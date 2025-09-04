package net.bigpoint.darkorbit.gui
{
   public class MgmtBtnConfig
   {
      
      public var tooltipKey:String = "";
      
      public var action:Function;
      
      public function MgmtBtnConfig(param1:Function = null, param2:String = "")
      {
         super();
         this.action = param1;
         this.tooltipKey = param2;
      }
   }
}


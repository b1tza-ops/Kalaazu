package net.bigpoint.darkorbit.gui
{
   public class WindowSetting
   {
      
      private var windowID:int;
      
      private var maximized:Boolean;
      
      private var x:int;
      
      private var y:int;
      
      public function WindowSetting(param1:int, param2:int, param3:int, param4:Boolean)
      {
         super();
         this.windowID = param1;
         this.x = param2;
         this.y = param3;
         this.maximized = param4;
      }
      
      public function getWindowID() : int
      {
         return this.windowID;
      }
      
      public function isMaximized() : Boolean
      {
         return this.maximized;
      }
      
      public function getX() : int
      {
         return this.x;
      }
      
      public function getY() : int
      {
         return this.y;
      }
   }
}


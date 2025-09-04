package net.bigpoint.darkorbit.resolution
{
   import net.bigpoint.darkorbit.pattern.CustomPattern;
   
   public class WindowPattern extends CustomPattern
   {
      
      private var xPos:int;
      
      private var yPos:int;
      
      private var centerHorizontal:Boolean;
      
      private var centerVertical:Boolean;
      
      public function WindowPattern(param1:int)
      {
         super(param1);
      }
      
      public function getXPos() : int
      {
         return this.xPos;
      }
      
      public function setXPos(param1:int) : void
      {
         this.xPos = param1;
      }
      
      public function getYPos() : int
      {
         return this.yPos;
      }
      
      public function setYPos(param1:int) : void
      {
         this.yPos = param1;
      }
      
      public function setCenterHorizontal() : void
      {
         this.centerHorizontal = true;
      }
      
      public function setCenterVertical() : void
      {
         this.centerVertical = true;
      }
      
      public function isCenterHorizontal() : Boolean
      {
         return this.centerHorizontal;
      }
      
      public function isCenterVertical() : Boolean
      {
         return this.centerVertical;
      }
   }
}


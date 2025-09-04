package net.bigpoint.darkorbit.background
{
   import net.bigpoint.darkorbit.pattern.CustomPattern;
   
   public class CustomBackgroundPattern extends CustomPattern
   {
      
      private var width:int;
      
      private var height:int;
      
      private var color:uint;
      
      public function CustomBackgroundPattern(param1:int, param2:int, param3:int, param4:uint)
      {
         super(param1);
         this.width = param2;
         this.height = param3;
         this.color = param4;
      }
      
      public function getWidth() : int
      {
         return this.width;
      }
      
      public function getHeight() : int
      {
         return this.height;
      }
      
      public function getColor() : uint
      {
         return this.color;
      }
   }
}


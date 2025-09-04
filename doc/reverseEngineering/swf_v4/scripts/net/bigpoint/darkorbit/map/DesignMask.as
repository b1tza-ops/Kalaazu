package net.bigpoint.darkorbit.map
{
   import flash.display.BitmapData;
   
   public class DesignMask
   {
      
      public var mask:BitmapData;
      
      public var scale:Number;
      
      public function DesignMask(param1:BitmapData = null, param2:Number = 1)
      {
         super();
         this.mask = param1;
         this.scale = param2;
      }
   }
}


package net.bigpoint.darkorbit.starfield
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class StarElement extends Bitmap
   {
      
      public var speed:Number;
      
      public function StarElement(param1:uint)
      {
         super(new BitmapData(1,1,false,param1));
      }
   }
}


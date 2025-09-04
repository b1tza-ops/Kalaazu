package net.bigpoint.as3toolbox.bitmapclip
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   internal class BCBitmapData extends BitmapData
   {
      
      public var offset:Point = new Point();
      
      public function BCBitmapData(param1:int, param2:int, param3:Boolean = true, param4:uint = 4294967295)
      {
         super(param1,param2,param3,param4);
      }
   }
}


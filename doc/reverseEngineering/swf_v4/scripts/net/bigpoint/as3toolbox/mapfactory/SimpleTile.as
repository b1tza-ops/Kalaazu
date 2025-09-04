package net.bigpoint.as3toolbox.mapfactory
{
   import flash.display.BitmapData;
   
   public class SimpleTile extends Tile
   {
      
      internal static var bitmapDataCache:Array = [];
      
      internal var bitmapData:BitmapData;
      
      internal var cacheID:String;
      
      internal var _effects:Array;
      
      public function SimpleTile(param1:int, param2:BitmapData, param3:String = null)
      {
         super(param1);
         this.cacheID = param3;
         if(param3 != null)
         {
            bitmapDataCache[param3] = param2;
         }
         else
         {
            this.bitmapData = param2;
         }
      }
      
      public function set effects(param1:Array) : void
      {
         var _loc2_:ITileEffect = null;
         this._effects = param1;
         if(this.bitmapData != null)
         {
            for each(_loc2_ in param1)
            {
               _loc2_.setBitmapData(this.bitmapData);
            }
         }
      }
      
      public function get effects() : Array
      {
         return this._effects;
      }
   }
}


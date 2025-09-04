package net.bigpoint.darkorbit.station
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   
   public class Station extends DynamicResource
   {
      
      public static const logger:ILogger = Log.getLogger("Station");
      
      private var stationName:String;
      
      private var posX:int;
      
      private var posY:int;
      
      private var pattern:StationPattern;
      
      private var iconBitmapData:BitmapData;
      
      public var stationGraphic:MovieClip;
      
      private var id:int;
      
      public function Station(param1:int, param2:int, param3:String, param4:int, param5:int, param6:StationPattern)
      {
         super(param2);
         this.id = param1;
         this.posX = param4;
         this.posY = param5;
         this.stationName = param3;
         this.pattern = param6;
      }
      
      public function getPosX() : int
      {
         return this.posX;
      }
      
      public function getPosY() : int
      {
         return this.posY;
      }
      
      public function getPattern() : StationPattern
      {
         return this.pattern;
      }
      
      public function setIcon(param1:int) : void
      {
         param1 += 20;
         var _loc2_:MovieClip = clip;
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(_loc2_.width / 2,_loc2_.height / 2);
         _loc3_.scale(scaleSize.x,scaleSize.y);
         var _loc4_:int = _loc2_.width / param1;
         var _loc5_:int = _loc2_.height / param1;
         this.iconBitmapData = new BitmapData(_loc4_,_loc5_,true,10);
         this.iconBitmapData.draw(_loc2_,_loc3_);
      }
      
      public function getIcon() : BitmapData
      {
         return this.iconBitmapData;
      }
      
      public function deleteIcon() : void
      {
         this.iconBitmapData = null;
      }
      
      public function setHealthStationStatus(param1:Boolean) : void
      {
         if(param1)
         {
            this.stationGraphic.cross.alpha = 1;
            this.stationGraphic.yellowCross.alpha = 0;
         }
         else
         {
            this.stationGraphic.cross.alpha = 0;
            this.stationGraphic.yellowCross.alpha = 1;
         }
      }
   }
}


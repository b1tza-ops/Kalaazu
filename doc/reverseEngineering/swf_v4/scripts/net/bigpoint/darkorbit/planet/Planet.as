package net.bigpoint.darkorbit.planet
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   
   public class Planet extends DynamicResource
   {
      
      private static const logger:ILogger = Log.getLogger("DarkOrbitRF.Planet");
      
      public var pFactor:Number;
      
      public var layerIndex:Number;
      
      public var x:int;
      
      public var y:int;
      
      public var rotation:int;
      
      private var iconBitmapData:BitmapData;
      
      private var _pattern:PlanetPattern;
      
      public var lightsourceID:int;
      
      private var eclipse:MovieClip;
      
      private var _originalPos:Point = new Point();
      
      public var _originPoint:Rectangle;
      
      public function Planet(param1:PlanetPattern, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:int, param8:int = -1)
      {
         super(param2);
         this.rotation = param5;
         this._pattern = param1;
         this.x = param3 * 10 / param6;
         this.y = param4 * 10 / param6;
         this.pFactor = param6;
         this.layerIndex = param7;
         this.lightsourceID = param8;
         this._originalPos.x = param3;
         this._originalPos.y = param4;
      }
      
      public function getLayerIndex() : Number
      {
         return this.layerIndex;
      }
      
      public function setIcon(param1:int) : void
      {
         param1 += 4;
         var _loc2_:MovieClip = clip;
         var _loc3_:Sprite = new Sprite();
         _loc2_.addChild(_loc3_);
         this._originPoint = _loc2_.getBounds(_loc3_);
         _loc2_.removeChild(_loc3_);
         var _loc4_:Matrix = new Matrix();
         _loc4_.translate(this._originPoint.x * -1,this._originPoint.y * -1);
         _loc4_.scale(scaleSize.x * this.pFactor,scaleSize.y * this.pFactor);
         var _loc5_:int = scaleSize.x * this.pFactor * _loc2_.width;
         var _loc6_:int = scaleSize.y * this.pFactor * _loc2_.height;
         if(_loc5_ > PlanetManager.MIN_ICON_SIZE && _loc6_ > PlanetManager.MIN_ICON_SIZE)
         {
            this.iconBitmapData = new BitmapData(_loc5_,_loc6_,true,10);
            this.iconBitmapData.draw(_loc2_,_loc4_);
         }
      }
      
      public function getIcon() : BitmapData
      {
         return this.iconBitmapData;
      }
      
      public function deleteIcon() : void
      {
         this.iconBitmapData = null;
      }
      
      public function attachEclipse() : void
      {
         this.eclipse = ResourceManager.getMovieClip("eclipse","eclipse");
         var _loc1_:Number = 100 / 515 * (this._pattern.getRadius() * 2) / 100;
         this.eclipse.scaleX = _loc1_;
         this.eclipse.scaleY = _loc1_;
         this.eclipse.blendMode = "overlay";
         clip.addChild(this.eclipse);
      }
      
      public function updateEclipse(param1:int) : void
      {
         if(this.eclipse != null)
         {
            this.eclipse.rotation = param1;
         }
      }
      
      public function toString() : String
      {
         return "Planet layerIndex" + this.layerIndex;
      }
      
      public function get originalPos() : Point
      {
         return this._originalPos;
      }
      
      public function get originPoint() : Rectangle
      {
         return this._originPoint;
      }
      
      public function get pattern() : PlanetPattern
      {
         return this._pattern;
      }
   }
}


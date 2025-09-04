package net.bigpoint.darkorbit.map
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class POIZone extends Sprite
   {
      
      public static var displayPOIVisuals:Boolean = false;
      
      public static const TYPE_CIRCLE:String = "CIR";
      
      public static const TYPE_RECT:String = "REC";
      
      public static const TYPE_POLYGON:String = "POL";
      
      private var simpleVisualsAlpha:Number = 0.4;
      
      private var finisher:SWFFinisher;
      
      public var active:Boolean;
      
      public var zoneType:String;
      
      public var shape:String;
      
      public var designID:int;
      
      public var designBmc:BitmapClip;
      
      public var points:Array;
      
      public var radius:Number;
      
      public var zoneWidth:Number;
      
      public var zoneHeight:Number;
      
      public var topLeft:Point;
      
      public var topRight:Point;
      
      public var botLeft:Point;
      
      public var botRight:Point;
      
      public var first:Point;
      
      public var second:Point;
      
      public var third:Point;
      
      public var fourth:Point;
      
      private var pointsArray:Array;
      
      public var map:Map;
      
      private var visualRep:Shape;
      
      private var fillerHolder:Sprite;
      
      private var loader:AssetLazyLoader;
      
      public function POIZone(param1:String, param2:int, param3:String, param4:Map, param5:int, param6:Array, param7:Number = NaN)
      {
         var _loc8_:Array = null;
         super();
         this.zoneType = param1;
         this.active = Boolean(param5);
         this.points = param6;
         this.shape = param3;
         this.radius = param7;
         this.map = param4;
         this.designID = param2;
         if(!param7)
         {
            this.first = new Point(param6[0],param6[1]);
            this.second = new Point(param6[2],param6[3]);
            this.third = new Point(param6[4],param6[5]);
            this.fourth = new Point(param6[6],param6[7]);
            this.pointsArray = [this.first,this.second,this.third,this.fourth];
            _loc8_ = this.findAllCornerPoints();
            this.topLeft = _loc8_[0];
            this.topRight = _loc8_[1];
            this.botLeft = _loc8_[2];
            this.botRight = _loc8_[3];
         }
      }
      
      public static function getRandomCount(param1:int, param2:int) : int
      {
         return param1 + Math.floor(Math.random() * (param2 - param1 + 1));
      }
      
      private function findAllCornerPoints() : Array
      {
         var _loc6_:Point = null;
         var _loc1_:Point = this.pointsArray[0];
         var _loc2_:Point = this.pointsArray[0];
         var _loc3_:Point = this.pointsArray[0];
         var _loc4_:Point = this.pointsArray[0];
         var _loc5_:int = 0;
         while(_loc5_ < this.pointsArray.length)
         {
            _loc6_ = this.pointsArray[_loc5_];
            if(_loc6_.x < _loc1_.x || _loc6_.y < _loc1_.y)
            {
               _loc1_ = _loc6_;
            }
            if(_loc6_.x > _loc2_.x || _loc6_.y < _loc2_.y)
            {
               _loc2_ = _loc6_;
            }
            if(_loc6_.x < _loc3_.x || _loc6_.y > _loc3_.y)
            {
               _loc3_ = _loc6_;
            }
            if(_loc6_.x > _loc4_.x || _loc6_.y > _loc4_.y)
            {
               _loc4_ = _loc6_;
            }
            _loc5_++;
         }
         return [_loc1_,_loc2_,_loc3_,_loc4_];
      }
      
      public function init() : void
      {
         switch(this.shape)
         {
            case TYPE_RECT:
               this.createRectangleZone();
               break;
            case TYPE_CIRCLE:
               this.createCircularZone();
               break;
            case TYPE_POLYGON:
               this.createPolygonZone();
         }
      }
      
      public function draw() : void
      {
         switch(this.shape)
         {
            case TYPE_RECT:
               this.drawRectangleZone();
               break;
            case TYPE_CIRCLE:
               this.drawCircularZone();
               break;
            case TYPE_POLYGON:
               this.drawPolygonZone();
         }
      }
      
      private function createRectangleZone() : void
      {
         x = this.topLeft.x;
         y = this.topLeft.y;
         this.zoneWidth = Math.abs(this.topLeft.x - this.topRight.x);
         this.zoneHeight = Math.abs(this.topLeft.y - this.botLeft.y);
      }
      
      private function drawRectangleZone() : void
      {
         if(this.designID != 0 && Settings.qualityPoizone == Settings.QUALITY_LOW)
         {
            if(this.visualRep == null)
            {
               this.visualRep = new Shape();
               this.map.getMain().screenManager.getPoizoneLayer().addChild(this.visualRep);
            }
            this.visualRep.graphics.lineStyle(1,0);
            this.visualRep.graphics.beginFill(POIManager.zoneTypeColorDict[this.zoneType],this.simpleVisualsAlpha);
            this.visualRep.graphics.drawRect(x,y,this.zoneWidth,this.zoneHeight);
            this.visualRep.graphics.endFill();
         }
      }
      
      private function createCircularZone() : void
      {
         x = this.points[0];
         y = this.points[1];
      }
      
      private function drawCircularZone() : void
      {
         if(this.designID != 0 && Settings.qualityPoizone == Settings.QUALITY_LOW)
         {
            if(this.visualRep == null)
            {
               this.visualRep = new Shape();
               this.map.getMain().screenManager.getPoizoneLayer().addChild(this.visualRep);
            }
            this.visualRep.graphics.lineStyle(1,0);
            this.visualRep.graphics.beginFill(POIManager.zoneTypeColorDict[this.zoneType],this.simpleVisualsAlpha);
            this.visualRep.graphics.drawCircle(x,y,this.radius);
            this.visualRep.graphics.endFill();
         }
      }
      
      private function createPolygonZone() : void
      {
      }
      
      private function drawPolygonZone() : void
      {
      }
      
      private function beginPopulatingProcess() : void
      {
         this.loader = new AssetLazyLoader();
         if(!ResourceManager.fileCollection.isLoaded(PatternManager.poizonePatterns[this.designID].resKey))
         {
            this.loader.addEventListener(AssetLazyLoader.ASSET_LOADED,this.populateZones);
            this.loader.loadAsset(PatternManager.poizonePatterns[this.designID].resKey);
         }
         else
         {
            this.populateZones(null);
         }
      }
      
      private function populateZones(param1:Event) : void
      {
         var _loc3_:BitmapClip = null;
         var _loc4_:int = 0;
         var _loc11_:int = 0;
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(PatternManager.poizonePatterns[this.designID].resKey));
         this.designBmc = new BitmapClip(this.finisher.getEmbededMovieClip("mc",true),PatternManager.poizonePatterns[this.designID].resKey);
         var _loc2_:int = this.designBmc.framesLoaded;
         var _loc5_:Array = [];
         this.fillerHolder = new Sprite();
         this.fillerHolder.mouseEnabled = false;
         this.fillerHolder.mouseChildren = false;
         var _loc6_:int = Math.round(this.zoneWidth / PatternManager.poizonePatterns[this.designID].avWidth);
         var _loc7_:int = Math.round(this.zoneHeight / PatternManager.poizonePatterns[this.designID].avHeight);
         _loc6_ = _loc6_ < 1 ? 1 : _loc6_;
         _loc7_ = _loc7_ < 1 ? 1 : _loc7_;
         var _loc8_:int = Math.round(this.zoneWidth / _loc6_);
         var _loc9_:int = Math.round(this.zoneHeight / _loc7_);
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_)
         {
            _loc5_[_loc10_] = [];
            _loc11_ = 0;
            while(_loc11_ < _loc6_)
            {
               _loc3_ = BitmapClip(this.designBmc.clone());
               if(_loc2_ <= 1)
               {
                  _loc4_ = getRandomCount(1,_loc2_);
               }
               else if(_loc10_ == 0 && _loc11_ == 0)
               {
                  _loc4_ = getRandomCount(1,_loc2_);
               }
               else if(_loc10_ == 0)
               {
                  while(_loc5_[_loc10_][_loc11_ - 1] == _loc4_)
                  {
                     _loc4_ = getRandomCount(1,_loc2_);
                  }
               }
               else if(_loc11_ == 0)
               {
                  while(_loc5_[_loc10_ - 1][_loc11_] == _loc4_)
                  {
                     _loc4_ = getRandomCount(1,_loc2_);
                  }
               }
               else
               {
                  while(_loc5_[_loc10_][_loc11_ - 1] == _loc4_ || _loc5_[_loc10_ - 1][_loc11_] == _loc4_)
                  {
                     _loc4_ = getRandomCount(1,_loc2_);
                  }
               }
               _loc5_[_loc10_][_loc11_] = _loc4_;
               _loc3_.gotoAndStop(_loc4_);
               _loc3_.x = this.x + (_loc11_ * _loc8_ + _loc8_ * 0.5);
               _loc3_.y = this.y + (_loc10_ * _loc9_ + _loc9_ * 0.5);
               this.fillerHolder.addChild(_loc3_);
               _loc11_++;
            }
            _loc10_++;
         }
         this.map.getMain().screenManager.getPoizoneLayer().addChild(this.fillerHolder);
      }
      
      public function cleanup() : void
      {
         if(this.visualRep != null && this.map.getMain().screenManager.getPoizoneLayer().contains(this.visualRep))
         {
            this.map.getMain().screenManager.getPoizoneLayer().removeChild(this.visualRep);
            this.visualRep = null;
         }
      }
   }
}


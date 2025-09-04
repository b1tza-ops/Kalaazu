package net.bigpoint.darkorbit.map
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.background.Background;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.PoizonePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class POIManager
   {
      
      public static const logger:ILogger = Log.getLogger("POIManager");
      
      public static var noaBmdScalefactor:Number = 40;
      
      public static var designMaskScalefactor:Number = 10;
      
      public static const NOA_BMP_WIDTH:int = 525;
      
      public static const NOA_BMP_HEIGHT:int = 328;
      
      public static const MAX_VISUAL_DIMENSION:int = 1000;
      
      public static const SHAPE_CIRCLE:String = "CIR";
      
      public static const SHAPE_RECT:String = "REC";
      
      public static const SHAPE_POLYGON:String = "POL";
      
      public static const TYPE_NO_ACCESS:String = "NOA";
      
      public static const TYPE_HEALING:String = "HEA";
      
      public static const TYPE_TRIGGER:String = "TRG";
      
      public static const TYPE_DAMAGE:String = "DMG";
      
      public static const COLOR_RED:uint = 16711680;
      
      public static const COLOR_GREEN:uint = 65280;
      
      public static const COLOR_BLUE:uint = 255;
      
      public static const zoneTypeColorDict:Dictionary = new Dictionary();
      
      public var poiZones:Array;
      
      public var designMasks:Vector.<DesignMask>;
      
      public var noaZones:Array;
      
      public var noaBmd:BitmapData;
      
      public var noaRouteBmd:Line;
      
      public var healingZones:Array;
      
      public var triggerZones:Array;
      
      public var enterLeaveTriggerZones:Array;
      
      private var map:Map;
      
      private var halfScreenWidth:int;
      
      private var halfScreenHeight:int;
      
      public var currentVisualStyle:int;
      
      public function POIManager(param1:Map)
      {
         super();
         this.map = param1;
         this.halfScreenWidth = ScreenManager.getHalfScreenWidth();
         this.halfScreenHeight = ScreenManager.getHalfScreenHeight();
         this.poiZones = [];
         this.noaZones = [];
         this.healingZones = [];
         this.triggerZones = [];
         this.designMasks = new Vector.<DesignMask>();
         this.enterLeaveTriggerZones = [];
         this.createPOIColorReference();
         this.currentVisualStyle = Settings.qualityPoizone;
      }
      
      private function createPOIColorReference() : void
      {
         zoneTypeColorDict[TYPE_NO_ACCESS] = COLOR_RED;
         zoneTypeColorDict[TYPE_HEALING] = COLOR_GREEN;
         zoneTypeColorDict[TYPE_TRIGGER] = COLOR_BLUE;
         zoneTypeColorDict[TYPE_DAMAGE] = COLOR_BLUE;
      }
      
      public function addPOIZone(param1:String, param2:int, param3:String, param4:int, param5:Array) : void
      {
         var _loc6_:POIZone = null;
         switch(param3)
         {
            case SHAPE_CIRCLE:
               _loc6_ = new POIZone(param1,param2,param3,this.map,param4,param5,param5[2]);
               switch(param1)
               {
                  case "NOA":
                     this.noaZones.push(_loc6_);
                     this.expandNoaBmp(_loc6_);
                     break;
                  case "HEA":
                     this.healingZones.push(_loc6_);
                     break;
                  case "TRG":
                     this.triggerZones.push(_loc6_);
               }
               break;
            case SHAPE_RECT:
            case SHAPE_POLYGON:
               _loc6_ = new POIZone(param1,param2,param3,this.map,param4,param5);
               switch(param1)
               {
                  case "NOA":
                     this.noaZones.push(_loc6_);
                     this.expandNoaBmp(_loc6_);
                     break;
                  case "HEA":
                     this.healingZones.push(_loc6_);
                     break;
                  case "TRG":
                     this.triggerZones.push(_loc6_);
               }
         }
         this.poiZones.push(_loc6_);
         _loc6_.init();
      }
      
      private function drawDesignMasks() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Rectangle = null;
         var _loc12_:Sprite = null;
         var _loc13_:Matrix = null;
         var _loc14_:POIZone = null;
         var _loc1_:int = 2;
         for each(_loc14_ in this.poiZones)
         {
            if(_loc14_.designID != 0)
            {
               while(_loc14_.designID >= this.designMasks.length)
               {
                  this.designMasks[this.designMasks.length] = null;
               }
               if(this.designMasks[_loc14_.designID] == null)
               {
                  this.designMasks[_loc14_.designID] = new DesignMask(new BitmapData(Math.round(this.map.serious_width / designMaskScalefactor),Math.round(this.map.serious_height / designMaskScalefactor),true,0));
               }
               if(this.designMasks[_loc14_.designID].scale > 1)
               {
                  _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                  _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
               }
               else
               {
                  _loc9_ = 0;
                  _loc10_ = 0;
               }
               switch(_loc14_.shape)
               {
                  case SHAPE_RECT:
                     if(_loc14_.topLeft.x + _loc9_ < 0)
                     {
                        this.expandDesignMask(_loc14_.designID,Math.abs(_loc14_.topLeft.x + _loc9_),0);
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     else if(_loc14_.topLeft.x + _loc9_ > this.map.serious_width + 2 * _loc9_)
                     {
                        this.expandDesignMask(_loc14_.designID,_loc14_.topLeft.x + _loc9_ - (this.map.serious_width + 2 * _loc9_),0);
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     if(_loc14_.topLeft.y + _loc10_ < 0)
                     {
                        this.expandDesignMask(_loc14_.designID,0,Math.abs(_loc14_.topLeft.y + _loc10_));
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     else if(_loc14_.topLeft.y + _loc10_ > this.map.serious_height + 2 * _loc10_)
                     {
                        this.expandDesignMask(_loc14_.designID,0,_loc14_.topLeft.y + _loc10_ - (this.map.serious_height + 2 * _loc10_));
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     if(_loc14_.botRight.x + _loc9_ > this.map.serious_width + 2 * _loc9_)
                     {
                        this.expandDesignMask(_loc14_.designID,_loc14_.botRight.x + _loc9_ - (this.map.serious_width + 2 * _loc9_),0);
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     if(_loc14_.botRight.y + _loc10_ > this.map.serious_height + 2 * _loc10_)
                     {
                        this.expandDesignMask(_loc14_.designID,0,_loc14_.botRight.y + _loc10_ - (this.map.serious_height + 2 * _loc10_));
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     _loc2_ = Math.round((_loc14_.topLeft.x + _loc9_) / designMaskScalefactor) - _loc1_;
                     _loc3_ = Math.round((_loc14_.topLeft.y + _loc10_) / designMaskScalefactor) - _loc1_;
                     _loc4_ = Math.round((_loc14_.botRight.x + _loc9_) / designMaskScalefactor) + _loc1_;
                     _loc5_ = Math.round((_loc14_.botRight.y + _loc10_) / designMaskScalefactor) + _loc1_;
                     _loc6_ = _loc4_ - _loc2_;
                     _loc7_ = _loc5_ - _loc3_;
                     _loc11_ = new Rectangle(_loc2_,_loc3_,_loc6_,_loc7_);
                     this.designMasks[_loc14_.designID].mask.fillRect(_loc11_,4278190080);
                     break;
                  case SHAPE_CIRCLE:
                     if(_loc14_.points[0] + _loc9_ - _loc8_ < 0)
                     {
                        this.expandDesignMask(_loc14_.designID,Math.abs(_loc14_.points[0] + _loc9_ - _loc8_),0);
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     else if(_loc14_.points[0] + _loc9_ + _loc8_ > this.map.serious_width + 2 * _loc9_)
                     {
                        this.expandDesignMask(_loc14_.designID,_loc14_.points[0] + _loc9_ + _loc8_ - (this.map.serious_width + 2 * _loc9_),0);
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     if(_loc14_.points[1] + _loc10_ - _loc8_ < 0)
                     {
                        this.expandDesignMask(_loc14_.designID,0,Math.abs(_loc14_.points[1] + _loc10_ - _loc8_));
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     else if(_loc14_.points[1] + _loc10_ + _loc8_ > this.map.serious_height + 2 * _loc10_)
                     {
                        this.expandDesignMask(_loc14_.designID,0,_loc14_.points[1] + _loc10_ + _loc8_ - (this.map.serious_height + 2 * _loc10_));
                        _loc9_ = Math.round((this.map.serious_width * this.designMasks[_loc14_.designID].scale - this.map.serious_width) / 2);
                        _loc10_ = Math.round((this.map.serious_height * this.designMasks[_loc14_.designID].scale - this.map.serious_height) / 2);
                     }
                     _loc2_ = Math.round((int(_loc14_.points[0]) + _loc9_) / designMaskScalefactor);
                     _loc3_ = Math.round((int(_loc14_.points[1]) + _loc10_) / designMaskScalefactor);
                     _loc8_ = Math.round(_loc14_.radius / designMaskScalefactor) + _loc1_;
                     _loc12_ = new Sprite();
                     _loc12_.graphics.beginFill(4278190080);
                     _loc12_.graphics.drawCircle(0,0,_loc8_);
                     _loc12_.graphics.endFill();
                     _loc13_ = new Matrix();
                     _loc13_.translate(_loc2_,_loc3_);
                     this.designMasks[_loc14_.designID].mask.draw(_loc12_,_loc13_);
                     break;
                  case SHAPE_POLYGON:
               }
            }
         }
      }
      
      private function expandDesignMask(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:BitmapData = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Point = null;
         var _loc4_:BitmapData = this.designMasks[param1].mask;
         if(_loc4_.width >= Map.LIMITED_WIDTH || _loc4_.height >= Map.LIMITED_HEIGHT)
         {
            return;
         }
         param2 = Math.round(param2 / designMaskScalefactor);
         param3 = Math.round(param3 / designMaskScalefactor);
         if(param2 > 0)
         {
            _loc5_ = _loc4_.width + 2 * param2;
            if(_loc5_ > Map.LIMITED_WIDTH)
            {
               _loc5_ = Map.LIMITED_WIDTH;
            }
            _loc7_ = _loc5_ / _loc4_.width;
            _loc6_ = _loc4_.height * _loc7_;
         }
         if(param3 > 0)
         {
            _loc6_ = _loc4_.height + 2 * param3;
            if(_loc6_ > Map.LIMITED_HEIGHT)
            {
               _loc6_ = Map.LIMITED_HEIGHT;
            }
            _loc7_ = _loc6_ / _loc4_.height;
            _loc5_ = _loc4_.width * _loc7_;
         }
         param2 = (_loc5_ - _loc4_.width) / 2;
         param3 = (_loc6_ - _loc4_.height) / 2;
         if(_loc5_ > 0 && _loc6_ > 0)
         {
            _loc8_ = new BitmapData(_loc5_,_loc6_,true,0);
            _loc9_ = new Rectangle(0,0,_loc4_.width,_loc4_.height);
            _loc10_ = new Point(param2,param3);
            _loc8_.copyPixels(_loc4_,_loc9_,_loc10_);
            this.designMasks[param1].mask = _loc8_;
            this.designMasks[param1].scale = _loc8_.width / (this.map.serious_width / designMaskScalefactor);
         }
         _loc4_.dispose();
      }
      
      public function drawPOIZones() : void
      {
         var _loc1_:POIZone = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:BitmapData = null;
         var _loc13_:PoizonePattern = null;
         var _loc14_:int = 0;
         this.cleanupSimpleVisuals();
         this.cleanupNormalVisuals();
         if(Settings.qualityPoizone == Settings.QUALITY_LOW)
         {
            for each(_loc1_ in this.poiZones)
            {
               _loc1_.draw();
            }
         }
         else
         {
            this.drawDesignMasks();
            _loc2_ = false;
            _loc3_ = 1;
            _loc4_ = this.map.getMain().screenManager.getBackgroundContainer().numChildren;
            _loc5_ = true;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 1;
            _loc9_ = -1;
            _loc10_ = true;
            _loc11_ = 1;
            while(_loc11_ < this.designMasks.length)
            {
               if(this.designMasks[_loc11_] != null && this.designMasks[_loc11_].mask != null)
               {
                  if(this.designMasks[_loc11_].scale != 1)
                  {
                     _loc8_ = this.designMasks[_loc11_].scale;
                  }
                  else
                  {
                     _loc8_ = 1;
                  }
                  _loc13_ = PatternManager.poizonePatterns[_loc11_];
                  if(_loc13_ != null)
                  {
                     for each(_loc14_ in _loc13_.backgroundIDs)
                     {
                        this.map.getMain().screenManager.addBackgroundLayer();
                        _loc12_ = this.designMasks[_loc11_].mask.clone();
                        this.map.getBackgroundManager().createBackground(_loc14_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc12_);
                        _loc4_++;
                     }
                  }
               }
               _loc11_++;
            }
            _loc11_ = 1;
            while(_loc11_ < this.designMasks.length)
            {
               if(this.designMasks[_loc11_] != null && this.designMasks[_loc11_].mask != null)
               {
                  this.designMasks[_loc11_].mask.dispose();
                  this.designMasks[_loc11_].mask = null;
                  this.designMasks[_loc11_] = null;
               }
               _loc11_++;
            }
         }
         if(this.map.getMinimapManager().getMiniMap())
         {
            this.map.getMinimapManager().getMiniMap().drawPOIZones();
         }
      }
      
      public function expandNoaBmp(param1:POIZone) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Rectangle = null;
         var _loc11_:Sprite = null;
         var _loc12_:Matrix = null;
         if(this.noaBmd == null)
         {
            this.noaBmd = new BitmapData(NOA_BMP_WIDTH,NOA_BMP_HEIGHT,true,0);
         }
         if(this.noaRouteBmd == null)
         {
            this.noaRouteBmd = new Line(NOA_BMP_WIDTH,NOA_BMP_HEIGHT,true,0);
         }
         var _loc2_:int = 1;
         switch(param1.shape)
         {
            case SHAPE_RECT:
               _loc3_ = param1.topLeft.x;
               _loc4_ = param1.topLeft.y;
               _loc5_ = param1.botRight.x;
               _loc6_ = param1.botRight.y;
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               else if(_loc3_ > this.map.serious_width)
               {
                  _loc3_ = this.map.serious_width;
               }
               if(_loc4_ < 0)
               {
                  _loc4_ = 0;
               }
               else if(_loc4_ > this.map.serious_height)
               {
                  _loc4_ = this.map.serious_height;
               }
               if(_loc5_ < 0)
               {
                  _loc5_ = 0;
               }
               else if(_loc5_ > this.map.serious_width)
               {
                  _loc5_ = this.map.serious_width;
               }
               if(_loc6_ < 0)
               {
                  _loc6_ = 0;
               }
               else if(_loc6_ > this.map.serious_height)
               {
                  _loc6_ = this.map.serious_height;
               }
               _loc3_ = Math.round(_loc3_ / noaBmdScalefactor);
               _loc4_ = Math.round(_loc4_ / noaBmdScalefactor);
               _loc5_ = Math.round(_loc5_ / noaBmdScalefactor);
               if(_loc5_ < NOA_BMP_WIDTH)
               {
                  _loc5_ += _loc2_;
               }
               _loc6_ = Math.round(_loc6_ / noaBmdScalefactor);
               if(_loc6_ < NOA_BMP_HEIGHT)
               {
                  _loc6_ += _loc2_;
               }
               _loc8_ = _loc5_ - _loc3_;
               _loc9_ = _loc6_ - _loc4_;
               _loc10_ = new Rectangle(_loc3_,_loc4_,_loc8_,_loc9_);
               this.noaBmd.fillRect(_loc10_,4278190080);
               break;
            case SHAPE_CIRCLE:
               _loc3_ = int(param1.points[0]);
               _loc4_ = int(param1.points[1]);
               _loc3_ = Math.round(_loc3_ / noaBmdScalefactor);
               _loc4_ = Math.round(_loc4_ / noaBmdScalefactor);
               _loc7_ = Math.round(param1.radius / noaBmdScalefactor) + _loc2_;
               _loc11_ = new Sprite();
               _loc11_.graphics.beginFill(4278190080);
               _loc11_.graphics.drawCircle(0,0,_loc7_);
               _loc11_.graphics.endFill();
               _loc12_ = new Matrix();
               _loc12_.translate(_loc3_,_loc4_);
               this.noaBmd.draw(_loc11_,_loc12_);
               break;
            case SHAPE_POLYGON:
         }
      }
      
      public function checkPOIZoneCollisions(param1:Point, param2:Point) : Point
      {
         var _loc3_:Point = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(this.noaZones.length < 1)
         {
            return null;
         }
         var _loc4_:Point = new Point(param1.x,param1.y);
         var _loc5_:Point = new Point(param2.x,param2.y);
         var _loc6_:Boolean = false;
         if(_loc4_.x < 0)
         {
            _loc6_ = true;
         }
         else if(_loc4_.x > this.map.serious_width)
         {
            _loc6_ = true;
         }
         if(_loc4_.y < 0)
         {
            _loc6_ = true;
         }
         else if(_loc4_.y > this.map.serious_height)
         {
            _loc6_ = true;
         }
         if(_loc5_.x < 0)
         {
            _loc6_ = true;
         }
         else if(_loc5_.x > this.map.serious_width)
         {
            _loc6_ = true;
         }
         if(_loc5_.y < 0)
         {
            _loc6_ = true;
         }
         else if(_loc5_.y > this.map.serious_height)
         {
            _loc6_ = true;
         }
         if(_loc6_)
         {
            return this.checkPOIZoneCollisionsByLines(param1,param2);
         }
         _loc4_.x = Math.round(_loc4_.x / noaBmdScalefactor);
         _loc4_.y = Math.round(_loc4_.y / noaBmdScalefactor);
         _loc5_.x = Math.round(_loc5_.x / noaBmdScalefactor);
         _loc5_.y = Math.round(_loc5_.y / noaBmdScalefactor);
         if(param2.x > param1.x)
         {
            _loc7_ = true;
            _loc8_ = false;
         }
         else
         {
            _loc7_ = false;
            _loc8_ = true;
         }
         if(param2.y > param1.y)
         {
            _loc9_ = true;
            _loc10_ = false;
         }
         else
         {
            _loc9_ = false;
            _loc10_ = true;
         }
         if(this.isCollidingWithNoa(_loc4_,_loc4_))
         {
            return this.checkPOIZoneCollisionsByLines(param1,param2);
         }
         var _loc11_:Boolean = false;
         _loc11_ = this.isCollidingWithNoa(_loc4_,_loc5_);
         if(_loc11_)
         {
            _loc3_ = this.getCollisonPoint(_loc4_,_loc5_);
            if(_loc3_ == null)
            {
               return this.checkPOIZoneCollisionsByLines(param1,param2);
            }
            _loc3_.x = Math.round(_loc3_.x * noaBmdScalefactor);
            _loc3_.y = Math.round(_loc3_.y * noaBmdScalefactor);
            if(_loc3_.x > param1.x && _loc8_)
            {
               _loc3_.x = Math.floor(param1.x);
            }
            if(_loc3_.x < param1.x && _loc7_)
            {
               _loc3_.x = Math.ceil(param1.x);
            }
            if(_loc3_.y > param1.y && _loc10_)
            {
               _loc3_.y = Math.floor(param1.y);
            }
            if(_loc3_.y < param1.y && _loc9_)
            {
               _loc3_.y = Math.ceil(param1.y);
            }
            return _loc3_;
         }
         return null;
      }
      
      private function getCollisonPoint(param1:Point, param2:Point) : Point
      {
         var _loc3_:int = 0;
         var _loc5_:Point = null;
         var _loc4_:Point = new Point(0,0);
         _loc3_ = Point.distance(param1,param2);
         while(_loc3_ > 1)
         {
            _loc5_ = this.getMiddlePoint(param1,param2);
            if(this.isCollidingWithNoa(param1,_loc5_))
            {
               param2 = _loc5_;
            }
            else
            {
               param1 = _loc5_;
            }
            _loc3_ = Point.distance(param1,param2);
         }
         if(!this.isCollidingWithNoa(param1,param1))
         {
            return param1;
         }
         if(!this.isCollidingWithNoa(param2,param2))
         {
            return param2;
         }
         return null;
      }
      
      private function isCollidingWithNoa(param1:Point, param2:Point = null) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Point = new Point(0,0);
         if(param2 != null)
         {
            this.noaRouteBmd.line(param1.x,param1.y,param2.x,param2.y,4278190080);
            _loc3_ = this.noaBmd.hitTest(_loc4_,255,this.noaRouteBmd,_loc4_);
            this.noaRouteBmd.dispose();
            this.noaRouteBmd = new Line(NOA_BMP_WIDTH,NOA_BMP_HEIGHT,true,0);
            return _loc3_;
         }
         return this.noaBmd.hitTest(_loc4_,255,param1);
      }
      
      private function getMiddlePoint(param1:Point, param2:Point) : Point
      {
         var _loc3_:Point = new Point(0,0);
         var _loc4_:Point = new Point();
         _loc4_.x = Math.floor((param1.x - param2.x) * 0.5);
         _loc4_.y = Math.floor((param1.y - param2.y) * 0.5);
         _loc4_.x += param2.x;
         _loc4_.y += param2.y;
         return _loc4_;
      }
      
      private function getOnePixelLessIntersectPoint(param1:Point, param2:Point) : Point
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param2.x < param1.x)
         {
            _loc3_ = param1.x - 5;
         }
         else if(param2.x > param1.x)
         {
            _loc3_ = param1.x + 5;
         }
         else if(param2.x == param1.x)
         {
            _loc3_ = param1.x;
         }
         if(param2.y < param1.y)
         {
            _loc4_ = param1.y - 5;
         }
         else if(param2.y > param1.y)
         {
            _loc4_ = param1.y + 5;
         }
         else if(param2.y == param1.y)
         {
            _loc4_ = param1.y;
         }
         return new Point(_loc3_,_loc4_);
      }
      
      public function checkPOIZoneCollisionsByLines(param1:Point, param2:Point) : Point
      {
         var _loc4_:Point = null;
         var _loc5_:POIZone = null;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:Point = null;
         var _loc15_:Number = NaN;
         var _loc16_:Point = null;
         var _loc3_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < this.noaZones.length)
         {
            _loc5_ = this.noaZones[_loc6_] as POIZone;
            if(_loc5_.shape == "REC")
            {
               _loc10_ = _loc5_.topLeft;
               _loc11_ = _loc5_.topRight;
               _loc12_ = _loc5_.botLeft;
               _loc13_ = _loc5_.botRight;
               _loc4_ = this.lineIntersect(param1,param2,_loc10_,_loc11_);
               if(_loc4_ != null)
               {
                  _loc3_.push(_loc4_);
               }
               _loc4_ = this.lineIntersect(param1,param2,_loc10_,_loc12_);
               if(_loc4_ != null)
               {
                  _loc3_.push(_loc4_);
               }
               _loc4_ = this.lineIntersect(param1,param2,_loc11_,_loc13_);
               if(_loc4_ != null)
               {
                  _loc3_.push(_loc4_);
               }
               _loc4_ = this.lineIntersect(param1,param2,_loc12_,_loc13_);
               if(_loc4_ != null)
               {
                  _loc3_.push(_loc4_);
               }
            }
            _loc6_++;
         }
         if(_loc3_.length < 1)
         {
            return null;
         }
         if(_loc3_.length == 1)
         {
            _loc14_ = this.getOnePixelLessIntersectPoint(_loc3_[0],param1);
            if(_loc14_.x == param1.x && _loc14_.y == param1.y)
            {
               _loc14_ = _loc3_[0];
            }
            _loc15_ = FastMath.sqrt(Math.pow(_loc14_.x - param1.x,2) + Math.pow(_loc14_.y - param1.y,2));
            if(_loc15_)
            {
            }
            if(_loc15_ > 0)
            {
               return this.getOnePixelLessIntersectPoint(_loc3_[0],param1);
            }
            return null;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc16_ = _loc3_[_loc6_];
            _loc9_ = FastMath.sqrt(Math.pow(_loc16_.x - param1.x,2) + Math.pow(_loc16_.y - param1.y,2));
            if(_loc6_ > 0)
            {
               if(_loc9_ < _loc8_)
               {
                  _loc7_ = _loc16_;
                  _loc8_ = _loc9_;
               }
            }
            else
            {
               _loc8_ = _loc9_;
               _loc7_ = _loc16_;
            }
            _loc6_++;
         }
         return this.getOnePixelLessIntersectPoint(_loc7_,param1);
      }
      
      private function testZoneCollisionsAgainstPoint(param1:Point) : Boolean
      {
         var _loc3_:POIZone = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.noaZones.length)
         {
            _loc3_ = this.noaZones[_loc2_];
            if(param1.x > _loc3_.topLeft.x && param1.x < _loc3_.topRight.x && param1.y > _loc3_.topLeft.y && param1.y < _loc3_.botLeft.y)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function lineIntersect(param1:Point, param2:Point, param3:Point, param4:Point, param5:Boolean = true) : Point
      {
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         _loc7_ = param2.y - param1.y;
         _loc9_ = param1.x - param2.x;
         _loc11_ = param2.x * param1.y - param1.x * param2.y;
         _loc8_ = param4.y - param3.y;
         _loc10_ = param3.x - param4.x;
         _loc12_ = param4.x * param3.y - param3.x * param4.y;
         var _loc13_:Number = _loc7_ * _loc10_ - _loc8_ * _loc9_;
         if(_loc13_ == 0)
         {
            return null;
         }
         _loc6_ = new Point();
         _loc6_.x = (_loc9_ * _loc12_ - _loc10_ * _loc11_) / _loc13_;
         _loc6_.y = (_loc8_ * _loc11_ - _loc7_ * _loc12_) / _loc13_;
         if(param5)
         {
            if(Point.distance(_loc6_,param2) > Point.distance(param1,param2))
            {
               return null;
            }
            if(Point.distance(_loc6_,param1) > Point.distance(param1,param2))
            {
               return null;
            }
            if(Point.distance(_loc6_,param4) > Point.distance(param3,param4))
            {
               return null;
            }
            if(Point.distance(_loc6_,param3) > Point.distance(param3,param4))
            {
               return null;
            }
         }
         return _loc6_;
      }
      
      public function updatePOIZoneVisualStyle() : void
      {
         if(Settings.qualityPoizone != this.currentVisualStyle)
         {
            switch(Settings.qualityPoizone)
            {
               case Settings.QUALITY_LOW:
                  this.cleanupSimpleVisuals();
                  break;
               case Settings.QUALITY_HIGH:
               default:
                  this.cleanupNormalVisuals();
            }
            this.drawPOIZones();
            this.currentVisualStyle = Settings.qualityPoizone;
         }
      }
      
      private function cleanupSimpleVisuals() : void
      {
         var _loc1_:POIZone = null;
         for each(_loc1_ in this.poiZones)
         {
            _loc1_.cleanup();
         }
      }
      
      private function cleanupNormalVisuals() : void
      {
         var _loc1_:Background = null;
         var _loc2_:int = int(this.map.getMain().screenManager.backgrounds.length - 1);
         while(_loc2_ >= 0)
         {
            _loc1_ = this.map.getMain().screenManager.backgrounds[_loc2_];
            if(_loc1_ != null && _loc1_.isPOIZone)
            {
               _loc1_.cleanup();
               this.map.getMain().screenManager.removeBackgroundLayer(_loc1_.getLayerIndex());
               this.map.getMain().screenManager.backgrounds.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.poiZones.length)
         {
            this.poiZones[_loc1_].cleanup();
            _loc1_++;
         }
         if(this.noaBmd != null)
         {
            this.noaBmd.dispose();
            this.noaBmd = null;
         }
         if(this.noaRouteBmd != null)
         {
            this.noaRouteBmd.dispose();
            this.noaRouteBmd = null;
         }
         _loc1_ = 1;
         while(_loc1_ < this.designMasks.length)
         {
            if(this.designMasks[_loc1_] != null && this.designMasks[_loc1_].mask != null)
            {
               this.designMasks[_loc1_].mask.dispose();
               this.designMasks[_loc1_].mask = null;
               this.designMasks[_loc1_] = null;
            }
            _loc1_++;
         }
      }
   }
}


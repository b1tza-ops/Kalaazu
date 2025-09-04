package net.bigpoint.darkorbit.map
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.Interference;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.collectable.Beacon;
   import net.bigpoint.darkorbit.collectable.Collectable;
   import net.bigpoint.darkorbit.ctb.HomeZone;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.planet.Planet;
   import net.bigpoint.darkorbit.portal.Portal;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.ship.ShipManager;
   import net.bigpoint.darkorbit.station.Station;
   
   public class MiniMap extends SimpleContainer
   {
      
      public static const logger:ILogger = Log.getLogger("MiniMap");
      
      public var zoomFactor:Number;
      
      private var shipManager:ShipManager;
      
      private var timer:Timer;
      
      private var minimapManager:MinimapManager;
      
      public var mapScaleFactor:Number;
      
      private var background:Bitmap;
      
      private var foreground:Bitmap;
      
      public var clickMap:Sprite;
      
      private var poizonesBmp:Bitmap;
      
      private var sprite:Sprite;
      
      private var tmpPoint:Point;
      
      private var route:Point;
      
      private var mapLabel:TextField;
      
      private var coordinatesLabel:TextField;
      
      private var routeInfoLabel:TextField;
      
      public var miniMapWidth:int;
      
      public var miniMapHeight:int;
      
      private var markers:Array;
      
      public var yOffset:int = 27;
      
      private var mapInfoY:int = 9;
      
      private var distance:Number = -1;
      
      private var finisher:SWFFinisher;
      
      private var mapID:int;
      
      private var mapName:String;
      
      private var mapNameWidth:int;
      
      private var maxNeededCooWidth:int;
      
      private var sourceBitmapData:BitmapData;
      
      private var threatBitmapData:BitmapData;
      
      private var interference:Interference;
      
      private var overlay:MovieClip;
      
      public var combinedScaleFactor:Number;
      
      private var foreGroundRec:Rectangle;
      
      private var indicatorColors:Array;
      
      private var scaleSize:Point;
      
      public function MiniMap(param1:MinimapManager, param2:BitmapData, param3:Number, param4:Point = null)
      {
         var _loc8_:Planet = null;
         var _loc9_:Station = null;
         this.clickMap = new Sprite();
         this.poizonesBmp = new Bitmap();
         this.sprite = new Sprite();
         this.tmpPoint = new Point();
         this.mapLabel = new TextField();
         this.coordinatesLabel = new TextField();
         this.routeInfoLabel = new TextField();
         this.markers = new Array();
         this.foreGroundRec = new Rectangle();
         this.indicatorColors = [16777215,16772505,16767296,16763955,16751360,16737792];
         this.scaleSize = new Point();
         super(param1.getMap().getMain().getGuiManager(),SimpleContainer.CLASS_MINIMAP);
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("minimap"));
         this.mapScaleFactor = param1.getMap().getScaleFactor();
         this.minimapManager = param1;
         this.shipManager = param1.getMap().getShipManager();
         this.sourceBitmapData = param2;
         this.zoomFactor = param3;
         this.combinedScaleFactor = 1 / (param3 * 10);
         this.route = param4;
         this.overlay = this.finisher.getEmbededMovieClip("minimapOverlay");
         this.overlay.mouseEnabled = false;
         this.setBackground(param2);
         this.timer = new Timer(250,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.startTimer();
         var _loc5_:Array = param1.getMap().getMain().screenManager.planets;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc8_ = _loc5_[_loc6_];
            _loc8_.deleteIcon();
            _loc6_++;
         }
         var _loc7_:Array = param1.getMap().getStationManager().getStations();
         _loc6_ = 0;
         while(_loc6_ < _loc7_.length)
         {
            _loc9_ = _loc7_[_loc6_];
            _loc9_.deleteIcon();
            _loc6_++;
         }
         this.initMapInfoLabel(this.mapLabel);
         this.initMapInfoLabel(this.coordinatesLabel);
         this.coordinatesLabel.text = "999/999";
         this.maxNeededCooWidth = int(this.coordinatesLabel.width) + 2;
         this.coordinatesLabel.text = "";
         this.initMapInfoLabel(this.routeInfoLabel);
         this.addChild(this.overlay);
         this.updateCoordinates();
         this.foreground.bitmapData.lock();
         this.foreground.bitmapData.fillRect(this.foreground.bitmapData.rect,0);
         this.foreGroundRec = this.foreground.bitmapData.rect;
         this.redrawEntities();
         this.updateCross();
         this.updateHeroPosition();
         this.foreground.bitmapData.lock();
      }
      
      public function startInterference(param1:int) : void
      {
         if(this.interference != null)
         {
            this.interference.cleanup();
         }
         this.interference = new Interference(this.clickMap.width,this.clickMap.height);
         this.interference.duration = param1;
         this.interference.alpha = 0.2;
         this.interference.start();
         this.interference.mouseChildren = false;
         this.interference.mouseEnabled = false;
         this.clickMap.addChild(this.interference);
      }
      
      public function stopInterference() : void
      {
         if(this.interference != null)
         {
            this.interference.cleanup();
            this.clickMap.removeChild(this.interference);
         }
      }
      
      public function updateThreatIndicator(param1:int = 0) : void
      {
         var _loc8_:Bitmap = null;
         var _loc2_:int = 6;
         var _loc3_:Number = this.background.height / (_loc2_ - 1);
         var _loc4_:Sprite = new Sprite();
         var _loc5_:uint = uint(this.indicatorColors[param1]);
         _loc4_.graphics.beginFill(_loc5_);
         _loc4_.graphics.drawRect(0,(5 - param1) * _loc3_,3,_loc3_ * param1);
         _loc4_.graphics.lineStyle(1,10079487);
         _loc4_.graphics.moveTo(8,0);
         _loc4_.graphics.lineTo(8,this.background.height);
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_)
         {
            if(_loc7_ == _loc2_ - 1)
            {
               _loc6_--;
            }
            _loc4_.graphics.moveTo(4,_loc6_);
            _loc4_.graphics.lineTo(10,_loc6_);
            _loc6_ += _loc3_;
            _loc7_++;
         }
         _loc6_ = 0;
         _loc2_ = 21;
         _loc3_ = this.background.height / (_loc2_ - 1);
         _loc7_ = 0;
         while(_loc7_ < _loc2_)
         {
            if(_loc7_ == _loc2_ - 1)
            {
               _loc6_--;
            }
            _loc4_.graphics.lineTo(9,_loc6_);
            _loc6_ += _loc3_;
            _loc7_++;
         }
         if(this.threatBitmapData == null)
         {
            this.threatBitmapData = new BitmapData(10,this.background.height,true,255);
            this.threatBitmapData.draw(_loc4_);
            _loc8_ = new Bitmap(this.threatBitmapData);
            _loc8_.x = -12;
            _loc8_.y = this.yOffset;
            this.addChild(_loc8_);
         }
         else
         {
            this.threatBitmapData.fillRect(this.threatBitmapData.rect,0);
            this.threatBitmapData.draw(_loc4_);
         }
      }
      
      public function startTimer() : void
      {
         if(!this.timer.running)
         {
            this.timer.start();
         }
      }
      
      public function stopTimer() : void
      {
         this.timer.stop();
      }
      
      private function initMapInfoLabel(param1:TextField) : void
      {
         param1.defaultTextFormat = Styles.h3Fmt;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.textColor = 16777215;
         param1.embedFonts = Styles.h3Embed;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
         param1.mouseEnabled = false;
         param1.y = this.mapInfoY;
         if(!contains(param1))
         {
            addChild(param1);
         }
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         this.updateCoordinates();
         this.foreground.bitmapData.lock();
         this.foreground.bitmapData.fillRect(this.foreGroundRec,0);
         this.updateCross();
         this.updateHeroPosition();
         this.foreground.bitmapData.unlock();
      }
      
      private function updateCoordinates() : void
      {
         var _loc1_:Ship = this.minimapManager.getMap().getShipManager().getHero();
         if(_loc1_ != null)
         {
            this.writeMapName();
            this.coordinatesLabel.x = this.mapNameWidth + this.mapLabel.x;
            this.coordinatesLabel.text = int(_loc1_.x / 100) + "/" + int(_loc1_.y / 100);
            if(this.distance != -1)
            {
               this.routeInfoLabel.text = "> " + BPLocale.getText("travelling_distance").replace(/%DIST%/,BPLocale.round(this.distance,2));
            }
            else
            {
               this.routeInfoLabel.text = "";
            }
         }
      }
      
      public function drawPOIZones() : void
      {
         var _loc4_:POIZone = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc1_:Array = this.minimapManager.getMap().poiManager.poiZones;
         if(this.clickMap.contains(this.poizonesBmp))
         {
            this.clickMap.removeChild(this.poizonesBmp);
            this.poizonesBmp = new Bitmap();
         }
         this.poizonesBmp.bitmapData = new BitmapData(this.foreground.width,this.foreground.height,true,0);
         var _loc2_:Sprite = new Sprite();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_];
            _loc5_ = new Point(_loc4_.x * this.combinedScaleFactor,_loc4_.y * this.combinedScaleFactor);
            if(_loc4_.zoneType == POIManager.TYPE_NO_ACCESS)
            {
               _loc2_.graphics.beginFill(POIManager.zoneTypeColorDict[_loc4_.zoneType]);
               _loc2_.alpha = 0.7;
            }
            switch(_loc4_.shape)
            {
               case "REC":
                  _loc6_ = new Point(_loc4_.zoneWidth * this.combinedScaleFactor,_loc4_.zoneHeight * this.combinedScaleFactor);
                  _loc2_.graphics.drawRect(_loc5_.x,_loc5_.y,_loc6_.x,_loc6_.y);
                  break;
               case "CIR":
                  _loc7_ = _loc4_.radius * this.combinedScaleFactor;
                  _loc2_.graphics.drawCircle(_loc5_.x,_loc5_.y,_loc7_);
                  break;
            }
            _loc2_.graphics.endFill();
            _loc3_++;
         }
         this.poizonesBmp.alpha = 0.4;
         this.poizonesBmp.bitmapData.draw(_loc2_);
         this.clickMap.addChild(this.poizonesBmp);
      }
      
      private function writeMapName() : void
      {
         if(this.mapID != this.minimapManager.getMap().getMapID())
         {
            this.mapID = this.minimapManager.getMap().getMapID();
            this.mapName = this.minimapManager.getMap().getName();
            this.mapLabel.text = this.mapName;
            this.mapNameWidth = int(this.mapLabel.width) + 2;
            this.routeInfoLabel.x = this.mapNameWidth + this.mapLabel.x + this.maxNeededCooWidth;
         }
      }
      
      public function setBackground(param1:BitmapData) : void
      {
         var _loc2_:BitmapData = this.scaleBitmapData(param1);
         this.background = new Bitmap(_loc2_);
         this.background.y = this.yOffset;
         this.overlay.width = _loc2_.width;
         this.overlay.height = _loc2_.height;
         this.overlay.y = this.yOffset;
         this.miniMapWidth = _loc2_.width;
         this.miniMapHeight = _loc2_.height;
         this.addChild(this.background);
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         this.foreground = new Bitmap(_loc3_);
         this.clickMap.addChild(this.foreground);
         this.clickMap.addEventListener(MouseEvent.CLICK,this.handleMapClick);
         this.clickMap.buttonMode = true;
         this.clickMap.y = this.yOffset;
         this.addChild(this.clickMap);
         this.drawPOIZones();
      }
      
      private function handleMapClick(param1:MouseEvent) : void
      {
         var _loc2_:Map = this.minimapManager.getMap();
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.getEventManager().isControlsLocked())
         {
            return;
         }
         var _loc3_:Sprite = param1.target as Sprite;
         var _loc4_:int = _loc3_.mouseX;
         var _loc5_:int = _loc3_.mouseY;
         var _loc6_:Number = _loc4_ * this.zoomFactor * 10;
         var _loc7_:Number = _loc5_ * this.zoomFactor * 10;
         if(_loc2_.getMain().getGuiManager().getGroupUI() != null && _loc2_.getMain().getGuiManager().getGroupUI().isInPingMode)
         {
            _loc2_.getMain().getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_PING,ClientCommands.GROUPSYSTEM_PING_POSITION,_loc6_,_loc7_]);
            _loc2_.getMain().getGuiManager().getGroupUI().isInPingMode = false;
            return;
         }
         var _loc8_:Ship = _loc2_.getShipManager().getHero();
         if(_loc8_ == null)
         {
            return;
         }
         var _loc9_:Point = _loc2_.poiManager.checkPOIZoneCollisions(new Point(_loc8_.x,_loc8_.y),new Point(_loc6_,_loc7_));
         if(_loc9_ != null)
         {
            _loc6_ = _loc9_.x;
            _loc7_ = _loc9_.y;
         }
         _loc2_.getEventManager().moveHeroToCordinates(_loc6_,_loc7_);
         this.highlightRoute(_loc6_,_loc7_);
      }
      
      public function highlightRoute(param1:int, param2:int) : void
      {
         this.route = new Point(param1 * this.combinedScaleFactor,param2 * this.combinedScaleFactor);
         var _loc3_:MovieClip = this.finisher.getEmbededMovieClip("minimapPointer");
         _loc3_.x = this.route.x;
         _loc3_.y = this.route.y + this.yOffset;
         addChild(_loc3_);
         TweenLite.to(_loc3_,5,{
            "onUpdate":this.onUpdatePointer,
            "onUpdateParams":[_loc3_]
         });
      }
      
      private function onUpdatePointer(param1:MovieClip) : void
      {
         if(param1.framesLoaded == param1.currentFrame)
         {
            TweenMax.killTweensOf(param1);
            removeChild(param1);
         }
      }
      
      private function scaleBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:int = Math.round(this.minimapManager.getMap().serious_width / this.zoomFactor * 0.1);
         var _loc3_:int = Math.round(this.minimapManager.getMap().serious_height / this.zoomFactor * 0.1);
         this.scaleSize.x = _loc2_ / this.minimapManager.getMap().serious_width;
         this.scaleSize.y = _loc3_ / this.minimapManager.getMap().serious_height;
         var _loc4_:int = Math.round(param1.width / this.zoomFactor * 10);
         var _loc5_:int = Math.round(param1.height / this.zoomFactor * 10);
         var _loc6_:Bitmap = new Bitmap(param1);
         var _loc7_:Number = 1 / this.zoomFactor * 10;
         var _loc8_:Matrix = new Matrix();
         _loc8_.scale(_loc7_,_loc7_);
         _loc8_.translate((_loc2_ - _loc4_) / 2,(_loc3_ - _loc5_) / 2);
         var _loc9_:BitmapData = new BitmapData(_loc2_,_loc3_,false,0);
         _loc9_.draw(_loc6_,_loc8_,null,null,new Rectangle(0,0,_loc2_,_loc3_),false);
         return _loc9_;
      }
      
      public function cleanup() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.clickMap.removeEventListener(MouseEvent.CLICK,this.handleMapClick);
         this.sourceBitmapData = null;
         this.threatBitmapData = null;
         this.background = null;
         this.foreground = null;
         if(this.interference != null)
         {
            this.interference.cleanup();
         }
      }
      
      public function redrawEntities() : void
      {
         var _loc5_:Planet = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Station = null;
         var _loc8_:BitmapData = null;
         var _loc9_:Portal = null;
         var _loc1_:Array = this.minimapManager.getMap().getMain().screenManager.planets;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc5_ = _loc1_[_loc2_];
            _loc6_ = _loc5_.getIcon();
            if(_loc5_.clip != null)
            {
               if(_loc6_ == null)
               {
                  _loc5_.scaleSize.x = this.scaleSize.x;
                  _loc5_.scaleSize.y = this.scaleSize.y;
                  _loc5_.setIcon(this.zoomFactor * this.mapScaleFactor);
               }
               this.drawPlanetIcon(_loc5_);
            }
            _loc2_++;
         }
         var _loc3_:Array = this.minimapManager.getMap().getStationManager().getStations();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc2_];
            _loc8_ = _loc7_.getIcon();
            if(_loc7_.clip != null)
            {
               if(_loc8_ == null)
               {
                  _loc7_.scaleSize.x = this.scaleSize.x;
                  _loc7_.scaleSize.y = this.scaleSize.y;
                  _loc7_.setIcon(this.zoomFactor * this.mapScaleFactor);
               }
               this.drawStationIcon(_loc7_);
            }
            _loc2_++;
         }
         var _loc4_:Vector.<Portal> = this.minimapManager.getMap().portalManager.getPortals();
         _loc2_ = int(_loc4_.length);
         while(--_loc2_ > -1)
         {
            _loc9_ = _loc4_[_loc2_];
            if(_loc9_.visibleOnMiniMap)
            {
               this.drawIcon(_loc9_.getPosX(),_loc9_.getPosY(),"mapIcon_portal");
            }
         }
      }
      
      private function updateCross() : void
      {
         var _loc2_:Ship = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:BitmapData = this.foreground.bitmapData;
         if(_loc1_ != null)
         {
            _loc2_ = this.shipManager.getHero();
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.x * this.combinedScaleFactor;
               _loc4_ = _loc2_.y * this.combinedScaleFactor;
               _loc5_ = _loc1_.width;
               while(--_loc5_ > -1)
               {
                  _loc1_.setPixel32(_loc5_,_loc4_,2861864084);
                  _loc1_.setPixel32(_loc5_,_loc4_ + 1,2861864084);
               }
               _loc6_ = _loc1_.height;
               while(--_loc6_ > -1)
               {
                  _loc1_.setPixel32(_loc3_,_loc6_,2861864084);
                  _loc1_.setPixel32(_loc3_ + 1,_loc6_,2861864084);
               }
               this.drawPixel(_loc3_,_loc4_,4281584640);
               if(this.route != null)
               {
                  this.updateRoute(_loc3_,_loc4_,this.route.x,this.route.y);
                  this.drawIcon(this.route.x,this.route.y,"mapIcon_finish",false);
               }
            }
         }
      }
      
      public function updateHeroPosition() : void
      {
         var _loc4_:MapObject = null;
         var _loc5_:Array = null;
         var _loc6_:HomeZone = null;
         var _loc7_:Array = null;
         var _loc8_:Collectable = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Beacon = null;
         if(this.foreground == null)
         {
            return;
         }
         var _loc1_:BitmapData = this.foreground.bitmapData;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Ship = this.shipManager.getHero();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Array = this.shipManager.getShips();
         for each(_loc4_ in _loc3_)
         {
            _loc9_ = _loc4_.x * this.combinedScaleFactor;
            _loc10_ = _loc4_.y * this.combinedScaleFactor;
            if(!_loc4_.idleState)
            {
               if(_loc4_.isIconOnMiniMap())
               {
                  this.drawIcon(_loc9_,_loc10_,_loc4_.getMiniMapIcon(),false);
               }
               else
               {
                  this.drawPixel(_loc9_,_loc10_,_loc4_.getMiniMapColor());
               }
            }
            _loc11_ = _loc4_.getBeacon();
            if(_loc11_ != null)
            {
               this.drawIcon(_loc4_.x,_loc4_.y,"beacon_" + _loc11_.getToCompanyID() + "_" + _loc11_.getFromCompanyID());
            }
         }
         _loc5_ = this.minimapManager.getMap().getCtbManager().getHomezones();
         for each(_loc6_ in _loc5_)
         {
            this.drawIcon(_loc6_.getX(),_loc6_.getY(),"homezone_" + _loc6_.getCompanyID());
         }
         _loc7_ = this.minimapManager.getMap().getCollectableManager().getBeacons();
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ is Beacon && _loc8_.clip != null)
            {
               this.drawIcon(_loc8_.clip.x,_loc8_.clip.y,"beacon_" + Beacon(_loc8_).getToCompanyID() + "_" + Beacon(_loc8_).getFromCompanyID());
            }
         }
      }
      
      private function drawPixel(param1:int, param2:int, param3:uint) : void
      {
         var _loc4_:BitmapData = this.foreground.bitmapData;
         if(param1 > 2 && param2 > 2 && param1 < this.miniMapWidth - 4 && param2 < this.miniMapHeight - 4)
         {
            _loc4_.setPixel32(param1,param2,param3);
            _loc4_.setPixel32(param1 + 1,param2,param3);
            _loc4_.setPixel32(param1,param2 + 1,param3);
            _loc4_.setPixel32(param1 + 1,param2 + 1,param3);
         }
         else if(param1 <= 1)
         {
            if(param2 <= 2)
            {
               _loc4_.setPixel32(3,3,param3);
               _loc4_.setPixel32(4,4,param3);
               _loc4_.setPixel32(4,5,param3);
               _loc4_.setPixel32(5,4,param3);
            }
            else if(param2 >= this.miniMapHeight - 4)
            {
               _loc4_.setPixel32(3,this.miniMapHeight - 5,param3);
               _loc4_.setPixel32(4,this.miniMapHeight - 6,param3);
               _loc4_.setPixel32(4,this.miniMapHeight - 7,param3);
               _loc4_.setPixel32(5,this.miniMapHeight - 6,param3);
            }
            else
            {
               _loc4_.setPixel32(2,param2,param3);
               _loc4_.setPixel32(3,param2,param3);
               _loc4_.setPixel32(3,param2 + 1,param3);
               _loc4_.setPixel32(3,param2 - 1,param3);
               _loc4_.setPixel32(4,param2 + 1,param3);
               _loc4_.setPixel32(4,param2 - 1,param3);
            }
         }
         else if(param1 >= this.miniMapWidth - 4)
         {
            if(param2 <= 1)
            {
               _loc4_.setPixel32(this.miniMapWidth - 3,2,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,3,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,4,param3);
               _loc4_.setPixel32(this.miniMapWidth - 5,3,param3);
            }
            else if(param2 >= this.miniMapHeight - 4)
            {
               _loc4_.setPixel32(this.miniMapWidth - 3,this.miniMapHeight - 3,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,this.miniMapHeight - 4,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,this.miniMapHeight - 5,param3);
               _loc4_.setPixel32(this.miniMapWidth - 5,this.miniMapHeight - 4,param3);
            }
            else
            {
               _loc4_.setPixel32(this.miniMapWidth - 3,param2,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,param2,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,param2 + 1,param3);
               _loc4_.setPixel32(this.miniMapWidth - 4,param2 - 1,param3);
               _loc4_.setPixel32(this.miniMapWidth - 5,param2 + 1,param3);
               _loc4_.setPixel32(this.miniMapWidth - 5,param2 - 1,param3);
            }
         }
         else if(param2 <= 2)
         {
            _loc4_.setPixel32(param1,2,param3);
            _loc4_.setPixel32(param1,3,param3);
            _loc4_.setPixel32(param1 + 1,3,param3);
            _loc4_.setPixel32(param1 - 1,3,param3);
            _loc4_.setPixel32(param1 + 1,4,param3);
            _loc4_.setPixel32(param1 - 1,4,param3);
         }
         else if(param2 >= this.miniMapHeight - 4)
         {
            _loc4_.setPixel32(param1,this.miniMapHeight - 3,param3);
            _loc4_.setPixel32(param1,this.miniMapHeight - 4,param3);
            _loc4_.setPixel32(param1 + 1,this.miniMapHeight - 4,param3);
            _loc4_.setPixel32(param1 - 1,this.miniMapHeight - 4,param3);
            _loc4_.setPixel32(param1 + 1,this.miniMapHeight - 5,param3);
            _loc4_.setPixel32(param1 - 1,this.miniMapHeight - 5,param3);
         }
      }
      
      public function drawIcon(param1:int, param2:int, param3:String, param4:Boolean = true) : void
      {
         var _loc6_:BitmapData = null;
         var _loc5_:BitmapData = this.finisher.getEmbededBitmapData(param3);
         if(param4)
         {
            param1 *= this.combinedScaleFactor;
            param2 *= this.combinedScaleFactor;
         }
         if(param3 == "mapIcon_portal")
         {
            _loc6_ = this.background.bitmapData;
         }
         else
         {
            _loc6_ = this.foreground.bitmapData;
         }
         this.tmpPoint.x = param1 - _loc5_.width / 2;
         this.tmpPoint.y = param2 - _loc5_.height / 2;
         _loc6_.copyPixels(_loc5_,_loc5_.rect,this.tmpPoint,null,null,true);
      }
      
      private function updateRoute(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:BitmapData = this.foreground.bitmapData;
         this.sprite.graphics.clear();
         this.sprite.graphics.lineStyle(1,6649302);
         this.sprite.graphics.moveTo(param1,param2);
         this.sprite.graphics.lineTo(param3,param4);
         _loc5_.draw(this.sprite);
         this.distance = FastMath.sqrt(Math.pow(param2 - param4,2) + Math.pow(param4 - param2,2));
      }
      
      private function updateRouteImpossiblePath(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:Sprite = new Sprite();
         var _loc6_:BitmapData = this.foreground.bitmapData;
         _loc5_.graphics.clear();
         _loc5_.graphics.lineStyle(1,16711680);
         _loc5_.graphics.moveTo(param1,param2);
         _loc5_.graphics.lineTo(param3,param4);
         _loc6_.draw(_loc5_);
         this.distance = FastMath.sqrt(Math.pow(param2 - param4,2) + Math.pow(param4 - param2,2));
      }
      
      public function drawPlanetIcon(param1:Planet) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BitmapData = null;
         var _loc2_:BitmapData = param1.getIcon();
         if(_loc2_ != null)
         {
            _loc3_ = param1.x * this.miniMapWidth * param1.pFactor / this.minimapManager.getMap().serious_width;
            _loc4_ = param1.y * this.miniMapHeight * param1.pFactor / this.minimapManager.getMap().serious_height;
            _loc5_ = this.background.bitmapData;
            this.tmpPoint.x = _loc3_ + param1.originPoint.x * param1.pFactor * param1.scaleSize.x;
            this.tmpPoint.y = _loc4_ + param1.originPoint.y * param1.pFactor * param1.scaleSize.y;
            _loc5_.copyPixels(_loc2_,_loc2_.rect,this.tmpPoint,null,null,true);
         }
      }
      
      public function drawStationIcon(param1:Station) : void
      {
         var _loc2_:BitmapData = param1.getIcon();
         var _loc3_:BitmapData = this.background.bitmapData;
         this.tmpPoint.x = (param1.getPosX() - param1.clip.width / 2) * this.miniMapWidth / this.minimapManager.getMap().serious_width;
         this.tmpPoint.y = (param1.getPosY() - param1.clip.height / 2) * this.miniMapHeight / this.minimapManager.getMap().serious_height;
         _loc3_.copyPixels(_loc2_,_loc2_.rect,this.tmpPoint,null,null,true);
      }
      
      public function clearRoute() : void
      {
         this.distance = -1;
         this.route = null;
      }
      
      public function getScaleFactor() : int
      {
         return this.zoomFactor;
      }
      
      public function getLastRoute() : Point
      {
         return this.route;
      }
      
      public function addMapMarker(param1:int, param2:int, param3:int, param4:int = -1) : void
      {
         var _loc5_:MapMarker = new MapMarker(param1,param2,param3,param4);
         this.markers[param1] = _loc5_;
         this.addMapMarker2(_loc5_);
      }
      
      private function addMapMarker2(param1:MapMarker) : void
      {
         param1.mc.gotoAndStop(1);
         param1.mc.x = param1.x * this.combinedScaleFactor;
         param1.mc.y = param1.y * this.combinedScaleFactor + this.yOffset;
         param1.mc.mouseEnabled = false;
         param1.mc.mouseChildren = false;
         addChild(param1.mc);
         TweenLite.to(param1.mc,0.5,{
            "ease":Linear.easeNone,
            "frame":param1.mc.framesLoaded,
            "onComplete":this.handleMapMarker,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleMapMarker(param1:MapMarker) : void
      {
         removeChild(param1.mc);
         if(param1.count == -1)
         {
            this.addMapMarker2(param1);
         }
         else if(param1.count > 1)
         {
            --param1.count;
            this.addMapMarker2(param1);
         }
         else
         {
            delete this.markers[param1.id];
         }
      }
      
      public function stopMapMarker(param1:int) : void
      {
         var _loc2_:MapMarker = this.markers[param1];
         _loc2_.count = 0;
         delete this.markers[param1];
      }
      
      private function pingCompleteHandler(param1:MovieClip) : void
      {
         removeChild(param1);
      }
   }
}


package net.bigpoint.darkorbit
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.background.Background;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.planet.Planet;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.starfield.Starfield;
   
   public class ScreenManager
   {
      
      public static var speedX:Number;
      
      public static var collisionDetection:Sprite;
      
      private static var windowLayer:Sprite;
      
      private static var screenWidth:int;
      
      private static var screenHeight:int;
      
      public static var halfScreenWidth:int;
      
      public static var halfScreenHeight:int;
      
      public static const logger:ILogger = Log.getLogger("ScreenManager");
      
      public static var TOP_OF_HERO:int = 0;
      
      public static var BOTTOM_OF_HERO:int = 1;
      
      public static const MASTER_SCREEN_WIDTH:int = 1280;
      
      public static const MASTER_SCREEN_HEIGHT:int = 900;
      
      public static var centerX:int = 640;
      
      public static var centerY:int = 450;
      
      public static var camera:Point = new Point();
      
      public static var lockedShipUserID:int = -1;
      
      public static var CAMERA_LOCKED_TO_HERO:int = 0;
      
      public static var CAMERA_TWEENING_TO_HERO:int = 1;
      
      public static var CAMERA_LOCKED_TO_SHIP:int = 2;
      
      public static var CAMERA_TWEENING_TO_SHIP:int = 3;
      
      public static var CAMERA_LOCKED_TO_COORDINATE:int = 4;
      
      public static var CAMERA_TWEENING_TO_COORDINATE:int = 5;
      
      public static var cameraLock:int = 0;
      
      private var movingContainer:Sprite;
      
      private var shipLayer:Sprite;
      
      private var petLayer:Sprite;
      
      private var heroLayer:Sprite;
      
      private var laserLayer:Sprite;
      
      private var main:Main;
      
      private var oldBgX:Number = 0;
      
      private var oldBgY:Number = 0;
      
      public var _mapScale:Number = 1;
      
      private var logBuffer:String;
      
      private var portalLayer:Sprite;
      
      private var lensflareLayer:Sprite;
      
      private var starfieldLayer:Sprite;
      
      private var explosionLayer:Sprite;
      
      private var _poizoneLayer:Sprite;
      
      private var _collectableLayer:Sprite;
      
      private var backgroundContainer:Sprite;
      
      private var backgroundLayers:Array = [];
      
      private var meteorLayers:Array = [];
      
      private var nebulaLayers:Array = [];
      
      private var _starfield:Starfield;
      
      public var staticContainer:Sprite;
      
      private var guiLayer0:Sprite;
      
      private var guiLayer1:Sprite;
      
      private var windowLayer2:Sprite;
      
      private var iconLayer:Sprite;
      
      private var _topmenuLayer:Sprite;
      
      private var _mainmenuLayer:Sprite;
      
      private var cnt:int;
      
      private var shakeTimer:Timer;
      
      private var shakeFactor:int = 5;
      
      private var _planets:Array;
      
      private var _hero:Ship;
      
      public var backgrounds:Vector.<Background>;
      
      private var _map:Map;
      
      private var lastStaticContainerPosition:Point = new Point();
      
      public var flashShape:Sprite;
      
      public function ScreenManager(param1:Main)
      {
         super();
         this.main = param1;
      }
      
      public static function getWindowLayer() : Sprite
      {
         return windowLayer;
      }
      
      public static function getScreenWidth() : int
      {
         return screenWidth;
      }
      
      public static function getScreenHeight() : int
      {
         return screenHeight;
      }
      
      public static function getHalfScreenWidth() : int
      {
         return halfScreenWidth;
      }
      
      public static function getHalfScreenHeight() : int
      {
         return halfScreenHeight;
      }
      
      public static function playAnimation(param1:DisplayObject, param2:int, param3:Boolean = false, param4:int = 1, param5:Boolean = true) : void
      {
         var _loc6_:int = 0;
         if(param1 is MovieClip)
         {
            _loc6_ = MovieClip(param1).framesLoaded;
            MovieClip(param1).gotoAndStop(param4);
         }
         else if(param1 is BitmapClip)
         {
            _loc6_ = BitmapClip(param1).framesLoaded;
            BitmapClip(param1).gotoAndStop(param4);
         }
         var _loc7_:Number = _loc6_ / param2;
         if(param3)
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_,
               "onComplete":playAnimation,
               "onCompleteParams":[param1,param2,param3]
            });
         }
         else if(param5)
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_,
               "onComplete":onRemoveDisplayObject,
               "onCompleteParams":[param1]
            });
         }
         else
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_
            });
         }
      }
      
      public static function stopAnimation(param1:DisplayObject) : void
      {
         TweenLite.killTweensOf(param1);
      }
      
      public static function fadeInClip(param1:Number, param2:DisplayObject) : void
      {
         TweenLite.to(param2,param1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      public static function fadeOutClip(param1:Number, param2:DisplayObject) : void
      {
         TweenLite.to(param2,param1,{
            "ease":Linear.easeNone,
            "alpha":0,
            "onComplete":onRemoveDisplayObject,
            "onCompleteParams":[param2]
         });
      }
      
      public static function onRemoveDisplayObject(param1:DisplayObject) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         TweenLite.killTweensOf(param1);
      }
      
      public function shakeScreen() : void
      {
         this.cnt = 40;
         this.shakeFactor = 5;
         if(this.shakeTimer != null && this.shakeTimer.running)
         {
            return;
         }
         this.shakeTimer = new Timer(25,0);
         this.shakeTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.shakeTimer.start();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(this.staticContainer != null)
         {
            this.staticContainer.x = this.lastStaticContainerPosition.x + this.shakeFactor * Math.cos(this.cnt);
            this.staticContainer.y = this.lastStaticContainerPosition.y + this.shakeFactor * Math.sin(this.cnt);
            --this.cnt;
            if(this.cnt % 10 == 0)
            {
               --this.shakeFactor;
            }
            if(this.cnt < 0)
            {
               this.shakeTimer.stop();
               this.shakeTimer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
               this.staticContainer.x = this.lastStaticContainerPosition.x;
               this.staticContainer.y = this.lastStaticContainerPosition.y;
            }
         }
      }
      
      public function flashScreen(param1:uint, param2:Number = 0.4, param3:Number = 0.25, param4:Number = 0.75) : void
      {
         if(this.flashShape == null)
         {
            this.flashShape = new Sprite();
            this.flashShape.mouseEnabled = false;
            this.flashShape.mouseChildren = false;
            this.flashShape.graphics.beginFill(param1);
            this.flashShape.graphics.drawRect(0,0,screenWidth,screenHeight);
            this.flashShape.alpha = 0;
            this.main.addChild(this.flashShape);
            TweenLite.to(this.flashShape,param3,{
               "alpha":param2,
               "onComplete":this.handleColorScreen,
               "onCompleteParams":[param4]
            });
         }
      }
      
      private function handleColorScreen(param1:Number) : void
      {
         if(this.flashShape != null)
         {
            TweenLite.to(this.flashShape,param1,{
               "alpha":0,
               "onComplete":this.handleRemoveFlashShape
            });
         }
      }
      
      private function handleRemoveFlashShape() : void
      {
         if(this.flashShape != null)
         {
            if(this.main.contains(this.flashShape))
            {
               this.main.removeChild(this.flashShape);
            }
            this.flashShape = null;
         }
      }
      
      public function init(param1:Main) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         this.main = param1;
         this.logBuffer = "";
         this.movingContainer = new Sprite();
         var _loc2_:int = int(Main.gameXML.patterns.nebulas.@layers);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Sprite();
            this.nebulaLayers.push(_loc3_);
            this.movingContainer.addChild(_loc3_);
            _loc4_++;
         }
         this._poizoneLayer = new Sprite();
         this._poizoneLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._poizoneLayer.mouseChildren = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this._poizoneLayer);
         this.portalLayer = new Sprite();
         this.portalLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.portalLayer.mouseChildren = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this.portalLayer);
         this._collectableLayer = new Sprite();
         this._collectableLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this.collectableLayer);
         this.shipLayer = new Sprite();
         this.shipLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.shipLayer.mouseChildren = Main.mouseEventsEnabled;
         collisionDetection = new Sprite();
         collisionDetection.graphics.beginFill(255);
         collisionDetection.graphics.drawCircle(0,0,5);
         this.shipLayer.addChild(collisionDetection);
         this.petLayer = new Sprite();
         this.petLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.petLayer.mouseChildren = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this.shipLayer);
         this.movingContainer.addChild(this.petLayer);
         this.explosionLayer = new Sprite();
         this.explosionLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.explosionLayer.mouseChildren = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this.explosionLayer);
         this.laserLayer = new Sprite();
         this.laserLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.laserLayer.mouseChildren = Main.mouseEventsEnabled;
         this.movingContainer.addChild(this.laserLayer);
         this.staticContainer = new Sprite();
         this.backgroundContainer = new Sprite();
         this.backgroundContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.backgroundContainer.mouseChildren = Main.mouseEventsEnabled;
         this.staticContainer.addChild(this.backgroundContainer);
         this.resetDefaults(Settings.mapID);
         this.starfieldLayer = new Sprite();
         this.starfieldLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.starfieldLayer.mouseChildren = Main.mouseEventsEnabled;
         this.staticContainer.addChild(this.starfieldLayer);
         this.staticContainer.addChild(this.movingContainer);
         var _loc5_:int = int(Main.gameXML.patterns.meteors.@layers);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new Sprite();
            _loc3_.mouseEnabled = Main.mouseEventsEnabled;
            _loc3_.mouseChildren = Main.mouseEventsEnabled;
            this.meteorLayers.push(_loc3_);
            this.staticContainer.addChild(_loc3_);
            _loc4_++;
         }
         this.heroLayer = new Sprite();
         this.heroLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.heroLayer.mouseChildren = Main.mouseEventsEnabled;
         this.staticContainer.addChild(this.heroLayer);
         this.lensflareLayer = new Sprite();
         this.lensflareLayer.mouseEnabled = Main.mouseEventsEnabled;
         this.lensflareLayer.mouseChildren = Main.mouseEventsEnabled;
         this.staticContainer.addChild(this.lensflareLayer);
         param1.addChild(this.staticContainer);
         this.guiLayer0 = new Sprite();
         this.guiLayer0.mouseEnabled = false;
         this.guiLayer0.mouseChildren = false;
         param1.addChild(this.guiLayer0);
         this.guiLayer1 = new Sprite();
         this.guiLayer1.mouseEnabled = false;
         this.guiLayer1.mouseChildren = false;
         param1.addChild(this.guiLayer1);
         windowLayer = new Sprite();
         windowLayer.mouseEnabled = Main.mouseEventsEnabled;
         param1.addChild(windowLayer);
         this._topmenuLayer = new Sprite();
         this._topmenuLayer.mouseEnabled = Main.mouseEventsEnabled;
         param1.addChild(this._topmenuLayer);
         this.iconLayer = new Sprite();
         this.iconLayer.mouseEnabled = Main.mouseEventsEnabled;
         param1.addChild(this.iconLayer);
         this._mainmenuLayer = new Sprite();
         this._mainmenuLayer.mouseEnabled = Main.mouseEventsEnabled;
         param1.addChild(this._mainmenuLayer);
         this.windowLayer2 = new Sprite();
         this.windowLayer2.mouseEnabled = Main.mouseEventsEnabled;
         param1.addChild(this.windowLayer2);
         this.addRenderFrameListener();
         this.setMapScale();
         this.setMask();
      }
      
      private function parseContainingBackgroundsCount(param1:int) : int
      {
         var backgroundLayerCount:int = 0;
         var newMapID:int = param1;
         backgroundLayerCount = int(XMLList(Main.mapsXML.map.(@id == String(newMapID)).backgrounds.background).length());
         return backgroundLayerCount;
      }
      
      private function parseContainingPlanetsCount(param1:int) : int
      {
         var planetLayerCount:int = 0;
         var newMapID:int = param1;
         planetLayerCount = int(XMLList(Main.mapsXML.map.(@id == String(newMapID)).planets.planet).length());
         return planetLayerCount;
      }
      
      private function getSprite(param1:int, param2:int) : Sprite
      {
         var _loc3_:uint = 4285624689;
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(_loc3_);
         _loc4_.graphics.drawRect(0,0,param1,param2);
         return _loc4_;
      }
      
      public function setMask() : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:int = 0;
         var _loc1_:ResolutionPattern = PatternManager.resolutionPatterns[Settings.resolutionID];
         var _loc2_:int = 3000 - _loc1_.width / 2;
         var _loc3_:int = 3000 - _loc1_.height / 2;
         var _loc4_:int = _loc1_.width;
         var _loc5_:int = _loc1_.height;
         _loc7_ = -1;
         while(_loc7_ < 2)
         {
            _loc6_ = this.getSprite(_loc2_,_loc5_);
            _loc6_.x = -_loc2_;
            _loc6_.y = _loc7_ * _loc5_;
            this.main.addChild(_loc6_);
            _loc7_++;
         }
         _loc7_ = -1;
         while(_loc7_ < 2)
         {
            _loc6_ = this.getSprite(_loc2_,_loc5_);
            _loc6_.x = _loc4_;
            _loc6_.y = _loc7_ * _loc5_;
            this.main.addChild(_loc6_);
            _loc7_++;
         }
         _loc6_ = this.getSprite(_loc4_,_loc3_);
         _loc6_.y = -_loc3_;
         this.main.addChild(_loc6_);
         _loc6_ = this.getSprite(_loc4_,_loc3_);
         _loc6_.y = _loc5_;
         this.main.addChild(_loc6_);
      }
      
      public function addRenderFrameListener() : void
      {
         this.main.addEventListener(Event.ENTER_FRAME,this.renderFrame);
      }
      
      public function removeRenderFrameListener() : void
      {
         this.main.removeEventListener(Event.ENTER_FRAME,this.renderFrame);
      }
      
      public function showSimpleMessage(param1:String, param2:String = "") : void
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.name = param2;
         _loc3_.mouseEnabled = Main.mouseEventsEnabled;
         _loc3_.mouseChildren = Main.mouseEventsEnabled;
         var _loc4_:BitmapData = new BitmapData(screenWidth,screenHeight,false,0);
         var _loc5_:Bitmap = new Bitmap(_loc4_);
         _loc3_.addChild(_loc5_);
         var _loc6_:TextField = new TextField();
         _loc6_.defaultTextFormat = Styles.systemSplashFmt;
         _loc6_.embedFonts = Styles.systemSplashEmbed;
         _loc6_.width = screenWidth * 0.6;
         _loc6_.multiline = true;
         _loc6_.wordWrap = true;
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_.textColor = 16777215;
         _loc6_.antiAliasType = "advanced";
         _loc6_.selectable = false;
         _loc6_.text = param1;
         _loc6_.x = screenWidth * 0.2;
         _loc6_.y = screenHeight * 0.4;
         _loc3_.addChild(_loc6_);
         this.main.addChild(_loc3_);
      }
      
      public function showBigMessage(param1:String, param2:int = 2, param3:int = 0) : void
      {
         var _loc4_:TextField = new TextField();
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.font = Styles.systemSplashFmt.font;
         _loc5_.size = 48;
         _loc5_.align = TextFormatAlign.CENTER;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.width = screenWidth * 0.8;
         _loc4_.embedFonts = Styles.systemSplashEmbed;
         _loc4_.wordWrap = true;
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.multiline = true;
         _loc4_.textColor = 16777215;
         _loc4_.antiAliasType = "advanced";
         _loc4_.selectable = false;
         _loc4_.text = param1;
         var _loc6_:BitmapData = new BitmapData(_loc4_.width,_loc4_.height,true,0);
         _loc6_.draw(_loc4_);
         var _loc7_:Bitmap = new Bitmap(_loc6_);
         _loc7_.alpha = 0;
         _loc7_.x = screenWidth / 2 - _loc4_.width / 2;
         _loc7_.y = screenHeight / 2 - _loc4_.height / 2 - 200;
         this.main.addChild(_loc7_);
         var _loc8_:int = _loc7_.x;
         _loc7_.x -= 25;
         TweenMax.to(_loc7_,1,{
            "delay":param3,
            "x":_loc8_,
            "alpha":1,
            "glowFilter":{
               "color":255,
               "alpha":1,
               "blurX":10,
               "blurY":10
            },
            "onComplete":this.onTeaserFadeIn,
            "onCompleteParams":[_loc7_,param2]
         });
      }
      
      private function onTeaserFadeIn(param1:Bitmap, param2:int) : void
      {
         TweenMax.to(param1,1,{
            "delay":param2,
            "alpha":0,
            "onComplete":this.removeDisplayObject,
            "onCompleteParams":[param1]
         });
      }
      
      private function removeDisplayObject(param1:Bitmap) : void
      {
         this.main.removeChild(param1);
      }
      
      private function renderFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Background = null;
         var _loc8_:Planet = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MapObject = null;
         if(this._map != null && this._hero != null)
         {
            if(cameraLock == CAMERA_LOCKED_TO_HERO)
            {
               camera.x = this._hero.x;
               camera.y = this._hero.y;
            }
            else if(cameraLock == CAMERA_LOCKED_TO_SHIP)
            {
               _loc10_ = this.map.getShipManager().getShip(lockedShipUserID);
               if(_loc10_ != null)
               {
                  camera.x = _loc10_.x;
                  camera.y = _loc10_.y;
               }
               else
               {
                  cameraLock == CAMERA_LOCKED_TO_HERO;
               }
            }
            this.movingContainer.x = -(camera.x - ScreenManager.centerX);
            this.movingContainer.y = -(camera.y - ScreenManager.centerY);
            _loc2_ = this.movingContainer.x - this.oldBgX;
            _loc3_ = this.movingContainer.y - this.oldBgY;
            if(this._starfield != null)
            {
               if(_loc2_ == 0 && _loc3_ == 0)
               {
                  this._starfield.moveField(0.2,0);
               }
               else
               {
                  this._starfield.moveField(_loc2_,_loc3_);
               }
            }
            this.oldBgX = this.movingContainer.x;
            this.oldBgY = this.movingContainer.y;
            for each(_loc7_ in this.backgrounds)
            {
               if(_loc7_ != null)
               {
                  _loc5_ = int(-camera.x / _loc7_.getParallaxFactor() + ScreenManager.centerX + _loc7_.offsetX);
                  _loc6_ = int(-camera.y / _loc7_.getParallaxFactor() + ScreenManager.centerY + _loc7_.offsetY);
                  if(_loc7_.tiledMap != null)
                  {
                     _loc7_.tiledMap.setPosition(_loc5_,_loc6_);
                  }
                  else if(_loc7_.clip != null)
                  {
                     _loc7_.clip.x = _loc5_;
                     _loc7_.clip.y = _loc6_;
                  }
               }
            }
            this.map.getLensflareManager().speedX = _loc2_;
            this.map.getLensflareManager().speedY = _loc3_;
            _loc4_ = 0;
            while(_loc4_ < this._planets.length)
            {
               _loc8_ = this._planets[_loc4_];
               _loc9_ = _loc8_.clip;
               if(_loc9_ != null)
               {
                  _loc9_.x = -camera.x / _loc8_.pFactor + ScreenManager.centerX + _loc8_.x;
                  _loc9_.y = -camera.y / _loc8_.pFactor + ScreenManager.centerY + _loc8_.y;
               }
               _loc4_++;
            }
         }
      }
      
      public function getPortalLayer() : Sprite
      {
         return this.portalLayer;
      }
      
      public function getStarfieldLayer() : Sprite
      {
         return this.starfieldLayer;
      }
      
      public function getExplosionLayer() : Sprite
      {
         return this.explosionLayer;
      }
      
      public function getHeroLayer() : Sprite
      {
         return this.heroLayer;
      }
      
      public function getLensflareLayer() : Sprite
      {
         return this.lensflareLayer;
      }
      
      public function getShipLayer() : Sprite
      {
         return this.shipLayer;
      }
      
      public function getPetLayer() : Sprite
      {
         return this.petLayer;
      }
      
      public function getBackgroundContainer() : Sprite
      {
         return this.backgroundContainer;
      }
      
      public function getBackgroundLayer(param1:int) : Sprite
      {
         return this.backgroundLayers[param1];
      }
      
      public function getMeteorLayer(param1:int) : Sprite
      {
         return this.meteorLayers[param1];
      }
      
      public function getNebulaLayer(param1:int) : Sprite
      {
         return this.nebulaLayers[param1];
      }
      
      public function getLaserLayer() : Sprite
      {
         return this.laserLayer;
      }
      
      public function getGUILayer0() : Sprite
      {
         return this.guiLayer0;
      }
      
      public function getGUILayer1() : Sprite
      {
         return this.guiLayer1;
      }
      
      public function getStaticContainer() : Sprite
      {
         return this.staticContainer;
      }
      
      public function increaseMapScale() : void
      {
         var _loc1_:Number = this._mapScale + 0.1;
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         TweenLite.to(this,1,{
            "_mapScale":_loc1_,
            "onUpdate":this.onScreenScale
         });
      }
      
      public function decreaseMapScale() : void
      {
         var _loc1_:Number = this._mapScale - 0.1;
         var _loc2_:ResolutionPattern = PatternManager.resolutionPatterns[Settings.initialResolutionID];
         var _loc3_:Number = screenWidth / MASTER_SCREEN_WIDTH;
         if(_loc1_ < _loc3_)
         {
            _loc1_ = _loc3_;
         }
         TweenLite.to(this,1,{
            "_mapScale":_loc1_,
            "onUpdate":this.onScreenScale
         });
      }
      
      public function zoomToFactor(param1:Number, param2:Number) : void
      {
         TweenLite.to(this,param1,{
            "_mapScale":param2,
            "onUpdate":this.onScreenScale
         });
      }
      
      public function resetZoomFactor() : void
      {
         var _loc1_:Number = screenWidth / MASTER_SCREEN_WIDTH;
         TweenLite.to(this,1,{
            "_mapScale":_loc1_,
            "onUpdate":this.onScreenScale
         });
      }
      
      public function zoomIn(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1)
         {
            _loc2_ = this._mapScale;
            this._mapScale = _loc2_ - 0.2;
            _loc3_ = 2;
            this.onScreenScale();
         }
         else
         {
            _loc2_ = this._mapScale + 0.2;
            _loc3_ = 0.1;
         }
         TweenLite.to(this,2,{
            "delay":_loc3_,
            "_mapScale":_loc2_,
            "onUpdate":this.onScreenScale
         });
      }
      
      public function zoomOut(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1)
         {
            _loc2_ = this._mapScale;
            this._mapScale = _loc2_ + 0.2;
            _loc3_ = 2;
            this.onScreenScale();
         }
         else
         {
            _loc2_ = this._mapScale - 0.2;
            _loc3_ = 0.1;
         }
         TweenLite.to(this,2,{
            "delay":_loc3_,
            "_mapScale":_loc2_,
            "onUpdate":this.onScreenScale
         });
      }
      
      private function onScreenScale() : void
      {
         this.staticContainer.scaleX = this._mapScale;
         this.staticContainer.scaleY = this._mapScale;
         centerX = Math.round(halfScreenWidth / this._mapScale);
         centerY = Math.round(halfScreenHeight / this._mapScale);
         if(this._hero != null && cameraLock == CAMERA_LOCKED_TO_HERO)
         {
            this._hero.clipContainer.x = centerX;
            this._hero.clipContainer.y = centerY;
         }
         if(this._map != null)
         {
            this._map.getEventManager().halfScreenWidth = centerX;
            this._map.getEventManager().halfScreenHeight = centerY;
         }
         this.lastStaticContainerPosition.x = this.staticContainer.x;
         this.lastStaticContainerPosition.y = this.staticContainer.y;
      }
      
      public function setMapScale() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = screenWidth / MASTER_SCREEN_WIDTH;
         _loc2_ = screenHeight / MASTER_SCREEN_HEIGHT;
         if(_loc1_ >= _loc2_)
         {
            this._mapScale = _loc1_;
         }
         else
         {
            this._mapScale = _loc2_;
         }
         this.onScreenScale();
      }
      
      public function getWindowLayer2() : Sprite
      {
         return this.windowLayer2;
      }
      
      public function getIconLayer() : Sprite
      {
         return this.iconLayer;
      }
      
      public function clearAllLayers() : void
      {
         var _loc1_:Sprite = null;
         this.clearSpriteLayers(this.shipLayer);
         this.clearSpriteLayers(this.petLayer);
         this.clearSpriteLayers(this.heroLayer);
         this.clearSpriteLayers(this.laserLayer);
         this.clearSpriteLayers(this.portalLayer);
         this.clearSpriteLayers(this.lensflareLayer);
         this.clearSpriteLayers(this.starfieldLayer);
         this.clearSpriteLayers(this.explosionLayer);
         this.clearSpriteLayers(this._poizoneLayer);
         this.clearSpriteLayers(this.collectableLayer);
         for each(_loc1_ in this.backgroundLayers)
         {
            this.clearSpriteLayers(_loc1_);
         }
         for each(_loc1_ in this.meteorLayers)
         {
            this.clearSpriteLayers(_loc1_);
         }
         for each(_loc1_ in this.nebulaLayers)
         {
            this.clearSpriteLayers(_loc1_);
         }
      }
      
      private function clearSpriteLayers(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            param1.removeChildAt(_loc2_);
            _loc2_++;
         }
      }
      
      public function setScreenWidth(param1:int) : void
      {
         screenWidth = param1;
         halfScreenWidth = screenWidth / 2;
      }
      
      public function setScreenHeight(param1:int) : void
      {
         screenHeight = param1;
         halfScreenHeight = screenHeight / 2;
      }
      
      public function getScaledScreenWidth() : int
      {
         var _loc1_:Number = screenWidth / MASTER_SCREEN_WIDTH;
         return screenWidth / _loc1_;
      }
      
      public function getScaledScreenHeight() : int
      {
         var _loc1_:Number = screenWidth / MASTER_SCREEN_WIDTH;
         return screenHeight / _loc1_;
      }
      
      public function getPoizoneLayer() : Sprite
      {
         return this._poizoneLayer;
      }
      
      public function addStarfield(param1:Starfield) : void
      {
         this._starfield = param1;
         this.starfieldLayer.addChild(param1);
      }
      
      public function removeStarfield() : void
      {
         if(this._starfield != null)
         {
            this._starfield.cleanup();
            this.starfieldLayer.removeChild(this._starfield);
         }
      }
      
      public function get planets() : Array
      {
         return this._planets;
      }
      
      public function set planets(param1:Array) : void
      {
         this._planets = param1;
      }
      
      public function get hero() : Ship
      {
         return this._hero;
      }
      
      public function set hero(param1:Ship) : void
      {
         this._hero = param1;
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function set map(param1:Map) : void
      {
         this._map = param1;
      }
      
      public function get topmenuLayer() : Sprite
      {
         return this._topmenuLayer;
      }
      
      public function get mainmenuLayer() : Sprite
      {
         return this._mainmenuLayer;
      }
      
      public function get collectableLayer() : Sprite
      {
         return this._collectableLayer;
      }
      
      private function getMain() : Main
      {
         return this.main;
      }
      
      public function resetDefaults(param1:int) : void
      {
         this.removeBackgroundLayers();
         this.addBackgroundLayers(param1);
         this.addPlanetLayers(param1);
      }
      
      private function removeBackgroundLayers() : void
      {
         var _loc1_:int = 0;
         if(this.backgroundContainer.numChildren > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.backgroundContainer.numChildren)
            {
               this.backgroundContainer.removeChild(this.backgroundLayers.pop());
               _loc1_++;
            }
         }
      }
      
      public function removeBackgroundLayer(param1:int) : void
      {
         var _loc2_:Sprite = this.getBackgroundLayer(param1);
         if(_loc2_ != null && this.backgroundContainer.contains(_loc2_))
         {
            this.backgroundContainer.removeChild(_loc2_);
            this.backgroundLayers.splice(param1,1);
         }
      }
      
      private function addBackgroundLayers(param1:int) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = this.parseContainingBackgroundsCount(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new Sprite();
            _loc2_.mouseEnabled = Main.mouseEventsEnabled;
            _loc2_.mouseChildren = Main.mouseEventsEnabled;
            this.backgroundLayers.push(_loc2_);
            this.backgroundContainer.addChild(_loc2_);
            _loc4_++;
         }
      }
      
      public function addBackgroundLayer() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.mouseEnabled = Main.mouseEventsEnabled;
         _loc1_.mouseChildren = Main.mouseEventsEnabled;
         this.backgroundLayers.push(_loc1_);
         this.backgroundContainer.addChild(_loc1_);
      }
      
      private function addPlanetLayers(param1:int) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = this.parseContainingPlanetsCount(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new Sprite();
            _loc2_.mouseEnabled = Main.mouseEventsEnabled;
            _loc2_.mouseChildren = Main.mouseEventsEnabled;
            this.backgroundLayers.push(_loc2_);
            this.backgroundContainer.addChild(_loc2_);
            _loc4_++;
         }
      }
   }
}


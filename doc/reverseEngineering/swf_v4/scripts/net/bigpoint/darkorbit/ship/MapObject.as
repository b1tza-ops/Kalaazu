package net.bigpoint.darkorbit.ship
{
   import com.bigpoint.filecollection.FileCollection;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import mx.utils.StringUtil;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ObjectPoolManager;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.collectable.Beacon;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.drone.DroneConnector;
   import net.bigpoint.darkorbit.drone.DroneDisplay;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.pet.Pet;
   
   public class MapObject
   {
      
      public static const ROTATION_SHIP:String = "rotation_ship";
      
      public static const ROTATION_MOVEMENT:String = "rotation_movement";
      
      public static var filter:GlowFilter = new GlowFilter(0,1,2,2,50,3);
      
      public static var mediumGlowFilter:GlowFilter = new GlowFilter(0,1,4,4,6,1);
      
      private static const GALAXY_GATES_FINISHED_MAXIMUM:int = 4;
      
      public static var LASERSHOOT_FRONT:int = 0;
      
      public static var LASERSHOOT_REAR:int = 1;
      
      public static var BORDER_SELECTED:int = 0;
      
      public static var BORDER_ATTACKED_BY_OPPONENT:int = 1;
      
      public static const CROSSHAIR_RED:int = 1;
      
      public static const CROSSHAIR_GRAY:int = 2;
      
      public var userID:Number;
      
      private var username:String;
      
      public var engines:Array;
      
      private var simpleShipEnginePositions:Array = [];
      
      public var radius:int;
      
      private var glowClip:MovieClip;
      
      private var clanTag:String;
      
      private var clanID:int = -1;
      
      private var miniMapColor:uint;
      
      private var miniMapColorAlpha:uint;
      
      private var shipAttackableInNonPVP:Boolean;
      
      private var miniMapIcon:String;
      
      private var isIcon:Boolean = false;
      
      private var userTitle:String = "";
      
      private var clanDiplomacy:int;
      
      private var fractionID:int;
      
      public var oldSeekRotation:int;
      
      private var dailyRank:int;
      
      private var speed:int = 0;
      
      public var expansionTypeID:int;
      
      public var lastShipFrame:int = 1;
      
      private var rankIcon:BitmapData;
      
      private var _shipRotation:int;
      
      public var explodeTypeID:int;
      
      public var movementDirection:int;
      
      public var clipContainer:Sprite;
      
      public var shipClip:MovieClip;
      
      private var droneDisplayClipContainer:Sprite;
      
      public var shipContainer:Sprite;
      
      private var glowContainer:Sprite;
      
      private var shipDecorator:ShipSkillDecorator;
      
      public var expansionContainer:Sprite;
      
      private var explosionContainer:Sprite;
      
      private var engineContainer:Sprite;
      
      private var ggClip:Sprite;
      
      public var heroProxy:Point;
      
      private var engineSmokePool:Array;
      
      private var borderClip:MovieClip;
      
      private var hitpointBackgroundClip:Sprite = new Sprite();
      
      private var shieldBackgroundClip:Sprite = new Sprite();
      
      private var extraHitpointClip:Sprite = new Sprite();
      
      private var hitpointClip:Sprite = new Sprite();
      
      private var shieldClip:Sprite = new Sprite();
      
      private var labelClip:MovieClip;
      
      private var titleClip:MovieClip;
      
      private var permanentTitleClip:MovieClip;
      
      public var droneConnector:DroneConnector;
      
      public var shieldDamageCount:int;
      
      private var laserLayer:Sprite;
      
      private var malusClip:MovieClip;
      
      private var engineTimer:Timer;
      
      private var engineChannel:SoundChannel;
      
      private var warnIconOnMap:Boolean;
      
      private var _isGroupMember:Boolean = false;
      
      private var repairSound:SoundChannel;
      
      private var hitpoints:Number = 0;
      
      private var extraHitpoints:Number = 0;
      
      private var maxHitpoints:Number = 0;
      
      private var shield:Number = 0;
      
      private var maxShield:Number = 0;
      
      private var cargo:Number = 0;
      
      private var maxCargo:Number = 0;
      
      private var simpleDroneDisplay:MovieClip;
      
      private var engineFrame:int = 16;
      
      private var whipCounter:Number = 0;
      
      private var beacon:Beacon;
      
      private var lastShoot:int = LASERSHOOT_REAR;
      
      private var enginePositionPatterns:Array;
      
      private var shipManager:ShipManager;
      
      private var repairRobotClip:MovieClip;
      
      private var battleRepairRobotClip:MovieClip;
      
      private var cloakAlpha:Number = 0.3;
      
      public var shipPattern:ShipPattern;
      
      private var expansionPattern:ExpansionPattern;
      
      private var engineSmokePattern:EngineSmokePattern;
      
      private var enginePattern:AudibleResourcePattern;
      
      private var glowPattern:ResourcePattern;
      
      private var map:Map;
      
      private var attackerID:int = -1;
      
      public var isDebuffed:Boolean = false;
      
      private var _isNPC:Boolean;
      
      private var hitpointLabel:TextField;
      
      private var hitpointShadowLabel:TextField;
      
      private var labelClipOldYPosition:int;
      
      private var tmp:int;
      
      public var energyLeechActive:Boolean = false;
      
      public var isMoving:Boolean;
      
      public var movingCnt:int = -2;
      
      private var maxMovingCnt:int = 3;
      
      private var energyLeechCloud:MovieClip;
      
      private var flashingEnergyLeech:Boolean = false;
      
      public var numberChainsInvolvedIn:int = 0;
      
      public var isDestroyed:Boolean;
      
      public var displaysExplosion:Boolean;
      
      public var isPoliceShip:Boolean = false;
      
      private var lightSetting:int = 0;
      
      private const glowStrength:Number = 9;
      
      private const glowBlurX:Number = 10;
      
      private const glowBlurY:Number = 10;
      
      private const glowAlpha:Number = 0.4;
      
      private const tintAmount:Number = 0.7;
      
      private const redColour:uint = 16711680;
      
      private const blueColour:uint = 255;
      
      private const lightFlashTime:Number = 0.4;
      
      private const lightFlashTimeDelay:Number = 0.6;
      
      public var isCubicon:Boolean = false;
      
      public var galaxyGatesFinished:int;
      
      public var shipLightDecorator:ShipLightDecorator;
      
      public var updateStandardVisualShipRotation:Function;
      
      public var tweenRage:TweenMax;
      
      private var _debuffMove:MovieClip;
      
      private var _debuffStop:MovieClip;
      
      public var skull:MovieClip;
      
      public var invincibility:MovieClip;
      
      public var idleState:Boolean = false;
      
      public var hasPet:Boolean = false;
      
      public var petID:int = -1;
      
      public var currentlyMoving:Boolean;
      
      public var currentEnginePosition:Point = new Point();
      
      private var expansionContainerFullyAdded:Boolean;
      
      public function MapObject(param1:ShipManager, param2:int, param3:String, param4:Sprite)
      {
         this.updateStandardVisualShipRotation = this.updateVisualShipRotation;
         super();
         this.shipManager = param1;
         this.userID = param2;
         this.username = param3;
         this.laserLayer = param4;
         this.engineSmokePool = ObjectPoolManager.engineSmokePool;
         this.map = param1.getMap();
         this.enginePositionPatterns = PatternManager.enginePositionClasses;
         if(param2 == Hero.userID)
         {
            this.heroProxy = new Point();
         }
         TweenPlugin.activate([ColorTransformPlugin]);
      }
      
      public function addMalus() : void
      {
         if(this.malusClip == null)
         {
            this.malusClip = ResourceManager.getMovieClip("malusCloud0","mc");
         }
         this.attachMalusClowdClip();
      }
      
      public function removeMalus() : void
      {
         this.removeMalusCloudClip();
      }
      
      public function setNPC(param1:Boolean) : void
      {
         this._isNPC = param1;
      }
      
      public function isNPC() : Boolean
      {
         return this._isNPC;
      }
      
      public function setAttackerID(param1:int) : void
      {
         this.attackerID = param1;
      }
      
      public function setClipPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
         if(this.isHeroShip())
         {
            this.clipContainer.x = ScreenManager.centerX;
            this.clipContainer.y = ScreenManager.centerY;
         }
         if(this.shipPattern.enginePositionClassID != -1)
         {
            this.whipCounter = Main.getRandomCount(0,10000);
         }
      }
      
      public function setDamageBarVisibility(param1:Boolean) : void
      {
         if(this.shipPattern.isEnergyVisible() && this.isSelected())
         {
            this.shieldBackgroundClip.visible = param1;
            this.hitpointBackgroundClip.visible = param1;
            this.extraHitpointClip.visible = param1;
            this.hitpointClip.visible = param1;
            this.shieldClip.visible = param1;
         }
      }
      
      public function setCloak(param1:Boolean) : void
      {
         var _loc2_:CPUItem = null;
         if(param1)
         {
            if(this.isHeroShip())
            {
               this.clipContainer.visible = true;
               this.clipContainer.alpha = this.cloakAlpha;
               this.map.getMain().getGuiManager().getMenuManager().setButtonAccess(SuperActionButton.ACTIVATION_CPU_CLOAK,false);
               this.map.getMain().getGuiManager().getMenuManager().setButtonSelected(SuperActionButton.ACTIVATION_CPU_CLOAK,true);
            }
            else
            {
               this.clipContainer.visible = false;
            }
         }
         else
         {
            this.clipContainer.alpha = 1;
            this.clipContainer.visible = true;
            if(this.isHeroShip())
            {
               _loc2_ = Hero.cpuItems[CPUItem.TYPE_CLOAK];
               if(_loc2_ != null && _loc2_.amount > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().setButtonAccess(SuperActionButton.ACTIVATION_CPU_CLOAK,true);
               }
               this.map.getMain().getGuiManager().getMenuManager().setButtonSelected(SuperActionButton.ACTIVATION_CPU_CLOAK,false);
            }
         }
      }
      
      public function isInvisible() : Boolean
      {
         if(this.clipContainer.alpha != 1)
         {
            return true;
         }
         return false;
      }
      
      public function toggleEnergyLeechEffect(param1:int) : void
      {
         if(param1 == 1)
         {
            this.energyLeechCloud = ResourceManager.getMovieClip("ela0","mc");
            this.clipContainer.addChild(this.energyLeechCloud);
            this.flashEnergyLeechEffect();
            this.flashingEnergyLeech = true;
         }
         else if(this.energyLeechCloud != null)
         {
            if(this.clipContainer.contains(this.energyLeechCloud))
            {
               this.clipContainer.removeChild(this.energyLeechCloud);
            }
         }
      }
      
      private function flashEnergyLeechEffect() : void
      {
         var _loc1_:Sprite = new Sprite();
         TweenLite.to(_loc1_,2,{
            "alpha":0,
            "onComplete":this.handleEnergyLeechPause
         });
      }
      
      private function handleEnergyLeechPause() : void
      {
         var _loc1_:Sprite = new Sprite();
         TweenLite.to(this.energyLeechCloud,1,{"alpha":0});
         TweenLite.to(_loc1_,7,{
            "alpha":0,
            "onComplete":this.handleEnergyLeechUnPause
         });
      }
      
      private function handleEnergyLeechUnPause() : void
      {
         TweenLite.to(this.energyLeechCloud,1,{"alpha":1});
         this.flashEnergyLeechEffect();
      }
      
      public function updateShipClip() : void
      {
         var _loc1_:FileCollection = null;
         var _loc2_:SWFFinisher = null;
         var _loc3_:MovieClip = null;
         if(Settings.qualityShip == Settings.QUALITY_LOW)
         {
            this.createSimpleShip();
            if(this.expansionContainer != null)
            {
               this.expansionContainer.visible = false;
               this.expansionContainerFullyAdded = false;
            }
         }
         else
         {
            this.updateExpansionClip();
            _loc1_ = ResourceManager.fileCollection;
            if(_loc1_.isLoaded(this.shipPattern.getResKey()))
            {
               _loc2_ = SWFFinisher(_loc1_.getFinisher(this.shipPattern.getResKey()));
               _loc3_ = MovieClip(_loc2_.getEmbededMovieClip("mc"));
               this.setShipClip(_loc3_);
               this.setLabelHitpointPositions(_loc3_);
            }
            else
            {
               this.createSimpleShip();
               this.shipManager.loadShipResource(this.shipPattern.getResKey());
            }
         }
         this.updateSimpleShipVisibility();
      }
      
      public function updateExpansionClip() : void
      {
         var _loc3_:FileCollection = null;
         var _loc4_:MovieClip = null;
         var _loc5_:SWFFinisher = null;
         var _loc1_:int = this.shipPattern.getExpansionClassID();
         if(_loc1_ == -1)
         {
            return;
         }
         var _loc2_:ExpansionPattern = PatternManager.getExpansionPattern(this.shipPattern.getExpansionClassID(),this.expansionTypeID);
         if(_loc2_ == null)
         {
            return;
         }
         this.expansionPattern = _loc2_;
         if(Settings.qualityShip == Settings.QUALITY_HIGH)
         {
            _loc3_ = ResourceManager.fileCollection;
            if(_loc2_.getResKey().length > 0)
            {
               if(_loc3_.isLoaded(_loc2_.getResKey()))
               {
                  _loc5_ = SWFFinisher(_loc3_.getFinisher(_loc2_.getResKey()));
                  _loc4_ = MovieClip(_loc5_.getEmbededMovieClip("mc"));
                  this.setExpansionClip(_loc4_);
               }
               else
               {
                  this.shipManager.lazyLoadExpansionResource(_loc2_.getResKey());
               }
            }
         }
      }
      
      public function setGlowClip(param1:MovieClip) : void
      {
         this.glowClip = param1;
         this.removeAllChildren(this.glowContainer);
         this.glowClip.mouseEnabled = false;
         this.glowClip.mouseChildren = false;
         this.glowClip.cacheAsBitmap = true;
         this.glowContainer.addChild(param1);
         param1.gotoAndStop(this.lastShipFrame);
      }
      
      public function setShipClip(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Array = null;
         var _loc6_:Point = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.shipClip = param1;
         this.shipClip.cacheAsBitmap = true;
         if(this.shipClip.framesLoaded == 1)
         {
            _loc5_ = [];
            _loc8_ = 0;
            while(_loc8_ < this.shipClip.numChildren)
            {
               if(this.shipClip.getChildAt(_loc8_) is MovieClip)
               {
                  _loc4_ = MovieClip(this.shipClip.getChildAt(_loc8_));
                  if(_loc4_ != null && _loc4_.name.search("engine") != -1)
                  {
                     _loc5_.push(_loc4_);
                     _loc2_ = Math.sqrt(_loc4_.x * _loc4_.x + _loc4_.y * _loc4_.y);
                     _loc3_ = Math.round(Math.atan(_loc4_.y / _loc4_.x) * 180 / Math.PI);
                     _loc7_ = [];
                     _loc9_ = 0;
                     while(_loc9_ < 360)
                     {
                        _loc6_ = new Point();
                        _loc6_.x = int(_loc2_ * Math.cos((_loc9_ + _loc3_) * Math.PI / 180));
                        _loc6_.y = int(_loc2_ * Math.sin((_loc9_ + _loc3_) * Math.PI / 180));
                        _loc7_[_loc9_] = _loc6_;
                        _loc9_++;
                     }
                     this.simpleShipEnginePositions[this.simpleShipEnginePositions.length] = _loc7_;
                  }
               }
               _loc8_++;
            }
            for each(_loc4_ in _loc5_)
            {
               this.shipClip.removeChild(_loc4_);
            }
         }
         else if(this.shipPattern.getSelectionYOffset() != 0)
         {
            this.borderClip.y = this.shipPattern.getSelectionYOffset();
         }
         else
         {
            this.borderClip.y = 8;
         }
         this.setRadius(param1);
         this.shipClip.mouseEnabled = false;
         this.shipClip.mouseChildren = false;
         this.shipClip.stop();
         this.removeAllChildren(this.shipContainer);
         this.shipContainer.addChild(this.shipClip);
         if(this.isDebuffed)
         {
            if(this._debuffMove != null)
            {
               this.shipContainer.addChild(this._debuffMove);
            }
            if(this._debuffStop != null)
            {
               this.shipContainer.addChild(this._debuffStop);
            }
         }
         this.updateVisualShipRotation();
         if(this.shipPattern.playLoop)
         {
            this.shipClip.play();
         }
         if(Settings.qualityShip == Settings.QUALITY_HIGH && this.shipPattern.getGlowID() != -1)
         {
            this.loadGlowClip();
         }
         if(this.isPoliceShip)
         {
            this.shipClip.light1.stop();
            this.shipClip.light2.stop();
         }
         this.updateStandardVisualShipRotation();
      }
      
      public function setExpansionClip(param1:MovieClip) : void
      {
         param1.mouseEnabled = Main.mouseEventsEnabled;
         param1.mouseChildren = Main.mouseEventsEnabled;
         param1.gotoAndStop(1);
         this.removeAllChildren(this.expansionContainer);
         if(this.expansionContainer != null)
         {
            param1.cacheAsBitmap = true;
            this.expansionContainer.addChild(param1);
            this.expansionContainer.cacheAsBitmap = true;
         }
         param1.gotoAndStop(this.lastShipFrame);
         this.updateSimpleShipVisibility();
         this.updateExpansionClipVisibility();
         this.updateVisualExpansionRotation();
      }
      
      private function createSimpleShip() : void
      {
         var _loc1_:String = "ship_" + this.shipPattern.getPatternID();
         var _loc2_:MovieClip = ResourceManager.getMovieClip("replacementShips",_loc1_);
         if(_loc2_ == null)
         {
            _loc2_ = ResourceManager.getMovieClip("replacementShips","ship_default");
         }
         this.setShipClip(_loc2_);
         this.setLabelHitpointPositions(_loc2_);
      }
      
      private function setLabelHitpointPositions(param1:DisplayObject) : void
      {
         this.setLabelYOffset(this.shipPattern.getLabelYOffset());
         if(this.shipPattern.getEnergyYOffset() != 0)
         {
            this.setHitpointsYOffset(-param1.height / 2 - this.shipPattern.getEnergyYOffset());
         }
         else
         {
            this.setHitpointsYOffset(-param1.height / 2);
         }
      }
      
      public function startEngineTimer() : void
      {
         if(this.shipPattern.enginePositionClassID != -1 && Settings.qualityEngine == Settings.QUALITY_HIGH)
         {
            if(this.engineTimer == null)
            {
               this.engineTimer = new Timer(50,0);
               this.engineTimer.addEventListener(TimerEvent.TIMER,this.addEngineSmoke);
            }
         }
      }
      
      public function stopEngineTimer() : void
      {
         if(this.engineTimer != null)
         {
            this.engineTimer.stop();
            this.engineTimer.removeEventListener(TimerEvent.TIMER,this.addEngineSmoke);
            this.engineTimer = null;
         }
      }
      
      public function setCrossHairColor(param1:int) : void
      {
         this.borderClip.gotoAndStop(param1);
      }
      
      public function cleanup() : void
      {
         if(this.shipPattern.enginePositionClassID != -1)
         {
            this.stopEngineTimer();
         }
         if(this.engineChannel != null)
         {
            AudioManager.removeLoop(this.engineChannel,false);
         }
         if(this.engineChannel != null)
         {
            this.engineChannel.stop();
            this.engineChannel = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.clipContainer.numChildren)
         {
            this.clipContainer.removeChildAt(_loc1_);
            _loc1_++;
         }
         if(this.repairSound != null)
         {
            AudioManager.removeLoop(this.repairSound,false);
            this.repairSound = null;
         }
      }
      
      private function addEngineSmoke(param1:TimerEvent) : void
      {
         var _loc4_:BitmapClip = null;
         var _loc5_:MovieClip = null;
         if(!this.engineContainer.visible)
         {
            return;
         }
         if(!this.clipContainer.visible)
         {
            return;
         }
         var _loc2_:int = 0;
         if(this.shipClip != null)
         {
            _loc2_ = this.shipClip.currentFrame;
         }
         var _loc3_:Array = this.engineSmokePool["engineSmoke0"];
         if(_loc3_ == null)
         {
            return;
         }
         for each(_loc5_ in this.engines)
         {
            _loc4_ = _loc3_.pop();
            if(_loc4_ == null)
            {
               return;
            }
            if(this.isHeroShip())
            {
               _loc4_.x = this.heroProxy.x + _loc5_.x;
               _loc4_.y = this.heroProxy.y + _loc5_.y;
            }
            else
            {
               _loc4_.x = this.clipContainer.x + _loc5_.x;
               _loc4_.y = this.clipContainer.y + _loc5_.y;
            }
            if(this.clipContainer.alpha != 1)
            {
               if(!this.isHeroShip())
               {
                  return;
               }
               _loc4_.alpha = this.cloakAlpha;
            }
            this.laserLayer.addChild(_loc4_);
            if(this.isDebuffed)
            {
               _loc4_.frame = Math.round(2 * (_loc4_.framesLoaded / 3));
            }
            else
            {
               _loc4_.frame = 1;
            }
            TweenLite.to(_loc4_,0.75,{
               "frame":_loc4_.framesLoaded,
               "onComplete":this.handleSmokeFinished,
               "onCompleteParams":[_loc4_]
            });
         }
      }
      
      private function handleSmokeFinished(param1:BitmapClip) : void
      {
         var _loc2_:Array = null;
         if(param1 != null)
         {
            param1.stop();
            this.laserLayer.removeChild(param1);
            _loc2_ = this.engineSmokePool[param1.cacheID];
            _loc2_.push(param1);
         }
      }
      
      public function createContainers() : void
      {
         var _loc3_:EnginePositionPattern = null;
         var _loc4_:int = 0;
         var _loc5_:TextFormat = null;
         var _loc6_:TextFormat = null;
         this.clipContainer = new Sprite();
         this.clipContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.clipContainer.mouseChildren = Main.mouseEventsEnabled;
         this.shipContainer = new Sprite();
         this.shipContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.shipContainer.mouseChildren = Main.mouseEventsEnabled;
         this.clipContainer.addChild(this.shipContainer);
         if(this.shipPattern.getGlowID() != -1)
         {
            this.glowContainer = new Sprite();
            this.glowContainer.mouseEnabled = Main.mouseEventsEnabled;
            this.glowContainer.mouseChildren = Main.mouseEventsEnabled;
            this.clipContainer.addChild(this.glowContainer);
         }
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.borderClip = MovieClip(_loc1_.getEmbededMovieClip("ship_border"));
         this.borderClip.gotoAndStop(CROSSHAIR_RED);
         this.borderClip.visible = false;
         this.borderClip.mouseEnabled = Main.mouseEventsEnabled;
         this.borderClip.mouseChildren = Main.mouseEventsEnabled;
         this.clipContainer.addChild(this.borderClip);
         var _loc2_:int = this.shipPattern.getEnginePositionClassID();
         this.engines = [];
         if(_loc2_ != -1)
         {
            _loc3_ = PatternManager.getEnginePositionPattern(_loc2_);
            this.engineContainer = new Sprite();
            this.engineContainer.mouseEnabled = Main.mouseEventsEnabled;
            this.engineContainer.mouseChildren = Main.mouseEventsEnabled;
            this.clipContainer.addChild(this.engineContainer);
            _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(this.enginePattern.getResKey()));
            _loc4_ = 0;
            while(_loc4_ < _loc3_.enginePositions.length)
            {
               this.engines[_loc4_] = MovieClip(_loc1_.getEmbededMovieClip("mc"));
               this.engines[_loc4_].mouseEnabled = Main.mouseEventsEnabled;
               this.engines[_loc4_].mouseChildren = Main.mouseEventsEnabled;
               this.engineContainer.addChild(this.engines[_loc4_]);
               _loc4_++;
            }
         }
         if(this.shipPattern.hasExpansion())
         {
            this.expansionContainer = new Sprite();
            this.expansionContainer.mouseEnabled = Main.mouseEventsEnabled;
            this.expansionContainer.mouseChildren = Main.mouseEventsEnabled;
            this.clipContainer.addChild(this.expansionContainer);
         }
         this.explosionContainer = new Sprite();
         this.explosionContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.explosionContainer.mouseChildren = Main.mouseEventsEnabled;
         this.clipContainer.addChild(this.explosionContainer);
         this.droneDisplayClipContainer = new Sprite();
         this.droneDisplayClipContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.droneDisplayClipContainer.mouseChildren = Main.mouseEventsEnabled;
         this.clipContainer.addChild(this.droneDisplayClipContainer);
         if(this.shipPattern.isEnergyVisible())
         {
            _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            if(Settings.SHOW_HP_NUMBERS_ON_MAP)
            {
               this.hitpointShadowLabel = new TextField();
               this.hitpointShadowLabel.multiline = false;
               _loc5_ = new TextFormat("Tahoma",10,0);
               _loc5_.align = TextFormatAlign.CENTER;
               _loc5_.bold = true;
               this.hitpointShadowLabel.defaultTextFormat = _loc5_;
               this.hitpointShadowLabel.embedFonts = false;
               this.hitpointShadowLabel.x = -49;
               this.hitpointShadowLabel.width = 100;
               this.hitpointShadowLabel.selectable = false;
               this.hitpointShadowLabel.text = "";
               this.hitpointShadowLabel.mouseEnabled = false;
               this.clipContainer.addChild(this.hitpointShadowLabel);
               this.hitpointLabel = new TextField();
               this.hitpointLabel.multiline = false;
               _loc6_ = new TextFormat("Tahoma",10,16777215);
               _loc6_.align = TextFormatAlign.CENTER;
               _loc6_.bold = true;
               this.hitpointLabel.defaultTextFormat = _loc6_;
               this.hitpointLabel.embedFonts = false;
               this.hitpointLabel.x = -50;
               this.hitpointLabel.width = 100;
               this.hitpointLabel.selectable = false;
               this.hitpointLabel.text = "";
               this.hitpointLabel.mouseEnabled = false;
               this.clipContainer.addChild(this.hitpointLabel);
            }
            this.shipDecorator = new ShipSkillDecorator(this);
            this.clipContainer.addChild(this.shipDecorator);
            this.hitpointBackgroundClip.graphics.lineStyle(1,0);
            this.hitpointBackgroundClip.mouseEnabled = Main.mouseEventsEnabled;
            this.hitpointBackgroundClip.mouseChildren = Main.mouseEventsEnabled;
            this.hitpointBackgroundClip.graphics.beginFill(7171437);
            this.hitpointBackgroundClip.graphics.drawRect(0,0,50,3);
            this.hitpointBackgroundClip.graphics.endFill();
            this.hitpointBackgroundClip.x = -25;
            this.clipContainer.addChild(this.hitpointBackgroundClip);
            this.shieldBackgroundClip.graphics.lineStyle(1,0);
            this.shieldBackgroundClip.mouseEnabled = Main.mouseEventsEnabled;
            this.shieldBackgroundClip.mouseChildren = Main.mouseEventsEnabled;
            this.shieldBackgroundClip.graphics.beginFill(7171437);
            this.shieldBackgroundClip.graphics.drawRect(0,0,50,3);
            this.shieldBackgroundClip.graphics.endFill();
            this.shieldBackgroundClip.x = -25;
            this.clipContainer.addChild(this.shieldBackgroundClip);
            this.hitpointClip.graphics.lineStyle(1,0);
            this.hitpointClip.mouseEnabled = Main.mouseEventsEnabled;
            this.hitpointClip.mouseChildren = Main.mouseEventsEnabled;
            this.hitpointClip.graphics.beginFill(4832832);
            this.hitpointClip.graphics.drawRect(0,0,50,3);
            this.hitpointClip.graphics.endFill();
            this.hitpointClip.x = -25;
            this.clipContainer.addChild(this.hitpointClip);
            this.extraHitpointClip.graphics.lineStyle(1,0);
            this.extraHitpointClip.mouseEnabled = Main.mouseEventsEnabled;
            this.extraHitpointClip.mouseChildren = Main.mouseEventsEnabled;
            this.extraHitpointClip.graphics.beginFill(16645438);
            this.extraHitpointClip.graphics.drawRect(0,0,50,3);
            this.extraHitpointClip.graphics.endFill();
            this.extraHitpointClip.x = -25;
            this.clipContainer.addChild(this.extraHitpointClip);
            this.shieldClip.graphics.lineStyle(1,0);
            this.shieldClip.mouseEnabled = Main.mouseEventsEnabled;
            this.shieldClip.mouseChildren = Main.mouseEventsEnabled;
            this.shieldClip.graphics.beginFill(3379148);
            this.shieldClip.graphics.drawRect(0,0,50,3);
            this.shieldClip.graphics.endFill();
            this.shieldClip.x = -25;
            this.clipContainer.addChild(this.shieldClip);
            if(!this.isHeroShip())
            {
               this.shieldBackgroundClip.visible = false;
               this.hitpointBackgroundClip.visible = false;
               this.hitpointClip.visible = false;
               this.shieldClip.visible = false;
               this.extraHitpointClip.visible = false;
            }
         }
         if(this.shipPattern.isLabelVisible())
         {
            this.labelClip = new MovieClip();
            this.labelClip.mouseEnabled = Main.mouseEventsEnabled;
            this.labelClip.mouseChildren = Main.mouseEventsEnabled;
            this.clipContainer.addChild(this.labelClip);
         }
      }
      
      public function getShipDecorator() : ShipSkillDecorator
      {
         return this.shipDecorator;
      }
      
      private function createBarGraphic() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.lineStyle(1,0);
         _loc1_.mouseEnabled = Main.mouseEventsEnabled;
         _loc1_.mouseChildren = Main.mouseEventsEnabled;
         _loc1_.graphics.beginFill(16645438);
         _loc1_.graphics.drawRect(0,0,50,3);
         _loc1_.graphics.endFill();
         _loc1_.x = -25;
         return _loc1_;
      }
      
      public function updateLabelVisibility() : void
      {
         if(this.shipPattern.isLabelVisible())
         {
            this.labelClip.visible = Settings.displayPlayerNames;
         }
      }
      
      private function setEnginePosition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:EnginePositionPattern = null;
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         if(this.shipClip != null)
         {
            if(this.engineContainer.numChildren != 0)
            {
               _loc1_ = this.shipPattern.getEnginePositionClassID();
               _loc2_ = PatternManager.getEnginePositionPattern(_loc1_);
               _loc3_ = 0;
               while(_loc3_ < this.engines.length)
               {
                  if(this.shipClip.framesLoaded > 1)
                  {
                     _loc4_ = _loc2_.enginePositions[_loc3_][this.shipClip.currentFrame - 1];
                     this.engines[_loc3_].x = _loc4_.x;
                     this.engines[_loc3_].y = _loc4_.y;
                     this.currentEnginePosition.x = _loc4_.x;
                     this.currentEnginePosition.y = _loc4_.y;
                  }
                  else
                  {
                     _loc5_ = this._shipRotation % 360;
                     while(_loc5_ < 0)
                     {
                        _loc5_ = 360 + _loc5_;
                     }
                     if(this.simpleShipEnginePositions[_loc3_] != undefined)
                     {
                        _loc4_ = this.simpleShipEnginePositions[_loc3_][_loc5_];
                        this.engines[_loc3_].x = _loc4_.x;
                        this.engines[_loc3_].y = _loc4_.y;
                        this.currentEnginePosition.x = _loc4_.x;
                        this.currentEnginePosition.y = _loc4_.y;
                        this.engines[_loc3_].visible = true;
                     }
                     else
                     {
                        this.engines[_loc3_].visible = false;
                     }
                  }
                  this.engines[_loc3_].rotation = int(this._shipRotation);
                  _loc3_++;
               }
            }
         }
      }
      
      private function removeAllChildren(param1:DisplayObjectContainer) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1.removeChildAt(0);
            _loc3_++;
         }
      }
      
      public function loadGlowClip() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:MovieClip = null;
         if(this.userID != Hero.userID)
         {
            return;
         }
         var _loc1_:FileCollection = ResourceManager.fileCollection;
         if(_loc1_.isLoaded(this.glowPattern.getResKey()))
         {
            _loc2_ = SWFFinisher(_loc1_.getFinisher(this.glowPattern.getResKey()));
            _loc3_ = MovieClip(_loc2_.getEmbededMovieClip("mc"));
            this.setGlowClip(_loc3_);
         }
         else
         {
            this.shipManager.loadGlowResource(this.glowPattern.getResKey());
         }
      }
      
      public function updateSimpleShipVisibility() : void
      {
         if(this.glowContainer != null)
         {
            if(this.shipClip != null && this.shipClip.framesLoaded == 1)
            {
               this.glowContainer.visible = false;
            }
            else
            {
               this.glowContainer.visible = true;
            }
         }
      }
      
      public function updateExpansionClipVisibility() : void
      {
         if(this.expansionContainer != null && !this.expansionContainerFullyAdded)
         {
            this.expansionContainerFullyAdded = true;
            this.expansionContainer.visible = true;
         }
      }
      
      private function setRadius(param1:MovieClip) : void
      {
         this.radius = param1.width / 2;
         if(param1.height > param1.width)
         {
            this.radius = param1.height / 2;
         }
      }
      
      public function isHeroShip() : Boolean
      {
         if(this.userID == Hero.userID)
         {
            return true;
         }
         return false;
      }
      
      public function isHeroPet() : Boolean
      {
         var _loc1_:Pet = this.shipManager.getHero().pet;
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            if(this.userID == _loc1_.userID)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function getExpansionClip() : MovieClip
      {
         if(this.expansionContainer != null && this.expansionContainer.numChildren > 0)
         {
            return MovieClip(this.expansionContainer.getChildAt(0));
         }
         return null;
      }
      
      public function getClipContainer() : Sprite
      {
         return this.clipContainer;
      }
      
      public function getUserId() : Number
      {
         return this.userID;
      }
      
      public function getSpeed() : int
      {
         return this.speed;
      }
      
      public function setSpeed(param1:int) : void
      {
         this.speed = param1;
      }
      
      public function removeTitle() : void
      {
         if(this.titleClip != null && this.clipContainer.contains(this.titleClip))
         {
            this.labelClip.y = this.labelClipOldYPosition;
            this.clipContainer.removeChild(this.titleClip);
            this.updateLabelPositions();
         }
      }
      
      public function removePermanentTitle() : void
      {
         if(this.permanentTitleClip != null && this.clipContainer.contains(this.permanentTitleClip))
         {
            this.clipContainer.removeChild(this.permanentTitleClip);
            this.updateLabelPositions();
         }
      }
      
      public function updateTitle(param1:String) : void
      {
         var _loc3_:BitmapData = null;
         if(this.titleClip != null && this.clipContainer.contains(this.titleClip))
         {
            this.labelClip.y = this.labelClipOldYPosition;
            this.clipContainer.removeChild(this.titleClip);
         }
         this.userTitle = param1;
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = Styles.systemTitleFmt;
         _loc2_.embedFonts = Styles.systemTitleEmbed;
         _loc2_.text = param1;
         this.titleClip = new MovieClip();
         this.titleClip.mouseEnabled = Main.mouseEventsEnabled;
         this.titleClip.mouseChildren = Main.mouseEventsEnabled;
         _loc2_.filters = [mediumGlowFilter];
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:int = _loc2_.width;
         _loc3_ = new BitmapData(_loc4_,_loc2_.height + 3,true,0);
         var _loc5_:Matrix = new Matrix();
         _loc3_.draw(_loc2_,_loc5_);
         this.titleClip.addChild(new Bitmap(_loc3_));
         this.titleClip.x = this.labelClip.x + 16 + this.tmp / 2 - this.titleClip.width / 2;
         this.titleClip.y = this.labelClip.y + 8;
         this.labelClipOldYPosition = this.labelClip.y;
         this.labelClip.y = this.titleClip.y + this.titleClip.height;
         this.clipContainer.addChild(this.titleClip);
         this.updateLabelPositions();
         this.titleClip.visible = Settings.displayPlayerNames;
      }
      
      private function updateLabelPositions() : void
      {
         if(this.permanentTitleClip != null && this.clipContainer.contains(this.permanentTitleClip))
         {
            if(this.simpleDroneDisplay != null && this.droneDisplayClipContainer.contains(this.simpleDroneDisplay))
            {
               this.permanentTitleClip.y = this.labelClip.height + this.labelClip.y + 12;
            }
            else
            {
               this.permanentTitleClip.y = this.labelClip.height + this.labelClip.y + 2;
            }
         }
         if(this.simpleDroneDisplay != null && this.droneDisplayClipContainer.contains(this.simpleDroneDisplay))
         {
            this.simpleDroneDisplay.y = this.labelClip.y + 24;
         }
      }
      
      public function updatePermanentTitle(param1:String) : void
      {
         var _loc3_:BitmapData = null;
         if(this.permanentTitleClip != null && this.clipContainer.contains(this.permanentTitleClip))
         {
            this.clipContainer.removeChild(this.permanentTitleClip);
         }
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = Styles.systemPermanentTitleFmt;
         _loc2_.embedFonts = Styles.systemPermanentTitleEmbed;
         _loc2_.text = param1;
         this.permanentTitleClip = new MovieClip();
         this.permanentTitleClip.mouseEnabled = Main.mouseEventsEnabled;
         this.permanentTitleClip.mouseChildren = Main.mouseEventsEnabled;
         _loc2_.filters = [mediumGlowFilter];
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:int = _loc2_.width;
         _loc3_ = new BitmapData(_loc4_,_loc2_.height + 3,true,0);
         var _loc5_:Matrix = new Matrix();
         _loc3_.draw(_loc2_,_loc5_);
         this.permanentTitleClip.addChild(new Bitmap(_loc3_));
         this.permanentTitleClip.x = this.labelClip.x + 16 + this.tmp / 2 - this.permanentTitleClip.width / 2;
         this.clipContainer.addChild(this.permanentTitleClip);
         this.updateLabelPositions();
         this.permanentTitleClip.visible = Settings.displayPlayerNames;
      }
      
      public function updateLabel(param1:String = "") : void
      {
         var _loc2_:Ship = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:uint = 0;
         var _loc10_:BitmapData = null;
         var _loc11_:BitmapData = null;
         var _loc15_:TextField = null;
         var _loc16_:TextFormat = null;
         var _loc17_:String = null;
         var _loc18_:Bitmap = null;
         if(!this.shipPattern.isLabelVisible())
         {
            return;
         }
         if(this.isHeroShip())
         {
            _loc2_ = this as Ship;
         }
         else
         {
            _loc2_ = this.shipManager.getHero();
         }
         if(_loc2_ == null)
         {
            return;
         }
         if(this.isHeroShip())
         {
            _loc3_ = PatternManager.colorPatterns["neutral"];
         }
         else if(this._isGroupMember)
         {
            _loc3_ = PatternManager.colorPatterns["sameGroup"];
         }
         else if(this.clanID != 0 && this.clanID == _loc2_.getClanID())
         {
            _loc3_ = PatternManager.colorPatterns["sameClan"];
         }
         else if(this.fractionID == _loc2_.getFactionID())
         {
            _loc3_ = PatternManager.colorPatterns["sameFraction"];
         }
         else
         {
            _loc3_ = PatternManager.colorPatterns["enemy"];
         }
         if(param1 != "")
         {
            _loc3_ = PatternManager.colorPatterns[param1];
         }
         if(this.clanDiplomacy == -1)
         {
            _loc4_ = PatternManager.colorPatterns["neutral"];
         }
         else if(this.clanDiplomacy == 0)
         {
            _loc4_ = PatternManager.colorPatterns["neutral"];
         }
         else if(this.clanDiplomacy == 1)
         {
            _loc4_ = PatternManager.colorPatterns["allied"];
         }
         else if(this.clanDiplomacy == 2)
         {
            _loc4_ = PatternManager.colorPatterns["noAttackPact"];
         }
         else if(this.clanDiplomacy == 3)
         {
            _loc4_ = PatternManager.colorPatterns["atWar"];
         }
         if(!this.isHeroShip())
         {
            this.setMiniMapColorInRelationToHero(_loc2_);
         }
         else
         {
            this.setShipProtectedStatus();
         }
         this.miniMapColorAlpha = this.makeMiniMapColorTransparent(this.miniMapColor);
         var _loc5_:uint = parseInt("0x" + _loc3_);
         if(this.clanTag != null && this.clanTag.length > 0 && _loc4_ != null)
         {
            _loc6_ = parseInt("0x" + _loc4_);
         }
         var _loc7_:TextField = new TextField();
         var _loc8_:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc5_,Styles.nickFmt.bold);
         _loc7_.defaultTextFormat = _loc8_;
         _loc7_.embedFonts = Styles.nickEmbed;
         var _loc9_:int = 0;
         if(this.clanTag != null && this.clanTag.length > 0)
         {
            _loc15_ = new TextField();
            _loc16_ = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc6_,Styles.nickFmt.bold);
            _loc15_.defaultTextFormat = _loc16_;
            _loc15_.embedFonts = Styles.nickEmbed;
            _loc15_.text = "[" + StringUtil.trim(this.clanTag) + "]";
            _loc15_.filters = [filter];
            _loc15_.autoSize = TextFieldAutoSize.LEFT;
            _loc9_ += _loc15_.width;
         }
         _loc7_.text = StringUtil.trim(this.username);
         _loc7_.filters = [filter];
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         this.invalidateProtectedStatus();
         _loc9_ += _loc7_.width;
         this.tmp = _loc9_;
         var _loc12_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
         if(this.dailyRank != 0)
         {
            this.rankIcon = BitmapData(_loc12_.getEmbededBitmapData("rank" + this.dailyRank));
            _loc9_ += this.rankIcon.width;
         }
         else
         {
            this.rankIcon = null;
         }
         if(this.fractionID != 0)
         {
            _loc11_ = BitmapData(_loc12_.getEmbededBitmapData("fraction" + this.fractionID));
            _loc9_ += _loc11_.width + 2;
         }
         _loc10_ = new BitmapData(_loc9_,_loc7_.height + 3,true,0);
         var _loc13_:Matrix = new Matrix();
         var _loc14_:Matrix = new Matrix();
         if(this.rankIcon != null)
         {
            _loc10_.copyPixels(this.rankIcon,this.rankIcon.rect,new Point(0,3));
            _loc13_.translate(this.rankIcon.width,0);
            _loc14_.translate(this.rankIcon.width,0);
         }
         if(_loc11_ != null)
         {
            _loc10_.copyPixels(_loc11_,_loc11_.rect,new Point(_loc9_ - _loc11_.width,0));
         }
         this.labelClip.graphics.clear();
         if(this.ggClip != null && this.labelClip.contains(this.ggClip))
         {
            this.labelClip.removeChild(this.ggClip);
         }
         if(this.galaxyGatesFinished > 0)
         {
            if(this.galaxyGatesFinished > GALAXY_GATES_FINISHED_MAXIMUM)
            {
               this.galaxyGatesFinished = GALAXY_GATES_FINISHED_MAXIMUM;
            }
            _loc17_ = "achievement_" + this.galaxyGatesFinished;
            _loc18_ = _loc12_.getEmbededBitmap(_loc17_);
            this.ggClip = new Sprite();
            this.ggClip.mouseEnabled = Main.mouseEventsEnabled;
            this.ggClip.mouseChildren = Main.mouseEventsEnabled;
            this.ggClip.addChild(_loc18_);
            this.ggClip.x = -2;
            this.ggClip.y = -14;
            this.labelClip.addChild(this.ggClip);
         }
         if(_loc15_ != null)
         {
            _loc10_.draw(_loc15_,_loc14_);
            _loc13_.translate(_loc15_.width,0);
         }
         _loc10_.draw(_loc7_,_loc13_);
         this.labelClip.addChild(new Bitmap(_loc10_));
         this.labelClip.x = -int(_loc9_ / 2);
         this.labelClip.visible = Settings.displayPlayerNames;
      }
      
      public function setMiniMapColorInRelationToHero(param1:Ship) : void
      {
         var _loc2_:Boolean = false;
         if(Hero.cpuItems[CPUItem.TYPE_RADAR] != null || Hero.premium)
         {
            _loc2_ = true;
         }
         if(param1.getClanID() > 0 && this.getClanID() == param1.getClanID())
         {
            this.miniMapColor = 4281597747;
         }
         else if(this.getClanDiplomacy() == 1 && _loc2_)
         {
            this.miniMapColor = 4281597747;
         }
         else if(this.getClanDiplomacy() == 2 && _loc2_)
         {
            this.miniMapColor = 4294953984;
         }
         else if(this.getClanDiplomacy() == 2 && _loc2_)
         {
            this.miniMapColor = 4291559424;
         }
         else if(this.getFactionID() == param1.getFactionID())
         {
            if(this.getClanDiplomacy() == 3 && _loc2_)
            {
               this.miniMapColor = 4294901760;
            }
            else
            {
               this.miniMapColor = 4278229503;
            }
         }
         else if(this.shipPattern.getPatternID() == 442)
         {
            this.miniMapIcon = "mapIcon_spaceball";
            this.isIcon = true;
         }
         else if(this.hasWarnIconOnMap())
         {
            this.miniMapIcon = "mapIcon_alert";
            this.isIcon = true;
         }
         else
         {
            this.miniMapColor = 4294901760;
         }
         this.setShipProtectedStatus();
      }
      
      public function setMinimapIcon(param1:String) : void
      {
         this.miniMapIcon = param1;
         this.isIcon = true;
      }
      
      private function setShipProtectedStatus() : void
      {
         if(!this.map.getPvpAllowed())
         {
            if(this.map.getHomeMapFaction() == this.fractionID)
            {
               this.shipAttackableInNonPVP = false;
            }
            else
            {
               this.shipAttackableInNonPVP = true;
            }
         }
         else
         {
            this.shipAttackableInNonPVP = true;
         }
      }
      
      public function makeMiniMapColorTransparent(param1:uint) : uint
      {
         return uint(param1 - 2147483648);
      }
      
      public function changeAttackableStateInNonPvPMap(param1:Boolean) : void
      {
         this.shipAttackableInNonPVP = param1;
         this.invalidateProtectedStatus();
      }
      
      private function invalidateProtectedStatus() : void
      {
         if(!this.shipAttackableInNonPVP)
         {
            this.labelClip.alpha = 0.4;
         }
         else
         {
            this.labelClip.alpha = 1;
         }
      }
      
      public function updateDroneDisplay(param1:int, param2:int) : void
      {
         var _loc3_:DroneDisplay = null;
         if(param1 > 0 || param2 > 0)
         {
            _loc3_ = new DroneDisplay(param1,param2);
            this.simpleDroneDisplay = new MovieClip();
            this.simpleDroneDisplay.mouseEnabled = Main.mouseEventsEnabled;
            this.simpleDroneDisplay.mouseChildren = Main.mouseEventsEnabled;
            this.simpleDroneDisplay.addChild(new Bitmap(_loc3_));
            this.simpleDroneDisplay.x = this.labelClip.x;
            this.simpleDroneDisplay.y = this.labelClip.y + 24;
            this.simpleDroneDisplay.x += 2;
            if(this.rankIcon != null)
            {
               this.simpleDroneDisplay.x += this.rankIcon.width;
            }
            this.droneDisplayClipContainer.addChild(this.simpleDroneDisplay);
            this.updateLabelPositions();
         }
      }
      
      public function setLabelYOffset(param1:int) : void
      {
         this.labelClip.y = param1;
      }
      
      public function setHitpointsYOffset(param1:int) : void
      {
         if(this.shipPattern.isEnergyVisible())
         {
            if(this.hitpointLabel != null)
            {
               this.hitpointLabel.y = param1 - 18;
               this.hitpointShadowLabel.y = param1 - 17;
            }
            this.hitpointBackgroundClip.y = param1;
            this.extraHitpointClip.y = param1;
            this.hitpointClip.y = param1;
            this.shieldClip.y = param1 + 6;
            this.shieldBackgroundClip.y = param1 + 6;
         }
      }
      
      public function setSelected(param1:Boolean) : void
      {
         var _loc2_:* = false;
         if(!this.idleState)
         {
            this.borderClip.visible = param1;
            if(param1)
            {
               this.borderClip.alpha = 0;
               TweenLite.to(this.borderClip,0.25,{"alpha":1});
               if(this.shipPattern.isEnergyVisible())
               {
                  this.shieldBackgroundClip.alpha = 0;
                  this.shieldBackgroundClip.visible = true;
                  this.hitpointBackgroundClip.alpha = 0;
                  this.hitpointBackgroundClip.visible = true;
                  this.extraHitpointClip.alpha = 0;
                  this.extraHitpointClip.visible = true;
                  this.hitpointClip.alpha = 0;
                  this.hitpointClip.visible = true;
                  this.shieldClip.alpha = 0;
                  this.shieldClip.visible = true;
                  TweenLite.to(this.shieldBackgroundClip,0.25,{"alpha":1});
                  TweenLite.to(this.hitpointBackgroundClip,0.25,{"alpha":1});
                  TweenLite.to(this.extraHitpointClip,0.25,{"alpha":1});
                  TweenLite.to(this.hitpointClip,0.25,{"alpha":1});
                  TweenLite.to(this.shieldClip,0.25,{"alpha":1});
               }
            }
            else
            {
               _loc2_ = false;
               if(this.shipManager.getHero().pet != null)
               {
                  _loc2_ = this.userID == this.shipManager.getHero().pet.userID;
               }
               if(this.shipPattern.isEnergyVisible() && !_loc2_)
               {
                  this.shieldBackgroundClip.visible = false;
                  this.hitpointBackgroundClip.visible = false;
                  this.extraHitpointClip.visible = false;
                  this.hitpointClip.visible = false;
                  this.shieldClip.visible = false;
               }
            }
            if(this.hitpointLabel != null)
            {
               this.hitpointLabel.visible = param1;
               this.hitpointShadowLabel.visible = param1;
            }
         }
      }
      
      public function isSelected() : Boolean
      {
         return this.borderClip.visible;
      }
      
      public function setMaxHitpoints(param1:Number) : void
      {
         this.maxHitpoints = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_HITPOINTS);
         }
      }
      
      public function setCargo(param1:Number) : void
      {
         this.cargo = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_CARGO);
         }
      }
      
      public function setMaxCargo(param1:Number) : void
      {
         this.maxCargo = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_CARGO);
         }
      }
      
      public function removeDrones() : void
      {
         if(this.droneConnector != null)
         {
            this.droneConnector.cleanup(this);
         }
         this.droneConnector = null;
      }
      
      public function removeSimpleDroneDisplay() : void
      {
         if(this.simpleDroneDisplay != null && this.droneDisplayClipContainer.contains(this.simpleDroneDisplay))
         {
            this.droneDisplayClipContainer.removeChild(this.simpleDroneDisplay);
         }
         this.simpleDroneDisplay = null;
         this.updateLabelPositions();
      }
      
      public function initDroneConnector() : void
      {
         this.droneConnector = new DroneConnector();
      }
      
      public function getFactionID() : int
      {
         return this.fractionID;
      }
      
      public function getClanID() : int
      {
         return this.clanID;
      }
      
      public function getMiniMapColor() : uint
      {
         if(this.shipAttackableInNonPVP)
         {
            return this.miniMapColor;
         }
         return this.miniMapColorAlpha;
      }
      
      public function getMiniMapColorAlpha() : uint
      {
         return this.miniMapColorAlpha;
      }
      
      public function getMiniMapIcon() : String
      {
         return this.miniMapIcon;
      }
      
      public function isIconOnMiniMap() : Boolean
      {
         return this.isIcon;
      }
      
      public function getClanDiplomacy() : int
      {
         return this.clanDiplomacy;
      }
      
      public function getUsername() : String
      {
         return this.username;
      }
      
      public function getClanTag() : String
      {
         return this.clanTag;
      }
      
      public function get shipRotation() : int
      {
         return this._shipRotation;
      }
      
      public function set shipRotation(param1:int) : void
      {
         if(this._shipRotation != param1)
         {
            this._shipRotation = param1;
            this.updateStandardVisualShipRotation();
            this.updateVisualExpansionRotation();
            this.updateVisualGlowRotation();
            if(this.isDebuffed)
            {
               if(this.map.getCombatManager().isShipAttacking(this.userID) == null || this.movingCnt == 0)
               {
                  this.updateDebuffRotation(ROTATION_SHIP);
               }
               else
               {
                  this.updateDebuffRotation(ROTATION_MOVEMENT,true);
               }
            }
            if(this.shipPattern.enginePositionClassID != -1)
            {
               this.setEnginePosition();
            }
         }
      }
      
      public function updateDebuffRotation(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case ROTATION_MOVEMENT:
               _loc3_ = this.movementDirection;
               break;
            case ROTATION_SHIP:
            default:
               _loc3_ = this._shipRotation;
         }
         if(this._debuffMove != null)
         {
            if((!param2 || this._debuffMove.alpha == 0) && this.isMoving)
            {
               this._debuffMove.rotation = _loc3_;
            }
            else if(this.isMoving)
            {
               TweenLite.to(this._debuffMove,0.25,{"shortRotation":{"rotation":_loc3_}});
            }
         }
         if(this._debuffStop != null)
         {
            if((!param2 || this._debuffStop.alpha == 0) && !this.isMoving)
            {
               this._debuffStop.rotation = _loc3_;
            }
            else if(param1 != ROTATION_MOVEMENT)
            {
               TweenLite.to(this._debuffStop,0.25,{"shortRotation":{"rotation":_loc3_}});
            }
         }
      }
      
      public function updateDebuff() : void
      {
         if(this._debuffMove != null && this._debuffStop != null)
         {
            if(this.isMoving)
            {
               this.updateDebuffRotation(ROTATION_MOVEMENT);
               TweenLite.to(this._debuffMove,1,{
                  "ease":Linear.easeNone,
                  "alpha":1
               });
               TweenLite.to(this._debuffStop,0.7,{
                  "ease":Linear.easeNone,
                  "alpha":0
               });
            }
            else
            {
               this.updateDebuffRotation(ROTATION_SHIP);
               TweenLite.to(this._debuffStop,0.7,{
                  "ease":Linear.easeNone,
                  "alpha":1
               });
               TweenLite.to(this._debuffMove,1,{
                  "ease":Linear.easeNone,
                  "alpha":0
               });
            }
         }
      }
      
      public function updateVisualShipRotation() : void
      {
         var _loc1_:int = this._shipRotation % 360;
         while(_loc1_ < 0)
         {
            _loc1_ = 360 + _loc1_;
         }
         this.lastShipFrame = 32 / 360 * _loc1_ + 1;
         if(this.lastShipFrame == this.shipClip.currentFrame)
         {
            return;
         }
         if(this.shipClip.framesLoaded > 1)
         {
            this.shipClip.gotoAndStop(this.lastShipFrame);
            if(this.isPoliceShip)
            {
               this.shipClip.light1.gotoAndStop(this.lastShipFrame);
               this.shipClip.light2.gotoAndStop(this.lastShipFrame);
            }
         }
         else if(!this.shipPattern.playLoop && this.shipPattern.rotatable)
         {
            this.shipClip.rotation = this._shipRotation;
         }
      }
      
      public function flashLights() : void
      {
         if(this.shipClip != null)
         {
            if(this.lightSetting == 0)
            {
               TweenLite.to(this.shipClip.light1,this.lightFlashTime,{"colorTransform":{
                  "tint":this.redColour,
                  "tintAmount":this.tintAmount
               }});
               TweenLite.to(this.shipClip.light1,this.lightFlashTime,{"glowFilter":{
                  "color":this.redColour,
                  "blurX":this.glowBlurX,
                  "blurY":this.glowBlurY,
                  "strength":this.glowStrength,
                  "alpha":this.glowAlpha
               }});
               TweenLite.to(this.shipClip.light2,this.lightFlashTime,{"colorTransform":{
                  "tint":this.blueColour,
                  "tintAmount":this.tintAmount
               }});
               TweenLite.to(this.shipClip.light2,this.lightFlashTime,{"glowFilter":{
                  "color":this.blueColour,
                  "blurX":this.glowBlurX,
                  "blurY":this.glowBlurY,
                  "strength":this.glowStrength,
                  "alpha":this.glowAlpha
               }});
               this.lightSetting = 1;
            }
            else if(this.lightSetting == 1)
            {
               TweenLite.to(this.shipClip.light2,this.lightFlashTime,{"colorTransform":{
                  "tint":this.redColour,
                  "tintAmount":this.tintAmount
               }});
               TweenLite.to(this.shipClip.light2,this.lightFlashTime,{"glowFilter":{
                  "color":this.redColour,
                  "blurX":this.glowBlurX,
                  "blurY":this.glowBlurY,
                  "strength":this.glowStrength,
                  "alpha":this.glowAlpha
               }});
               TweenLite.to(this.shipClip.light1,this.lightFlashTime,{"colorTransform":{
                  "tint":this.blueColour,
                  "tintAmount":this.tintAmount
               }});
               TweenLite.to(this.shipClip.light1,this.lightFlashTime,{"glowFilter":{
                  "color":this.blueColour,
                  "blurX":this.glowBlurX,
                  "blurY":this.glowBlurY,
                  "strength":this.glowStrength,
                  "alpha":this.glowAlpha
               }});
               this.lightSetting = 0;
            }
         }
         TweenMax.delayedCall(this.lightFlashTimeDelay,this.flashLights);
      }
      
      private function updateVisualExpansionRotation() : void
      {
         if(this.expansionContainer != null && this.expansionTypeID != 0 && this.expansionContainer.numChildren != 0)
         {
            MovieClip(this.expansionContainer.getChildAt(0)).gotoAndStop(this.lastShipFrame);
         }
      }
      
      private function updateVisualGlowRotation() : void
      {
         if(this.glowClip != null)
         {
            this.glowClip.gotoAndStop(this.lastShipFrame);
         }
      }
      
      public function getCurrentFrameOfShip() : int
      {
         if(this.shipClip != null)
         {
            return this.shipClip.currentFrame;
         }
         return 1;
      }
      
      public function getExpansionTypeID() : int
      {
         return this.expansionTypeID;
      }
      
      public function setExpansionTypeID(param1:int) : void
      {
         if(param1 > 3)
         {
            param1 = 3;
         }
         this.expansionTypeID = param1;
      }
      
      public function getExplosionContainer() : Sprite
      {
         return this.explosionContainer;
      }
      
      public function addShipDamage(param1:String) : void
      {
         var _loc2_:ExplosionPattern = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ShipDamage = null;
         var _loc10_:Number = NaN;
         var _loc11_:MovieClip = null;
         switch(param1)
         {
            case "L":
            case "ECI":
            case "SIN":
               _loc3_ = Main.getRandomCount(0,2);
               _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,_loc3_);
               break;
            case "R":
               _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,this.shipPattern.getRocketDamageTypeID());
               break;
            case "I":
               _loc3_ = Main.getRandomCount(0,2);
               _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,_loc3_);
               break;
            case "M":
               _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,this.shipPattern.getRocketDamageTypeID());
               break;
            case "P":
               _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,2);
               break;
            case "H":
         }
         if(_loc2_ != null)
         {
            _loc4_ = _loc2_.getSoundID();
            if(_loc4_ != -1)
            {
               AudioManager.playSoundEffect(_loc4_,false,false,this.clipContainer.x,this.clipContainer.y);
            }
            _loc5_ = ResourceManager.getMovieClip(_loc2_.getResKey(),"mc");
            if(this.shipContainer.numChildren != 0)
            {
               _loc11_ = MovieClip(this.shipContainer.getChildAt(0));
               _loc6_ = _loc11_.width / 2 - 5;
            }
            _loc7_ = Main.getRandomCount(0,360);
            _loc8_ = Main.getRandomCount(0,_loc6_);
            _loc10_ = 1.7;
            switch(param1)
            {
               case "L":
               case "ECI":
               case "SIN":
                  _loc9_ = new ShipDamage(this,_loc5_,_loc7_,_loc8_,true);
                  break;
               case "R":
                  _loc9_ = new ShipDamage(this,_loc5_,_loc7_,_loc8_);
                  break;
               case "I":
                  _loc9_ = new ShipDamage(this,_loc5_,_loc7_,_loc8_,true);
                  this.map.getMain().screenManager.shakeScreen();
                  AudioManager.playSoundEffect(7);
                  break;
               case "M":
                  _loc9_ = new ShipDamage(this,_loc5_,_loc7_,_loc8_);
                  _loc10_ = 0.8;
                  break;
               case "P":
                  _loc9_ = new ShipDamage(this,_loc5_,0,0);
                  break;
               case "H":
                  break;
               default:
                  return;
            }
            _loc9_.positionClip();
            _loc9_.playClip();
         }
      }
      
      public function getLastShoot() : int
      {
         return this.lastShoot;
      }
      
      public function setLastShoot(param1:int) : void
      {
         this.lastShoot = param1;
      }
      
      public function showRepairRobot(param1:int) : void
      {
         var _loc2_:ResourcePattern = null;
         var _loc3_:SWFFinisher = null;
         if(this.repairRobotClip == null)
         {
            _loc2_ = PatternManager.robotPatterns[int(param1)];
            _loc3_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc2_.getResKey()));
            this.repairRobotClip = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            this.clipContainer.addChild(this.repairRobotClip);
         }
         if(!this.clipContainer.contains(this.repairRobotClip))
         {
            this.repairRobotClip.alpha = 0;
            this.repairRobotClip.robot.gotoAndStop(1);
            this.repairRobotClip.robot.play();
            this.clipContainer.addChild(this.repairRobotClip);
            TweenLite.to(this.repairRobotClip,0.25,{"alpha":1});
         }
         if(this.repairSound == null)
         {
            this.repairSound = AudioManager.playSoundEffect(35,true);
         }
      }
      
      public function hideRepairRobot() : void
      {
         if(this.repairRobotClip != null && this.clipContainer.contains(this.repairRobotClip))
         {
            TweenLite.to(this.repairRobotClip,0.25,{
               "alpha":0,
               "onComplete":this.handleRobotRemove
            });
         }
         if(this.repairSound != null)
         {
            AudioManager.removeLoop(this.repairSound,false);
            this.repairSound = null;
         }
      }
      
      public function showBattleRepairBot(param1:int) : void
      {
         var _loc2_:ResourcePattern = null;
         var _loc3_:SWFFinisher = null;
         if(this.battleRepairRobotClip == null)
         {
            _loc2_ = PatternManager.robotPatterns[int(param1)];
            _loc3_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc2_.getResKey()));
            this.battleRepairRobotClip = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            this.clipContainer.addChild(this.battleRepairRobotClip);
         }
         if(!this.clipContainer.contains(this.battleRepairRobotClip))
         {
            this.battleRepairRobotClip.alpha = 0;
            this.battleRepairRobotClip.robot.gotoAndStop(1);
            this.battleRepairRobotClip.robot.play();
            this.clipContainer.addChild(this.battleRepairRobotClip);
            TweenLite.to(this.battleRepairRobotClip,0.25,{"alpha":1});
         }
         if(this.repairSound == null)
         {
            this.repairSound = AudioManager.playSoundEffect(35,true);
         }
      }
      
      public function hideBattleRepairBot() : void
      {
         if(this.battleRepairRobotClip != null && this.clipContainer.contains(this.battleRepairRobotClip))
         {
            TweenLite.to(this.battleRepairRobotClip,0.25,{
               "alpha":0,
               "onComplete":this.handleBattleRepRobotRemove
            });
         }
         if(this.repairSound != null)
         {
            AudioManager.removeLoop(this.repairSound,false);
            this.repairSound = null;
         }
      }
      
      private function handleBattleRepRobotRemove() : void
      {
         this.clipContainer.removeChild(this.battleRepairRobotClip);
         this.battleRepairRobotClip = null;
      }
      
      private function handleRobotRemove() : void
      {
         this.clipContainer.removeChild(this.repairRobotClip);
         this.repairRobotClip = null;
      }
      
      public function hasWarnIconOnMap() : Boolean
      {
         return this.warnIconOnMap;
      }
      
      public function get isGroupMember() : Boolean
      {
         return this._isGroupMember;
      }
      
      public function getMaxHitpoints() : Number
      {
         return this.maxHitpoints;
      }
      
      public function updateHitpointShieldBar(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.hitpoints > this.maxHitpoints * 2)
         {
            this.hitpoints = this.maxHitpoints * 2;
         }
         if(this.hitpointLabel != null)
         {
            this.hitpointLabel.text = BPLocale.roundInteger(this.hitpoints);
            this.hitpointShadowLabel.text = this.hitpointLabel.text;
         }
         if(this.hitpoints > this.maxHitpoints)
         {
            this.extraHitpoints = this.hitpoints - this.maxHitpoints;
         }
         else
         {
            this.extraHitpoints = 0;
         }
         if(this.shipPattern.isEnergyVisible())
         {
            if(this.maxShield != 0)
            {
               if(this.shield == 0)
               {
                  this.shieldClip.width = 0;
                  this.shieldClip.visible = false;
                  this.shieldBackgroundClip.visible = false;
               }
               else
               {
                  this.shieldClip.visible = true;
                  this.shieldBackgroundClip.visible = true;
                  if(this.shield > this.maxShield)
                  {
                     this.maxShield = this.shield;
                  }
                  _loc2_ = 50 / this.maxShield * this.shield;
                  if(param1)
                  {
                     TweenLite.to(this.shieldClip,0.25,{"width":_loc2_});
                  }
                  else
                  {
                     this.shieldClip.width = _loc2_;
                  }
               }
            }
            if(this.extraHitpoints != 0)
            {
               if(this.clipContainer.contains(this.extraHitpointClip))
               {
                  this.clipContainer.setChildIndex(this.extraHitpointClip,this.clipContainer.numChildren - 1);
               }
               this.extraHitpointClip.visible = true;
               _loc3_ = this.extraHitpoints / this.maxHitpoints * 50;
               if(param1)
               {
                  TweenLite.to(this.extraHitpointClip,0.25,{"width":_loc3_});
               }
               else
               {
                  this.extraHitpointClip.width = _loc3_;
               }
               this.hitpointClip.width = 50;
               return;
            }
            if(this.clipContainer.contains(this.extraHitpointClip))
            {
               this.clipContainer.setChildIndex(this.extraHitpointClip,0);
            }
            this.extraHitpointClip.visible = false;
            this.extraHitpointClip.width = 0;
            if(this.hitpoints == 0)
            {
               this.hitpointClip.width = 0;
               this.hitpointClip.visible = false;
            }
            else
            {
               this.hitpointClip.visible = true;
               _loc4_ = 50 / this.maxHitpoints * this.hitpoints;
               if(param1)
               {
                  TweenLite.to(this.hitpointClip,0.25,{"width":_loc4_});
               }
               else
               {
                  this.hitpointClip.width = _loc4_;
               }
            }
         }
      }
      
      public function getHitpoints() : Number
      {
         return this.hitpoints;
      }
      
      public function setHitpoints(param1:Number) : void
      {
         this.hitpoints = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_HITPOINTS);
         }
      }
      
      public function getShield() : int
      {
         return this.shield;
      }
      
      public function setShieldChunk(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         this.shield = param1;
         if(param1 > param2)
         {
            param2 = param1;
         }
         this.maxShield = param2;
         if(param3)
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_SHIELD);
         }
         this.updateHitpointShieldBar(false);
      }
      
      public function setShield(param1:Number) : void
      {
         this.shield = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_SHIELD);
         }
      }
      
      public function setMaxShield(param1:Number) : void
      {
         if(this.shield > param1)
         {
            param1 = this.shield;
         }
         this.maxShield = param1;
         if(this.isHeroShip())
         {
            this.map.getMain().getGuiManager().updateInfoField(SimpleWindow.WINDOW_CLASS_SHIP,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_SHIELD);
         }
      }
      
      public function getMaxShield() : Number
      {
         return this.maxShield;
      }
      
      public function getCargo() : Number
      {
         return this.cargo;
      }
      
      public function getMaxCargo() : Number
      {
         return this.maxCargo;
      }
      
      public function getShipContainer() : Sprite
      {
         return this.shipContainer;
      }
      
      public function getExpansionContainer() : Sprite
      {
         return this.expansionContainer;
      }
      
      public function setEngineSmokePattern(param1:EngineSmokePattern) : void
      {
         this.engineSmokePattern = param1;
      }
      
      public function setShipPattern(param1:ShipPattern) : void
      {
         this.shipPattern = param1;
      }
      
      public function setClanTag(param1:String) : void
      {
         this.clanTag = param1;
      }
      
      public function setClanID(param1:int) : void
      {
         this.clanID = param1;
      }
      
      public function setClanDiplomacy(param1:int) : void
      {
         this.clanDiplomacy = param1;
      }
      
      public function setFactionID(param1:int) : void
      {
         this.fractionID = param1;
      }
      
      public function setDailyRank(param1:int) : void
      {
         this.dailyRank = param1;
      }
      
      public function setWarnIconOnMap(param1:Boolean) : void
      {
         this.warnIconOnMap = param1;
      }
      
      public function set isGroupMember(param1:Boolean) : void
      {
         this._isGroupMember = param1;
      }
      
      public function setEnginePattern(param1:AudibleResourcePattern) : void
      {
         this.enginePattern = param1;
      }
      
      public function setShipGlowPattern(param1:ResourcePattern) : void
      {
         this.glowPattern = param1;
      }
      
      public function getGlowPattern() : ResourcePattern
      {
         return this.glowPattern;
      }
      
      public function getShipManager() : ShipManager
      {
         return this.shipManager;
      }
      
      public function attachBeaconClip(param1:Beacon) : void
      {
         this.beacon = param1;
         var _loc2_:DisplayObject = param1.clip;
         _loc2_.alpha = 0;
         this.clipContainer.addChild(param1.clip);
         ScreenManager.fadeInClip(0.25,_loc2_);
      }
      
      public function removeBeaconClip() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.beacon != null)
         {
            _loc1_ = this.beacon.clip;
            ScreenManager.fadeOutClip(0.25,_loc1_);
         }
      }
      
      public function attachMalusClowdClip() : void
      {
         if(this.malusClip != null && !this.clipContainer.contains(this.malusClip))
         {
            this.clipContainer.addChild(this.malusClip);
            this.malusClip.alpha = 0;
            this.malusClip.doubleClickEnabled = true;
            this.malusClip.y = this.shipPattern.getLabelYOffset() * -1.5;
            ScreenManager.fadeInClip(0.25,this.malusClip);
         }
      }
      
      public function removeMalusCloudClip() : void
      {
         if(this.malusClip != null && this.clipContainer.contains(this.malusClip))
         {
            ScreenManager.fadeOutClip(0.25,this.malusClip);
         }
      }
      
      public function updateEngine() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(this.engines.length > 0)
         {
            if(this.movingCnt > 0)
            {
               this.shipContainer.y = 0;
               if(this.expansionContainer != null)
               {
                  this.expansionContainer.y = 0;
               }
               if(this.glowContainer != null)
               {
                  this.glowContainer.y = 0;
               }
               if(this.engineFrame > -1)
               {
                  --this.engineFrame;
                  if(this.userID == Hero.userID && this.engineChannel == null)
                  {
                     _loc1_ = this.enginePattern.getSoundID();
                     if(_loc1_ != -1)
                     {
                        this.engineChannel = AudioManager.playSoundEffect(_loc1_,true,true);
                     }
                  }
                  if(this.engineFrame < 16)
                  {
                     if(this.engineTimer != null && !this.engineTimer.running)
                     {
                        this.engineTimer.start();
                     }
                  }
               }
            }
            else
            {
               if(Settings.qualityShip == Settings.QUALITY_HIGH)
               {
                  this.whip();
               }
               if(this.engineFrame < 17)
               {
                  ++this.engineFrame;
                  if(this.userID == Hero.userID && this.engineChannel != null)
                  {
                     _loc1_ = this.enginePattern.getSoundID();
                     if(_loc1_ != -1)
                     {
                        AudioManager.removeLoop(this.engineChannel,true);
                        this.engineChannel = null;
                     }
                  }
                  if(this.engineFrame > 14)
                  {
                     if(this.engineTimer != null && this.engineTimer.running)
                     {
                        this.engineTimer.stop();
                     }
                  }
               }
            }
            for each(_loc2_ in this.engines)
            {
               if(this.isDebuffed)
               {
                  _loc3_ = Math.round(2 * (_loc2_.framesLoaded / 3));
                  if(this.engineFrame <= _loc3_)
                  {
                     this.engineFrame = _loc3_;
                  }
               }
               _loc2_.gotoAndStop(this.engineFrame);
            }
         }
         if(this.movingCnt > 0)
         {
            --this.movingCnt;
            if(this.movingCnt == 0)
            {
               this.handleIsStopping();
            }
         }
      }
      
      public function getBeacon() : Beacon
      {
         return this.beacon;
      }
      
      public function whip() : void
      {
         var _loc1_:int = 0;
         this.shipContainer.y += 0.15 * Math.cos(this.whipCounter * 0.1);
         if(this.expansionContainer != null)
         {
            this.expansionContainer.y = this.shipContainer.y;
         }
         if(this.glowContainer != null)
         {
            this.glowContainer.y = this.shipContainer.y;
         }
         this.whipCounter += 0.5;
         if(this.whipCounter > 10000)
         {
            this.whipCounter = 0;
            this.shipContainer.y = 0;
            if(this.expansionContainer != null)
            {
               this.expansionContainer.y = 0;
            }
            if(this.glowContainer != null)
            {
               this.glowContainer.y = 0;
            }
         }
         if(!this.shipPattern.playLoop && this.userID != Hero.userID)
         {
            if(int(this.whipCounter) % this.shipPattern.getSeekInterval() == 0)
            {
               if(!this.map.getCombatManager().isShipAttacking(this.userID))
               {
                  _loc1_ = Main.getRandomCount(0,360);
                  if(this.oldSeekRotation - _loc1_ > 20)
                  {
                     TweenMax.to(this,0.25,{"shortRotation":{"shipRotation":_loc1_}});
                  }
                  this.oldSeekRotation = _loc1_;
               }
            }
         }
      }
      
      public function getAttackerID() : int
      {
         return this.attackerID;
      }
      
      public function getDroneDisplayClipContainer() : Sprite
      {
         return this.droneDisplayClipContainer;
      }
      
      public function getExpansionPattern() : ExpansionPattern
      {
         return this.expansionPattern;
      }
      
      public function setCCPositionToRealPosition() : void
      {
         this.clipContainer.x = this.heroProxy.x;
         this.clipContainer.y = this.heroProxy.y;
      }
      
      public function setCCPositionToFakePosition() : void
      {
         this.heroProxy.x = this.clipContainer.x;
         this.heroProxy.y = this.clipContainer.y;
         this.clipContainer.x = ScreenManager.getHalfScreenWidth();
         this.clipContainer.y = ScreenManager.getHalfScreenHeight();
      }
      
      public function set x(param1:Number) : void
      {
         if(param1 == this.x)
         {
            return;
         }
         if(this.movingCnt < this.maxMovingCnt)
         {
            ++this.movingCnt;
         }
         if(this.heroProxy != null && ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            this.heroProxy.x = param1;
         }
         else
         {
            this.clipContainer.x = param1;
         }
      }
      
      public function set y(param1:Number) : void
      {
         if(param1 == this.y)
         {
            return;
         }
         if(this.movingCnt == 0)
         {
            this.handleIsStarting();
         }
         if(this.movingCnt < this.maxMovingCnt)
         {
            ++this.movingCnt;
         }
         if(this.heroProxy != null && ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            this.heroProxy.y = param1;
         }
         else
         {
            this.clipContainer.y = param1;
         }
      }
      
      public function get x() : Number
      {
         if(this.heroProxy != null && ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            return this.heroProxy.x;
         }
         return this.clipContainer.x;
      }
      
      public function get y() : Number
      {
         if(this.heroProxy != null && ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            return this.heroProxy.y;
         }
         return this.clipContainer.y;
      }
      
      public function showShield(param1:int) : void
      {
         AudioManager.playSoundEffect(37);
         var _loc2_:MovieClip = ResourceManager.getMovieClip("shield" + param1,"mc");
         var _loc3_:BitmapClip = new BitmapClip(_loc2_,"shield" + param1);
         this.updateShieldSize(_loc3_);
         _loc3_.x = -_loc3_.width * 0.5;
         _loc3_.y = -_loc3_.height * 0.5;
         _loc3_.alpha = 0;
         this.clipContainer.addChild(_loc3_);
         ScreenManager.playAnimation(_loc3_,15,true);
         TweenLite.to(_loc3_,0.25,{
            "alpha":1,
            "onComplete":this.handleShield,
            "onCompleteParams":[this.clipContainer,_loc3_]
         });
      }
      
      private function updateShieldSize(param1:BitmapClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(param1 != null && this.shipContainer.numChildren > 0)
         {
            _loc2_ = MovieClip(this.shipContainer.getChildAt(0));
            _loc3_ = _loc2_.width / 2;
            if(_loc2_.height > _loc2_.width)
            {
               _loc3_ = _loc2_.height / 2;
            }
            _loc4_ = _loc3_ / 65;
            param1.scaleX = _loc4_;
            param1.scaleY = _loc4_;
         }
      }
      
      private function handleShield(param1:Sprite, param2:DisplayObject) : void
      {
         TweenMax.delayedCall(1,this.handleFadeOutShield,[param1,param2]);
      }
      
      private function handleFadeOutShield(param1:Sprite, param2:DisplayObject) : void
      {
         TweenLite.to(param2,0.25,{
            "alpha":0,
            "onComplete":this.handleRemoveShieldClip,
            "onCompleteParams":[param1,param2]
         });
      }
      
      private function handleRemoveShieldClip(param1:Sprite, param2:DisplayObject) : void
      {
         if(param1.contains(param2))
         {
            param1.removeChild(param2);
            TweenLite.killTweensOf(param2,true);
         }
         if(this.shield == 0)
         {
            Hero.showSkinShieldRandomly = false;
         }
         TweenMax.killDelayedCallsTo(this.showShield);
         if(this.isHeroShip() && Hero.showSkinShieldRandomly)
         {
            TweenMax.delayedCall(Main.getRandomCount(Hero.minSkinShieldTwinkle,Hero.maxSkinShieldTwinkle),this.showShield,[0]);
         }
      }
      
      private function handleIsStarting() : void
      {
         this.isMoving = true;
         if(this.isDebuffed)
         {
            this.updateDebuff();
         }
      }
      
      private function handleIsStopping() : void
      {
         this.isMoving = false;
         if(this.isDebuffed)
         {
            this.updateDebuff();
         }
      }
      
      public function updateShieldTwinkle() : void
      {
         TweenMax.killDelayedCallsTo(this.showShield);
         if(Hero.showSkinShieldRandomly)
         {
            this.showShield(0);
         }
      }
      
      public function stopSirenAnimations() : void
      {
         if(this.shipClip != null)
         {
            this.shipClip.light1.stop();
            this.shipClip.light2.stop();
         }
      }
      
      public function get debuffMove() : MovieClip
      {
         return this._debuffMove;
      }
      
      public function set debuffMove(param1:MovieClip) : void
      {
         this._debuffMove = param1;
         if(this._debuffMove != null)
         {
            this._debuffMove.rotation = this._shipRotation - 90;
         }
      }
      
      public function setIdle(param1:Boolean) : void
      {
         this.idleState = param1;
      }
      
      public function get debuffStop() : MovieClip
      {
         return this._debuffStop;
      }
      
      public function set debuffStop(param1:MovieClip) : void
      {
         this._debuffStop = param1;
         if(this._debuffStop != null)
         {
            this._debuffStop.rotation = this._shipRotation - 90;
         }
      }
   }
}


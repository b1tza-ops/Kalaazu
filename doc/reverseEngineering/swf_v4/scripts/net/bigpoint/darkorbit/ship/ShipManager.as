package net.bigpoint.darkorbit.ship
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.EventManager;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.collectable.Beacon;
   import net.bigpoint.darkorbit.collectable.CollectablePattern;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.fireworks.Shockwave;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.lazyload.LazyLoadEvent;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.pet.Pet;
   
   public class ShipManager
   {
      
      private var ships:Array;
      
      private var shipResourceQueue:Array = [];
      
      private var glowResourceQueue:Array = [];
      
      private var expansionResourceQueue:Array = [];
      
      private var map:Map;
      
      public var smID:int;
      
      private var motionTimer:Timer;
      
      private var shipFinishers:Array = [];
      
      private var expansionFinishers:Array = [];
      
      private var rageSound:SoundChannel;
      
      private var _userID:int;
      
      private var loader:AssetLazyLoader;
      
      private var invincibility:MovieClip;
      
      private var invFinisher:SWFFinisher;
      
      private var shieldLoaded:Boolean = false;
      
      public function ShipManager(param1:Map)
      {
         super();
         this.smID = param1.getMapID();
         this.map = param1;
         this.ships = [];
         this.shipResourceQueue = [];
         this.glowResourceQueue = [];
         this.expansionResourceQueue = [];
         this.motionTimer = new Timer(25,0);
         this.motionTimer.addEventListener(TimerEvent.TIMER,this.onMotionTimer);
         this.motionTimer.start();
      }
      
      public function getPet(param1:int) : Pet
      {
         var _loc2_:MapObject = this.ships[int(param1)];
         if(!(_loc2_ is Pet) || _loc2_ == null)
         {
            _loc2_ = null;
         }
         return Pet(_loc2_);
      }
      
      public function getPetByOwnerID(param1:int) : Pet
      {
         var _loc2_:Pet = null;
         var _loc3_:Pet = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.ships.length)
         {
            if(this.ships[_loc4_] is Pet)
            {
               _loc2_ = this.ships[_loc4_] as Pet;
               if(_loc2_ != null && _loc2_.owner == param1)
               {
                  return _loc2_;
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function createPet(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:String, param8:int, param9:int, param10:int, param11:String, param12:int, param13:String = "") : Pet
      {
         if(!this.map.valid)
         {
            return null;
         }
         var _loc14_:Pet = this.getPet(param2);
         if(_loc14_ != null)
         {
            if(_loc14_.shipPattern.getPatternID() == param1)
            {
               return _loc14_ as Pet;
            }
            this.removeOpponentShip(param2,false);
         }
         var _loc15_:ShipPattern = PatternManager.shipPatterns[param1];
         if(_loc15_ == null)
         {
            _loc15_ = PatternManager.shipPatterns[4];
            param7 = "! PET TYPE " + param1 + " NOT DEFINED !";
         }
         var _loc16_:AudibleResourcePattern = PatternManager.enginePatterns[_loc15_.getEngineTypeID()];
         var _loc17_:EngineSmokePattern = PatternManager.engineSmokePatterns[_loc15_.getEngineSmokeID()];
         var _loc18_:ResourcePattern = PatternManager.shipGlowPatterns[_loc15_.getGlowID()];
         var _loc19_:Pet = new Pet(this,param2,param7,param3,param8,this.getMap().getMain().screenManager.getLaserLayer());
         _loc19_.shipPattern = _loc15_;
         _loc19_.owner = param3;
         _loc19_.setEnginePattern(_loc16_);
         _loc19_.setEngineSmokePattern(_loc17_);
         _loc19_.setShipGlowPattern(_loc18_);
         _loc19_.setClanTag(param11);
         _loc19_.setClanID(param10);
         _loc19_.setClanDiplomacy(param12);
         _loc19_.setFactionID(param9);
         _loc19_.setSpeed(param6);
         _loc19_.createContainers();
         this.ships[int(param2)] = _loc19_;
         _loc19_.updateLabel(param13);
         _loc19_.updateShipClip();
         _loc19_.updateExpansionClip();
         _loc19_.setClipPosition(param4,param5);
         if(Settings.qualityEngine == Settings.QUALITY_HIGH)
         {
            _loc19_.startEngineTimer();
         }
         this.map.getMain().screenManager.getPetLayer().addChild(_loc19_.getClipContainer());
         return _loc19_;
      }
      
      public function destroyPet(param1:int) : void
      {
         this.removeOpponentShip(param1);
         var _loc2_:Pet = this.getHero().pet;
         if(_loc2_ != null && param1 == _loc2_.userID)
         {
            this.getHero().pet = null;
         }
      }
      
      private function onMotionTimer(param1:TimerEvent = null) : void
      {
         var _loc2_:MapObject = null;
         for each(_loc2_ in this.ships)
         {
            if(_loc2_.shipPattern.enginePositionClassID != -1)
            {
               _loc2_.updateEngine();
            }
         }
      }
      
      public function attachBeaconToShip(param1:int, param2:int) : void
      {
         var _loc3_:MapObject = this.getShip(param1);
         var _loc4_:CollectablePattern = PatternManager.getCollectablePattern(CollectablePattern.TYPE_BEACON,param2);
         var _loc5_:Beacon = new Beacon(param2,_loc4_,"-",0,0);
         var _loc6_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc4_.getResKey()));
         var _loc7_:MovieClip = MovieClip(_loc6_.getEmbededMovieClip("mc"));
         _loc7_.y = -30;
         ScreenManager.playAnimation(_loc7_,30,true);
         _loc5_.clip = _loc7_;
         _loc3_.attachBeaconClip(_loc5_);
      }
      
      public function removeBeaconFromShip(param1:int) : void
      {
         var _loc2_:MapObject = this.getShip(param1);
         if(_loc2_ != null)
         {
            _loc2_.removeBeaconClip();
         }
      }
      
      public function setDisplayDamageBar(param1:Boolean) : void
      {
         var _loc2_:MapObject = null;
         for each(_loc2_ in this.ships)
         {
            _loc2_.setDamageBarVisibility(param1);
         }
      }
      
      public function getHero() : Ship
      {
         return this.ships[Hero.userID] as Ship;
      }
      
      public function removeTweens(param1:int) : void
      {
         var _loc2_:MapObject = this.getShip(param1);
         if(_loc2_ != null)
         {
            TweenMax.killTweensOf(_loc2_.getClipContainer());
         }
      }
      
      public function getShips() : Array
      {
         return this.ships;
      }
      
      public function updateLabels() : void
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            _loc1_.updateLabel();
         }
      }
      
      public function updateLabelVisibility() : void
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            _loc1_.updateLabelVisibility();
         }
      }
      
      public function removeHeroShip() : void
      {
         this.removeTweens(Hero.userID);
         this.map.getMain().setScheduledDisconnect(true);
         this.map.getMain().getGuiManager().stopWarningTimer();
         var _loc1_:MapObject = this.getShip(Hero.userID);
         _loc1_.cleanup();
         this.map.getCombatManager().removeLaserAttack(Hero.userID);
         this.map.getCombatManager().removeLaserAttackTo(Hero.userID);
         this.map.getCombatManager().removeRocketAttackTo(Hero.userID);
         if(ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            this.map.getMain().screenManager.getHeroLayer().removeChild(_loc1_.getClipContainer());
         }
         else
         {
            this.map.getMain().screenManager.getShipLayer().removeChild(_loc1_.getClipContainer());
         }
         this.map.getMain().getGuiManager().showRadiationWarning(false);
         this.map.getMain().screenManager.hero = null;
      }
      
      public function destroyHero() : void
      {
         this.map.getMain().getGuiManager().createEndSequence();
      }
      
      public function removeOpponentShip(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:ShipPattern = null;
         var _loc4_:ExplosionPattern = null;
         var _loc5_:MapObject = null;
         var _loc7_:EventManager = null;
         var _loc8_:Shockwave = null;
         this.removeTweens(param1);
         var _loc6_:MapObject = this.ships[param1];
         if(_loc6_ != null)
         {
            if(_loc6_.numberChainsInvolvedIn > 0)
            {
               _loc6_.isDestroyed = true;
               _loc6_.displaysExplosion = _loc6_.displaysExplosion || param2;
               return;
            }
            _loc7_ = this.map.getEventManager();
            if(_loc7_.heroLockToTarget == _loc6_)
            {
               _loc7_.heroLockToTarget = null;
            }
            _loc3_ = _loc6_.shipPattern;
            this.map.getMain().getGuiManager().getMenuManager().checkLaserToggleButton(_loc6_);
            _loc6_.setSelected(false);
            _loc6_.cleanup();
            this.map.getCombatManager().removeLaserAttack(_loc6_.getUserId());
            this.map.getCombatManager().removeLaserAttackTo(_loc6_.getUserId());
            this.map.getCombatManager().removeRocketAttackTo(_loc6_.getUserId());
            if(_loc6_ is Pet)
            {
               this.map.getMain().screenManager.getPetLayer().removeChild(_loc6_.getClipContainer());
            }
            else
            {
               this.map.getMain().screenManager.getShipLayer().removeChild(_loc6_.getClipContainer());
            }
            delete this.ships[param1];
            if(param2 && Settings.qualityExplosion >= Settings.QUALITY_MEDIUM)
            {
               _loc4_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,_loc6_.explodeTypeID);
               this.map.getCombatManager().showPyroEffect(_loc6_.x,_loc6_.y,_loc4_,37,true);
               if(_loc4_.displayShockwave)
               {
                  this.map.getMain().screenManager.flashScreen(16777215,0.75,0.25,2);
                  _loc8_ = new Shockwave(this.map,_loc6_.shipPattern.shockwaveID);
                  AudioManager.playSoundEffect(18,false,false,_loc6_.x,_loc6_.y);
                  _loc8_.impact(_loc6_.x,_loc6_.y);
                  if(_loc8_.shakeScreen)
                  {
                     this.map.getMain().screenManager.shakeScreen();
                  }
               }
            }
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            _loc1_.cleanup();
            if(_loc1_.getUserId() == Hero.userID && ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
            {
               this.map.getMain().screenManager.getHeroLayer().removeChild(_loc1_.getClipContainer());
            }
            else if(this.map.getMain().screenManager.getShipLayer().contains(_loc1_.getClipContainer()))
            {
               this.map.getMain().screenManager.getShipLayer().removeChild(_loc1_.getClipContainer());
            }
            else if(this.map.getMain().screenManager.getPetLayer().contains(_loc1_.getClipContainer()))
            {
               this.map.getMain().screenManager.getPetLayer().removeChild(_loc1_.getClipContainer());
            }
         }
         this.motionTimer.stop();
         this.motionTimer.removeEventListener(TimerEvent.TIMER,this.onMotionTimer);
         this.ships = [];
         this.shipResourceQueue = [];
         this.glowResourceQueue = [];
         this.expansionResourceQueue = [];
         this.map = null;
      }
      
      public function hitTest(param1:int, param2:int) : MapObject
      {
         var _loc3_:MapObject = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         for each(_loc3_ in this.ships)
         {
            if(_loc3_.getUserId() != Hero.userID)
            {
               _loc4_ = _loc3_.shipPattern.getClickRadius();
               _loc4_ *= _loc4_;
               _loc5_ = _loc3_.shipPattern.getClickOffsetX();
               _loc6_ = _loc3_.shipPattern.getClickOffsetY();
               _loc7_ = Math.pow(_loc3_.y + _loc6_ - param2,2) + Math.pow(_loc3_.x + _loc5_ - param1,2);
               if(_loc7_ < _loc4_)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function mouseOverTest(param1:int, param2:int) : Boolean
      {
         var _loc4_:MapObject = null;
         var _loc3_:int = 50;
         for each(_loc4_ in this.ships)
         {
            if(_loc4_.getUserId() != Hero.userID)
            {
               if(_loc4_.x - _loc3_ < param1 && param1 < _loc4_.x + _loc3_ && _loc4_.y - _loc3_ < param2 && param2 < _loc4_.y + _loc3_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function createShip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String, param7:String, param8:int, param9:int, param10:int, param11:int, param12:int, param13:Boolean, param14:int, param15:Boolean) : Ship
      {
         var _loc23_:ShipLightDecorator = null;
         if(!this.map.valid)
         {
            return null;
         }
         var _loc16_:MapObject = this.getShip(param2);
         if(_loc16_ != null)
         {
            if(_loc16_.shipPattern.getPatternID() == param1)
            {
               return _loc16_ as Ship;
            }
            if(_loc16_.isHeroShip())
            {
               this.removeHeroShip();
            }
            else
            {
               this.removeOpponentShip(param2,false);
            }
         }
         var _loc17_:ShipPattern = PatternManager.shipPatterns[param1];
         if(_loc17_ == null)
         {
            _loc17_ = PatternManager.shipPatterns[4];
            param6 = "! SHIP TYPE " + param1 + " NOT DEFINED !";
         }
         var _loc18_:AudibleResourcePattern = PatternManager.enginePatterns[_loc17_.getEngineTypeID()];
         var _loc19_:EngineSmokePattern = PatternManager.engineSmokePatterns[_loc17_.getEngineSmokeID()];
         var _loc20_:ResourcePattern = PatternManager.shipGlowPatterns[_loc17_.getGlowID()];
         var _loc21_:Ship = new Ship(this,param2,param6,this.getMap().getMain().screenManager.getLaserLayer());
         _loc21_.explodeTypeID = _loc17_.getExplodeTypeID();
         _loc21_.setShipPattern(_loc17_);
         _loc21_.setEnginePattern(_loc18_);
         _loc21_.setEngineSmokePattern(_loc19_);
         _loc21_.setShipGlowPattern(_loc20_);
         _loc21_.setSpeed(param5);
         _loc21_.setClanTag(param7);
         _loc21_.setClanID(param9);
         _loc21_.setClanDiplomacy(param10);
         _loc21_.setFactionID(param8);
         _loc21_.setDailyRank(param11);
         _loc21_.setWarnIconOnMap(param13);
         _loc21_.createContainers();
         _loc21_.galaxyGatesFinished = param14;
         _loc21_.setNPC(param15);
         if(!param15)
         {
            _loc21_.isGroupMember = this.map.getMain().getGroupManager().isGroupMember(param2);
         }
         this.ships[int(param2)] = _loc21_;
         _loc21_.updateLabel();
         _loc21_.updateShipClip();
         _loc21_.setExpansionTypeID(param12);
         _loc21_.updateExpansionClip();
         _loc21_.setClipPosition(param3,param4);
         if(Settings.qualityEngine == Settings.QUALITY_HIGH)
         {
            _loc21_.startEngineTimer();
         }
         var _loc22_:* = param2 == Hero.userID;
         if(_loc22_)
         {
            this.map.getMain().screenManager.hero = _loc21_;
            if(ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
            {
               this.map.getMain().screenManager.getHeroLayer().addChild(_loc21_.getClipContainer());
            }
            else
            {
               this.map.getMain().screenManager.getShipLayer().addChild(_loc21_.getClipContainer());
            }
         }
         else
         {
            this.map.getMain().screenManager.getShipLayer().addChild(_loc21_.getClipContainer());
         }
         if(param1 == 98)
         {
            _loc21_.isPoliceShip = true;
            _loc21_.stopSirenAnimations();
            _loc21_.flashLights();
         }
         else if(param1 == 63)
         {
            _loc23_ = new ShipLightDecorator(_loc21_);
            _loc21_.shipLightDecorator = _loc23_;
            _loc21_.updateStandardVisualShipRotation = _loc23_.updateGraphicRotation;
            _loc21_.updateStandardVisualShipRotation();
         }
         return _loc21_;
      }
      
      public function loadExpansionResource(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.expansionResourceQueue.length)
         {
            if(this.expansionResourceQueue[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.expansionResourceQueue.push(param1);
         ResourceManager.fileCollection.load(param1,this.handleExpansionResourceLoaded);
      }
      
      public function lazyLoadExpansionResource(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.expansionResourceQueue.length)
         {
            if(this.expansionResourceQueue[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.expansionResourceQueue.push(param1);
         var _loc3_:AssetLazyLoader = new AssetLazyLoader();
         if(!ResourceManager.fileCollection.isLoaded(param1))
         {
            _loc3_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handleExpansionResourceLoaded);
            _loc3_.loadAsset(param1);
         }
         else
         {
            this.handleExpansionResourceLoaded(null);
         }
      }
      
      private function handleExpansionResourceLoaded(param1:LazyLoadEvent) : void
      {
         var _loc3_:SWFFinisher = null;
         var _loc4_:MapObject = null;
         var _loc5_:ShipPattern = null;
         var _loc6_:ExpansionPattern = null;
         var _loc7_:MovieClip = null;
         var _loc2_:String = param1.resKey;
         for each(_loc4_ in this.ships)
         {
            if(_loc4_.expansionTypeID > 0)
            {
               _loc5_ = _loc4_.shipPattern;
               if(_loc5_.hasExpansion())
               {
                  _loc6_ = PatternManager.getExpansionPattern(_loc5_.getExpansionClassID(),_loc4_.getExpansionTypeID());
                  if(_loc6_.getResKey() == _loc2_)
                  {
                     _loc3_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc2_));
                     if(_loc3_ != null)
                     {
                        this.expansionFinishers.push(_loc3_);
                        if(Settings.unloadResources && _loc6_.isUnload())
                        {
                           this.map.addFinisherToList(_loc3_);
                        }
                        _loc7_ = MovieClip(_loc3_.getEmbededMovieClip("mc"));
                        _loc4_.setExpansionClip(_loc7_);
                     }
                  }
               }
            }
         }
      }
      
      public function loadShipResource(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.shipResourceQueue.length)
         {
            if(this.shipResourceQueue[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.shipResourceQueue.push(param1);
         ResourceManager.fileCollection.load(param1,this.handleShipResourceLoaded);
      }
      
      public function loadGlowResource(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.glowResourceQueue.length)
         {
            if(this.glowResourceQueue[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.glowResourceQueue.push(param1);
         ResourceManager.fileCollection.load(param1,this.handleGlowResourceLoaded);
      }
      
      private function handleShipResourceLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:MapObject = null;
         var _loc4_:ShipPattern = null;
         var _loc5_:MovieClip = null;
         var _loc2_:String = param1.fileVO.id;
         for each(_loc3_ in this.ships)
         {
            _loc4_ = _loc3_.shipPattern;
            if(_loc4_.getResKey() == _loc2_)
            {
               this.shipFinishers.push(param1);
               if(Settings.unloadResources && _loc4_.isUnload())
               {
                  this.map.addFinisherToList(param1);
               }
               _loc5_ = MovieClip(param1.getEmbededMovieClip("mc"));
               _loc5_.mouseEnabled = false;
               _loc5_.mouseChildren = false;
               _loc5_.gotoAndStop(1);
               _loc3_.setShipClip(_loc5_);
               this.setLabelHitpointPositions(_loc3_,_loc5_);
            }
         }
      }
      
      private function handleGlowResourceLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:MapObject = null;
         var _loc4_:ResourcePattern = null;
         var _loc5_:MovieClip = null;
         var _loc2_:String = param1.fileVO.id;
         for each(_loc3_ in this.ships)
         {
            if(_loc3_ != null && _loc3_.shipPattern.getGlowID() != -1)
            {
               _loc4_ = _loc3_.getGlowPattern();
               if(_loc4_.getResKey() == _loc2_)
               {
                  param1 = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc2_));
                  if(Settings.unloadResources)
                  {
                     this.map.addFinisherToList(param1);
                  }
                  _loc5_ = MovieClip(param1.getEmbededMovieClip("mc"));
                  _loc3_.setGlowClip(_loc5_);
               }
            }
         }
      }
      
      private function setLabelHitpointPositions(param1:MapObject, param2:MovieClip) : void
      {
         var _loc3_:ShipPattern = param1.shipPattern;
         param1.setLabelYOffset(_loc3_.getLabelYOffset());
         if(_loc3_.getEnergyYOffset() != 0)
         {
            param1.setHitpointsYOffset(-param2.height / 2 - _loc3_.getEnergyYOffset());
         }
         else
         {
            param1.setHitpointsYOffset(-param2.height / 2);
         }
      }
      
      public function focusHeroToCoordinates(param1:int, param2:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc3_:MapObject = this.getShip(Hero.userID);
         if(_loc3_ != null && !_loc3_.shipPattern.playLoop)
         {
            if(this.map.getCombatManager().isShipAttacking(_loc3_.getUserId()) != null)
            {
               return;
            }
            _loc4_ = Math.atan2(param2 - _loc3_.y,param1 - _loc3_.x) * 180 / Math.PI;
            _loc5_ = Math.round(_loc4_ + 180);
            TweenMax.to(_loc3_,0.25,{"shortRotation":{"shipRotation":_loc5_}});
         }
      }
      
      public function moveShip(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc5_:MapObject = this.getShip(param1);
         var _loc6_:Boolean = false;
         if(this.map.getShipManager().getPet(param1) != null)
         {
            _loc6_ = this.map.getShipManager().getPet(param1).hasEvasionProtocol();
         }
         if(_loc5_ == null)
         {
            this.map.getMain().getConnectionManager().sendCommand(ServerCommands.REQUEST_SHIP,[param1]);
            return;
         }
         _loc5_.currentlyMoving = true;
         var _loc7_:ShipPattern = _loc5_.shipPattern;
         if(!_loc6_)
         {
            TweenLite.to(_loc5_,param4 / 1000,{
               "ease":Linear.easeNone,
               "x":param2,
               "y":param3,
               "onComplete":this.handleMapObjectStoppedMoving,
               "onCompleteParams":[_loc5_]
            });
         }
         else
         {
            _loc10_ = 150;
            _loc11_ = (Math.random() - 0.5) * _loc10_ + param2;
            _loc12_ = (Math.random() - 0.5) * _loc10_ + param3;
            TweenLite.to(_loc5_,param4 / 2000,{
               "ease":Linear.easeNone,
               "x":_loc11_,
               "y":_loc12_,
               "onComplete":this.moveShip,
               "onCompleteParams":[param1,param2,param3,param4]
            });
         }
         var _loc8_:Number = Math.atan2(param3 - _loc5_.y,param2 - _loc5_.x) * 180 / Math.PI;
         var _loc9_:int = Math.round(_loc8_ + 180);
         _loc5_.movementDirection = _loc9_;
         if(!_loc7_.playLoop && this.map.getCombatManager().isShipAttacking(_loc5_.getUserId()) == null)
         {
            if(param3 != _loc5_.y && param2 != _loc5_.x)
            {
               TweenLite.to(_loc5_,0.25,{"shortRotation":{"shipRotation":_loc9_}});
            }
         }
      }
      
      private function handleMapObjectStoppedMoving(param1:MapObject) : void
      {
         if(param1 != null)
         {
            param1.currentlyMoving = false;
         }
      }
      
      public function selectSpaceball(param1:int) : MapObject
      {
         var _loc2_:MapObject = this.getShip(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:MapObject = this.getSelectedShip();
         if(_loc3_ != null)
         {
            _loc3_.setSelected(false);
            if(this.map.getCombatManager().isShipAttackedByHero(_loc3_.getUserId()))
            {
               this.map.getEventManager().abortLaserAttack(_loc3_.getUserId());
            }
         }
         _loc2_.setSelected(true);
         return _loc2_;
      }
      
      public function selectShip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Boolean) : MapObject
      {
         var _loc7_:MapObject = this.getSelectedShip();
         if(_loc7_ != null)
         {
            if(_loc7_.getUserId() != param1)
            {
               _loc7_.setSelected(false);
               if(this.map.getCombatManager().isShipAttackedByHero(_loc7_.getUserId()))
               {
                  this.map.getEventManager().abortLaserAttack(_loc7_.getUserId());
                  this.map.getMain().getGuiManager().writeToLog(BPLocale.getText("attstop").replace(/%!/,_loc7_.getUsername()));
               }
            }
         }
         var _loc8_:MapObject = this.getShip(param1);
         _loc8_.setSelected(true);
         _loc8_.setHitpoints(param2);
         _loc8_.setMaxHitpoints(param3);
         _loc8_.setShieldChunk(param4,param5);
         return _loc8_;
      }
      
      public function deselectSelectedShip() : void
      {
         var _loc1_:MapObject = this.getSelectedShip();
         if(_loc1_ != null)
         {
            _loc1_.setSelected(false);
            if(this.map.getCombatManager().isShipAttackedByHero(_loc1_.getUserId()))
            {
               this.map.getEventManager().abortLaserAttack(_loc1_.getUserId());
               this.map.getMain().getGuiManager().writeToLog(BPLocale.getText("attstop").replace(/%!/,_loc1_.getUsername()));
            }
         }
      }
      
      public function getShip(param1:int) : MapObject
      {
         return this.ships[int(param1)];
      }
      
      public function getSelectedShip() : MapObject
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            if(_loc1_.isSelected())
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function setAttackedShip() : MapObject
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            if(_loc1_ != null && _loc1_.isSelected())
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getMap() : Map
      {
         return this.map;
      }
      
      public function updateHeroCargo() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:OrePattern = null;
         var _loc1_:MapObject = this.map.getShipManager().getHero();
         if(_loc1_ != null)
         {
            _loc2_ = 0;
            _loc3_ = Hero.getOres([OrePattern.ORE_PROMETIUM,OrePattern.ORE_ENDURIUM,OrePattern.ORE_TERBIUM,OrePattern.ORE_PROMETID,OrePattern.ORE_DURANIUM,OrePattern.ORE_PROMERIUM,OrePattern.ORE_SEPROM,OrePattern.ORE_PALLADIUM]);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc2_ += _loc5_.count;
               _loc4_++;
            }
            _loc1_.setCargo(_loc2_);
         }
      }
      
      public function updateShipVisualStyle() : void
      {
         var _loc1_:MapObject = null;
         var _loc2_:SWFFinisher = null;
         var _loc3_:SWFFinisher = null;
         if(Settings.qualityShip == Settings.QUALITY_LOW)
         {
            for each(_loc2_ in this.shipFinishers)
            {
               this.shipResourceQueue = [];
               _loc2_.clear();
            }
            for each(_loc3_ in this.expansionFinishers)
            {
               this.expansionResourceQueue = [];
               _loc3_.clear();
            }
         }
         for each(_loc1_ in this.ships)
         {
            _loc1_.updateShipClip();
         }
      }
      
      public function updateEngineSmokeTimers() : void
      {
         var _loc1_:MapObject = null;
         for each(_loc1_ in this.ships)
         {
            if(Settings.qualityEngine == Settings.QUALITY_HIGH)
            {
               _loc1_.startEngineTimer();
            }
            else
            {
               _loc1_.stopEngineTimer();
            }
         }
      }
   }
}


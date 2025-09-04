package net.bigpoint.darkorbit
{
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.AmmoPrice;
   import net.bigpoint.LastTargetInfo;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.catalog.SpecialAmmunition;
   import net.bigpoint.darkorbit.collectable.Collectable;
   import net.bigpoint.darkorbit.collectable.CollectablePattern;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.map.MiniMap;
   import net.bigpoint.darkorbit.menu.ActionButton;
   import net.bigpoint.darkorbit.menu.ActionButton2;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.station.RelayStation;
   
   public class EventManager
   {
      
      private static const COLLECTABLE_Y_OFFSET:Number = 120;
      
      private var moveTimer:Timer;
      
      private var lastTarget:LastTargetInfo;
      
      private var controlsLocked:Boolean;
      
      private var map:Map;
      
      private var rotateTimer:Timer;
      
      private var mouseOverTimer:Timer;
      
      public var halfScreenWidth:int;
      
      public var halfScreenHeight:int;
      
      private var keyDown:Array = [];
      
      private var _lockedShip:MapObject;
      
      private var lastClick:Point;
      
      private var lastDblc:uint = 0;
      
      public var serverFunctionDict:Dictionary = new Dictionary();
      
      public var idleState:Boolean = false;
      
      public function EventManager(param1:Map)
      {
         super();
         this.map = param1;
         this.halfScreenWidth = ScreenManager.centerX;
         this.halfScreenHeight = ScreenManager.centerY;
         this.lastTarget = new LastTargetInfo();
         this.lastClick = new Point();
         this.addEventListeners();
      }
      
      public function addEventListeners() : void
      {
         this.map.getMain().screenManager.getStaticContainer().addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.map.getMain().stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseRelease);
         this.map.getMain().screenManager.getStaticContainer().mouseEnabled = true;
         this.map.getMain().screenManager.getStaticContainer().addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this.map.getMain().screenManager.getStaticContainer().addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.map.getMain().screenManager.getStaticContainer().addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelEvent);
         this.moveTimer = new Timer(370,0);
         this.moveTimer.addEventListener(TimerEvent.TIMER,this.onMoveTimer);
         this.rotateTimer = new Timer(25,0);
         this.rotateTimer.addEventListener(TimerEvent.TIMER,this.onRotateTimer);
         this.rotateTimer.start();
         this.mouseOverTimer = new Timer(100,0);
         this.mouseOverTimer.addEventListener(TimerEvent.TIMER,this.onMouseOverTimer);
         this.mouseOverTimer.start();
      }
      
      private function handleDoubleClick(param1:MouseEvent) : void
      {
      }
      
      public function removeKeyListener() : void
      {
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      public function cleanup() : void
      {
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.map.getMain().stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseRelease);
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClick);
         this.map.getMain().screenManager.getStaticContainer().doubleClickEnabled = false;
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.map.getMain().screenManager.getStaticContainer().removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelEvent);
         this.moveTimer.stop();
         this.moveTimer.removeEventListener(TimerEvent.TIMER,this.onMoveTimer);
         this.mouseOverTimer.stop();
         this.mouseOverTimer.removeEventListener(TimerEvent.TIMER,this.onMouseOverTimer);
         this.rotateTimer.stop();
         this.rotateTimer.removeEventListener(TimerEvent.TIMER,this.onRotateTimer);
      }
      
      private function onMouseWheelEvent(param1:MouseEvent) : void
      {
         this.map.getDroneManager().setDroneRadius(param1.delta * 10);
      }
      
      private function onMoveTimer(param1:TimerEvent) : void
      {
         if(this.controlsLocked)
         {
            return;
         }
         var _loc2_:Number = this.map.getMain().screenManager.getStaticContainer().mouseX;
         var _loc3_:Number = this.map.getMain().screenManager.getStaticContainer().mouseY;
         var _loc4_:Number = _loc2_ - this.halfScreenWidth + this.map.getShipManager().getHero().x;
         var _loc5_:Number = _loc3_ - this.halfScreenHeight + this.map.getShipManager().getHero().y;
         var _loc6_:Point = this.map.poiManager.checkPOIZoneCollisions(new Point(this.map.getShipManager().getHero().x,this.map.getShipManager().getHero().y),new Point(_loc4_,_loc5_));
         if(this.isMouseInMoveableArea())
         {
            if(_loc6_ != null)
            {
               this.moveHeroToCordinates(_loc6_.x,_loc6_.y);
            }
            else
            {
               this.moveShip(_loc2_,_loc3_);
            }
         }
      }
      
      private function isMouseInMoveableArea() : Boolean
      {
         var _loc1_:Number = this.map.getMain().screenManager.getStaticContainer().mouseX;
         var _loc2_:Number = this.map.getMain().screenManager.getStaticContainer().mouseY;
         var _loc3_:Ship = this.map.getShipManager().getHero();
         var _loc4_:Number = Math.pow(_loc2_ - this.halfScreenHeight,2) + Math.pow(_loc1_ - this.halfScreenWidth,2);
         if(_loc4_ < _loc3_.shipPattern.moveRadiusSquared)
         {
            return false;
         }
         return true;
      }
      
      private function onRotateTimer(param1:TimerEvent) : void
      {
         var _loc2_:Ship = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(this._lockedShip != null)
         {
            _loc2_ = this.map.getShipManager().getHero();
            if(_loc2_ != null)
            {
               _loc3_ = Math.atan2(this._lockedShip.y - _loc2_.y,this._lockedShip.x - _loc2_.x) * 180 / Math.PI;
               _loc4_ = Math.round(_loc3_ + 180);
               TweenMax.to(_loc2_,0.25,{"shortRotation":{"shipRotation":_loc4_}});
            }
         }
         else
         {
            this.rotateHero();
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Ship = null;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MapObject = null;
         var _loc7_:RelayStation = null;
         var _loc8_:Date = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:MapObject = null;
         var _loc12_:RelayStation = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Collectable = null;
         var _loc16_:Point = null;
         var _loc17_:MiniMap = null;
         if(this.idleState)
         {
            return;
         }
         if(Settings.doubleclickAttackEnabled)
         {
            _loc8_ = new Date();
            _loc9_ = uint(_loc8_.getTime());
            if(this.lastDblc > 0)
            {
               _loc10_ = uint(_loc9_ - this.lastDblc);
               if(_loc10_ < 500)
               {
                  _loc11_ = this.map.getShipManager().getSelectedShip();
                  if(_loc11_ != null)
                  {
                     _loc2_ = this.map.getShipManager().getHero();
                     _loc3_ = this.map.getMain().screenManager.getStaticContainer();
                     _loc4_ = _loc3_.mouseX - this.halfScreenWidth + _loc2_.x;
                     _loc5_ = _loc3_.mouseY - this.halfScreenHeight + _loc2_.y;
                     _loc6_ = this.map.getShipManager().hitTest(_loc4_,_loc5_);
                     if(_loc6_ != null)
                     {
                        this.toggleLaserAttack(ActionButton.ENV_KEYBOARD);
                     }
                  }
                  _loc12_ = this.map.getStationManager().getSelectedAsset();
                  if(_loc12_ != null)
                  {
                     _loc2_ = this.map.getShipManager().getHero();
                     _loc3_ = this.map.getMain().screenManager.getStaticContainer();
                     _loc4_ = _loc3_.mouseX - this.halfScreenWidth + _loc2_.x;
                     _loc5_ = _loc3_.mouseY - this.halfScreenHeight + _loc2_.y;
                     _loc7_ = this.map.getStationManager().hitTest(_loc4_,_loc5_);
                     if(_loc7_ != null)
                     {
                        this.map.getMain().getConnectionManager().sendCommand(ServerCommands.LASER_ATTACK,[_loc7_.relayID]);
                     }
                  }
               }
            }
            this.lastDblc = _loc9_;
         }
         _loc3_ = this.map.getMain().screenManager.getStaticContainer();
         this.map.getMain().stage.focus = _loc3_;
         if(this.controlsLocked)
         {
            return;
         }
         if(this.map.getMain().getGuiManager().getGroupUI() != null && this.map.getMain().getGuiManager().getGroupUI().isInPingMode)
         {
            _loc2_ = this.map.getShipManager().getHero();
            _loc13_ = _loc3_.mouseX;
            _loc14_ = _loc3_.mouseY;
            if(_loc2_ != null)
            {
               _loc13_ = _loc13_ - this.halfScreenWidth + _loc2_.x;
               _loc14_ = _loc14_ - this.halfScreenHeight + _loc2_.y;
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_PING,ClientCommands.GROUPSYSTEM_PING_POSITION,_loc13_,_loc14_]);
               this.map.getMain().getGuiManager().getGroupUI().isInPingMode = false;
               return;
            }
         }
         if(!this.isShipSelected())
         {
            _loc2_ = this.map.getShipManager().getHero();
            _loc4_ = _loc3_.mouseX - this.halfScreenWidth + _loc2_.x;
            _loc5_ = _loc3_.mouseY - this.halfScreenHeight + _loc2_.y;
            _loc15_ = this.map.getCollectableManager().hitTest(_loc4_,_loc5_);
            _loc7_ = this.map.getStationManager().hitTest(_loc4_,_loc5_);
            if(_loc7_ != null)
            {
               _loc7_.isSelected = true;
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT_SHIP,[_loc7_.relayID]);
               return;
            }
            if(_loc15_ != null)
            {
               _loc16_ = this.map.poiManager.checkPOIZoneCollisions(new Point(this.map.getShipManager().getHero().x,this.map.getShipManager().getHero().y),new Point(_loc4_,_loc5_));
               if(_loc16_ != null)
               {
                  this.moveHeroToCordinates(_loc16_.x,_loc16_.y);
               }
               else
               {
                  this.moveShipToCollectable(_loc15_);
               }
            }
            else
            {
               if(this.isMouseInMoveableArea())
               {
                  _loc16_ = this.map.poiManager.checkPOIZoneCollisions(new Point(this.map.getShipManager().getHero().x,this.map.getShipManager().getHero().y),new Point(_loc4_,_loc5_));
                  if(_loc16_ != null)
                  {
                     this.moveHeroToCordinates(_loc16_.x,_loc16_.y);
                  }
                  else
                  {
                     this.moveShip(_loc3_.mouseX,_loc3_.mouseY);
                  }
               }
               if(!this.moveTimer.running)
               {
                  this.moveTimer.start();
               }
            }
            _loc17_ = this.map.getMinimapManager().getMiniMap();
            if(_loc17_ != null)
            {
               _loc17_.clearRoute();
            }
         }
      }
      
      private function isShipSelected() : Boolean
      {
         var _loc1_:Ship = this.map.getShipManager().getHero();
         var _loc2_:Sprite = this.map.getMain().screenManager.getStaticContainer();
         var _loc3_:int = _loc2_.mouseX - this.halfScreenWidth + _loc1_.x;
         var _loc4_:int = _loc2_.mouseY - this.halfScreenHeight + _loc1_.y;
         var _loc5_:MapObject = this.map.getShipManager().getSelectedShip();
         var _loc6_:MapObject = this.map.getShipManager().hitTest(_loc3_,_loc4_);
         if(_loc5_ != null && _loc5_ == _loc6_)
         {
            return true;
         }
         if(_loc6_ != null)
         {
            if(this._lockedShip != null && this._lockedShip != _loc6_)
            {
               this._lockedShip = null;
            }
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT_SHIP,[_loc6_.getUserId()]);
            if(_loc6_.shipPattern.isSpaceball())
            {
               this.map.getShipManager().selectSpaceball(_loc6_.getUserId());
            }
            return true;
         }
         return false;
      }
      
      private function handleMouseRelease(param1:MouseEvent) : void
      {
         this.map.getMain().getGuiManager().checkWindows();
         this.map.getMain().getGuiManager().checkAllResizableWindows();
         this.moveTimer.reset();
         this.moveTimer.stop();
      }
      
      public function moveShip(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:Ship = this.map.getShipManager().getHero();
         if(_loc4_ != null)
         {
            if(param3)
            {
               _loc5_ = param1;
               _loc6_ = param2;
            }
            else
            {
               _loc5_ = param1 - this.halfScreenWidth + _loc4_.x;
               _loc6_ = param2 - this.halfScreenHeight + _loc4_.y;
            }
            this.moveHeroToCordinates(_loc5_,_loc6_);
         }
      }
      
      public function moveHeroToCordinates(param1:int, param2:int, param3:Collectable = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc4_:Ship = this.map.getShipManager().getHero();
         if(_loc4_ != null)
         {
            _loc4_.currentlyMoving = true;
            this.lastTarget.x = param1;
            this.lastTarget.y = param2;
            this.lastTarget.valid = true;
            this.map.getMain().getConnectionManager().sendCommand(ServerCommands.SHIP_MOVEMENT,[param1,param2,int(_loc4_.x),int(_loc4_.y)]);
            _loc5_ = _loc4_.getSpeed();
            _loc6_ = Math.sqrt(Math.pow(param2 - _loc4_.y,2) + Math.pow(param1 - _loc4_.x,2));
            _loc7_ = _loc6_ / _loc5_;
            _loc8_ = Math.atan2(param2 - _loc4_.y,param1 - _loc4_.x) * 180 / Math.PI;
            _loc9_ = Math.round(_loc8_ + 180);
            _loc4_.movementDirection = _loc9_;
            if(_loc4_.isDebuffed)
            {
               _loc4_.updateDebuffRotation(MapObject.ROTATION_MOVEMENT,true);
            }
            if(param3)
            {
               TweenMax.to(_loc4_,_loc7_,{
                  "ease":Linear.easeNone,
                  "x":param1,
                  "y":param2,
                  "onComplete":this.handleCollectInit,
                  "onCompleteParams":[param3]
               });
            }
            else
            {
               TweenMax.to(_loc4_,_loc7_,{
                  "ease":Linear.easeNone,
                  "x":param1,
                  "y":param2,
                  "onComplete":this.handleHeroStoppedMoving,
                  "onCompleteParams":[_loc4_]
               });
            }
            this.lastClick.x = param1;
            this.lastClick.y = param2;
         }
      }
      
      private function handleHeroStoppedMoving(param1:MapObject) : void
      {
         if(param1 != null)
         {
            param1.currentlyMoving = false;
         }
      }
      
      public function updateShipMovement() : void
      {
         var _loc1_:Ship = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.lastClick.x != 0 && this.lastClick.y != 0)
         {
            _loc1_ = this.map.getShipManager().getHero();
            _loc2_ = _loc1_.getSpeed();
            _loc3_ = Math.sqrt(Math.pow(this.lastClick.y - _loc1_.y,2) + Math.pow(this.lastClick.x - _loc1_.x,2));
            _loc4_ = _loc3_ / _loc2_;
            TweenMax.to(_loc1_,_loc4_,{
               "ease":Linear.easeNone,
               "x":this.lastClick.x,
               "y":this.lastClick.y
            });
         }
      }
      
      private function moveShipToCollectable(param1:Collectable) : void
      {
         this.moveHeroToCordinates(param1.getPosX(),param1.getPosY() - COLLECTABLE_Y_OFFSET,param1);
      }
      
      private function handleCollectInit(param1:Collectable) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:CollectablePattern = null;
         var _loc6_:int = 0;
         var _loc2_:Ship = this.map.getShipManager().getHero();
         _loc2_.currentlyMoving = false;
         if(_loc2_.x == this.lastTarget.x && _loc2_.y == this.lastTarget.y)
         {
            this.map.getCollectableManager().setLastSelectedHash(param1.getHash());
            if(param1.collectableClass == CollectablePattern.TYPE_ORE)
            {
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.COLLECT_ORE,[param1.getHash()]);
               _loc3_ = "beam0";
               _loc4_ = true;
            }
            else if(param1.collectableClass == CollectablePattern.TYPE_BOX || param1.collectableClass == CollectablePattern.TYPE_BEACON)
            {
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.COLLECT_BOX,[param1.getHash()]);
               _loc3_ = "beam1";
               _loc4_ = true;
            }
         }
         if(_loc4_)
         {
            _loc5_ = PatternManager.getCollectablePattern(param1.collectableClass,param1.getTypeID());
            if(!_loc5_.isHarvestable)
            {
               this.map.getCollectableManager().showBeam(param1.getPosX(),param1.getPosY(),_loc5_.getDuration(),_loc3_);
               _loc6_ = _loc5_.getSoundID();
               if(_loc6_ != -1)
               {
                  AudioManager.playSoundEffect(_loc6_,false,false,param1.clip.x,param1.clip.y);
               }
            }
         }
      }
      
      public function lockControls() : void
      {
         this.controlsLocked = true;
      }
      
      public function unlockControls() : void
      {
         this.controlsLocked = false;
      }
      
      private function rotateHero() : void
      {
         if(this.lastTarget.valid)
         {
            this.map.getShipManager().focusHeroToCoordinates(this.lastTarget.x,this.lastTarget.y);
            this.lastTarget.valid = false;
         }
      }
      
      public function quickBuy(param1:String, param2:int) : void
      {
         var _loc4_:AmmoPrice = null;
         var _loc3_:int = -1;
         if(param1 == ServerCommands.BUY_LASER)
         {
            _loc4_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,param2);
            if(_loc4_ != null)
            {
               _loc3_ = _loc4_.amount;
            }
         }
         else if(param1 == ServerCommands.BUY_ROCKET)
         {
            _loc4_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,param2);
            if(_loc4_ != null)
            {
               _loc3_ = _loc4_.amount;
            }
         }
         if(_loc3_ != -1)
         {
            this.map.getMain().getConnectionManager().sendCommand(ServerCommands.BUY,[param1,param2,_loc3_]);
         }
      }
      
      public function toggleLaserAttack(param1:int) : void
      {
         var _loc2_:Ship = null;
         var _loc3_:MapObject = null;
         var _loc4_:int = 0;
         if(param1 == ActionButton.ENV_QUICKSTART && Settings.quickSlotStopAttack || param1 == ActionButton.ENV_KEYBOARD || param1 == ActionButton.ENV_POOL)
         {
            _loc2_ = this.map.getShipManager().getHero();
            _loc3_ = this.map.getShipManager().getSelectedShip();
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.getUserId();
               if(_loc4_ != -1)
               {
                  if(this.map.getCombatManager().isShipAttacking(_loc2_.getUserId()) != null)
                  {
                     this.abortLaserAttack(_loc4_);
                  }
                  else
                  {
                     this.startLaserAttack(_loc4_);
                  }
               }
            }
            this.map.getMain().getGuiManager().getMenuManager().updateQuickstartLaserButtons();
         }
      }
      
      public function activateRocket(param1:int) : void
      {
         var _loc2_:MapObject = null;
         var _loc3_:int = 0;
         if(param1 == ActionButton.ENV_QUICKSTART && Settings.quickSlotStopAttack || param1 == ActionButton.ENV_KEYBOARD || param1 == ActionButton.ENV_POOL)
         {
            _loc2_ = this.map.getShipManager().getSelectedShip();
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getUserId();
               if(_loc3_ != -1)
               {
                  this.map.getMain().getConnectionManager().sendCommand(ServerCommands.ROCKET_ATTACK,[_loc3_]);
               }
            }
         }
      }
      
      public function loadRocketLauncher(param1:int) : void
      {
         if(Settings.rocketLauncherRocketsLoaded < 1)
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.ROCKETLAUNCHER,[ClientCommands.ROCKETLAUNCHER_LOAD]);
         }
         else
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.ROCKETLAUNCHER,[ClientCommands.ROCKETLAUNCHER_ATTACK]);
         }
      }
      
      public function startLaserAttack(param1:int) : void
      {
         this.map.getMain().getConnectionManager().sendCommand(ServerCommands.LASER_ATTACK,[param1]);
         this.map.getMain().getGuiManager().getMenuManager().togglePoolButton(SuperActionButton.ACTIVATION_LASER,true);
      }
      
      public function abortLaserAttack(param1:int) : void
      {
         this.map.getMain().getGuiManager().getMenuManager().togglePoolButton(SuperActionButton.ACTIVATION_LASER,false);
         this.map.getMain().screenManager.map.getCombatManager().removeLaserAttack(Hero.userID);
         this.map.getMain().getConnectionManager().sendCommand(ClientCommands.LASER_STOP,[param1]);
         this._lockedShip = null;
         var _loc2_:MapObject = this.map.getShipManager().getSelectedShip();
         if(_loc2_ != null)
         {
            this.map.getMain().getGuiManager().writeToLog(BPLocale.getText("attstop").replace(/%!/,_loc2_.getUsername()));
         }
      }
      
      public function activateJumpCPU() : void
      {
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_JUMP];
         if(_loc1_ != null && _loc1_.amount > 0)
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.JUMP_CPU,_loc1_.level]);
            this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_CPU_JUMP);
         }
      }
      
      public function activateInstaRepair() : void
      {
         this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.INSTAREPAIR]);
         var _loc1_:ActionButton2 = this.map.getMain().getGuiManager().getTopMenu().getButton(SuperActionButton.ACTION_FASTREPAIR);
         _loc1_.startFlash();
         _loc1_.setCounterVisibility(false);
      }
      
      public function activateArolCPU() : void
      {
         var _loc2_:String = null;
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_AROL];
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.state ? "0" : "1";
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.AROL,_loc2_]);
         }
      }
      
      public function toggleRllbCpu() : void
      {
         var _loc2_:String = null;
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_RLLB];
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.state ? "0" : "1";
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.RLLB,_loc2_]);
         }
      }
      
      public function activateAimCPU() : void
      {
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_AIM];
         if(_loc1_ != null)
         {
            if(_loc1_.state)
            {
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.AIM,"0"]);
            }
            else
            {
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.AIM,"1"]);
            }
         }
      }
      
      public function activateCloakCPU() : void
      {
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_CLOAK];
         if(_loc1_ != null && _loc1_.amount > 0)
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.SELECT_CLOAK]);
         }
      }
      
      public function activateExplosive() : void
      {
         var _loc1_:int = Settings.selectedExplosive;
         switch(_loc1_)
         {
            case 1:
               if(Hero.explosiveAmounts[SpecialAmmunition.MINE] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.MINE,ServerCommands.MINE_ACM]);
               }
               break;
            case 2:
               if(Hero.explosiveAmounts[SpecialAmmunition.SMARTBOMB] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.SMARTBOMB]);
               }
               break;
            case 3:
               if(Hero.explosiveAmounts[SpecialAmmunition.INSTASHIELD] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.INSTASHIELD]);
               }
               break;
            case 4:
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.EMP]);
               break;
            case 5:
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.FIREWORKS,1]);
               break;
            case 6:
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.FIREWORKS,2]);
               break;
            case 7:
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.FIREWORKS,3]);
               break;
            case 8:
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ServerCommands.FIREWORKS_IGNITE]);
               break;
            case 9:
               if(Hero.explosiveAmounts[SpecialAmmunition.MINE_EMP] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.MINE,ServerCommands.MINE_EMP]);
               }
               break;
            case 10:
               if(Hero.explosiveAmounts[SpecialAmmunition.MINE_SAB] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.MINE,ServerCommands.MINE_SAB]);
               }
               break;
            case 11:
               if(Hero.explosiveAmounts[SpecialAmmunition.MINE_DDM] > 0)
               {
                  this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_EXPLOSIVE);
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.MINE,ServerCommands.MINE_DDM]);
               }
         }
      }
      
      public function activateGate() : void
      {
         var _loc2_:String = null;
         var _loc1_:SimpleWindow = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
         if(_loc1_.isMaximizeClicked())
         {
            return;
         }
         if(Hero.inJumpArea)
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.PORTAL_JUMP);
         }
         else
         {
            _loc2_ = BPLocale.getText("jumpgate_failed_no_gate");
            this.map.getMain().getGuiManager().writeToLog(_loc2_);
            AudioManager.playSoundEffect(29);
         }
      }
      
      public function activateRobot() : void
      {
         if(this.map.getShipManager().getHero().getHitpoints() < this.map.getShipManager().getHero().getMaxHitpoints())
         {
            this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.ROBOT]);
         }
      }
      
      public function selectLaser(param1:int) : void
      {
         this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT_LASER,[param1]);
         Settings.selectedLaser = param1;
         Settings.lastSelectedLaser = param1;
      }
      
      public function selectRocket(param1:int) : void
      {
         switch(param1)
         {
            case RocketPattern.R310:
            case RocketPattern.PLT_2026:
            case RocketPattern.PLT_2021:
            case RocketPattern.PLT_3030:
            case RocketPattern.PLD_8:
            case RocketPattern.DCR_250:
            case RocketPattern.WIZ:
               Settings.selectedRocket = param1;
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT_ROCKET,[param1]);
               break;
            case RocketPattern.HSTRM01:
            case RocketPattern.UBR100:
            case RocketPattern.ECO10:
               Settings.selectedLauncherRocket = param1;
               this.map.getMain().getConnectionManager().sendCommand(ClientCommands.ROCKETLAUNCHER,[ClientCommands.ROCKETLAUNCHER_SELECT_ROCKET,param1]);
         }
      }
      
      public function selectConfiguration(param1:int) : void
      {
         this.map.getMain().getConnectionManager().sendCommand(ClientCommands.SELECT,[ClientCommands.CONFIGURATION,param1.toString()]);
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         this.keyDown[param1.keyCode] = false;
      }
      
      private function handleCommands(param1:Array) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:ConnectionManager = this.map.getMain().getConnectionManager();
         if(param1.length == 1)
         {
            _loc2_.sendRawCommand(param1[0]);
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if(param1[_loc5_] is Number)
               {
                  _loc4_ = Number(param1[_loc5_]);
                  _loc3_ += _loc4_;
                  TweenMax.delayedCall(_loc3_,_loc2_.sendRawCommand,[param1[_loc5_ + 1]]);
                  _loc5_ += 2;
               }
               else
               {
                  TweenMax.delayedCall(_loc3_ + 0.1,_loc2_.sendRawCommand,[param1[_loc5_]]);
                  _loc5_++;
               }
            }
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:int = 0;
         if(!this.map.valid)
         {
            return;
         }
         if(this.keyDown[param1.keyCode])
         {
            return;
         }
         this.keyDown[param1.keyCode] = true;
         if(this.controlsLocked)
         {
            return;
         }
         if(this.serverFunctionDict[param1.keyCode] != undefined)
         {
            this.handleCommands(this.serverFunctionDict[param1.keyCode]);
         }
         else
         {
            switch(param1.keyCode)
            {
               case Keyboard.CONTROL:
                  this.toggleLaserAttack(ActionButton.ENV_KEYBOARD);
                  break;
               case Keyboard.SPACE:
                  this.activateRocket(ActionButton.ENV_KEYBOARD);
                  break;
               case 49:
               case 97:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(0);
                  AudioManager.playSoundEffect(25);
                  break;
               case 50:
               case 98:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(1);
                  AudioManager.playSoundEffect(25);
                  break;
               case 51:
               case 99:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(2);
                  AudioManager.playSoundEffect(25);
                  break;
               case 52:
               case 100:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(3);
                  AudioManager.playSoundEffect(25);
                  break;
               case 53:
               case 101:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(4);
                  AudioManager.playSoundEffect(25);
                  break;
               case 54:
               case 102:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(5);
                  AudioManager.playSoundEffect(25);
                  break;
               case 55:
               case 103:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(6);
                  AudioManager.playSoundEffect(25);
                  break;
               case 56:
               case 104:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(7);
                  AudioManager.playSoundEffect(25);
                  break;
               case 57:
               case 105:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(8);
                  AudioManager.playSoundEffect(25);
                  break;
               case 48:
               case 96:
                  this.map.getMain().getGuiManager().getMenuManager().getQuickMenu().activateSlot(9);
                  AudioManager.playSoundEffect(25);
                  break;
               case 74:
                  _loc2_ = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
                  if(_loc2_.isMaximizeClicked())
                  {
                     return;
                  }
                  this.map.getMain().getConnectionManager().sendCommand(ClientCommands.PORTAL_JUMP);
                  break;
               case 67:
                  _loc3_ = Settings.selectedConfiguration;
                  if(_loc3_ == 1)
                  {
                     this.selectConfiguration(2);
                  }
                  else if(_loc3_ == 2)
                  {
                     this.selectConfiguration(1);
                  }
                  break;
               case 76:
                  _loc2_ = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
                  if(!_loc2_.isLocked())
                  {
                     _loc2_.maximize();
                  }
                  break;
               case 72:
                  this.map.getMain().getGuiManager().toggleHUD();
                  break;
               case 70:
                  this.map.getMain().getGuiManager().toggleDebugView();
                  break;
               case 187:
               case 107:
                  this.map.getMain().screenManager.increaseMapScale();
                  break;
               case 189:
               case 109:
                  this.map.getMain().screenManager.decreaseMapScale();
            }
         }
      }
      
      private function onMouseOverTimer(param1:TimerEvent) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.controlsLocked)
         {
            return;
         }
         var _loc2_:Ship = this.map.getShipManager().getHero();
         if(_loc2_ != null)
         {
            _loc3_ = this.map.getMain().screenManager.getStaticContainer();
            _loc4_ = _loc3_.mouseX - this.halfScreenWidth + _loc2_.x;
            _loc5_ = _loc3_.mouseY - this.halfScreenHeight + _loc2_.y;
            if(this.map.getShipManager().mouseOverTest(_loc4_,_loc5_) || this.map.getCollectableManager().mouseOverTest(_loc4_,_loc5_))
            {
               _loc3_.useHandCursor = true;
               _loc3_.buttonMode = true;
            }
            else
            {
               _loc3_.buttonMode = false;
               _loc3_.useHandCursor = false;
            }
         }
      }
      
      public function isControlsLocked() : Boolean
      {
         return this.controlsLocked;
      }
      
      public function get heroLockToTarget() : MapObject
      {
         return this._lockedShip;
      }
      
      public function set heroLockToTarget(param1:MapObject) : void
      {
         this._lockedShip = param1;
      }
      
      private function genereateTestShips() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc1_:int = 100000000;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = _loc2_ * 100;
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               _loc5_ = _loc4_ * 100;
               _loc6_ = "FB|C|" + _loc1_ + "|2|1||-=[ Streuner ]=-|" + _loc5_ + "|" + _loc3_ + "|0|0|0|0|0|0|0|1|0|1";
               this.map.getMain().getConnectionManager().sendRawCommand(_loc6_);
               _loc1_++;
               _loc4_++;
            }
            _loc2_++;
         }
      }
   }
}


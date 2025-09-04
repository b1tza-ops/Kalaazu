package net.bigpoint.darkorbit.menu
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.gui.BitmapFont;
   import net.bigpoint.darkorbit.gui.GuiManager;
   
   public class SuperActionButton extends EventDispatcher
   {
      
      public static const ACTION_ACTIVATE_GATE:int = 2;
      
      public static const ACTION_SHOW_SETTINGS_WINDOW:int = 8;
      
      public static const ACTION_LOGOUT:int = 9;
      
      public static const ACTION_TRADE:int = 10;
      
      public static const ACTION_HELP:int = 25;
      
      public static const ACTION_FASTREPAIR:int = 34;
      
      public static const ACTIVATION_LASER:int = 0;
      
      public static const SELECTION_LASER_1:int = 3;
      
      public static const SELECTION_LASER_2:int = 4;
      
      public static const SELECTION_LASER_3:int = 5;
      
      public static const SELECTION_LASER_4:int = 6;
      
      public static const SELECTION_LASER_5:int = 7;
      
      public static const SELECTION_LASER_6:int = 39;
      
      public static const ACTIVATION_ROCKET:int = 1;
      
      public static const SELECTION_ROCKET_R_310:int = 11;
      
      public static const SELECTION_ROCKET_PLT_2026:int = 12;
      
      public static const SELECTION_ROCKET_PLT_2021:int = 13;
      
      public static const SELECTION_ROCKET_PLT_3030:int = 57;
      
      public static const SELECTION_ROCKET_PLD_8:int = 44;
      
      public static const SELECTION_ROCKET_DCR_250:int = 72;
      
      public static const SELECTION_ROCKET_WIZ:int = 43;
      
      public static const SELECTION_LOAD_ROCKET_LAUNCHER:int = 46;
      
      public static const SELECTION_LAUNCHER_ROCKET_HST01:int = 48;
      
      public static const SELECTION_LAUNCHER_ROCKET_UBR100:int = 49;
      
      public static const SELECTION_LAUNCHER_ROCKET_ECO10:int = 50;
      
      public static const ACTIVATION_CHAIN_BOLT:int = 51;
      
      public static const ACTIVATION_TECH:int = 52;
      
      public static const ACTIVATION_SHIELD_BACKUP:int = 53;
      
      public static const ACTIVATION_ENERGY_LEECH:int = 54;
      
      public static const ACTIVATION_ROCKET_PRECISION:int = 55;
      
      public static const ACTIVATION_BATTLE_REP_BOT:int = 59;
      
      public static const ACTIVATION_SPEED_LEECH:int = 60;
      
      public static const ACTIVATION_SKILL_SOLACE:int = 63;
      
      public static const ACTIVATION_SKILL_DIMINISHER:int = 64;
      
      public static const ACTIVATION_SKILL_SPECTRUM:int = 65;
      
      public static const ACTIVATION_SKILL_SENTINEL:int = 66;
      
      public static const ACTIVATION_SKILL_VENOM:int = 67;
      
      public static const ACTIVATION_SKILL_LIGHNTING:int = 73;
      
      public static const ACTIVATION_EXPLOSIVE:int = 14;
      
      public static const SELECTION_MINE:int = 15;
      
      public static const SELECTION_MINE_EMP:int = 68;
      
      public static const SELECTION_MINE_SAB:int = 69;
      
      public static const SELECTION_MINE_DDM:int = 70;
      
      public static const SELECTION_EMP:int = 45;
      
      public static const SELECTION_SMARTBOMB:int = 16;
      
      public static const SELECTION_INSTASHIELD:int = 17;
      
      public static const ACTIVATION_CPU_JUMP:int = 20;
      
      public static const ACTIVATION_CPU_CLOAK:int = 21;
      
      public static const ACTIVATION_CPU_AROL:int = 22;
      
      public static const ACTIVATION_CPU_ROBOT:int = 23;
      
      public static const ACTIVATION_CPU_AIM:int = 24;
      
      public static const ACTIVATION_CPU_HM7:int = 35;
      
      public static const ACTIVATION_CPU_DRONE_REPAIR:int = 41;
      
      public static const ACTIVATION_CPU_AMMOBUY:int = 42;
      
      public static const ACTIVATION_CPU_RLLB:int = 47;
      
      public static const ACTIVATION_CPU_ROCKETBUY:int = 56;
      
      public static const SELECT_CPU_JUMP_TARGET:int = 71;
      
      public static const ACTIVATION_BUY:int = 25;
      
      public static const BUY_LASER_1:int = 26;
      
      public static const BUY_LASER_2:int = 27;
      
      public static const BUY_LASER_3:int = 28;
      
      public static const BUY_LASER_4:int = 29;
      
      public static const BUY_LASER_5:int = 30;
      
      public static const BUY_ROCKET_R_310:int = 31;
      
      public static const BUY_ROCKET_PLT_2026:int = 32;
      
      public static const BUY_ROCKET_PLT_2021:int = 33;
      
      public static const BUY_ROCKET_PLT_3030:int = 58;
      
      public static const SELECTION_FIREWORK_1:int = 36;
      
      public static const SELECTION_FIREWORK_2:int = 37;
      
      public static const SELECTION_FIREWORK_3:int = 38;
      
      public static const FIREWORK_IGNITE:int = 40;
      
      public var actionID:int;
      
      protected var guiManager:GuiManager;
      
      private var directionArrowTimer:Timer;
      
      private var directionArrow:MovieClip;
      
      protected var actionNormal:Bitmap;
      
      protected var actionHover:Bitmap;
      
      protected var actionSelected:Bitmap;
      
      protected var actionDisabled:Bitmap;
      
      protected var selectedIcon:Bitmap;
      
      protected var count:int;
      
      protected var bitmapFont:BitmapFont;
      
      protected var hasCounter:Boolean;
      
      protected var buttonContainer:MovieClip;
      
      protected var ammobar:MovieClip;
      
      protected var maxAmmo:int;
      
      private var flashCount:int;
      
      private var directionArrows:Array = [];
      
      public function SuperActionButton()
      {
         super();
      }
      
      protected function setInvisible(param1:Bitmap) : void
      {
         if(TweenMax.isTweening(param1))
         {
            return;
         }
         param1.visible = false;
      }
      
      public function getActionNormal() : Bitmap
      {
         return this.actionNormal;
      }
      
      public function getActionID() : int
      {
         return this.actionID;
      }
      
      public function getCount() : int
      {
         return this.count;
      }
      
      public function setCount(param1:int) : void
      {
         if(this.hasCounter)
         {
            this.bitmapFont.setText(param1.toString());
         }
      }
      
      public function setAmmobar(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.ammobar != null)
         {
            _loc2_ = this.ammobar.framesLoaded;
            _loc3_ = _loc2_ / this.maxAmmo * param1;
            if(_loc3_ > _loc2_)
            {
               _loc3_ = _loc2_;
            }
            _loc3_ = _loc2_ - _loc3_ + 1;
            this.ammobar.gotoAndStop(_loc3_);
         }
      }
      
      public function containsNumbersContainer() : Boolean
      {
         if(this.bitmapFont == null)
         {
            return false;
         }
         return true;
      }
      
      public function startFlash() : void
      {
         this.actionSelected.alpha = 0;
         this.actionSelected.visible = true;
         TweenLite.to(this.actionSelected,0.25,{
            "alpha":1,
            "onComplete":this.endFlash
         });
      }
      
      public function endFlash() : void
      {
         TweenLite.to(this.actionSelected,0.25,{
            "alpha":0,
            "onComplete":this.setInvisible,
            "onCompleteParams":[this.actionSelected]
         });
      }
      
      public function isLocked() : Boolean
      {
         return this.actionDisabled.visible;
      }
      
      public function lockButton() : void
      {
         this.actionDisabled.visible = true;
         this.buttonContainer.buttonMode = false;
      }
      
      public function unlockButton() : void
      {
         this.actionDisabled.visible = false;
         this.buttonContainer.buttonMode = true;
      }
      
      public function setCounterVisibility(param1:Boolean) : void
      {
         if(this.bitmapFont != null)
         {
            this.bitmapFont.visible = param1;
         }
      }
      
      public function getButtonContainer() : MovieClip
      {
         return this.buttonContainer;
      }
      
      public function flashIcon(param1:int = -1) : void
      {
         if(TweenMax.isTweening(this.selectedIcon))
         {
            return;
         }
         this.flashCount = param1;
         TweenMax.killTweensOf(this.selectedIcon);
         this.selectedIcon.alpha = 0;
         this.selectedIcon.visible = true;
         TweenLite.to(this.selectedIcon,0.25,{
            "alpha":1,
            "onComplete":this.endFlash2,
            "onCompleteParams":[this.selectedIcon]
         });
      }
      
      public function endFlash2(param1:Bitmap) : void
      {
         TweenLite.to(param1,0.25,{
            "alpha":0,
            "onComplete":this.setBitmapInvisible,
            "onCompleteParams":[param1]
         });
      }
      
      protected function setBitmapInvisible(param1:Bitmap) : void
      {
         param1.visible = false;
         if(this.flashCount == -1)
         {
            this.flashIcon(this.flashCount);
         }
         else
         {
            --this.flashCount;
            if(this.flashCount > 0)
            {
               this.flashIcon(this.flashCount);
            }
            else
            {
               this.stopPointer();
            }
         }
      }
      
      public function stopFlashIcon() : void
      {
         this.flashCount = 0;
         this.stopPointer();
      }
      
      protected function removeAllDirectionArrows() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.directionArrows.length)
         {
            _loc2_ = this.directionArrows[_loc1_];
            TweenMax.killTweensOf(_loc2_);
            TweenMax.killDelayedCallsTo(_loc2_);
            _loc2_.parent.removeChild(_loc2_);
            _loc1_++;
         }
         this.directionArrows = [];
      }
      
      public function startPointer() : void
      {
         this.stopPointer();
         this.directionArrow = ResourceManager.getMovieClip("ui","windowArrow");
         this.directionArrow.mouseEnabled = false;
         this.directionArrow.mouseChildren = false;
         this.directionArrow.x = this.getDynamicXPos();
         this.directionArrow.y = this.getDynamicYPos();
         this.directionArrow.scaleX = 0.7;
         this.directionArrow.scaleY = 0.7;
         this.directionArrow.rotation = -90;
         this.directionArrow.alpha = 0;
         this.updateArrowRotation(null);
         TweenLite.to(this.directionArrow,0.5,{"alpha":1});
         this.buttonContainer.stage.addChild(this.directionArrow);
         this.handleWindowPointer1(this.directionArrow);
         this.directionArrowTimer = new Timer(40,0);
         this.directionArrowTimer.addEventListener(TimerEvent.TIMER,this.updateArrowRotation);
         this.directionArrowTimer.start();
      }
      
      public function stopPointer() : void
      {
         if(this.directionArrow != null)
         {
            TweenMax.killTweensOf(this.directionArrow);
            if(this.buttonContainer.stage.contains(this.directionArrow))
            {
               TweenLite.to(this.directionArrow,0.5,{
                  "alpha":0,
                  "onComplete":this.directionArrow.parent.removeChild,
                  "onCompleteParams":[this.directionArrow]
               });
            }
         }
         if(this.directionArrowTimer != null)
         {
            this.directionArrowTimer.stop();
            this.directionArrowTimer.removeEventListener(TimerEvent.TIMER,this.updateArrowRotation);
         }
      }
      
      private function handleWindowPointer1(param1:MovieClip) : void
      {
         TweenLite.to(param1,0.5,{
            "x":this.getDynamicXPos(),
            "y":this.getDynamicYPos(),
            "onComplete":this.handleWindowPointer2,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleWindowPointer2(param1:MovieClip) : void
      {
         var _loc2_:int = int(40 * Math.cos(param1.rotation * Math.PI / 180));
         var _loc3_:int = int(40 * Math.sin(param1.rotation * Math.PI / 180));
         TweenLite.to(param1,0.5,{
            "x":this.getDynamicXPos() + _loc2_,
            "y":this.getDynamicYPos() + _loc3_,
            "onComplete":this.handleWindowPointer1,
            "onCompleteParams":[param1]
         });
      }
      
      private function updateArrowRotation(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Number = int(Math.atan2(this.getDynamicYPos() - ScreenManager.getHalfScreenHeight() - this.guiManager.getMain().y,this.getDynamicXPos() - ScreenManager.getHalfScreenWidth() - this.guiManager.getMain().x) * 180 / Math.PI);
         if(_loc2_ != 0)
         {
            _loc3_ = Math.round(_loc2_ + 180);
            this.directionArrow.rotation = _loc3_;
         }
      }
      
      private function getDynamicXPos() : int
      {
         var _loc1_:Point = this.buttonContainer.localToGlobal(new Point(this.buttonContainer.stage.x,this.buttonContainer.stage.y));
         _loc1_.x += this.actionNormal.width / 2;
         return _loc1_.x;
      }
      
      private function getDynamicYPos() : int
      {
         var _loc1_:Point = this.buttonContainer.localToGlobal(new Point(this.buttonContainer.stage.x,this.buttonContainer.stage.y));
         _loc1_.y += this.actionNormal.height / 2;
         return _loc1_.y;
      }
   }
}


package net.bigpoint.darkorbit.combat
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Sine;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   
   public class LaserAttackJob
   {
      
      private static var defaultSalvos:Array = [[[new Point(0,0)]]];
      
      private var attackerID:int;
      
      private var targetID:int;
      
      private var laserType:int;
      
      private var fireRate:int;
      
      private var timer:Timer;
      
      private var active:Boolean;
      
      private var combatManager:CombatManager;
      
      private var cnt:int = 0;
      
      private var attackerShip:MapObject;
      
      private var targetShip:MapObject;
      
      private var laserPattern:LaserPattern;
      
      private var overrideSoundLimit:Boolean;
      
      private var shipPattern:ShipPattern;
      
      private var showShieldDamage:Boolean;
      
      private var skilledLaser:Boolean;
      
      private var salvos:Array;
      
      private var usedSalvoPattern:int;
      
      private var salvosLoopPatternLength:int;
      
      private var resKey:String;
      
      private var canAlign:Boolean = false;
      
      private var laserLayer:Sprite;
      
      public function LaserAttackJob(param1:CombatManager, param2:int, param3:int, param4:int, param5:int, param6:Boolean = false, param7:Boolean = false)
      {
         super();
         this.combatManager = param1;
         this.attackerID = param2;
         this.targetID = param3;
         this.laserType = param4;
         this.fireRate = param5;
         this.active = true;
         this.showShieldDamage = param6;
         this.skilledLaser = param7;
         this.laserLayer = this.combatManager.getMap().getMain().screenManager.getLaserLayer();
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:int = 0;
         if(this.attackerID == Hero.userID)
         {
            this.overrideSoundLimit = true;
         }
         var _loc1_:Map = this.combatManager.getMap();
         if(_loc1_ == null)
         {
            this.combatManager.removeLaserAttack(this.attackerID);
         }
         else
         {
            this.attackerShip = _loc1_.getShipManager().getShip(this.attackerID);
            this.targetShip = _loc1_.getShipManager().getShip(this.targetID);
            if(this.attackerShip == null || this.targetShip == null)
            {
               this.combatManager.removeLaserAttack(this.attackerID);
            }
            else
            {
               this.shipPattern = this.attackerShip.shipPattern;
               if(this.shipPattern.getExpansionClassID() > 0)
               {
                  this.salvos = PatternManager.getExpansionPattern(this.shipPattern.getExpansionClassID(),this.attackerShip.getExpansionTypeID()).salvosData;
                  this.salvosLoopPatternLength = this.salvos.length;
                  this.usedSalvoPattern = 0;
                  this.canAlign = true;
               }
               else
               {
                  this.salvos = defaultSalvos;
                  this.salvosLoopPatternLength = 1;
                  this.usedSalvoPattern = 0;
                  this.canAlign = false;
               }
               _loc2_ = this.shipPattern.getLaserClassID();
               this.laserPattern = PatternManager.getLaserPattern(_loc2_,this.laserType);
               this.resKey = this.laserPattern.getResKey();
               this.timer = new Timer(100,0);
               this.timer.addEventListener(TimerEvent.TIMER,this.handleAttackTick);
               this.handleAttackTick(null);
               if(this.attackerShip.isHeroShip())
               {
                  this.combatManager.getMap().getShipManager().focusHeroToCoordinates(this.targetShip.x,this.targetShip.y);
               }
               this.timer.start();
            }
         }
      }
      
      private function handleAttackTick(param1:TimerEvent) : void
      {
         if(this.cnt > this.laserPattern.getAttackLength())
         {
            if(!this.active)
            {
               this.cleanup();
               return;
            }
            this.cnt = 0;
            this.active = false;
         }
         if(this.cnt % this.fireRate == 0)
         {
            this.startAttack();
         }
         this.focusShip();
         this.cnt += 100;
      }
      
      private function focusShip() : void
      {
         if(this.attackerShip.isHeroShip())
         {
            return;
         }
         if(this.attackerShip == null || this.targetShip == null)
         {
            this.cleanup();
            return;
         }
         if(this.shipPattern != null && !this.shipPattern.playLoop)
         {
            this.combatManager.focusShip(this.attackerShip,this.targetShip);
         }
      }
      
      public function cleanup() : void
      {
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleAttackTick);
         }
         this.combatManager.removeLaserAttack(this.attackerID,false);
      }
      
      public function resume() : void
      {
         if(!this.timer.hasEventListener(TimerEvent.TIMER))
         {
            this.timer.addEventListener(TimerEvent.TIMER,this.handleAttackTick);
            this.timer.start();
         }
      }
      
      public function idle() : void
      {
         if(this.timer.hasEventListener(TimerEvent.TIMER))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleAttackTick);
         }
      }
      
      public function startAttack() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         if(this.attackerShip == null || this.targetShip == null)
         {
            this.cleanup();
            return;
         }
         var _loc1_:int = this.laserPattern.getSoundID();
         if(this.skilledLaser && this.laserPattern.skillResKey != "-1")
         {
            this.resKey = this.laserPattern.skillResKey;
         }
         else
         {
            this.resKey = this.laserPattern.getResKey();
         }
         if(this.laserPattern.isAbsorber())
         {
            _loc2_ = this.targetShip.x;
            _loc3_ = this.targetShip.y;
            _loc4_ = this.attackerShip.x;
            _loc5_ = this.attackerShip.y;
            this.addLaser(_loc2_,_loc3_,_loc4_,_loc5_,this.resKey);
            if(_loc1_ != -1)
            {
               AudioManager.playSoundEffect(_loc1_,false,false,_loc2_,_loc3_,this.overrideSoundLimit);
            }
         }
         else
         {
            if(this.attackerShip == null || this.targetShip == null)
            {
               this.cleanup();
               return;
            }
            _loc6_ = 0;
            if(this.canAlign)
            {
               _loc6_ = this.attackerShip.getCurrentFrameOfShip() - 1;
            }
            _loc4_ = this.targetShip.x;
            _loc5_ = this.targetShip.y;
            _loc7_ = this.showShieldDamage;
            _loc8_ = 0;
            while(_loc8_ < this.salvos[this.usedSalvoPattern].length)
            {
               _loc2_ = this.attackerShip.x + this.salvos[this.usedSalvoPattern][_loc8_][_loc6_].x;
               _loc3_ = this.attackerShip.y + this.salvos[this.usedSalvoPattern][_loc8_][_loc6_].y;
               this.addLaser(_loc2_,_loc3_,_loc4_,_loc5_,this.resKey,_loc7_);
               _loc7_ = false;
               _loc8_++;
            }
            ++this.usedSalvoPattern;
            this.usedSalvoPattern %= this.salvosLoopPatternLength;
            if(_loc1_ != -1)
            {
               AudioManager.playSoundEffect(_loc1_,false,false,_loc2_,_loc3_,this.overrideSoundLimit);
            }
         }
      }
      
      private function addLaser(param1:int, param2:int, param3:int, param4:int, param5:String, param6:Boolean = false) : void
      {
         var _loc8_:Function = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         if(this.attackerShip == null)
         {
            return;
         }
         var _loc7_:MovieClip = ResourceManager.getMovieClip(param5,"mc");
         _loc7_.mouseEnabled = false;
         _loc7_.mouseChildren = false;
         if(!this.laserPattern.isAbsorber())
         {
            _loc11_ = _loc7_.width;
            if(_loc11_ > 0)
            {
               _loc12_ = param1 - param3;
               _loc13_ = param2 - param4;
               _loc14_ = Math.pow(param4 - param2,2) + Math.pow(param3 - param1,2);
               if(_loc14_ < _loc11_ * _loc11_)
               {
                  return;
               }
               _loc15_ = FastMath.sqrt(_loc14_);
               param3 = _loc12_ / _loc15_ * _loc11_ + param3;
               param4 = _loc13_ / _loc15_ * _loc11_ + param4;
            }
         }
         _loc7_.play();
         if(!this.laserPattern.playLoop)
         {
            _loc16_ = Math.atan2(param4 - param2,param3 - param1) * 180 / Math.PI;
            _loc17_ = Math.round(_loc16_ + 180);
            _loc7_.rotation = _loc17_;
         }
         _loc7_.x = param1;
         _loc7_.y = param2;
         this.laserLayer.addChild(_loc7_);
         var _loc9_:Number = 1;
         var _loc10_:Number = 1;
         if(this.laserPattern.isAbsorber())
         {
            _loc8_ = Linear.easeNone;
            _loc9_ = 0.1;
            _loc10_ = 0.1;
         }
         else if(this.laserPattern.isPlayLoopRotated())
         {
            _loc8_ = Back.easeIn;
         }
         else
         {
            _loc8_ = Sine.easeOut;
         }
         TweenLite.to(_loc7_,this.laserPattern.getSpeed(),{
            "ease":Linear.easeNone,
            "x":param3,
            "y":param4,
            "scaleX":_loc9_,
            "scaleY":_loc10_,
            "onComplete":this.handleLaserRemove,
            "onCompleteParams":[_loc7_,param6]
         });
      }
      
      public function handleFlareFinished(param1:MovieClip, param2:Sprite) : void
      {
         if(param1 != null && param2 != null && param2.contains(param1))
         {
            param2.removeChild(param1);
         }
      }
      
      private function handleRemoveShieldDamage(param1:Sprite, param2:MovieClip) : void
      {
         if(param1 != null && param2 != null && param1.contains(param2))
         {
            param1.removeChild(param2);
            if(this.targetShip != null)
            {
               --this.targetShip.shieldDamageCount;
            }
         }
      }
      
      public function handleLaserRemove(param1:MovieClip, param2:Boolean) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Sprite = null;
         if(param1 != null && param1.parent != null)
         {
            param1.gotoAndStop(1);
            param1.parent.removeChild(param1);
         }
         if(param2 && this.targetShip != null && this.targetShip.shieldDamageCount < 9)
         {
            _loc3_ = ResourceManager.getMovieClip("shieldDamage","mc");
            _loc4_ = this.targetShip.radius + 10;
            _loc5_ = _loc4_ / 100;
            _loc3_.scaleX = _loc5_;
            _loc3_.scaleY = _loc5_;
            _loc3_.x = int(_loc4_ * Math.cos(param1.rotation * Math.PI / 180));
            _loc3_.y = int(_loc4_ * Math.sin(param1.rotation * Math.PI / 180));
            _loc3_.rotation = param1.rotation;
            _loc6_ = _loc3_.framesLoaded;
            _loc7_ = _loc6_ / 30;
            _loc8_ = this.targetShip.getClipContainer();
            _loc8_.addChild(_loc3_);
            TweenLite.to(_loc3_,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_,
               "onComplete":this.handleRemoveShieldDamage,
               "onCompleteParams":[_loc8_,_loc3_]
            });
            ++this.targetShip.shieldDamageCount;
         }
      }
      
      public function getAttackerID() : int
      {
         return this.attackerID;
      }
      
      public function getTargetID() : int
      {
         return this.targetID;
      }
      
      public function getFireRate() : int
      {
         return this.fireRate;
      }
      
      public function getLaserType() : int
      {
         return this.laserType;
      }
      
      public function getActive() : Boolean
      {
         return this.active;
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.active = param1;
      }
      
      public function setLaserType(param1:int) : void
      {
         var _loc3_:int = 0;
         this.laserType = param1;
         var _loc2_:Map = this.combatManager.getMap();
         if(_loc2_ != null)
         {
            _loc3_ = this.shipPattern.getLaserClassID();
            this.laserPattern = PatternManager.getLaserPattern(_loc3_,this.getLaserType());
         }
      }
   }
}


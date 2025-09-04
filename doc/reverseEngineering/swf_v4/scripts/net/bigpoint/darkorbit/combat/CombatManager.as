package net.bigpoint.darkorbit.combat
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Quint;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import net.bigpoint.darkorbit.pattern.ShockwavePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   import net.bigpoint.darkorbit.ship.effects.EffectIDList;
   import net.bigpoint.darkorbit.ship.effects.EffectsManager;
   import net.bigpoint.darkorbit.ship.effects.HealBeamEffect;
   
   public class CombatManager
   {
      
      private static const logger:ILogger = Log.getLogger("CombatManager");
      
      private var laserAttacks:Dictionary;
      
      private var rocketAttacks:Array;
      
      private var chainBoltAttacks:Dictionary;
      
      private var healingBeams:Array;
      
      private var tractorBeams:Array;
      
      private var rays:Array = [];
      
      private var map:Map;
      
      private var effectsManager:EffectsManager = EffectsManager.getInstance();
      
      public function CombatManager(param1:Map)
      {
         super();
         this.map = param1;
         this.laserAttacks = new Dictionary();
         this.rocketAttacks = [];
         this.chainBoltAttacks = new Dictionary();
         this.healingBeams = [];
         this.tractorBeams = [];
      }
      
      public function cleanup() : void
      {
         var _loc1_:LaserAttackJob = null;
         var _loc2_:ChainBoltAttackJob = null;
         var _loc3_:HealingBeamJob = null;
         var _loc4_:TractorBeamJob = null;
         for each(_loc1_ in this.laserAttacks)
         {
            _loc1_.cleanup();
         }
         for each(_loc2_ in this.chainBoltAttacks)
         {
            _loc2_.cleanup();
         }
         for each(_loc3_ in this.healingBeams)
         {
            _loc3_.cleanup();
         }
         for each(_loc4_ in this.tractorBeams)
         {
            _loc4_.cleanup();
         }
         this.laserAttacks = new Dictionary();
         this.rocketAttacks = [];
         this.chainBoltAttacks = new Dictionary();
         this.healingBeams = [];
         this.tractorBeams = [];
      }
      
      public function removeRocketAttackTo(param1:int) : void
      {
         var _loc3_:RocketAttackJob = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.rocketAttacks.length)
         {
            _loc3_ = this.rocketAttacks[_loc2_];
            if(param1 == _loc3_.targetShip.getUserId())
            {
               this.rocketAttacks.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addLaserAttack(param1:int, param2:int, param3:int, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:MapObject = this.map.getShipManager().getShip(param1);
         var _loc7_:MapObject = this.map.getShipManager().getShip(param2);
         if(_loc6_ == null || _loc7_ == null)
         {
            return;
         }
         if(param1 == Hero.userID)
         {
            if(!this.isShipAttackedByHero(param2) && _loc7_ != null)
            {
               this.map.getMain().getGuiManager().writeToLog(BPLocale.getText("oppoatt").replace("%!",_loc7_.getUsername()));
            }
         }
         var _loc8_:ShipPattern = _loc6_.shipPattern;
         var _loc9_:int = _loc8_.getLaserClassID();
         if(_loc9_ == -1)
         {
            return;
         }
         var _loc10_:LaserPattern = PatternManager.getLaserPattern(_loc9_,param3);
         if(_loc10_ == null)
         {
            logger.fatal("laser not found for laserclass:" + _loc9_ + " laserType:" + param3);
            return;
         }
         var _loc11_:LaserAttackJob = this.laserAttacks[int(param1)];
         if(_loc11_ != null)
         {
            if(_loc11_.getTargetID() == param2)
            {
               if(_loc11_.getFireRate() == _loc10_.getFireRate())
               {
                  _loc11_.setActive(true);
                  if(_loc11_.getLaserType() != param3)
                  {
                     _loc11_.setLaserType(param3);
                  }
                  return;
               }
               _loc11_.cleanup();
               delete this.laserAttacks[int(param1)];
            }
            else
            {
               this.removeLaserAttack(param1,true);
            }
         }
         this.laserAttacks[int(param1)] = new LaserAttackJob(this,param1,param2,param3,_loc10_.getFireRate(),param4,param5);
      }
      
      public function removeLaserAttack(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:LaserAttackJob = this.laserAttacks[int(param1)];
         if(_loc3_ != null)
         {
            if(param2)
            {
               _loc3_.cleanup();
            }
            delete this.laserAttacks[int(param1)];
         }
      }
      
      public function removeLaserAttackTo(param1:int) : void
      {
         var _loc2_:LaserAttackJob = null;
         for each(_loc2_ in this.laserAttacks)
         {
            if(_loc2_.getTargetID() == param1)
            {
               _loc2_.cleanup();
               delete this.laserAttacks[int(_loc2_.getAttackerID())];
            }
         }
      }
      
      public function idleLaserAttack(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:LaserAttackJob = this.laserAttacks[int(param1)];
         if(_loc3_ != null)
         {
            if(param2)
            {
               _loc3_.idle();
            }
         }
      }
      
      public function idleLaserAttackTo(param1:int) : void
      {
         var _loc2_:LaserAttackJob = null;
         for each(_loc2_ in this.laserAttacks)
         {
            if(_loc2_.getTargetID() == param1)
            {
               _loc2_.idle();
            }
         }
      }
      
      public function resumeLaserAttackTo(param1:int) : void
      {
         var _loc2_:LaserAttackJob = null;
         for each(_loc2_ in this.laserAttacks)
         {
            if(_loc2_.getTargetID() == param1)
            {
               _loc2_.resume();
            }
         }
      }
      
      public function resumeLaserAttack(param1:int) : void
      {
         var _loc2_:LaserAttackJob = this.laserAttacks[int(param1)];
         if(_loc2_ != null)
         {
            _loc2_.resume();
         }
      }
      
      public function removeChainBoltAttackFrom(param1:int) : void
      {
         var _loc2_:ChainBoltAttackJob = this.chainBoltAttacks[int(param1)];
         if(_loc2_ != null)
         {
            delete this.chainBoltAttacks[int(_loc2_.originalAttackerID)];
         }
      }
      
      public function removeHealingBeamFrom(param1:int) : void
      {
         var _loc2_:HealingBeamJob = this.healingBeams[int(param1)];
         if(_loc2_ != null)
         {
            delete this.healingBeams[int(_loc2_.originalAttackerID)];
         }
      }
      
      public function addChainBoltAttackFor(param1:int, param2:ChainBoltAttackJob) : void
      {
         this.chainBoltAttacks[int(param1)] = param2;
      }
      
      public function removeTractorBeam(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:TractorBeamJob = this.tractorBeams[int(param1)];
         if(_loc3_ != null)
         {
            if(param2)
            {
               _loc3_.cleanup();
            }
            delete this.tractorBeams[int(param1)];
         }
      }
      
      public function isShipAttackedByHero(param1:int) : Boolean
      {
         var _loc2_:LaserAttackJob = this.laserAttacks[int(Hero.userID)];
         if(_loc2_ != null && _loc2_.getTargetID() == param1)
         {
            return true;
         }
         return false;
      }
      
      public function isShipAttacking(param1:int) : LaserAttackJob
      {
         var _loc2_:LaserAttackJob = this.laserAttacks[int(param1)];
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function addRocketAttack(param1:int, param2:int, param3:int, param4:Boolean, param5:int = 0, param6:Boolean = false) : void
      {
         var _loc7_:MapObject = null;
         var _loc13_:MovieClip = null;
         var _loc14_:MovieClip = null;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:RocketSmokePattern = null;
         var _loc18_:Number = NaN;
         var _loc19_:RocketAttackJob = null;
         var _loc20_:ColorTransform = null;
         _loc7_ = this.map.getShipManager().getShip(param1);
         if(_loc7_ == null)
         {
            return;
         }
         if(_loc7_.getUserId() == Hero.userID)
         {
            this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_ROCKET);
         }
         var _loc8_:ShipPattern = _loc7_.shipPattern;
         var _loc9_:int = _loc8_.getRocketClass();
         if(_loc9_ == -1)
         {
            return;
         }
         var _loc10_:RocketPattern = PatternManager.getRocketPattern(_loc9_,param3);
         if(_loc10_ == null)
         {
            _loc10_ = PatternManager.getRocketPattern(0,0);
         }
         var _loc11_:int = _loc10_.getSoundID();
         if(_loc11_ != -1)
         {
            AudioManager.playSoundEffect(_loc11_,false,false,_loc7_.x,_loc7_.y,true);
         }
         var _loc12_:MapObject = this.map.getShipManager().getShip(param2);
         if(_loc7_ != null && _loc12_ != null)
         {
            _loc13_ = ResourceManager.getMovieClip(_loc10_.getResKey(),"mc");
            _loc13_.x = _loc7_.x;
            _loc13_.y = _loc7_.y;
            _loc14_ = null;
            if(param6)
            {
               _loc14_ = ResourceManager.getMovieClip("minePulse","mc");
               _loc20_ = new ColorTransform();
               _loc20_.color = 16711680;
               _loc14_.transform.colorTransform = _loc20_;
               _loc13_.addChild(_loc14_);
               this.playPulseAnimation(_loc14_,15);
               _loc14_.x = -30;
            }
            _loc15_ = Math.atan2(_loc12_.y - _loc7_.y,_loc12_.x - _loc7_.x) * 180 / Math.PI;
            _loc16_ = Math.round(_loc15_ + 180);
            _loc13_.rotation = _loc16_;
            this.map.getMain().screenManager.getExplosionLayer().addChild(_loc13_);
            if(!_loc8_.playLoop)
            {
               this.focusShip(_loc7_,_loc12_);
            }
            _loc17_ = PatternManager.rocketSmokePatterns[param5];
            _loc18_ = 0.75;
            _loc19_ = new RocketAttackJob(this,_loc7_,_loc12_,_loc13_,param4,_loc18_,_loc17_,param6,_loc14_);
            this.rocketAttacks.push(_loc19_);
            _loc19_.init();
         }
      }
      
      public function addChainBoltAttack(param1:int, param2:Array) : void
      {
         var _loc6_:MapObject = null;
         var _loc3_:MapObject = this.map.getShipManager().getShip(param1);
         if(_loc3_ == null)
         {
            return;
         }
         ++_loc3_.numberChainsInvolvedIn;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc6_ = this.map.getShipManager().getShip(param2[_loc4_]);
            if(_loc6_ == null)
            {
               return;
            }
            ++_loc6_.numberChainsInvolvedIn;
            _loc4_++;
         }
         var _loc5_:ChainBoltAttackJob = new ChainBoltAttackJob(_loc3_,param2,this,false);
         this.chainBoltAttacks[int(param1)] = _loc5_;
         _loc5_.init();
      }
      
      public function addAirstrike(param1:int, param2:int, param3:int, param4:int = 20, param5:Boolean = false) : void
      {
         var _loc13_:int = 0;
         var _loc14_:MovieClip = null;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:RocketAttackJob = null;
         var _loc6_:MapObject = this.map.getShipManager().getShip(param1);
         if(_loc6_ == null)
         {
            return;
         }
         if(_loc6_.getUserId() == Hero.userID)
         {
            this.map.getMain().getGuiManager().getMenuManager().flashButton(SuperActionButton.ACTIVATION_ROCKET);
         }
         var _loc7_:ShipPattern = _loc6_.shipPattern;
         var _loc8_:int = _loc7_.getRocketClass();
         var _loc9_:RocketPattern = PatternManager.getRocketPattern(_loc8_,param3);
         if(_loc9_ == null)
         {
            _loc9_ = PatternManager.getRocketPattern(0,0);
         }
         AudioManager.playSoundEffect(_loc9_.getSoundID(),false,false,_loc6_.x,_loc6_.y);
         AudioManager.playSoundEffect(40,false,false,_loc6_.x,_loc6_.y);
         var _loc10_:MapObject = this.map.getShipManager().getShip(param2);
         if(!_loc7_.playLoop)
         {
            this.focusShip(_loc6_,_loc10_);
         }
         var _loc11_:RocketSmokePattern = PatternManager.rocketSmokePatterns[0];
         var _loc12_:Number = 0;
         if(_loc6_ != null && _loc10_ != null)
         {
            _loc13_ = 0;
            while(_loc13_ < param4)
            {
               _loc14_ = ResourceManager.getMovieClip(_loc9_.getResKey(),"mc");
               _loc14_.x = _loc6_.x;
               _loc14_.y = _loc6_.y;
               _loc15_ = Math.atan2(_loc10_.y - _loc6_.y,_loc10_.x - _loc6_.x) * 180 / Math.PI;
               _loc16_ = Math.round(_loc15_ + 180);
               _loc14_.rotation = _loc16_;
               this.map.getMain().screenManager.getExplosionLayer().addChild(_loc14_);
               _loc17_ = Main.getRandomCount(75,200) / 100;
               if(_loc17_ > _loc12_)
               {
                  _loc12_ = _loc17_;
               }
               _loc18_ = new RocketAttackJob(this,_loc6_,_loc10_,_loc14_,true,_loc17_,_loc11_,true,null);
               _loc18_.airstrikeMode = true;
               this.rocketAttacks.push(_loc18_);
               _loc18_.init();
               if(_loc13_ == param4 - 1 && param5 == true)
               {
                  TweenMax.delayedCall(_loc12_,this.handleAirStrikeMissedDisplay,[_loc10_]);
               }
               _loc13_++;
            }
         }
      }
      
      public function handleAirStrikeMissedDisplay(param1:Ship) : void
      {
         if(Settings.displayHitpointBubbles)
         {
            if(this.map != null)
            {
               this.map.getMain().getGuiManager().showHitpointDelta(param1,0);
            }
         }
      }
      
      private function playPulseAnimation(param1:MovieClip, param2:int) : void
      {
         var _loc3_:int = param1.framesLoaded;
         var _loc4_:Number = _loc3_ / param2;
         param1.gotoAndStop(1);
         AudioManager.playSoundEffect(38,false,false,param1.parent.x,param1.parent.y);
         TweenLite.to(param1,_loc4_,{
            "ease":Linear.easeNone,
            "frame":_loc3_,
            "onComplete":this.playPulseAnimation,
            "onCompleteParams":[param1,param2]
         });
      }
      
      public function focusShip(param1:MapObject, param2:MapObject) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         var _loc3_:Number = Math.atan2(param2.y - param1.y,param2.x - param1.x) * 180 / Math.PI;
         var _loc4_:int = Math.round(_loc3_ + 180);
         TweenMax.to(param1,0.25,{
            "ease":Expo.easeOut,
            "shortRotation":{"shipRotation":_loc4_}
         });
      }
      
      public function getMap() : Map
      {
         return this.map;
      }
      
      public function addEMPBolt() : void
      {
         var _loc1_:Ship = this.map.getShipManager().getHero();
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            TweenMax.delayedCall(_loc2_,this.attachEMPBoltClip);
            _loc2_ += 0.15;
            _loc3_++;
         }
         AudioManager.playSoundEffect(45,false,false,_loc1_.x,_loc1_.y);
      }
      
      private function attachEMPBoltClip() : void
      {
         var _loc1_:Ship = this.map.getShipManager().getHero();
         var _loc2_:int = _loc1_.radius / 3;
         var _loc3_:MovieClip = ResourceManager.getMovieClip("shockwaves","blitz");
         var _loc4_:Number = Main.getRandomCount(200,1000) / 1000;
         _loc3_.scaleX = _loc4_;
         _loc3_.scaleY = _loc4_;
         var _loc5_:int = Main.getRandomCount(-_loc2_,_loc2_);
         var _loc6_:int = Main.getRandomCount(-_loc2_,_loc2_);
         TweenLite.to(_loc3_,2,{
            "x":_loc5_,
            "y":_loc6_
         });
         _loc1_.getClipContainer().addChild(_loc3_);
         ScreenManager.playAnimation(_loc3_,15,true);
         TweenMax.delayedCall(3,this.stopBoltAnimation,[_loc3_]);
      }
      
      private function stopBoltAnimation(param1:MovieClip) : void
      {
         TweenLite.to(param1,0.5,{
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":this.removeBolt,
            "onCompleteParams":[param1]
         });
      }
      
      private function removeBolt(param1:MovieClip) : void
      {
         param1.parent.removeChild(param1);
         TweenMax.killTweensOf(param1);
      }
      
      public function addEMPtoShip(param1:MapObject) : void
      {
         this.createEMP(param1.getClipContainer(),param1.x,param1.y);
      }
      
      public function addEMPtoMap(param1:int, param2:int) : void
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.x = param1;
         _loc3_.y = param2;
         this.map.getMain().screenManager.getExplosionLayer().addChild(_loc3_);
         this.createEMP(_loc3_,param1,param2);
      }
      
      private function createEMP(param1:Sprite, param2:int, param3:int) : void
      {
         var _loc5_:Bitmap = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("shockwaves"));
         if(param1 != null)
         {
            _loc5_ = ResourceManager.getBitmap("lensFlash","lensFlash");
            _loc5_.x = -_loc5_.width * 0.5;
            _loc5_.y = -_loc5_.height * 0.5;
            param1.addChild(_loc5_);
            TweenLite.to(_loc5_,0.25,{
               "alpha":0,
               "onComplete":this.removeFromParent,
               "onCompleteParams":[_loc5_,param1]
            });
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
               TweenMax.delayedCall(_loc6_,this.showEMPRing,[_loc4_,param1,_loc7_]);
               _loc6_ += 0.1;
               _loc7_++;
            }
            _loc8_ = MovieClip(_loc4_.getEmbededMovieClip("blitz"));
            ScreenManager.playAnimation(_loc8_,15,true);
            _loc8_.scaleX = 0.1;
            _loc8_.scaleY = 0.1;
            param1.addChild(_loc8_);
            TweenLite.to(_loc8_,1.5,{
               "scaleX":3.5,
               "scaleY":3.5,
               "onComplete":this.removeFromParent,
               "onCompleteParams":[_loc8_,param1]
            });
            TweenMax.delayedCall(0.75,this.fadeOutBolt,[_loc8_]);
            AudioManager.playSoundEffect(43,false,false,param2,param3);
         }
      }
      
      private function removeFromParent(param1:DisplayObject, param2:Sprite, param3:int = -1) : void
      {
         TweenMax.killTweensOf(param1);
         if(param2 != null && param2.contains(param1))
         {
            param2.removeChild(param1);
         }
      }
      
      private function showEMPRing(param1:SWFFinisher, param2:Sprite, param3:int) : void
      {
         var _loc4_:MovieClip = MovieClip(param1.getEmbededMovieClip("shockring0"));
         _loc4_.scaleX = 0.1;
         _loc4_.scaleY = 0.1;
         _loc4_.alpha = 0.3;
         param2.addChild(_loc4_);
         TweenLite.to(_loc4_,1.5,{
            "scaleX":3.5,
            "scaleY":3.5,
            "alpha":0,
            "onComplete":this.removeFromParent,
            "onCompleteParams":[_loc4_,param2,param3]
         });
      }
      
      private function fadeOutBolt(param1:MovieClip) : void
      {
         TweenLite.to(param1,0.25,{"alpha":0});
      }
      
      public function showShockwave(param1:int, param2:int, param3:int, param4:Boolean, param5:int = 300) : void
      {
         var _loc11_:Bitmap = null;
         var _loc12_:int = 0;
         var _loc13_:Sprite = null;
         var _loc6_:int = 40;
         var _loc7_:int = 360 / _loc6_;
         var _loc8_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("shockwaves"));
         var _loc9_:ShockwavePattern = PatternManager.shockwavePatterns[param1];
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_)
         {
            _loc11_ = Bitmap(_loc8_.getEmbededBitmap(_loc9_.getResKey()));
            _loc11_.x = param2;
            _loc11_.y = param3;
            _loc12_ = _loc10_ * _loc7_;
            _loc11_.rotation = _loc12_ + 180;
            _loc13_ = this.map.getMain().screenManager.getExplosionLayer();
            _loc13_.addChild(_loc11_);
            TweenLite.to(_loc11_,_loc9_.duration,{
               "ease":Quint.easeOut,
               "x":param2 + int(param5 * Math.cos(_loc12_ * Math.PI / 180)),
               "y":param3 + int(param5 * Math.sin(_loc12_ * Math.PI / 180)),
               "scaleX":_loc9_.endScale,
               "scaleY":_loc9_.endScale,
               "alpha":0,
               "onComplete":this.handleAnimationFinished,
               "onCompleteParams":[_loc13_,_loc11_]
            });
            _loc10_++;
         }
         if(param4)
         {
            AudioManager.playSoundEffect(36,false,false,_loc11_.x,_loc11_.y);
         }
      }
      
      public function showPyroEffect(param1:int, param2:int, param3:ExplosionPattern, param4:int = 37, param5:Boolean = true, param6:Boolean = false) : void
      {
         var _loc8_:DisplayObject = null;
         var _loc9_:int = 0;
         var _loc7_:String = param3.getResKey();
         if(param6 || param3.useBitmapClip)
         {
            _loc8_ = new BitmapClip(ResourceManager.getMovieClip(_loc7_,"mc"),param3.getResKey());
            _loc9_ = BitmapClip(_loc8_).framesLoaded;
         }
         else
         {
            _loc8_ = MovieClip(ResourceManager.getMovieClip(_loc7_,"mc"));
            _loc9_ = MovieClip(_loc8_).framesLoaded;
         }
         _loc8_.x = param1;
         _loc8_.y = param2;
         _loc8_.rotation = Math.random() * 360;
         var _loc10_:Number = _loc9_ / param4;
         var _loc11_:Sprite = this.map.getMain().screenManager.getExplosionLayer();
         _loc11_.addChild(_loc8_);
         TweenLite.to(_loc8_,_loc10_,{
            "ease":Linear.easeNone,
            "frame":_loc9_,
            "onComplete":this.handleAnimationFinished,
            "onCompleteParams":[_loc11_,_loc8_]
         });
         var _loc12_:int = param3.getSoundID();
         if(_loc12_ != -1 && param5)
         {
            AudioManager.playSoundEffect(_loc12_,false,false,_loc8_.x,_loc8_.y);
         }
      }
      
      public function showPyroEffectOnShip(param1:ExplosionPattern, param2:MapObject, param3:int = 37, param4:Boolean = false) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc5_:String = param1.getResKey();
         var _loc6_:Sprite = param2.getClipContainer();
         if(param4 || param1.useBitmapClip)
         {
            _loc7_ = new BitmapClip(ResourceManager.getMovieClip(_loc5_,"mc"),param1.getResKey());
            _loc8_ = BitmapClip(_loc7_).framesLoaded;
         }
         else
         {
            _loc7_ = MovieClip(ResourceManager.getMovieClip(_loc5_,"mc"));
            _loc8_ = MovieClip(_loc7_).framesLoaded;
         }
         var _loc9_:Number = _loc8_ / param3;
         _loc6_.addChild(_loc7_);
         TweenLite.to(_loc7_,_loc9_,{
            "ease":Linear.easeNone,
            "frame":_loc8_,
            "onComplete":this.handleAnimationFinished,
            "onCompleteParams":[_loc6_,_loc7_]
         });
         var _loc10_:int = param1.getSoundID();
         if(_loc10_ != -1)
         {
            AudioManager.playSoundEffect(_loc10_,false,false,param2.getClipContainer().x,param2.getClipContainer().y);
         }
      }
      
      private function handleAnimationFinished(param1:Sprite, param2:DisplayObject) : void
      {
         param1.removeChild(param2);
      }
      
      public function addChasingShot(param1:int, param2:int, param3:String) : void
      {
         var _loc6_:SWFFinisher = null;
         var _loc7_:MovieClip = null;
         var _loc4_:MapObject = this.map.getShipManager().getShip(param1);
         var _loc5_:MapObject = this.map.getShipManager().getShip(param2);
         if(_loc4_ != null && _loc5_ != null)
         {
            _loc6_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(param3));
            _loc7_ = _loc6_.getEmbededMovieClip("mc");
            new ChasingShotPirate(_loc4_,_loc5_,_loc7_,this.map.getMain().screenManager.getExplosionLayer());
            AudioManager.playSoundEffect(76,false,false,_loc4_.x,_loc4_.y,true);
         }
      }
      
      public function addHealingBeam(param1:int, param2:int) : void
      {
         var _loc3_:MapObject = this.map.getShipManager().getShip(param1);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:MapObject = this.map.getShipManager().getShip(param2);
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:HealBeamEffect = new HealBeamEffect(EffectIDList.HEALBEAM_EFFECT,PatternManager.effectPatterns[EffectIDList.HEALBEAM_EFFECT],[param2]);
         _loc5_.id = param2;
         if(!this.effectsManager.doesEffectExistOn(_loc3_,EffectIDList.HEALBEAM_EFFECT,param2))
         {
            this.effectsManager.addEffect(_loc5_,_loc3_,EffectsManager.NORMAL_EFFECT);
            _loc5_.startEmitter(_loc3_,_loc4_);
            AudioManager.playSoundEffect(77,false,false,_loc3_.x,_loc3_.y);
         }
      }
      
      public function addTractorBeam(param1:int, param2:int) : void
      {
         var _loc3_:MapObject = this.map.getShipManager().getShip(param1);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:MapObject = this.map.getShipManager().getShip(param2);
         if(_loc4_ == null)
         {
         }
         var _loc5_:TractorBeamJob = new TractorBeamJob(this,param1,param2);
         this.tractorBeams[int(param1)] = _loc5_;
         _loc5_.init();
      }
      
      public function isTruce() : Boolean
      {
         if(this.laserAttacks.length == 0 && this.rocketAttacks.length == 0)
         {
            return true;
         }
         return false;
      }
   }
}


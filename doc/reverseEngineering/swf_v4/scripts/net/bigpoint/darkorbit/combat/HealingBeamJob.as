package net.bigpoint.darkorbit.combat
{
   import com.greensock.TweenLite;
   import flash.display.*;
   import flash.events.Event;
   import flash.filters.*;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.fireworks.*;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.ShipManager;
   
   public class HealingBeamJob extends MovieClip
   {
      
      private var beamAnimaionTime:Number = 0.3;
      
      private var boltFadeTime:Number = 3;
      
      private var attacker:MapObject;
      
      public var attackerID:int;
      
      private var originalAttacker:MapObject;
      
      public var originalAttackerID:int;
      
      public var target:MapObject;
      
      private var nextTarget:MapObject;
      
      private var nextTargetID:int;
      
      private var chainArray:Array;
      
      private var boltGraphicActual:Array = new Array();
      
      private var boltGraphicArray:Array = new Array();
      
      private var numFramesBoltAnimation:int;
      
      private var framesToRepeatBoltAnimation:int;
      
      private var boltFinishedAnimating:Boolean = false;
      
      private var boltGraphic:Lightning = new Lightning();
      
      private var currentBoltStage:int = 0;
      
      private var chainLength:int;
      
      private var boltAttackFinished:Boolean = false;
      
      private var attackManager:CombatManager;
      
      private var animationPacing:Sprite = new Sprite();
      
      private var boltLeadingObject:Sprite = new Sprite();
      
      private var overPI:Number = 57.29577951308232;
      
      private var distanceToTarget:Number;
      
      private var scaleFactor:Number;
      
      private var originalBoltWidth:Number = 4;
      
      private var color:uint = 14544639;
      
      private var lightning:Lightning;
      
      private var instantChainBuild:Boolean = false;
      
      public function HealingBeamJob(param1:MapObject, param2:int, param3:CombatManager, param4:Boolean)
      {
         super();
         this.attackManager = param3;
         this.attacker = param1;
         this.attackerID = this.attacker.getUserId();
         this.originalAttackerID = this.attacker.getUserId();
         this.originalAttacker = param1;
         this.chainArray = [param2];
         this.chainLength = this.chainArray.length;
         this.instantChainBuild = param4;
      }
      
      public function init() : void
      {
         if(this.instantChainBuild)
         {
            this.beamAnimaionTime = 1e-7;
         }
         else
         {
            this.beamAnimaionTime = 0.3;
         }
         this.createBoltGraphics();
         this.boltGraphic = this.boltGraphicArray[0];
         this.originalBoltWidth = this.boltGraphic.width;
         this.nextTargetID = this.chainArray[0];
         this.nextTarget = this.attackManager.getMap().getShipManager().getShip(this.nextTargetID);
         this.boltLeadingObject.x = this.originalAttacker.x;
         this.boltLeadingObject.y = this.originalAttacker.y;
         this.attacker = this.originalAttacker;
         this.getDistanceAndScaleFactor();
         this.addEventListener(Event.ENTER_FRAME,this.handleChainBoltUpdate);
         this.createBolt();
      }
      
      private function handleChainBoltUpdate(param1:Event) : void
      {
         var _loc3_:Lightning = null;
         var _loc4_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.boltGraphicArray.length)
         {
            _loc3_ = this.boltGraphicArray[_loc2_];
            if(_loc3_.isAdded)
            {
               if(_loc3_.getAttackerShip() != null && _loc3_.getTargetShip() != null)
               {
                  _loc3_.startX = _loc3_.getAttackerShip().x;
                  _loc3_.startY = _loc3_.getAttackerShip().y;
                  _loc3_.endX = _loc3_.getTargetShip().x;
                  _loc3_.endY = _loc3_.getTargetShip().y;
                  _loc4_ = FastMath.sqrt(Math.pow(_loc3_.getTargetShip().x - _loc3_.getAttackerShip().x,2) + Math.pow(_loc3_.getTargetShip().y - _loc3_.getAttackerShip().y,2));
                  _loc3_.maxLength = _loc4_ * 0.9;
                  _loc3_.maxLengthVary = _loc4_ * 0.5;
               }
               else
               {
                  this.prepareAndReInitialise();
               }
            }
            _loc3_.update();
            _loc2_++;
         }
      }
      
      private function prepareAndReInitialise() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.chainArray.length)
         {
            _loc3_ = int(this.chainArray[_loc1_]);
            if(this.attackManager.getMap().getShipManager().getShip(_loc3_) == null)
            {
            }
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.boltGraphicArray.length)
         {
            if(this.attackManager.getMap().getMain().screenManager.getExplosionLayer().contains(this.boltGraphicArray[_loc2_]))
            {
               this.attackManager.getMap().getMain().screenManager.getExplosionLayer().removeChild(this.boltGraphicArray[_loc2_]);
            }
            _loc2_++;
         }
         this.currentBoltStage = 0;
         this.boltGraphicArray = [];
         this.removeEventListener(Event.ENTER_FRAME,this.handleChainBoltUpdate);
         this.attackManager.removeHealingBeamFrom(this.originalAttacker.getUserId());
      }
      
      private function createBoltGraphics() : void
      {
         var _loc2_:Lightning = null;
         var _loc3_:GlowFilter = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.chainArray.length)
         {
            _loc2_ = new Lightning(this.color,2);
            _loc2_.blendMode = BlendMode.ADD;
            _loc2_.childrenDetachedEnd = false;
            _loc2_.childrenLifeSpanMin = 1;
            _loc2_.childrenLifeSpanMax = 2;
            _loc2_.childrenMaxCount = 3;
            _loc2_.childrenMaxCountDecay = 0.5;
            _loc2_.steps = 45;
            _loc2_.childrenProbability = 0.1;
            _loc2_.thickness = 2.7;
            _loc2_.speed = 2;
            _loc2_.alphaFadeType = LightningFadeType.GENERATION;
            _loc3_ = new GlowFilter();
            _loc3_.color = this.color;
            _loc3_.strength = 3.5;
            _loc3_.quality = 3;
            _loc3_.blurX = _loc3_.blurY = 10;
            _loc2_.filters = [_loc3_];
            _loc2_.attackManager = this.attackManager;
            this.boltGraphicArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function createBolt() : void
      {
         if(this.boltGraphic != null)
         {
            if(this.boltGraphic.getAttackerShip() != null && this.boltGraphic.getTargetShip() != null)
            {
               this.attackManager.getMap().getMain().screenManager.getExplosionLayer().addChild(this.boltGraphic);
               TweenLite.to(this.boltLeadingObject,this.beamAnimaionTime,{
                  "dynamicProps":{
                     "x":this.getTargetShipXPos,
                     "y":this.getTargetShipYPos
                  },
                  "onComplete":this.handleBoltFinishedAnimating,
                  "onUpdate":this.handleUpdate
               });
            }
            else
            {
               this.prepareAndReInitialise();
            }
         }
      }
      
      private function handleUpdate() : void
      {
         this.boltGraphic.endX = this.boltLeadingObject.x;
         this.boltGraphic.endY = this.boltLeadingObject.y;
      }
      
      private function getDistanceAndScaleFactor() : void
      {
         if(this.boltGraphic != null)
         {
            if(this.attackManager.getMap().getShipManager().getShip(this.nextTargetID) != null && Boolean(this.attackManager.getMap().getShipManager().getShip(this.attackerID)))
            {
               this.distanceToTarget = Math.sqrt(Math.pow(this.nextTarget.x - this.attacker.x,2) + Math.pow(this.nextTarget.y - this.attacker.y,2));
               this.boltGraphic.startX = this.attacker.x;
               this.boltGraphic.startY = this.attacker.y;
               this.boltGraphic.endX = this.attacker.x;
               this.boltGraphic.endY = this.attacker.y;
               this.boltGraphic.maxLength = this.distanceToTarget - this.distanceToTarget * 0.1;
               this.boltGraphic.maxLengthVary = this.distanceToTarget * 0.5;
               this.boltGraphic.attackerID = this.attackerID;
               this.boltGraphic.targetID = this.nextTargetID;
            }
            else
            {
               this.prepareAndReInitialise();
            }
         }
      }
      
      private function handleBoltFinishedAnimating() : void
      {
         this.boltGraphic.isAdded = true;
         ++this.currentBoltStage;
         if(this.currentBoltStage < this.chainArray.length)
         {
            this.attacker = this.nextTarget;
            this.attackerID = this.nextTargetID;
            this.nextTargetID = this.chainArray[this.currentBoltStage];
            this.nextTarget = this.attackManager.getMap().getShipManager().getShip(this.nextTargetID);
            this.boltGraphic = this.boltGraphicArray[this.currentBoltStage];
            this.boltFinishedAnimating = false;
            this.getDistanceAndScaleFactor();
            this.createBolt();
         }
         else
         {
            this.boltAttackFinished = true;
            this.cleanUpBolts();
         }
      }
      
      private function fadePreviousBolt(param1:Sprite, param2:int) : void
      {
         param1.alpha = 1;
         TweenLite.to(param1,this.boltFadeTime,{
            "alpha":0,
            "onComplete":this.handleBoltFinished,
            "onCompleteParams":[param1,param2]
         });
      }
      
      private function handleBoltFinished(param1:Sprite, param2:int) : void
      {
         if(this.attackManager.getMap().getMain().screenManager.getExplosionLayer().contains(param1))
         {
            this.attackManager.getMap().getMain().screenManager.getExplosionLayer().removeChild(param1);
         }
         param1.removeEventListener(Event.ENTER_FRAME,this.showRandomLastFrames);
         if(param2 == this.boltGraphicArray.length - 1)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.handleChainBoltUpdate);
            this.cleanup();
         }
      }
      
      private function cleanUpBolts() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.boltGraphicArray.length)
         {
            this.fadePreviousBolt(this.boltGraphicArray[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      private function getScaleFactor() : Number
      {
         return this.scaleFactor;
      }
      
      private function getTargetShipXPos() : Number
      {
         return this.nextTarget.x;
      }
      
      private function getTargetShipYPos() : Number
      {
         return this.nextTarget.y;
      }
      
      private function getDistanceToTarget() : Number
      {
         return this.distanceToTarget;
      }
      
      private function showRandomLastFrames(param1:Event) : void
      {
         var _loc2_:int = Math.round(Math.random() * (this.numFramesBoltAnimation - this.framesToRepeatBoltAnimation)) + this.framesToRepeatBoltAnimation;
         param1.currentTarget.gotoAndStop(_loc2_);
         var _loc3_:Number = Math.round(Math.random() * (1 - 0.7)) + 0.7;
         param1.currentTarget.alpha = _loc3_;
      }
      
      private function repeatLastFramesRandomly(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = param1;
         param1.addEventListener(Event.ENTER_FRAME,this.showRandomLastFrames);
      }
      
      public function cleanup() : void
      {
         var _loc4_:MapObject = null;
         var _loc1_:ShipManager = this.attackManager.getMap().getShipManager();
         --this.attacker.numberChainsInvolvedIn;
         if(this.attacker.isDestroyed && this.attacker.numberChainsInvolvedIn < 1)
         {
            if(this.attacker.isHeroShip())
            {
               _loc1_.destroyHero();
            }
            else
            {
               _loc1_.removeOpponentShip(this.attacker.getUserId(),this.attacker.displaysExplosion);
            }
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.chainArray.length)
         {
            _loc4_ = _loc1_.getShip(this.chainArray[_loc2_]);
            if(_loc4_ != null)
            {
               --_loc4_.numberChainsInvolvedIn;
               if(_loc4_.isDestroyed && _loc4_.numberChainsInvolvedIn < 1)
               {
                  if(_loc4_.isHeroShip())
                  {
                     _loc1_.destroyHero();
                  }
                  else
                  {
                     _loc1_.removeOpponentShip(this.chainArray[_loc2_],_loc4_.displaysExplosion);
                  }
               }
            }
            _loc2_++;
         }
         this.attackManager.removeHealingBeamFrom(this.originalAttackerID);
         var _loc3_:int = 0;
         while(_loc3_ < this.boltGraphicArray.length)
         {
            if(this.attackManager.getMap().getMain().screenManager.getExplosionLayer().contains(this.boltGraphicArray[_loc3_]))
            {
               this.attackManager.getMap().getMain().screenManager.getExplosionLayer().removeChild(this.boltGraphicArray[_loc3_]);
            }
            _loc3_++;
         }
         this.boltGraphicArray = [];
         this.removeEventListener(Event.ENTER_FRAME,this.handleChainBoltUpdate);
      }
   }
}


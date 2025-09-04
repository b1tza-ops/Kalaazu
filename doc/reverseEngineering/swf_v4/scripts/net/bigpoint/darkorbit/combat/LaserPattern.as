package net.bigpoint.darkorbit.combat
{
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   
   public class LaserPattern extends AudibleResourcePattern
   {
      
      private var laserClass:int;
      
      private var fireRate:int;
      
      private var muzzleFlashID:int;
      
      public var laserLength:int;
      
      private var absorber:Boolean;
      
      private var speed:Number = 0.15;
      
      public var playLoop:Boolean;
      
      private var playLoopRotated:Boolean;
      
      private var attackLength:int = 1350;
      
      public var skillResKey:String;
      
      public function LaserPattern(param1:int, param2:int, param3:String, param4:int)
      {
         super(param2,param3);
         this.laserClass = param1;
         this.fireRate = param4;
      }
      
      public function getFireRate() : int
      {
         return this.fireRate;
      }
      
      public function getLaserClass() : int
      {
         return this.laserClass;
      }
      
      public function getMuzzleFlashID() : int
      {
         return this.muzzleFlashID;
      }
      
      public function setLaserFlashID(param1:int) : void
      {
         this.muzzleFlashID = param1;
      }
      
      public function isAbsorber() : Boolean
      {
         return this.absorber;
      }
      
      public function setAbsorber(param1:Boolean) : void
      {
         this.absorber = param1;
      }
      
      public function getSpeed() : Number
      {
         return this.speed;
      }
      
      public function setSpeed(param1:Number) : void
      {
         this.speed = param1;
      }
      
      public function setPlayLoop(param1:Boolean) : void
      {
         this.playLoop = param1;
      }
      
      public function isPlayLoopRotated() : Boolean
      {
         return this.playLoopRotated;
      }
      
      public function setPlayLoopRotated(param1:Boolean) : void
      {
         this.playLoopRotated = param1;
      }
      
      public function getAttackLength() : int
      {
         return this.attackLength;
      }
      
      public function setAttackLength(param1:int) : void
      {
         this.attackLength = param1;
      }
   }
}


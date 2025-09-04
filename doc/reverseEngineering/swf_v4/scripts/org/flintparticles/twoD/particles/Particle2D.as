package org.flintparticles.twoD.particles
{
   import flash.geom.Matrix;
   import org.flintparticles.common.particles.Particle;
   import org.flintparticles.common.particles.ParticleFactory;
   
   public class Particle2D extends Particle
   {
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var previousX:Number = 0;
      
      public var previousY:Number = 0;
      
      public var velX:Number = 0;
      
      public var velY:Number = 0;
      
      public var rotation:Number = 0;
      
      public var angVelocity:Number = 0;
      
      private var _previousMass:Number;
      
      private var _previousRadius:Number;
      
      private var _inertia:Number;
      
      public var sortID:int = -1;
      
      public function Particle2D()
      {
         super();
      }
      
      public function get inertia() : Number
      {
         if(mass != this._previousMass || collisionRadius != this._previousRadius)
         {
            this._inertia = mass * collisionRadius * collisionRadius * 0.5;
            this._previousMass = mass;
            this._previousRadius = collisionRadius;
         }
         return this._inertia;
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.x = 0;
         this.y = 0;
         this.previousX = 0;
         this.previousY = 0;
         this.velX = 0;
         this.velY = 0;
         this.rotation = 0;
         this.angVelocity = 0;
         this.sortID = -1;
      }
      
      public function get matrixTransform() : Matrix
      {
         var _loc1_:Number = scale * Math.cos(this.rotation);
         var _loc2_:Number = scale * Math.sin(this.rotation);
         return new Matrix(_loc1_,_loc2_,-_loc2_,_loc1_,this.x,this.y);
      }
      
      override public function clone(param1:ParticleFactory = null) : Particle
      {
         var _loc2_:Particle2D = null;
         if(param1)
         {
            _loc2_ = param1.createParticle() as Particle2D;
         }
         else
         {
            _loc2_ = new Particle2D();
         }
         cloneInto(_loc2_);
         _loc2_.x = this.x;
         _loc2_.y = this.y;
         _loc2_.velX = this.velX;
         _loc2_.velY = this.velY;
         _loc2_.rotation = this.rotation;
         _loc2_.angVelocity = this.angVelocity;
         return _loc2_;
      }
   }
}


package org.flintparticles.common.events
{
   import flash.events.Event;
   import org.flintparticles.common.particles.Particle;
   
   public class ParticleEvent extends Event
   {
      
      public static var PARTICLE_CREATED:String = "particleCreated";
      
      public static var PARTICLE_DEAD:String = "particleDead";
      
      public static var PARTICLE_ADDED:String = "particleAdded";
      
      public static var PARTICLES_COLLISION:String = "particlesCollision";
      
      public static var ZONE_COLLISION:String = "zoneCollision";
      
      public static var BOUNDING_BOX_COLLISION:String = "boundingBoxCollision";
      
      public var particle:Particle;
      
      public var otherObject:*;
      
      public function ParticleEvent(param1:String, param2:Particle = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.particle = param2;
      }
      
      override public function clone() : Event
      {
         var _loc1_:ParticleEvent = new ParticleEvent(type,this.particle,bubbles,cancelable);
         _loc1_.otherObject = this.otherObject;
         return _loc1_;
      }
   }
}


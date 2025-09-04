package org.flintparticles.twoD.zones
{
   import flash.geom.Point;
   import org.flintparticles.twoD.particles.Particle2D;
   
   public interface Zone2D
   {
      
      function contains(param1:Number, param2:Number) : Boolean;
      
      function getLocation() : Point;
      
      function getArea() : Number;
      
      function collideParticle(param1:Particle2D, param2:Number = 1) : Boolean;
   }
}


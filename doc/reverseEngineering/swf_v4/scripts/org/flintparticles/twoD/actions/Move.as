package org.flintparticles.twoD.actions
{
   import org.flintparticles.common.actions.ActionBase;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.particles.Particle;
   import org.flintparticles.twoD.particles.Particle2D;
   
   public class Move extends ActionBase
   {
      
      public function Move()
      {
         super();
         priority = -10;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc4_:Particle2D = Particle2D(param2);
         _loc4_.previousX = _loc4_.x;
         _loc4_.previousY = _loc4_.y;
         _loc4_.x += _loc4_.velX * param3;
         _loc4_.y += _loc4_.velY * param3;
      }
   }
}


package org.flintparticles.common.actions
{
   import org.flintparticles.common.behaviours.Behaviour;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.particles.Particle;
   
   public interface Action extends Behaviour
   {
      
      function update(param1:Emitter, param2:Particle, param3:Number) : void;
   }
}


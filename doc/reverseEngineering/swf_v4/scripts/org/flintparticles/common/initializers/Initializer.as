package org.flintparticles.common.initializers
{
   import org.flintparticles.common.behaviours.Behaviour;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.particles.Particle;
   
   public interface Initializer extends Behaviour
   {
      
      function initialize(param1:Emitter, param2:Particle) : void;
   }
}


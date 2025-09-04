package org.flintparticles.common.activities
{
   import org.flintparticles.common.behaviours.Behaviour;
   import org.flintparticles.common.emitters.Emitter;
   
   public interface Activity extends Behaviour
   {
      
      function initialize(param1:Emitter) : void;
      
      function update(param1:Emitter, param2:Number) : void;
   }
}


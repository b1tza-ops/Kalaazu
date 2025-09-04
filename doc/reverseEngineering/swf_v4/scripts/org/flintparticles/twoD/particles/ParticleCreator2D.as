package org.flintparticles.twoD.particles
{
   import org.flintparticles.common.debug.ParticleFactoryStats;
   import org.flintparticles.common.particles.Particle;
   import org.flintparticles.common.particles.ParticleFactory;
   
   public class ParticleCreator2D implements ParticleFactory
   {
      
      private var _particles:Vector.<Particle>;
      
      public function ParticleCreator2D()
      {
         super();
         this._particles = new Vector.<Particle>();
      }
      
      public function createParticle() : Particle
      {
         ++ParticleFactoryStats.numParticles;
         if(this._particles.length)
         {
            return this._particles.pop();
         }
         return new Particle2D();
      }
      
      public function disposeParticle(param1:Particle) : void
      {
         --ParticleFactoryStats.numParticles;
         if(param1 is Particle2D)
         {
            param1.initialize();
            this._particles.push(param1);
         }
      }
      
      public function clearAllParticles() : void
      {
         this._particles = new Vector.<Particle>();
      }
   }
}


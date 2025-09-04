package org.flintparticles.common.renderers
{
   import flash.display.Sprite;
   import flash.events.Event;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.events.EmitterEvent;
   import org.flintparticles.common.events.ParticleEvent;
   import org.flintparticles.common.particles.Particle;
   
   public class SpriteRendererBase extends Sprite implements Renderer
   {
      
      protected var _emitters:Vector.<Emitter>;
      
      protected var _particles:Array;
      
      public function SpriteRendererBase()
      {
         super();
         this._emitters = new Vector.<Emitter>();
         this._particles = [];
         mouseEnabled = false;
         mouseChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
      }
      
      public function addEmitter(param1:Emitter) : void
      {
         var _loc2_:Particle = null;
         this._emitters.push(param1);
         if(stage)
         {
            stage.invalidate();
         }
         param1.addEventListener(EmitterEvent.EMITTER_UPDATED,this.emitterUpdated,false,0,true);
         param1.addEventListener(ParticleEvent.PARTICLE_CREATED,this.particleAdded,false,0,true);
         param1.addEventListener(ParticleEvent.PARTICLE_ADDED,this.particleAdded,false,0,true);
         param1.addEventListener(ParticleEvent.PARTICLE_DEAD,this.particleRemoved,false,0,true);
         for each(_loc2_ in param1.particlesArray)
         {
            this.addParticle(_loc2_);
         }
         if(this._emitters.length == 1)
         {
            addEventListener(Event.RENDER,this.updateParticles,false,0,true);
         }
      }
      
      public function removeEmitter(param1:Emitter) : void
      {
         var _loc3_:Particle = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._emitters.length)
         {
            if(this._emitters[_loc2_] == param1)
            {
               this._emitters.splice(_loc2_,1);
               param1.removeEventListener(EmitterEvent.EMITTER_UPDATED,this.emitterUpdated);
               param1.removeEventListener(ParticleEvent.PARTICLE_CREATED,this.particleAdded);
               param1.removeEventListener(ParticleEvent.PARTICLE_ADDED,this.particleAdded);
               param1.removeEventListener(ParticleEvent.PARTICLE_DEAD,this.particleRemoved);
               for each(_loc3_ in param1.particlesArray)
               {
                  this.removeParticle(_loc3_);
               }
               if(this._emitters.length == 0)
               {
                  removeEventListener(Event.RENDER,this.updateParticles);
                  this.renderParticles([]);
               }
               else if(stage)
               {
                  stage.invalidate();
               }
               return;
            }
            _loc2_++;
         }
      }
      
      private function addedToStage(param1:Event) : void
      {
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      private function particleAdded(param1:ParticleEvent) : void
      {
         this.addParticle(param1.particle);
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      private function particleRemoved(param1:ParticleEvent) : void
      {
         this.removeParticle(param1.particle);
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      protected function emitterUpdated(param1:EmitterEvent) : void
      {
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      protected function updateParticles(param1:Event) : void
      {
         this.renderParticles(this._particles);
      }
      
      protected function addParticle(param1:Particle) : void
      {
         this._particles.push(param1);
      }
      
      protected function removeParticle(param1:Particle) : void
      {
         var _loc2_:int = int(this._particles.indexOf(param1));
         if(_loc2_ != -1)
         {
            this._particles.splice(_loc2_,1);
         }
      }
      
      protected function renderParticles(param1:Array) : void
      {
      }
      
      public function get emitters() : Vector.<Emitter>
      {
         return this._emitters;
      }
      
      public function set emitters(param1:Vector.<Emitter>) : void
      {
         var _loc2_:Emitter = null;
         for each(_loc2_ in this._emitters)
         {
            this.removeEmitter(_loc2_);
         }
         for each(_loc2_ in param1)
         {
            this.addEmitter(_loc2_);
         }
      }
   }
}


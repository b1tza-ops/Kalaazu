package org.flintparticles.twoD.actions
{
   import org.flintparticles.common.actions.ActionBase;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.particles.Particle;
   import org.flintparticles.twoD.particles.Particle2D;
   import org.flintparticles.twoD.zones.Zone2D;
   
   public class DeathZone extends ActionBase
   {
      
      private var _zone:Zone2D;
      
      private var _invertZone:Boolean;
      
      private var p:Particle2D;
      
      private var inside:Boolean;
      
      public function DeathZone(param1:Zone2D = null, param2:Boolean = false)
      {
         super();
         priority = -20;
         this.zone = param1;
         this.zoneIsSafe = param2;
      }
      
      public function get zone() : Zone2D
      {
         return this._zone;
      }
      
      public function set zone(param1:Zone2D) : void
      {
         this._zone = param1;
      }
      
      public function get zoneIsSafe() : Boolean
      {
         return this._invertZone;
      }
      
      public function set zoneIsSafe(param1:Boolean) : void
      {
         this._invertZone = param1;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         this.p = Particle2D(param2);
         this.inside = this._zone.contains(this.p.x,this.p.y);
         if(this._invertZone)
         {
            if(!this.inside)
            {
               this.p.isDead = true;
            }
         }
         else if(this.inside)
         {
            this.p.isDead = true;
         }
      }
   }
}


package net.bigpoint.darkorbit.ship.effects
{
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import org.flintparticles.common.counters.Pulse;
   import org.flintparticles.common.initializers.ColorInit;
   import org.flintparticles.twoD.actions.DeathZone;
   import org.flintparticles.twoD.actions.Move;
   import org.flintparticles.twoD.emitters.Emitter2D;
   import org.flintparticles.twoD.initializers.Position;
   import org.flintparticles.twoD.initializers.Velocity;
   import org.flintparticles.twoD.renderers.PixelRenderer;
   import org.flintparticles.twoD.zones.DiscZone;
   import org.flintparticles.twoD.zones.LineZone;
   import org.flintparticles.twoD.zones.PointZone;
   
   public class HealBeamEffect extends EffectBase
   {
      
      private var emitter:Emitter2D;
      
      private var renderer:PixelRenderer;
      
      private var velocity:Velocity;
      
      private var move:Move = new Move();
      
      private var timer:Timer = new Timer(1000 * 2,1);
      
      private var updateTimer:Timer = new Timer(10,250);
      
      private const DIS_X:Number = 550;
      
      private const DIS_Y:Number = 40;
      
      private var angle:Number;
      
      private var rayHeight:Number;
      
      private var distance:Number;
      
      private var oldDistance:Number;
      
      private var oldHeight:Number;
      
      private var particleCount:Number;
      
      private var pulse:Pulse;
      
      private var attackerShip:MapObject;
      
      private var targetShip:MapObject;
      
      private var dZone:DiscZone = new DiscZone(new Point(0,0),200);
      
      private var effectID:int;
      
      private var maxDistance:Number;
      
      private const RADIANS:Number = 57.29577951308232;
      
      public function HealBeamEffect(param1:int, param2:EffectPattern, param3:Array = null, param4:Boolean = true)
      {
         super(param1,param2,false,param3,param4);
         this.effectID = param3[0];
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.stopEmitter);
      }
      
      override public function initEffectVisuals() : void
      {
         this.emitter = new Emitter2D();
         this.emitter.addInitializer(new ColorInit(4278255360,4278255360));
         var _loc1_:PointZone = new PointZone(new Point(0,0));
         var _loc2_:Position = new Position(_loc1_);
         this.emitter.addInitializer(_loc2_);
      }
      
      private function deleteParticles(param1:Point, param2:Number) : void
      {
         this.dZone.center = param1;
         this.dZone.outerRadius = param2 + 200;
      }
      
      public function startEmitter(param1:MapObject, param2:MapObject) : void
      {
         switch(Settings.resolutionID)
         {
            case 0:
               this.maxDistance = 820;
               break;
            case 1:
            case 2:
               this.maxDistance = 1024;
               break;
            case 3:
            case 4:
               this.maxDistance = 1280;
         }
         this.attackerShip = param1;
         this.targetShip = param2;
         this.updateTimer.addEventListener(TimerEvent.TIMER,this.updateRay);
         this.updateTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.resetTimer);
         this.oldDistance = Math.sqrt(Math.pow(this.targetShip.y - this.attackerShip.y,2) + Math.pow(this.targetShip.x - this.attackerShip.x,2));
         this.oldDistance = this.oldDistance > this.maxDistance ? 20 : this.oldDistance;
         this.oldHeight = this.oldDistance * this.DIS_Y / this.DIS_X << 1;
         var _loc3_:BlurFilter = new BlurFilter(4,4,1);
         var _loc4_:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.99,0]);
         this.renderer = new PixelRenderer(new Rectangle(0,this.oldHeight * -0.5,this.oldDistance,this.oldHeight));
         this.renderer.name = "renderer";
         this.renderer.addFilter(_loc3_);
         this.renderer.addFilter(_loc4_);
         this.pulse = new Pulse(0.2,10);
         this.updateRay();
         var _loc5_:Point = new Point(this.DIS_X,this.DIS_Y);
         var _loc6_:Point = new Point(this.DIS_X,~this.DIS_Y + 1);
         var _loc7_:LineZone = new LineZone(_loc5_,_loc6_);
         this.velocity = new Velocity(_loc7_);
         this.emitter.addInitializer(this.velocity);
         var _loc8_:DeathZone = new DeathZone(this.dZone,true);
         this.emitter.addAction(_loc8_);
         this.emitter.counter = this.pulse;
         this.emitter.addAction(this.move);
         this.renderer.addEmitter(this.emitter);
         if(!getEffect().getChildByName("renderer"))
         {
            getEffect().addChild(this.renderer);
         }
         this.emitter.start();
         this.timer.start();
         this.updateTimer.start();
      }
      
      public function stopEmitter(param1:TimerEvent = null) : void
      {
         this.pulse.stop();
         this.timer.stop();
         this.timer.reset();
         this.emitter.killAllParticles();
         this.emitter.removeInitializer(this.velocity);
         this.emitter.removeAction(this.move);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.stopEmitter);
      }
      
      public function updateRay(param1:TimerEvent = null) : void
      {
         if(Boolean(this.targetShip.getShipManager().getShip(this.targetShip.userID)) && Boolean(this.attackerShip.getShipManager().getShip(this.attackerShip.userID)))
         {
            this.angle = Math.atan2(this.targetShip.y - this.attackerShip.y,this.targetShip.x - this.attackerShip.x) * this.RADIANS;
            this.distance = Math.sqrt(Math.pow(this.targetShip.y - this.attackerShip.y,2) + Math.pow(this.targetShip.x - this.attackerShip.x,2));
            this.distance = this.distance > this.maxDistance ? 20 : this.distance;
            this.rayHeight = this.distance * this.DIS_Y / this.DIS_X << 1;
            this.rayHeight = this.rayHeight > 30 ? 30 : this.rayHeight;
            this.renderer.scaleX = this.distance / this.oldDistance;
            this.renderer.scaleY = this.rayHeight / this.oldHeight;
            this.particleCount = this.distance >> 2;
            this.pulse.quantity = this.particleCount;
            this.renderer.rotation = this.angle;
            this.deleteParticles(new Point(0,this.rayHeight * -0.5),this.distance);
         }
         else
         {
            this.stopEmitter();
         }
      }
      
      public function resetTimer(param1:TimerEvent) : void
      {
         this.updateTimer.stop();
         this.updateTimer.reset();
         this.updateTimer.removeEventListener(TimerEvent.TIMER,this.updateRay);
         this.updateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.resetTimer);
         dispatchEvent(new EntityEffectEvent(EntityEffectEvent.EFFECT_TIMEOUT,id));
      }
   }
}


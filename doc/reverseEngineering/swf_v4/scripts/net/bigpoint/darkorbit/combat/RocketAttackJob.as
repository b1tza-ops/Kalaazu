package net.bigpoint.darkorbit.combat
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ObjectPoolManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class RocketAttackJob
   {
      
      private static const logger:ILogger = Log.getLogger("RocketAttackJob");
      
      private var attackManager:CombatManager;
      
      private var attackerShip:MapObject;
      
      public var targetShip:MapObject;
      
      private var rocketClip:MovieClip;
      
      private var hit:Boolean;
      
      public var rocketSmokePattern:RocketSmokePattern;
      
      private var rocketSmokeTimer:Timer;
      
      private var explosionLayer:Sprite;
      
      private var heatSeeking:Boolean;
      
      public var xGap:int = 0;
      
      public var yGap:int = 0;
      
      public var pulseClip:MovieClip;
      
      public var duration:Number;
      
      public var airstrikeMode:Boolean;
      
      public function RocketAttackJob(param1:CombatManager, param2:MapObject, param3:MapObject, param4:MovieClip, param5:Boolean, param6:Number, param7:RocketSmokePattern, param8:Boolean, param9:MovieClip)
      {
         super();
         this.attackManager = param1;
         this.attackerShip = param2;
         this.targetShip = param3;
         this.rocketClip = param4;
         this.hit = param5;
         this.duration = param6;
         this.rocketSmokePattern = param7;
         this.explosionLayer = param1.getMap().getMain().screenManager.getExplosionLayer();
         this.heatSeeking = param8;
         this.pulseClip = param9;
      }
      
      public function init() : void
      {
         if(this.hit)
         {
            if(this.heatSeeking)
            {
               this.xGap = Main.getRandomCount(-800,800);
               this.yGap = Main.getRandomCount(-800,800);
               TweenLite.to(this,this.duration,{
                  "xGap":0,
                  "yGap":0
               });
            }
            TweenLite.to(this.rocketClip,this.duration,{
               "dynamicProps":{
                  "x":this.getTargetShipXPos,
                  "y":this.getTargetShipYPos
               },
               "onComplete":this.onFinishRocketTween,
               "onCompleteParams":[this.rocketClip,this.targetShip.getUserId()],
               "onUpdate":this.onUpdate
            });
         }
         else
         {
            TweenLite.to(this.rocketClip,this.duration,{
               "ease":Linear.easeNone,
               "x":this.targetShip.x,
               "y":this.targetShip.y,
               "onComplete":this.onFinishRocketTween,
               "onCompleteParams":[this.rocketClip,this.targetShip.getUserId()]
            });
         }
         if(Settings.rocketSmoke)
         {
            this.rocketSmokeTimer = new Timer(this.rocketSmokePattern.particleInterval,0);
            this.rocketSmokeTimer.addEventListener(TimerEvent.TIMER,this.addRocketSmoke);
            this.rocketSmokeTimer.start();
         }
      }
      
      public function onFinishRocketTween(param1:MovieClip, param2:int) : void
      {
         var _loc3_:Map = null;
         var _loc4_:ExplosionPattern = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 != null)
         {
            _loc3_ = this.attackManager.getMap();
            if(_loc3_ != null)
            {
               _loc3_.getMain().screenManager.getExplosionLayer().removeChild(param1);
               if(this.pulseClip != null)
               {
                  TweenLite.killTweensOf(this.pulseClip);
                  param1.removeChild(this.pulseClip);
               }
            }
         }
         this.attackManager.removeRocketAttackTo(param2);
         if(!this.hit)
         {
            if(Settings.displayHitpointBubbles)
            {
               _loc3_ = this.attackManager.getMap();
               if(_loc3_ != null)
               {
                  _loc3_.getMain().getGuiManager().showHitpointDelta(this.targetShip,0);
               }
            }
            _loc4_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,1);
            this.attackManager.showPyroEffect(param1.x,param1.y,_loc4_);
         }
         if(this.rocketSmokeTimer != null)
         {
            this.rocketSmokeTimer.stop();
            this.rocketSmokeTimer.removeEventListener(TimerEvent.TIMER,this.addRocketSmoke);
         }
         if(this.airstrikeMode)
         {
            _loc4_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,1);
            _loc5_ = Main.getRandomCount(-40,40);
            _loc6_ = Main.getRandomCount(-40,40);
            this.attackManager.showPyroEffect(this.targetShip.x + _loc5_,this.targetShip.y + _loc6_,_loc4_,37,true,true);
         }
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Number = Math.atan2(this.targetShip.y - this.rocketClip.y,this.targetShip.x - this.rocketClip.x) * 180 / Math.PI;
         this.rocketClip.rotation = Math.round(_loc1_ + 180);
      }
      
      public function getClip() : MovieClip
      {
         return this.rocketClip;
      }
      
      private function getTargetShipXPos() : Number
      {
         if(this.heatSeeking)
         {
            return this.targetShip.x + this.xGap;
         }
         return this.targetShip.x;
      }
      
      private function getTargetShipYPos() : Number
      {
         if(this.heatSeeking)
         {
            return this.targetShip.y + this.yGap;
         }
         return this.targetShip.y;
      }
      
      private function addRocketSmoke(param1:TimerEvent) : void
      {
         var _loc2_:BitmapClip = ObjectPoolManager.getRocketSmokeClip(this.rocketSmokePattern.resKey);
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.x = this.rocketClip.x;
         _loc2_.y = this.rocketClip.y;
         this.explosionLayer.addChild(_loc2_);
         _loc2_.frame = 1;
         TweenLite.to(_loc2_,this.rocketSmokePattern.particleDuration,{
            "ease":Linear.easeNone,
            "frame":_loc2_.framesLoaded,
            "onComplete":this.handleSmokeFinished,
            "onCompleteParams":[_loc2_]
         });
      }
      
      private function handleSmokeFinished(param1:BitmapClip) : void
      {
         if(param1 != null)
         {
            this.explosionLayer.removeChild(param1);
            ObjectPoolManager.addRocketSmokeClip(param1);
         }
      }
   }
}


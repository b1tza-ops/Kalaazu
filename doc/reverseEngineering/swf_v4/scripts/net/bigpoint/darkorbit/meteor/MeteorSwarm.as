package net.bigpoint.darkorbit.meteor
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class MeteorSwarm extends MovieClip
   {
      
      private var resKey:String;
      
      private var rect:Rectangle;
      
      private var finisher:SWFFinisher;
      
      private var speed:int;
      
      private var meteorManager:MeteorManager;
      
      private var timer:Timer;
      
      public function MeteorSwarm(param1:MeteorManager, param2:String, param3:Rectangle, param4:int, param5:int, param6:int = 25)
      {
         super();
         this.meteorManager = param1;
         this.resKey = param2;
         this.rect = param3;
         this.speed = param5;
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param2));
         this.timer = new Timer(param4,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.spawnMeteorit);
         this.timer.start();
      }
      
      public function cleanup() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.spawnMeteorit);
      }
      
      private function spawnMeteorit(param1:TimerEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:MovieClip = this.finisher.getEmbededMovieClip("mc");
         _loc2_.mouseEnabled = Main.mouseEventsEnabled;
         _loc2_.mouseChildren = Main.mouseEventsEnabled;
         var _loc3_:int = Math.floor(Math.random() * 4);
         switch(_loc3_)
         {
            case 0:
               _loc4_ = Math.floor(Math.random() * this.rect.width);
               _loc5_ = Math.floor(Math.random() * this.rect.width);
               _loc6_ = this.rect.y - _loc2_.height;
               _loc7_ = this.rect.height + _loc2_.height;
               break;
            case 1:
               _loc4_ = this.rect.width + _loc2_.width;
               _loc5_ = this.rect.x - _loc2_.width;
               _loc6_ = Math.floor(Math.random() * this.rect.height);
               _loc7_ = Math.floor(Math.random() * this.rect.height);
               break;
            case 2:
               _loc4_ = Math.floor(Math.random() * this.rect.width);
               _loc5_ = Math.floor(Math.random() * this.rect.width);
               _loc6_ = this.rect.height + _loc2_.height;
               _loc7_ = this.rect.y - _loc2_.height;
               break;
            case 3:
               _loc4_ = this.rect.x - _loc2_.width;
               _loc5_ = this.rect.width + _loc2_.width;
               _loc6_ = Math.floor(Math.random() * this.rect.height);
               _loc7_ = Math.floor(Math.random() * this.rect.height);
         }
         _loc2_.x = _loc4_;
         _loc2_.y = _loc6_;
         _loc2_.play();
         this.addChild(_loc2_);
         TweenLite.to(_loc2_,this.speed,{
            "ease":Linear.easeNone,
            "x":_loc5_,
            "y":_loc7_,
            "onComplete":this.onFinishTween,
            "onCompleteParams":[_loc2_]
         });
      }
      
      private function onFinishTween(param1:MovieClip) : void
      {
         if(param1 != null)
         {
            this.removeChild(param1);
         }
      }
   }
}


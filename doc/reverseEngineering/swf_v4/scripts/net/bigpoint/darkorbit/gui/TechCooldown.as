package net.bigpoint.darkorbit.gui
{
   import com.greensock.TweenMax;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class TechCooldown
   {
      
      private static const logger:ILogger = Log.getLogger("TechCooldown");
      
      public var frameIndex:int = 1;
      
      public var seconds:int;
      
      public var startingTime:int;
      
      public var techID:int;
      
      public var isRunning:Boolean;
      
      public var onCompleteCallback:Function;
      
      public function TechCooldown(param1:int, param2:int)
      {
         super();
         this.techID = param1;
         this.seconds = param2;
         this.startingTime = param2;
      }
      
      public function cleanup() : void
      {
      }
      
      public function update() : void
      {
         if(this.seconds > 0 && !this.isRunning)
         {
            this.isRunning = true;
            this.tick();
         }
      }
      
      private function tick() : void
      {
         --this.seconds;
         if(this.seconds > 0)
         {
            TweenMax.delayedCall(1,this.tick);
         }
         else
         {
            this.isRunning = false;
            if(this.onCompleteCallback != null)
            {
               this.onCompleteCallback(this.techID);
            }
         }
      }
   }
}


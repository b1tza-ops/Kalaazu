package org.flintparticles.common.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import org.flintparticles.common.events.UpdateEvent;
   
   public class FrameUpdater extends EventDispatcher
   {
      
      private static var _instance:FrameUpdater;
      
      private var _shape:Shape;
      
      private var _time:Number;
      
      private var _running:Boolean = false;
      
      public function FrameUpdater()
      {
         super();
         this._shape = new Shape();
      }
      
      public static function get instance() : FrameUpdater
      {
         if(_instance == null)
         {
            _instance = new FrameUpdater();
         }
         return _instance;
      }
      
      private function startTimer() : void
      {
         this._shape.addEventListener(Event.ENTER_FRAME,this.frameUpdate,false,0,true);
         this._time = getTimer();
         this._running = true;
      }
      
      private function stopTimer() : void
      {
         this._shape.removeEventListener(Event.ENTER_FRAME,this.frameUpdate);
         this._running = false;
      }
      
      private function frameUpdate(param1:Event) : void
      {
         var _loc2_:int = this._time;
         this._time = getTimer();
         var _loc3_:Number = (this._time - _loc2_) * 0.001;
         dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE,_loc3_));
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         if(!this._running && hasEventListener(UpdateEvent.UPDATE))
         {
            this.startTimer();
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         if(this._running && !hasEventListener(UpdateEvent.UPDATE))
         {
            this.stopTimer();
         }
      }
   }
}


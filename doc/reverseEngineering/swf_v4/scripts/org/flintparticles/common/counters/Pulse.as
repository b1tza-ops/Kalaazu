package org.flintparticles.common.counters
{
   import org.flintparticles.common.emitters.Emitter;
   
   public class Pulse implements Counter
   {
      
      private var _timeToNext:Number;
      
      private var _period:Number;
      
      private var _quantity:Number;
      
      private var _running:Boolean;
      
      public function Pulse(param1:Number = 1, param2:uint = 0)
      {
         super();
         this._running = false;
         this._quantity = param2;
         this._period = param1;
      }
      
      public function stop() : void
      {
         this._running = false;
      }
      
      public function resume() : void
      {
         this._running = true;
      }
      
      public function get period() : Number
      {
         return this._period;
      }
      
      public function set period(param1:Number) : void
      {
         this._period = param1;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
      
      public function set quantity(param1:uint) : void
      {
         this._quantity = param1;
      }
      
      public function startEmitter(param1:Emitter) : uint
      {
         this._running = true;
         this._timeToNext = this._period;
         return this._quantity;
      }
      
      public function updateEmitter(param1:Emitter, param2:Number) : uint
      {
         if(!this._running)
         {
            return 0;
         }
         var _loc3_:uint = 0;
         this._timeToNext -= param2;
         while(this._timeToNext <= 0)
         {
            _loc3_ += this._quantity;
            this._timeToNext += this._period;
         }
         return _loc3_;
      }
      
      public function get complete() : Boolean
      {
         return false;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
   }
}


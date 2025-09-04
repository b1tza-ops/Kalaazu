package net.bigpoint.darkorbit
{
   public class CommandLog
   {
      
      private static var _instance:CommandLog;
      
      private var _logData:String;
      
      private var _logLines:Array;
      
      private var _bufferSize:int;
      
      private var _last:int;
      
      private var _targets:Array;
      
      public function CommandLog(param1:Function)
      {
         super();
         this.clear();
         this._targets = [];
         if(param1 !== hidden)
         {
            throw new Error("CommandLog is a Singleton and can only be accessed through CommandLog.instance");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function get instance() : CommandLog
      {
         if(_instance == null)
         {
            _instance = new CommandLog(hidden);
         }
         return _instance;
      }
      
      public function addTarget(param1:ICommandLogTarget) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._targets.length)
         {
            if(this._targets[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         param1.writeOutput(this._logData);
         this._targets.push(param1);
      }
      
      public function removeTarget(param1:ICommandLogTarget) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._targets.length)
         {
            if(this._targets[_loc2_] == param1)
            {
               this._targets.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function write(param1:String) : void
      {
         this._logData += param1 + "\n";
         ++this._last;
         this._logLines[this._last] = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._targets.length)
         {
            ICommandLogTarget(this._targets[_loc2_]).writeOutput(param1);
            _loc2_++;
         }
      }
      
      public function getAll() : String
      {
         return this._logData;
      }
      
      public function getLast() : String
      {
         if(this._last == -1 || this._logLines[this._last] == null)
         {
            return "no Log Data";
         }
         return this._logLines[this._last];
      }
      
      public function clear() : void
      {
         this._logData = "";
         this._logLines = [];
         this._bufferSize = 500;
         this._last = -1;
      }
      
      public function passFullInCommand(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._targets.length)
         {
            ICommandLogTarget(this._targets[_loc2_]).passFullInCommand(param1);
            _loc2_++;
         }
      }
   }
}


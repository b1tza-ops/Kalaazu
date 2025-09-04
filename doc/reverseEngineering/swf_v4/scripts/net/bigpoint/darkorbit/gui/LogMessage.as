package net.bigpoint.darkorbit.gui
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   
   public class LogMessage
   {
      
      private static const logger:ILogger = Log.getLogger("LogMessage");
      
      private var message:String;
      
      private var completed:Boolean;
      
      private var charIndex:int;
      
      public function LogMessage(param1:String)
      {
         super();
         this.message = StringUtil.trim(param1);
      }
      
      public function isCompleted() : Boolean
      {
         if(this.charIndex == this.message.length)
         {
            this.completed = true;
         }
         return this.completed;
      }
      
      public function getMessage() : String
      {
         return this.message;
      }
      
      public function getPartialMessage(param1:int) : String
      {
         var _loc2_:int = this.message.length - this.charIndex;
         var _loc3_:int = _loc2_ >= param1 ? param1 : _loc2_;
         this.charIndex += _loc3_;
         return this.message.substring(0,this.charIndex) + "_";
      }
   }
}


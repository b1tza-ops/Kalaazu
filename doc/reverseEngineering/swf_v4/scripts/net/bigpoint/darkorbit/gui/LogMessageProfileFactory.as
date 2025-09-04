package net.bigpoint.darkorbit.gui
{
   public class LogMessageProfileFactory
   {
      
      public static const HIGH_PRIORITY_MESSAGE:String = "HP";
      
      public static const STANDARD_MESSAGE:String = "ST";
      
      public static const STD_MESSAGE_DISPLAY_TIME:int = 4;
      
      public static const HP_MESSAGE_DISPLAY_TIME:int = 10;
      
      public function LogMessageProfileFactory()
      {
         super();
      }
      
      public static function getLogMessageProfile(param1:String) : LogMessageProfile
      {
         var _loc2_:LogMessageProfile = new LogMessageProfile(param1);
         _loc2_.displayTime = getDisplayTimeByType(param1);
         _loc2_.highPriority = isHighPriority(param1);
         return _loc2_;
      }
      
      private static function isHighPriority(param1:String) : Boolean
      {
         return param1 == HIGH_PRIORITY_MESSAGE;
      }
      
      private static function getDisplayTimeByType(param1:String) : int
      {
         if(param1 == STANDARD_MESSAGE)
         {
            return STD_MESSAGE_DISPLAY_TIME;
         }
         return HP_MESSAGE_DISPLAY_TIME;
      }
   }
}


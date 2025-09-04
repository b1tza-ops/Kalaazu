package com.bigpoint.utils
{
   public class TimeFormatter
   {
      
      private static var _delimiter:String = ":";
      
      public function TimeFormatter()
      {
         super();
      }
      
      public static function formatTime(param1:int) : String
      {
         var _loc2_:* = "";
         var _loc3_:int = Math.floor(param1 / 3600);
         if(_loc3_ > 0)
         {
            _loc2_ += _loc3_ + _delimiter;
         }
         param1 -= _loc3_ * 3600;
         var _loc4_:int = Math.floor(param1 / 60);
         if(_loc3_ > 0 && _loc4_ < 10)
         {
            _loc2_ += "0";
         }
         _loc2_ += _loc4_ + _delimiter;
         param1 -= _loc4_ * 60;
         if(param1 < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + String(param1);
      }
   }
}


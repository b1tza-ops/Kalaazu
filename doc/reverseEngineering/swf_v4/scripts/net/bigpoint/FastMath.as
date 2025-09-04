package net.bigpoint
{
   public class FastMath
   {
      
      private static const RADTODEG:Number = 180 / Math.PI;
      
      private static const DEGTORAD:Number = Math.PI / 180;
      
      public function FastMath()
      {
         super();
      }
      
      public static function sqrt(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(isNaN(param1))
         {
            return NaN;
         }
         var _loc2_:Number = 0.002;
         var _loc3_:Number = param1 * 0.25;
         if(param1 == 0)
         {
            return 0;
         }
         do
         {
            _loc5_ = param1 / _loc3_;
            _loc3_ = (_loc3_ + _loc5_) * 0.5;
            _loc4_ = _loc3_ - _loc5_;
            if(_loc4_ < 0)
            {
               _loc4_ = -_loc4_;
            }
         }
         while(_loc4_ > _loc2_);
         
         return _loc3_;
      }
      
      public static function asDegrees(param1:Number) : Number
      {
         return param1 * RADTODEG;
      }
      
      public static function asRadians(param1:Number) : Number
      {
         return param1 * DEGTORAD;
      }
   }
}


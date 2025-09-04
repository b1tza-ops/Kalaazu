package net.bigpoint.darkorbit.map
{
   import flash.display.BitmapData;
   
   public class Line extends BitmapData
   {
      
      public function Line(param1:int, param2:int, param3:Boolean = true, param4:uint = 4294967295)
      {
         super(param1,param2,param3,param4);
      }
      
      public function line(param1:int, param2:int, param3:int, param4:int, param5:uint) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         _loc12_ = param1;
         _loc13_ = param2;
         _loc6_ = param3 - param1;
         _loc7_ = param4 - param2;
         _loc9_ = _loc6_ > 0 ? 1 : -1;
         _loc10_ = _loc7_ > 0 ? 1 : -1;
         _loc6_ = _loc6_ < 0 ? int(-_loc6_) : _loc6_;
         _loc7_ = _loc7_ < 0 ? int(-_loc7_) : _loc7_;
         setPixel32(_loc12_,_loc13_,param5);
         if(_loc6_ > _loc7_)
         {
            _loc11_ = _loc6_ >> 1;
            _loc8_ = 1;
            while(_loc8_ <= _loc6_)
            {
               _loc12_ += _loc9_;
               _loc11_ += _loc7_;
               if(_loc11_ >= _loc6_)
               {
                  _loc11_ -= _loc6_;
                  _loc13_ += _loc10_;
               }
               setPixel32(_loc12_,_loc13_,param5);
               _loc8_++;
            }
         }
         else
         {
            _loc11_ = _loc7_ >> 1;
            _loc8_ = 1;
            while(_loc8_ <= _loc7_)
            {
               _loc13_ += _loc10_;
               _loc11_ += _loc6_;
               if(_loc11_ >= _loc7_)
               {
                  _loc11_ -= _loc7_;
                  _loc12_ += _loc9_;
               }
               setPixel32(_loc12_,_loc13_,param5);
               _loc8_++;
            }
         }
      }
   }
}


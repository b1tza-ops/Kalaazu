package net.bigpoint.darkorbit.collisionDetection
{
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PixelPerfectCollisionDetection
   {
      
      public function PixelPerfectCollisionDetection()
      {
         super();
      }
      
      public static function getCollisionRect(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0) : Rectangle
      {
         var _loc9_:BitmapData = null;
         var _loc10_:BitmapData = null;
         var _loc11_:uint = 0;
         var _loc12_:Rectangle = null;
         var _loc13_:int = 0;
         var _loc6_:Rectangle = param1.getBounds(param3);
         var _loc7_:Rectangle = param2.getBounds(param3);
         var _loc8_:Rectangle = _loc6_.intersection(_loc7_);
         if(_loc8_.size.length > 0)
         {
            if(param4)
            {
               _loc8_.width = Math.ceil(_loc8_.width);
               _loc8_.height = Math.ceil(_loc8_.height);
               _loc9_ = getAlphaMap(param1,_loc8_,BitmapDataChannel.RED,param3);
               _loc10_ = getAlphaMap(param2,_loc8_,BitmapDataChannel.GREEN,param3);
               _loc9_.draw(_loc10_,null,null,BlendMode.LIGHTEN);
               if(param5 <= 0)
               {
                  _loc11_ = 65792;
               }
               else
               {
                  if(param5 > 1)
                  {
                     param5 = 1;
                  }
                  _loc13_ = Math.round(param5 * 255);
                  _loc11_ = uint(_loc13_ << 16 | _loc13_ << 8 | 0);
               }
               _loc12_ = _loc9_.getColorBoundsRect(_loc11_,_loc11_);
               _loc12_.x += _loc8_.x;
               _loc12_.y += _loc8_.y;
               return _loc12_;
            }
            return _loc8_;
         }
         return null;
      }
      
      private static function getAlphaMap(param1:DisplayObject, param2:Rectangle, param3:uint, param4:DisplayObjectContainer) : BitmapData
      {
         var _loc5_:Matrix = param4.transform.concatenatedMatrix.clone();
         _loc5_.invert();
         var _loc6_:Matrix = param1.transform.concatenatedMatrix.clone();
         _loc6_.concat(_loc5_);
         _loc6_.translate(-param2.x,-param2.y);
         var _loc7_:BitmapData = new BitmapData(param2.width,param2.height,true,0);
         _loc7_.draw(param1,_loc6_);
         var _loc8_:BitmapData = new BitmapData(param2.width,param2.height,false,0);
         _loc8_.copyChannel(_loc7_,_loc7_.rect,new Point(0,0),BitmapDataChannel.ALPHA,param3);
         return _loc8_;
      }
      
      public static function getCollisionPoint(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0) : Point
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc6_:Rectangle = getCollisionRect(param1,param2,param3,param4,param5);
         if(_loc6_ != null && _loc6_.size.length > 0)
         {
            _loc7_ = (_loc6_.left + _loc6_.right) / 2;
            _loc8_ = (_loc6_.top + _loc6_.bottom) / 2;
            return new Point(_loc7_,_loc8_);
         }
         return null;
      }
      
      public static function isColliding(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0) : Boolean
      {
         var _loc6_:Rectangle = getCollisionRect(param1,param2,param3,param4,param5);
         if(_loc6_ != null && _loc6_.size.length > 0)
         {
            return true;
         }
         return false;
      }
   }
}


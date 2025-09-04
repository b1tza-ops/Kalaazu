package net.bigpoint.darkorbit.collisionDetection
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class CollisionDetection
   {
      
      private static var s:Stage;
      
      public function CollisionDetection()
      {
         super();
      }
      
      public static function registerStage(param1:Stage) : void
      {
         s = param1;
      }
      
      public static function checkForCollision(param1:Sprite, param2:Sprite, param3:Number = 255) : Rectangle
      {
         var _loc4_:Rectangle = param1.getBounds(s);
         var _loc5_:Rectangle = param2.getBounds(s);
         if(_loc4_.right < _loc5_.left || _loc5_.right < _loc4_.left || (_loc4_.bottom < _loc5_.top || _loc5_.bottom < _loc4_.top))
         {
            return null;
         }
         var _loc6_:Rectangle = new Rectangle();
         _loc6_.left = Math.max(_loc4_.left,_loc5_.left);
         _loc6_.right = Math.min(_loc4_.right,_loc5_.right);
         _loc6_.top = Math.max(_loc4_.top,_loc5_.top);
         _loc6_.bottom = Math.min(_loc4_.bottom,_loc5_.bottom);
         if(_loc6_.height < 1 || _loc6_.width < 1)
         {
            return null;
         }
         var _loc7_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,false);
         var _loc8_:Matrix = param1.transform.concatenatedMatrix;
         _loc8_.tx -= _loc6_.left;
         _loc8_.ty -= _loc6_.top;
         _loc7_.draw(param1,_loc8_,new ColorTransform(1,1,1,1,255,-255,-255,param3));
         _loc8_ = param2.transform.concatenatedMatrix;
         _loc8_.tx -= _loc6_.left;
         _loc8_.ty -= _loc6_.top;
         _loc7_.draw(param2,_loc8_,new ColorTransform(1,1,1,1,255,255,255,param3),"difference");
         var _loc9_:Rectangle = _loc7_.getColorBoundsRect(4294967295,4278255615);
         if(_loc9_.width == 0)
         {
            return null;
         }
         _loc9_.x += _loc6_.left;
         _loc9_.y += _loc6_.top;
         return _loc9_;
      }
   }
}


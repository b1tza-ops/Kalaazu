package org.flintparticles.twoD.zones
{
   import flash.geom.Point;
   import org.flintparticles.twoD.particles.Particle2D;
   
   public class PointZone implements Zone2D
   {
      
      private var _point:Point;
      
      public function PointZone(param1:Point = null)
      {
         super();
         if(param1 == null)
         {
            this._point = new Point(0,0);
         }
         else
         {
            this._point = param1;
         }
      }
      
      public function get point() : Point
      {
         return this._point;
      }
      
      public function set point(param1:Point) : void
      {
         this._point = param1;
      }
      
      public function get x() : Number
      {
         return this._point.x;
      }
      
      public function set x(param1:Number) : void
      {
         this._point.x = param1;
      }
      
      public function get y() : Number
      {
         return this._point.y;
      }
      
      public function set y(param1:Number) : void
      {
         this._point.y = param1;
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         return this._point.x == param1 && this._point.y == param2;
      }
      
      public function getLocation() : Point
      {
         return this._point.clone();
      }
      
      public function getArea() : Number
      {
         return 1;
      }
      
      public function collideParticle(param1:Particle2D, param2:Number = 1) : Boolean
      {
         var _loc19_:Number = NaN;
         var _loc3_:Number = param1.previousX - this._point.x;
         var _loc4_:Number = param1.previousY - this._point.y;
         var _loc5_:Number = _loc3_ * param1.velX + _loc4_ * param1.velY;
         if(_loc5_ >= 0)
         {
            return false;
         }
         var _loc6_:Number = param1.x - this._point.x;
         var _loc7_:Number = param1.y - this._point.y;
         var _loc8_:Number = param1.collisionRadius;
         _loc5_ = _loc6_ * param1.velX + _loc7_ * param1.velY;
         if(_loc5_ <= 0)
         {
            if(_loc6_ > _loc8_ || _loc6_ < -_loc8_)
            {
               return false;
            }
            if(_loc7_ > _loc8_ || _loc7_ < -_loc8_)
            {
               return false;
            }
            if(_loc6_ * _loc6_ + _loc7_ * _loc7_ > _loc8_ * _loc8_)
            {
               return false;
            }
         }
         var _loc9_:Number = _loc6_ - _loc3_;
         var _loc10_:Number = _loc7_ - _loc4_;
         var _loc11_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_;
         var _loc12_:Number = 2 * (_loc3_ * _loc9_ + _loc4_ * _loc10_);
         var _loc13_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_ - _loc8_ * _loc8_;
         var _loc14_:Number = _loc12_ * _loc12_ - 4 * _loc11_ * _loc13_;
         if(_loc14_ < 0)
         {
            return false;
         }
         var _loc15_:Number = Math.sqrt(_loc14_);
         var _loc16_:Number = (-_loc12_ + _loc15_) / (2 * _loc11_);
         var _loc17_:Number = (-_loc12_ - _loc15_) / (2 * _loc11_);
         var _loc18_:Array = new Array();
         if(_loc16_ > 0 && _loc16_ <= 1)
         {
            _loc18_.push(_loc16_);
         }
         if(_loc17_ > 0 && _loc17_ <= 1)
         {
            _loc18_.push(_loc17_);
         }
         if(_loc18_.length == 0)
         {
            return false;
         }
         if(_loc18_.length == 1)
         {
            _loc19_ = Number(_loc18_[0]);
         }
         else
         {
            _loc19_ = Math.min(_loc16_,_loc17_);
         }
         var _loc20_:Number = _loc3_ + _loc19_ * _loc9_ + this._point.x;
         var _loc21_:Number = _loc4_ + _loc19_ * _loc10_ + this._point.y;
         var _loc22_:Number = _loc20_ - this._point.x;
         var _loc23_:Number = _loc21_ - this._point.y;
         var _loc24_:Number = Math.sqrt(_loc22_ * _loc22_ + _loc23_ * _loc23_);
         _loc22_ /= _loc24_;
         _loc23_ /= _loc24_;
         var _loc25_:Number = _loc9_ * _loc22_ + _loc10_ * _loc23_;
         _loc9_ -= 2 * _loc22_ * _loc25_;
         _loc10_ -= 2 * _loc23_ * _loc25_;
         param1.x = _loc20_ + (1 - _loc19_) * _loc9_;
         param1.y = _loc21_ + (1 - _loc19_) * _loc10_;
         var _loc26_:Number = param1.velX * _loc22_ + param1.velY * _loc23_;
         param1.velX -= (1 + param2) * _loc22_ * _loc26_;
         param1.velY -= (1 + param2) * _loc23_ * _loc26_;
         return true;
      }
   }
}


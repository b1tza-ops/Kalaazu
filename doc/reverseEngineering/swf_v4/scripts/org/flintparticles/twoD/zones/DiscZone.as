package org.flintparticles.twoD.zones
{
   import flash.geom.Point;
   import org.flintparticles.twoD.particles.Particle2D;
   
   public class DiscZone implements Zone2D
   {
      
      private static const TWOPI:Number = Math.PI * 2;
      
      private var _center:Point;
      
      private var _innerRadius:Number;
      
      private var _outerRadius:Number;
      
      private var _innerSq:Number;
      
      private var _outerSq:Number;
      
      public function DiscZone(param1:Point = null, param2:Number = 0, param3:Number = 0)
      {
         super();
         if(param2 < param3)
         {
            throw new Error("The outerRadius (" + param2 + ") can\'t be smaller than the innerRadius (" + param3 + ") in your DiscZone. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument.");
         }
         if(param1 == null)
         {
            this._center = new Point(0,0);
         }
         else
         {
            this._center = param1;
         }
         this._innerRadius = param3;
         this._outerRadius = param2;
         this._innerSq = this._innerRadius * this._innerRadius;
         this._outerSq = this._outerRadius * this._outerRadius;
      }
      
      public function get center() : Point
      {
         return this._center;
      }
      
      public function set center(param1:Point) : void
      {
         this._center = param1;
      }
      
      public function get centerX() : Number
      {
         return this._center.x;
      }
      
      public function set centerX(param1:Number) : void
      {
         this._center.x = param1;
      }
      
      public function get centerY() : Number
      {
         return this._center.y;
      }
      
      public function set centerY(param1:Number) : void
      {
         this._center.y = param1;
      }
      
      public function get innerRadius() : Number
      {
         return this._innerRadius;
      }
      
      public function set innerRadius(param1:Number) : void
      {
         this._innerRadius = param1;
         this._innerSq = this._innerRadius * this._innerRadius;
      }
      
      public function get outerRadius() : Number
      {
         return this._outerRadius;
      }
      
      public function set outerRadius(param1:Number) : void
      {
         this._outerRadius = param1;
         this._outerSq = this._outerRadius * this._outerRadius;
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         param1 -= this._center.x;
         param2 -= this._center.y;
         var _loc3_:Number = param1 * param1 + param2 * param2;
         return _loc3_ <= this._outerSq && _loc3_ >= this._innerSq;
      }
      
      public function getLocation() : Point
      {
         var _loc1_:Number = Math.random();
         var _loc2_:Point = Point.polar(this._innerRadius + (1 - _loc1_ * _loc1_) * (this._outerRadius - this._innerRadius),Math.random() * TWOPI);
         _loc2_.x += this._center.x;
         _loc2_.y += this._center.y;
         return _loc2_;
      }
      
      public function getArea() : Number
      {
         return Math.PI * (this._outerSq - this._innerSq);
      }
      
      public function collideParticle(param1:Particle2D, param2:Number = 1) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = 0.001;
         var _loc15_:Number = param1.x - this._center.x;
         var _loc16_:Number = param1.y - this._center.y;
         var _loc17_:Number = param1.velX * _loc15_ + param1.velY * _loc16_;
         if(_loc17_ < 0)
         {
            _loc3_ = this._outerRadius + param1.collisionRadius;
            if(Math.abs(_loc15_) > _loc3_)
            {
               return false;
            }
            if(Math.abs(_loc16_) > _loc3_)
            {
               return false;
            }
            _loc7_ = _loc15_ * _loc15_ + _loc16_ * _loc16_;
            _loc5_ = _loc3_ * _loc3_;
            if(_loc7_ > _loc5_)
            {
               return false;
            }
            _loc9_ = param1.previousX - this._center.x;
            _loc10_ = param1.previousY - this._center.y;
            _loc11_ = _loc9_ * _loc9_ + _loc10_ * _loc10_;
            if(_loc11_ > _loc5_)
            {
               _loc12_ = (1 + param2) * _loc17_ / _loc7_;
               param1.velX -= _loc12_ * _loc15_;
               param1.velY -= _loc12_ * _loc16_;
               _loc8_ = Math.sqrt(_loc7_);
               _loc13_ = (2 * _loc3_ - _loc8_) / _loc8_ + _loc14_;
               param1.x = this._center.x + _loc15_ * _loc13_;
               param1.y = this._center.y + _loc16_ * _loc13_;
               return true;
            }
            if(this._innerRadius != 0 && this.innerRadius != this._outerRadius)
            {
               _loc4_ = this._innerRadius + param1.collisionRadius;
               if(Math.abs(_loc15_) > _loc4_)
               {
                  return false;
               }
               if(Math.abs(_loc16_) > _loc4_)
               {
                  return false;
               }
               _loc6_ = _loc4_ * _loc4_;
               if(_loc7_ > _loc6_)
               {
                  return false;
               }
               if(_loc11_ > _loc6_)
               {
                  _loc12_ = (1 + param2) * _loc17_ / _loc7_;
                  param1.velX -= _loc12_ * _loc15_;
                  param1.velY -= _loc12_ * _loc16_;
                  _loc8_ = Math.sqrt(_loc7_);
                  _loc13_ = (2 * _loc4_ - _loc8_) / _loc8_ + _loc14_;
                  param1.x = this._center.x + _loc15_ * _loc13_;
                  param1.y = this._center.y + _loc16_ * _loc13_;
                  return true;
               }
            }
            return false;
         }
         _loc3_ = this._outerRadius - param1.collisionRadius;
         _loc9_ = param1.previousX - this._center.x;
         _loc10_ = param1.previousY - this._center.y;
         if(Math.abs(_loc9_) > _loc3_)
         {
            return false;
         }
         if(Math.abs(_loc10_) > _loc3_)
         {
            return false;
         }
         _loc11_ = _loc9_ * _loc9_ + _loc10_ * _loc10_;
         _loc5_ = _loc3_ * _loc3_;
         if(_loc11_ > _loc5_)
         {
            return false;
         }
         _loc7_ = _loc15_ * _loc15_ + _loc16_ * _loc16_;
         if(this._innerRadius != 0 && this.innerRadius != this._outerRadius)
         {
            _loc4_ = this._innerRadius - param1.collisionRadius;
            _loc6_ = _loc4_ * _loc4_;
            if(_loc11_ < _loc6_ && _loc7_ >= _loc6_)
            {
               _loc12_ = (1 + param2) * _loc17_ / _loc7_;
               param1.velX -= _loc12_ * _loc15_;
               param1.velY -= _loc12_ * _loc16_;
               _loc8_ = Math.sqrt(_loc7_);
               _loc13_ = (2 * _loc4_ - _loc8_) / _loc8_ - _loc14_;
               param1.x = this._center.x + _loc15_ * _loc13_;
               param1.y = this._center.y + _loc16_ * _loc13_;
               return true;
            }
         }
         if(_loc7_ >= _loc5_)
         {
            _loc12_ = (1 + param2) * _loc17_ / _loc7_;
            param1.velX -= _loc12_ * _loc15_;
            param1.velY -= _loc12_ * _loc16_;
            _loc8_ = Math.sqrt(_loc7_);
            _loc13_ = (2 * _loc3_ - _loc8_) / _loc8_ - _loc14_;
            param1.x = this._center.x + _loc15_ * _loc13_;
            param1.y = this._center.y + _loc16_ * _loc13_;
            return true;
         }
         return false;
      }
   }
}


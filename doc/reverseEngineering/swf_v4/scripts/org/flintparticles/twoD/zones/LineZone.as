package org.flintparticles.twoD.zones
{
   import flash.geom.Point;
   import org.flintparticles.twoD.particles.Particle2D;
   
   public class LineZone implements Zone2D
   {
      
      private var _start:Point;
      
      private var _end:Point;
      
      private var _length:Point;
      
      private var _normal:Point;
      
      private var _parallel:Point;
      
      public function LineZone(param1:Point = null, param2:Point = null)
      {
         super();
         if(param1 == null)
         {
            this._start = new Point(0,0);
         }
         else
         {
            this._start = param1;
         }
         if(param2 == null)
         {
            this._end = new Point(0,0);
         }
         else
         {
            this._end = param2;
         }
         this.setLengthAndNormal();
      }
      
      private function setLengthAndNormal() : void
      {
         this._length = this._end.subtract(this._start);
         this._parallel = this._length.clone();
         this._parallel.normalize(1);
         this._normal = new Point(this._parallel.y,-this._parallel.x);
      }
      
      public function get start() : Point
      {
         return this._start;
      }
      
      public function set start(param1:Point) : void
      {
         this._start = param1;
         this.setLengthAndNormal();
      }
      
      public function get end() : Point
      {
         return this._end;
      }
      
      public function set end(param1:Point) : void
      {
         this._end = param1;
         this.setLengthAndNormal();
      }
      
      public function get startX() : Number
      {
         return this._start.x;
      }
      
      public function set startX(param1:Number) : void
      {
         this._start.x = param1;
         this._length = this._end.subtract(this._start);
      }
      
      public function get startY() : Number
      {
         return this._start.y;
      }
      
      public function set startY(param1:Number) : void
      {
         this._start.y = param1;
         this._length = this._end.subtract(this._start);
      }
      
      public function get endX() : Number
      {
         return this._end.x;
      }
      
      public function set endX(param1:Number) : void
      {
         this._end.x = param1;
         this._length = this._end.subtract(this._start);
      }
      
      public function get endY() : Number
      {
         return this._end.y;
      }
      
      public function set endY(param1:Number) : void
      {
         this._end.y = param1;
         this._length = this._end.subtract(this._start);
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         if((param1 - this._start.x) * this._length.y - (param2 - this._start.y) * this._length.x != 0)
         {
            return false;
         }
         return (param1 - this._start.x) * (param1 - this._end.x) + (param2 - this._start.y) * (param2 - this._end.y) <= 0;
      }
      
      public function getLocation() : Point
      {
         var _loc1_:Point = this._start.clone();
         var _loc2_:Number = Math.random();
         _loc1_.x += this._length.x * _loc2_;
         _loc1_.y += this._length.y * _loc2_;
         return _loc1_;
      }
      
      public function getArea() : Number
      {
         return this._length.length;
      }
      
      public function collideParticle(param1:Particle2D, param2:Number = 1) : Boolean
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = (param1.previousX - this._start.x) * this._normal.x + (param1.previousY - this._start.y) * this._normal.y;
         var _loc4_:Number = param1.velX * this._normal.x + param1.velY * this._normal.y;
         if(_loc3_ * _loc4_ >= 0)
         {
            return false;
         }
         var _loc5_:Number = (param1.x - this._start.x) * this._normal.x + (param1.y - this._start.y) * this._normal.y;
         if(_loc5_ * _loc3_ > 0 && (_loc5_ > param1.collisionRadius || _loc5_ < -param1.collisionRadius))
         {
            return false;
         }
         if(_loc3_ < 0)
         {
            _loc6_ = this._normal.x * param1.collisionRadius;
            _loc7_ = this._normal.y * param1.collisionRadius;
         }
         else
         {
            _loc6_ = -this._normal.x * param1.collisionRadius;
            _loc7_ = -this._normal.y * param1.collisionRadius;
         }
         var _loc8_:Number = param1.previousX + _loc6_;
         var _loc9_:Number = param1.previousY + _loc7_;
         var _loc10_:Number = param1.x + _loc6_;
         var _loc11_:Number = param1.y + _loc7_;
         var _loc12_:Number = this._start.x - this._parallel.x * param1.collisionRadius;
         var _loc13_:Number = this._start.y - this._parallel.y * param1.collisionRadius;
         var _loc14_:Number = this._end.x + this._parallel.x * param1.collisionRadius;
         var _loc15_:Number = this._end.y + this._parallel.y * param1.collisionRadius;
         var _loc16_:Number = 1 / ((_loc11_ - _loc9_) * (_loc14_ - _loc12_) - (_loc10_ - _loc8_) * (_loc15_ - _loc13_));
         var _loc17_:Number = _loc16_ * ((_loc10_ - _loc8_) * (_loc13_ - _loc9_) - (_loc11_ - _loc9_) * (_loc12_ - _loc8_));
         if(_loc17_ < 0 || _loc17_ > 1)
         {
            return false;
         }
         var _loc18_:Number = -_loc16_ * ((_loc14_ - _loc12_) * (_loc9_ - _loc13_) - (_loc15_ - _loc13_) * (_loc8_ - _loc12_));
         if(_loc18_ < 0 || _loc18_ > 1)
         {
            return false;
         }
         param1.x = param1.previousX + _loc18_ * (param1.x - param1.previousX);
         param1.y = param1.previousY + _loc18_ * (param1.y - param1.previousY);
         var _loc19_:Number = this._normal.x * param1.velX + this._normal.y * param1.velY;
         var _loc20_:Number = (1 + param2) * _loc19_;
         param1.velX -= _loc20_ * this._normal.x;
         param1.velY -= _loc20_ * this._normal.y;
         return true;
      }
   }
}


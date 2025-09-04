package net.bigpoint.darkorbit.lensflare
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.collisionDetection.PixelPerfectCollisionDetection;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.planet.Planet;
   import net.bigpoint.darkorbit.planet.PlanetPattern;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.station.Station;
   
   public class LensFlare extends MovieClip
   {
      
      private static const logger:ILogger = Log.getLogger("Client.Lensflare");
      
      private var id:int;
      
      private var lenses:Array = [];
      
      public var star:MovieClip;
      
      private var rect:Rectangle;
      
      private var state:int = 0;
      
      private var hLimit:int;
      
      private var vLimit:int;
      
      private var init:Boolean;
      
      public var xGap:int;
      
      public var yGap:int;
      
      public var pFactor:Number;
      
      private var divider:int = 3;
      
      private var lensflareManager:LensflareManager;
      
      private var xTemp:int;
      
      private var yTemp:int;
      
      private var lensFlash:Bitmap;
      
      private var useLensFlash:Boolean;
      
      private var lastDistance:int;
      
      private var collisionDetection:Sprite;
      
      private var halfScreenWidth:int;
      
      private var halfScreenHeight:int;
      
      public function LensFlare(param1:LensflareManager, param2:int, param3:int, param4:int, param5:Rectangle, param6:Number = 1)
      {
         super();
         this.lensflareManager = param1;
         this.id = param2;
         this.xTemp = param3;
         this.yTemp = param4;
         this.halfScreenWidth = param5.width / 2;
         this.halfScreenHeight = param5.height / 2;
         this.xGap = param3 / param6;
         this.yGap = param4 / param6;
         this.rect = param5;
         this.pFactor = param6;
         this.hLimit = param5.width;
         this.vLimit = param5.height;
      }
      
      public function addLensFlare(param1:MovieClip) : void
      {
         this.lenses.push(param1);
         this.addChild(param1);
      }
      
      public function initLensflare() : void
      {
         this.init = true;
      }
      
      public function addStar(param1:MovieClip) : void
      {
         this.star = param1;
         param1.play();
         this.addChild(this.star);
         this.lensFlash = ResourceManager.getBitmap("lensFlash","lensFlash");
         this.lensFlash.x = -this.lensFlash.width / 2;
         this.lensFlash.y = -this.lensFlash.height / 2;
         this.addChild(this.lensFlash);
         this.lensFlash.visible = false;
      }
      
      public function addCollisionDetection() : void
      {
         this.collisionDetection = new Sprite();
         this.collisionDetection.graphics.beginFill(255);
         this.collisionDetection.graphics.drawCircle(0,0,5);
         this.collisionDetection.alpha = 0;
         this.addChild(this.collisionDetection);
      }
      
      public function rotate() : void
      {
         var _loc1_:int = this.lensflareManager.getMap().getMain().screenManager.getStaticContainer().mouseX;
         if(_loc1_ > this.halfScreenWidth)
         {
            this.star.rotation += 0.15;
         }
         else
         {
            this.star.rotation -= 0.15;
         }
      }
      
      public function updateLens(param1:int, param2:int) : void
      {
         if(!this.init)
         {
            return;
         }
         var _loc3_:int = param1 - this.x;
         var _loc4_:int = param2 - this.y;
         switch(this.state)
         {
            case 0:
               if(_loc3_ < -this.hLimit || _loc3_ > this.hLimit)
               {
                  this.state = 2;
                  break;
               }
               if(_loc4_ < -this.vLimit || _loc4_ > this.vLimit)
               {
                  this.state = 2;
                  break;
               }
               if(this.isBehindPlanet())
               {
                  this.state = 2;
                  this.useLensFlash = true;
                  break;
               }
               if(this.isBehindShip())
               {
                  this.state = 2;
                  break;
               }
               if(this.isBehindStations())
               {
                  this.state = 2;
                  break;
               }
               this.drawLenses(param1,param2);
               break;
            case 2:
               this.fadeOutChilds();
               this.state = 4;
               break;
            case 4:
               if(_loc3_ > -this.hLimit && _loc3_ < this.hLimit && _loc4_ > -this.vLimit && _loc4_ < this.vLimit && !this.isBehindPlanet() && !this.isBehindStations() && !this.isBehindShip())
               {
                  this.state = 1;
               }
               break;
            case 1:
               this.divider = 3;
               this.fadeInChilds();
               this.state = 0;
         }
      }
      
      private function fadeInChilds() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.lenses.length)
         {
            _loc2_ = this.lenses[_loc1_];
            TweenLite.to(_loc2_,0.5,{"alpha":1});
            _loc1_++;
         }
         if(this.star != null)
         {
            TweenLite.to(this.star,0.5,{"alpha":1});
            if(this.useLensFlash)
            {
               this.lensFlash.alpha = 0;
               this.lensFlash.visible = true;
               TweenLite.to(this.lensFlash,0.25,{
                  "alpha":0.75,
                  "onComplete":this.fadeOutLensFlash,
                  "onCompleteParams":[this.lensFlash]
               });
               this.useLensFlash = false;
            }
         }
      }
      
      private function fadeOutLensFlash(param1:Bitmap) : void
      {
         TweenLite.to(param1,3,{
            "alpha":0,
            "onComplete":this.handleRemoveLensFlash,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleRemoveLensFlash(param1:Bitmap) : void
      {
         param1.visible = false;
      }
      
      private function fadeOutChilds() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.lenses.length)
         {
            _loc2_ = this.lenses[_loc1_];
            TweenLite.to(_loc2_,0.5,{"alpha":0});
            _loc1_++;
         }
         if(this.star != null)
         {
            TweenLite.to(this.star,0.5,{"alpha":0});
         }
      }
      
      private function drawLenses(param1:int, param2:int) : void
      {
         var _loc7_:MovieClip = null;
         var _loc8_:Number = NaN;
         var _loc9_:MovieClip = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc3_:Number = Math.atan2(param2 - this.y,param1 - this.x) * 180 / Math.PI;
         var _loc4_:Number = FastMath.sqrt(Math.pow(param2 - this.y,2) + Math.pow(param1 - this.x,2));
         _loc4_ = _loc4_ / this.divider;
         if(int(_loc4_) != this.lastDistance)
         {
            _loc7_ = this.lenses[5];
            _loc8_ = (_loc4_ + 50) * 0.0033;
            if(_loc8_ > 0 && _loc8_ < 1)
            {
               _loc7_.scaleX = _loc8_;
               _loc7_.scaleY = _loc8_;
            }
         }
         this.lastDistance = _loc4_;
         var _loc5_:int = 0;
         var _loc6_:int = 3;
         while(_loc6_ > -1)
         {
            _loc9_ = this.lenses[_loc6_];
            _loc10_ = -_loc5_ * _loc4_ * Math.cos(_loc3_ * Math.PI / 180);
            _loc11_ = -_loc5_ * _loc4_ * Math.sin(_loc3_ * Math.PI / 180);
            _loc9_.x = _loc10_;
            _loc9_.y = _loc11_;
            _loc5_++;
            _loc6_--;
         }
         _loc5_ = 1;
         _loc6_ = 3;
         while(_loc6_ < this.lenses.length)
         {
            _loc9_ = this.lenses[_loc6_];
            _loc10_ = _loc5_ * _loc4_ * Math.cos(_loc3_ * Math.PI / 180);
            _loc11_ = _loc5_ * _loc4_ * Math.sin(_loc3_ * Math.PI / 180);
            _loc9_.x = _loc10_;
            _loc9_.y = _loc11_;
            _loc5_++;
            _loc6_++;
         }
      }
      
      public function isBehindPlanet() : Boolean
      {
         var _loc3_:Planet = null;
         var _loc4_:PlanetPattern = null;
         var _loc5_:Number = NaN;
         var _loc1_:Array = this.lensflareManager.getMap().getMain().screenManager.planets;
         if(_loc1_ == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.clip != null)
            {
               _loc4_ = PatternManager.planetPatterns[int(_loc3_.getTypeID())];
               _loc5_ = Math.pow(_loc3_.clip.y - this.y,2) + Math.pow(_loc3_.clip.x - this.x,2);
               if(_loc5_ < _loc4_.radiusAndPaddingSquared)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      private function isBehindStations() : Boolean
      {
         var _loc3_:Station = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Array = this.lensflareManager.getMap().getStationManager().getStations();
         var _loc2_:Ship = this.lensflareManager.getMap().getShipManager().getHero();
         for each(_loc3_ in _loc1_)
         {
            if(this.collisionDetection != null && _loc3_ != null && _loc3_.clip != null && _loc2_ != null)
            {
               _loc4_ = _loc3_.clip.x - _loc2_.x + this.halfScreenWidth;
               _loc5_ = _loc3_.clip.y - _loc2_.y + this.halfScreenHeight;
               _loc6_ = this.x;
               _loc7_ = this.y;
               if(_loc4_ - _loc3_.clip.width / 2 < _loc6_ && _loc6_ < _loc4_ + _loc3_.clip.width / 2 && _loc5_ - _loc3_.clip.height / 2 < _loc7_ && _loc7_ < _loc5_ + _loc3_.clip.height / 2)
               {
                  if(PixelPerfectCollisionDetection.isColliding(this.collisionDetection,_loc3_.clip,this.collisionDetection.parent,true))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      private function isBehindShip() : Boolean
      {
         var _loc4_:MapObject = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Array = this.lensflareManager.getMap().getShipManager().getShips();
         var _loc2_:Ship = this.lensflareManager.getMap().getShipManager().getHero();
         var _loc3_:int = 20;
         if(_loc2_ != null)
         {
            for each(_loc4_ in _loc1_)
            {
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_.x - _loc2_.x + this.halfScreenWidth;
                  _loc6_ = _loc4_.y - _loc2_.y + this.halfScreenHeight;
                  _loc7_ = this.x;
                  _loc8_ = this.y;
                  if(_loc5_ - _loc3_ < _loc7_ && _loc7_ < _loc5_ + _loc3_ && _loc6_ - _loc3_ < _loc8_ && _loc8_ < _loc6_ + _loc3_)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function cleanup() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.numChildren)
         {
            _loc2_ = this.getChildAt(_loc1_);
            if(this.contains(_loc2_))
            {
               this.removeChild(_loc2_);
            }
            _loc1_++;
         }
      }
   }
}


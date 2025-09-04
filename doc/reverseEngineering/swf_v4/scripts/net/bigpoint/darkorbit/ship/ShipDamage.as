package net.bigpoint.darkorbit.ship
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ShipDamage
   {
      
      private var ship:MapObject;
      
      private var clip:MovieClip;
      
      private var rotation:int;
      
      private var distance:int;
      
      private var autoRotate:Boolean;
      
      public function ShipDamage(param1:MapObject, param2:MovieClip, param3:int, param4:int, param5:Boolean = false)
      {
         super();
         this.ship = param1;
         this.clip = param2;
         this.clip.cacheAsBitmap = true;
         this.rotation = param3;
         this.distance = param4;
         this.autoRotate = param5;
      }
      
      public function positionClip() : void
      {
         this.clip.x = int(this.distance * Math.cos((this.ship.shipRotation + this.rotation) * Math.PI / 180));
         this.clip.y = int(this.distance * Math.sin((this.ship.shipRotation + this.rotation) * Math.PI / 180));
      }
      
      public function playClip() : void
      {
         if(this.ship.getExplosionContainer().numChildren > 0)
         {
            this.ship.getExplosionContainer().removeChildAt(0);
         }
         this.ship.getExplosionContainer().addChild(this.clip);
         TweenLite.to(this.clip,0.5,{
            "frame":this.clip.framesLoaded,
            "onComplete":this.onAnimationFinish,
            "onCompleteParams":[this.clip]
         });
      }
      
      private function onAnimationFinish(param1:MovieClip) : void
      {
         if(this.ship != null && this.ship.getExplosionContainer().contains(param1))
         {
            this.ship.getExplosionContainer().removeChild(param1);
         }
      }
      
      public function isAutoRotate() : Boolean
      {
         return this.autoRotate;
      }
   }
}


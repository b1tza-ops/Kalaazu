package net.bigpoint.darkorbit.combat
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class ChasingShotPirate
   {
      
      private var attackerShip:MapObject;
      
      private var targetShip:MapObject;
      
      private var shotClip:MovieClip;
      
      private var layer:Sprite;
      
      public function ChasingShotPirate(param1:MapObject, param2:MapObject, param3:MovieClip, param4:Sprite)
      {
         super();
         this.attackerShip = param1;
         this.targetShip = param2;
         this.shotClip = param3;
         this.layer = param4;
         this.init();
      }
      
      private function init() : void
      {
         this.layer.addChild(this.shotClip);
         this.shotClip.x = this.attackerShip.x;
         this.shotClip.y = this.attackerShip.y;
         TweenLite.to(this.shotClip,1,{
            "dynamicProps":{
               "x":this.getTargetShipXPos,
               "y":this.getTargetShipYPos
            },
            "onComplete":this.shotClip.parent.removeChild,
            "onCompleteParams":[this.shotClip]
         });
      }
      
      private function getTargetShipXPos() : Number
      {
         return this.targetShip.x;
      }
      
      private function getTargetShipYPos() : Number
      {
         return this.targetShip.y;
      }
   }
}


package net.bigpoint.darkorbit.ship
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ShipLightDecorator
   {
      
      public static const logger:ILogger = Log.getLogger("ShipLightDecorator");
      
      public var ship:MapObject;
      
      private var shipClip:MovieClip;
      
      private var lightSetting:int = 0;
      
      private var lightFlashTime:Number = 0.4;
      
      private const greenColour:uint = 65280;
      
      private const whiteColour:uint = 0;
      
      private const glowStrength:Number = 9;
      
      private const glowBlurX:Number = 10;
      
      private const glowBlurY:Number = 10;
      
      private const glowAlpha:Number = 0.4;
      
      private const tintAmount:Number = 0.7;
      
      private const lightFlashTimeDelay:Number = 0.6;
      
      public var numberOfFlashes:int = -1;
      
      public function ShipLightDecorator(param1:MapObject)
      {
         super();
         this.ship = param1;
         TweenPlugin.activate([ColorTransformPlugin]);
      }
      
      public function startFlashes(param1:int) : void
      {
         this.numberOfFlashes = param1;
         this.shipClip = this.ship.shipClip.light;
         this.flashLights();
      }
      
      public function flashLights() : void
      {
         --this.numberOfFlashes;
         if(this.ship.shipClip != null)
         {
            if(this.lightSetting == 0)
            {
               TweenLite.to(this.shipClip,this.lightFlashTime,{"colorTransform":{
                  "tint":this.greenColour,
                  "tintAmount":this.tintAmount
               }});
               TweenLite.to(this.shipClip,this.lightFlashTime,{"glowFilter":{
                  "color":this.greenColour,
                  "blurX":this.glowBlurX,
                  "blurY":this.glowBlurY,
                  "strength":this.glowStrength,
                  "alpha":this.glowAlpha
               }});
               this.lightSetting = 1;
            }
            else if(this.lightSetting == 1)
            {
               TweenLite.to(this.shipClip,this.lightFlashTime,{"colorTransform":{
                  "tint":this.whiteColour,
                  "tintAmount":0
               }});
               TweenLite.to(this.shipClip,this.lightFlashTime,{"glowFilter":{
                  "color":this.whiteColour,
                  "blurX":0,
                  "blurY":0,
                  "strength":0,
                  "alpha":0
               }});
               this.lightSetting = 0;
            }
         }
         if(this.numberOfFlashes > -1)
         {
            TweenMax.delayedCall(this.lightFlashTimeDelay,this.flashLights);
         }
      }
      
      public function updateGraphicRotation() : void
      {
         this.ship.updateVisualShipRotation();
         this.ship.shipClip.light.gotoAndStop(this.ship.lastShipFrame);
      }
   }
}


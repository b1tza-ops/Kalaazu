package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.pixelwelders.fx.EarthquakeManager;
   import flash.events.Event;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SpeedBuffEffect extends RotationEffect
   {
      
      private var speedBuffStartupSound:SoundChannel;
      
      private var speedBuffSound:SoundChannel;
      
      private var startupSoundPlayed:Boolean = false;
      
      public function SpeedBuffEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         addRotationTick();
         start();
      }
      
      override public function actionOnMovingRotation() : void
      {
         this.clip.visible = true;
         if(this.clip != null)
         {
            if(!this.startupSoundPlayed)
            {
               this.speedBuffStartupSound = AudioManager.playSoundEffect(81,false,false,associatedMapObject.x,associatedMapObject.y);
               this.startupSoundPlayed = true;
            }
            EarthquakeManager.getInstance().addQuake(associatedMapObject.shipClip,8);
            this.clip.x = associatedMapObject.currentEnginePosition.x;
            this.clip.y = associatedMapObject.currentEnginePosition.y;
            TweenMax.to(this.clip,0.1,{
               "ease":Linear.easeNone,
               "alpha":1
            });
            TweenMax.to(this.clip,0.25,{"shortRotation":{"rotation":associatedMapObject.movementDirection}});
            if(!this.speedBuffSound)
            {
               this.speedBuffSound = AudioManager.playSoundEffect(82,true,true,associatedMapObject.x,associatedMapObject.y);
            }
         }
      }
      
      override public function actionOnStationaryRotation() : void
      {
         if(this.clip != null)
         {
            EarthquakeManager.getInstance().killQuake(associatedMapObject.shipClip);
            this.clip.alpha = 0;
            this.clip.x = associatedMapObject.currentEnginePosition.x;
            this.clip.y = associatedMapObject.currentEnginePosition.y;
            TweenMax.to(this.clip,0.25,{"shortRotation":{"rotation":associatedMapObject.movementDirection}});
            if(this.speedBuffSound != null)
            {
               AudioManager.removeLoop(this.speedBuffSound,true);
               this.speedBuffSound = null;
            }
         }
      }
      
      override public function cleanup() : void
      {
         removeEventListener(Event.ENTER_FRAME,mapObjectRotationCallback);
         EarthquakeManager.getInstance().killQuake(associatedMapObject.shipClip);
         associatedMapObject = null;
         if(this.speedBuffSound != null)
         {
            AudioManager.removeLoop(this.speedBuffSound,true);
            this.speedBuffSound = null;
         }
      }
   }
}


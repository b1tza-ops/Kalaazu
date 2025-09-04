package net.bigpoint.darkorbit.ship.effects
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class LevelUpEffect extends EffectBase
   {
      
      private static const ANIMATION_SOUND_LINKAGE_ID:String = "soundfx";
      
      private static const STD_FRAME_DURATION:Number = 0.04;
      
      public function LevelUpEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         var _loc2_:Sound = null;
         if(Settings.playSFX)
         {
            _loc2_ = ResourceManager.getSound(pattern.resKey,ANIMATION_SOUND_LINKAGE_ID);
            if(_loc2_ != null)
            {
               _loc2_.play();
            }
         }
         this.clip.visible = true;
         this.clip.y -= 150;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * STD_FRAME_DURATION;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.handleEffectFinished
         });
      }
      
      private function handleEffectFinished() : void
      {
         dispatchEvent(new EntityEffectEvent(EntityEffectEvent.EFFECT_TIMEOUT,id));
      }
   }
}


package net.bigpoint.darkorbit.audio
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.FastMath;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.Ship;
   
   public class AudioManager
   {
      
      private static var main:Main;
      
      private static var musicSndChannel:SoundChannel;
      
      private static var sndCnt:int;
      
      public static const logger:ILogger = Log.getLogger("AudioManager");
      
      private static var lastTrack:String = "-1";
      
      private static var soundRadius:int = 800;
      
      public function AudioManager()
      {
         super();
      }
      
      public static function init(param1:Main) : void
      {
         main = param1;
      }
      
      public static function loadMusic(param1:int) : void
      {
         var _loc2_:AudioPattern = PatternManager.musicPatterns[int(param1)];
         if(ResourceManager.fileCollection.isLoaded(_loc2_.getResKey()))
         {
            playMusic(_loc2_,_loc2_.getVolume());
         }
         else
         {
            ResourceManager.fileCollection.load(_loc2_.getResKey(),onMusicLoaded);
         }
      }
      
      public static function stopMusic() : void
      {
         if(musicSndChannel != null)
         {
            musicSndChannel.stop();
         }
         lastTrack = "-1";
      }
      
      private static function onMusicLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:AudioPattern = null;
         var _loc2_:int = 0;
         while(_loc2_ < PatternManager.musicPatterns.length)
         {
            _loc3_ = PatternManager.musicPatterns[_loc2_];
            if(_loc3_.getResKey() == param1.fileVO.id)
            {
               playMusic(_loc3_,_loc3_.getVolume());
            }
            _loc2_++;
         }
      }
      
      private static function playMusic(param1:AudioPattern, param2:Number) : void
      {
         if(lastTrack == param1.getResKey())
         {
            return;
         }
         if(musicSndChannel != null)
         {
            musicSndChannel.stop();
         }
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1.getResKey()));
         lastTrack = param1.getResKey();
         var _loc4_:Sound = Sound(_loc3_.getEmbededSound("track"));
         musicSndChannel = _loc4_.play(0,9999,new SoundTransform(param2,0));
      }
      
      public static function playSoundEffect(param1:int, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:int = -1, param6:Boolean = true) : SoundChannel
      {
         var _loc10_:SoundChannel = null;
         var _loc14_:Ship = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(!param6 && sndCnt > 10)
         {
            return null;
         }
         if(!Settings.playSFX)
         {
            return null;
         }
         var _loc7_:AudioPattern = PatternManager.soundPatterns[param1];
         var _loc8_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc7_.soundbank));
         var _loc9_:Sound = Sound(_loc8_.getEmbededSound(_loc7_.getResKey()));
         var _loc11_:Number = _loc7_.getVolume();
         var _loc12_:SoundTransform = new SoundTransform(_loc11_,0);
         var _loc13_:Map = main.screenManager.map;
         if(_loc13_ != null && param4 != -1 && param5 != -1)
         {
            _loc14_ = _loc13_.getShipManager().getHero();
            if(_loc14_ != null)
            {
               _loc15_ = Math.pow(_loc14_.y - param5,2) + Math.pow(_loc14_.x - param4,2);
               if(_loc15_ > soundRadius * soundRadius)
               {
                  return null;
               }
               _loc16_ = FastMath.sqrt(_loc15_);
               _loc17_ = _loc11_ - _loc11_ / soundRadius * _loc16_;
               _loc12_.volume = _loc17_;
               _loc18_ = -1 * (1 / 500) * (_loc14_.x - param4);
               _loc12_.pan = _loc18_;
            }
         }
         if(param2)
         {
            if(param3)
            {
               _loc10_ = _loc9_.play(0,9999,_loc12_);
               TweenLite.to(_loc12_,0.75,{
                  "volume":_loc7_.getVolume(),
                  "onUpdate":updateChannel,
                  "onUpdateParams":[_loc10_,_loc12_]
               });
            }
            else
            {
               _loc10_ = _loc9_.play(0,9999,_loc12_);
            }
         }
         else
         {
            _loc10_ = _loc9_.play(0,0,_loc12_);
         }
         if(_loc10_ == null)
         {
            return null;
         }
         _loc10_.addEventListener(Event.SOUND_COMPLETE,soundComplete);
         ++sndCnt;
         return _loc10_;
      }
      
      private static function soundComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.currentTarget as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
         --sndCnt;
      }
      
      private static function updateChannel(param1:SoundChannel, param2:SoundTransform) : void
      {
         if(param1 != null)
         {
            param1.soundTransform = param2;
         }
      }
      
      public static function removeLoop(param1:SoundChannel, param2:Boolean = false) : void
      {
         var _loc3_:SoundTransform = null;
         if(param2)
         {
            _loc3_ = param1.soundTransform;
            TweenLite.to(_loc3_,0.75,{
               "volume":0,
               "onUpdate":updateChannel,
               "onUpdateParams":[param1,_loc3_],
               "onComplete":removeLoop,
               "onCompleteParams":[param1,false]
            });
         }
         else
         {
            param1.stop();
            param1.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
            --sndCnt;
         }
      }
   }
}


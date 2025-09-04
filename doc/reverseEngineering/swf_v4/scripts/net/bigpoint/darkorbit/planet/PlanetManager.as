package net.bigpoint.darkorbit.planet
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PlanetManager
   {
      
      public static const logger:ILogger = Log.getLogger("PlanetManager");
      
      public static const CLIP_LOADED:String = "clipLoaded";
      
      public static const MIN_ICON_SIZE:int = 4;
      
      private var map:Map;
      
      private var halfScreenWidth:int;
      
      private var halfScreenHeight:int;
      
      private var timer:Timer;
      
      private var planetCnt:int = 0;
      
      public var clipLoadedEvent:EventDispatcher = new EventDispatcher();
      
      public function PlanetManager(param1:Map)
      {
         super();
         this.map = param1;
         this.halfScreenWidth = ScreenManager.getHalfScreenWidth();
         this.halfScreenHeight = ScreenManager.getHalfScreenHeight();
         param1.getMain().screenManager.planets = [];
      }
      
      public function startTimer() : void
      {
         this.timer = new Timer(25,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.handleTimer);
         this.timer.start();
      }
      
      public function cleanup() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Planet = null;
         var _loc1_:Array = this.map.getMain().screenManager.planets;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc4_];
            _loc2_ = this.map.getMain().screenManager.getBackgroundLayer(_loc3_.getLayerIndex());
            if(_loc3_.clip != null && _loc2_.contains(_loc3_.clip))
            {
               _loc2_.removeChild(_loc3_.clip);
            }
            _loc3_.removeClip();
            _loc4_++;
         }
         this.map.getMain().screenManager.planets = null;
         this.map.getMain().screenManager.planets = [];
         this.map = null;
      }
      
      private function attachClip(param1:Planet, param2:String) : void
      {
         var _loc3_:Sprite = this.map.getMain().screenManager.getBackgroundLayer(param1.getLayerIndex());
         if(param1.clip != null && _loc3_.contains(param1.clip))
         {
            return;
         }
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param2));
         var _loc5_:MovieClip = MovieClip(_loc4_.getEmbededMovieClip("planet"));
         _loc5_.mouseEnabled = Main.mouseEventsEnabled;
         _loc5_.mouseChildren = Main.mouseEventsEnabled;
         _loc5_.x = param1.x;
         _loc5_.y = param1.y;
         _loc5_.rotation = param1.rotation;
         param1.clip = _loc5_;
         param1.clip.alpha = 0;
         _loc3_.addChild(param1.clip);
      }
      
      private function removeClip(param1:Planet) : void
      {
         var _loc2_:Sprite = this.map.getMain().screenManager.getBackgroundLayer(param1.getLayerIndex());
         if(param1.clip != null && _loc2_.contains(param1.clip))
         {
            _loc2_.removeChild(param1.clip);
            param1.clip = null;
         }
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         if(Settings.qualityBackground >= Settings.QUALITY_GOOD)
         {
            if(this.map != null && this.map.getShipManager() != null && this.map.getShipManager().getHero() != null)
            {
               this.fadeInPlanets();
            }
         }
      }
      
      public function fadeInPlanets() : void
      {
         var _loc2_:Planet = null;
         var _loc1_:Array = this.map.getMain().screenManager.planets;
         if(this.planetCnt == _loc1_.length)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleTimer);
         }
         if(_loc1_ != null)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_ != null && _loc2_.clip != null && _loc2_.clip.alpha == 0)
               {
                  TweenLite.to(_loc2_.clip,0.5,{"alpha":1});
                  ++this.planetCnt;
               }
            }
         }
         this.clipLoadedEvent.dispatchEvent(new Event(CLIP_LOADED));
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc4_:Planet = null;
         var _loc5_:PlanetPattern = null;
         var _loc2_:Array = this.map.getMain().screenManager.planets;
         if(Settings.unloadResources)
         {
            this.map.addFinisherToList(param1);
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = PatternManager.planetPatterns[_loc4_.getTypeID()];
            if(_loc5_.getResKey() == param1.fileVO.id)
            {
               this.attachClip(_loc4_,_loc5_.getResKey());
            }
            _loc3_++;
         }
      }
      
      public function preparePlanet(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:int, param7:int = -1) : void
      {
         var _loc8_:Array = this.map.getMain().screenManager.planets;
         var _loc9_:PlanetPattern = PatternManager.planetPatterns[int(param1)];
         var _loc10_:Planet = new Planet(_loc9_,param1,param2,param3,param4,param5,param6,param7);
         if(Settings.qualityBackground >= Settings.QUALITY_GOOD)
         {
            ResourceManager.fileCollection.load(_loc9_.getResKey(),this.onClipLoaded);
         }
         _loc8_.push(_loc10_);
         _loc8_.sortOn("layerIndex",Array.NUMERIC);
      }
      
      public function updatePlanetQuality(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Planet = null;
         var _loc4_:PlanetPattern = null;
         if(Settings.qualityBackground != param1)
         {
            _loc2_ = this.map.getMain().screenManager.planets;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ != null)
               {
                  switch(Settings.qualityBackground)
                  {
                     case Settings.QUALITY_LOW:
                     case Settings.QUALITY_MEDIUM:
                        this.removeClip(_loc3_);
                        break;
                     case Settings.QUALITY_GOOD:
                     case Settings.QUALITY_HIGH:
                        _loc4_ = _loc3_.pattern;
                        break;
                  }
                  if(ResourceManager.fileCollection.isLoaded(_loc4_.getResKey()))
                  {
                     this.attachClip(_loc3_,_loc4_.getResKey());
                     this.fadeInPlanets();
                  }
                  else
                  {
                     ResourceManager.fileCollection.load(_loc4_.getResKey(),this.onClipLoaded);
                  }
               }
            }
         }
      }
   }
}


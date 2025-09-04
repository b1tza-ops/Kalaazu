package net.bigpoint.darkorbit.station
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class StationManager
   {
      
      private static const logger:ILogger = Log.getLogger("StationManager");
      
      private var stations:Array;
      
      public var assets:Array = [];
      
      private var map:Map;
      
      private var halfScreenWidth:int;
      
      private var halfScreenHeight:int;
      
      public function StationManager(param1:Map)
      {
         super();
         this.map = param1;
         this.halfScreenWidth = ScreenManager.getHalfScreenWidth();
         this.halfScreenHeight = ScreenManager.getHalfScreenHeight();
         this.stations = [];
      }
      
      private function attachClip(param1:Station, param2:String) : void
      {
         var _loc6_:MovieClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param2));
         var _loc4_:MovieClip = MovieClip(_loc3_.getEmbededMovieClip("mc"));
         if(param1.getTypeID() == 4)
         {
            this.prepareHealthStation(_loc4_);
            param1.stationGraphic = _loc4_;
         }
         _loc4_.mouseEnabled = Main.mouseEventsEnabled;
         _loc4_.mouseChildren = Main.mouseEventsEnabled;
         _loc4_.x = param1.getPosX();
         _loc4_.y = param1.getPosY();
         param1.clip = _loc4_;
         this.map.getMain().screenManager.getPortalLayer().addChild(_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < 11)
         {
            _loc6_ = _loc4_["glow_" + _loc5_];
            if(_loc6_ != null)
            {
               _loc6_.alpha = 0;
               _loc6_.mouseEnabled = Main.mouseEventsEnabled;
               _loc6_.mouseChildren = Main.mouseEventsEnabled;
               _loc6_.blendMode = "screen";
               this.startGlow(_loc6_);
            }
            _loc5_++;
         }
         if(this.map.getMinimapManager().getMiniMap())
         {
            this.map.getMinimapManager().getMiniMap().redrawEntities();
         }
      }
      
      private function prepareHealthStation(param1:MovieClip) : void
      {
         param1.topLight.alpha = 0;
         param1.botLight.alpha = 0;
         param1.rightLight.alpha = 0;
         param1.leftLight.alpha = 0;
         param1.cross.alpha = 0;
      }
      
      public function hitTest(param1:int, param2:int) : RelayStation
      {
         var _loc3_:RelayStation = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         for each(_loc3_ in this.assets)
         {
            _loc4_ = _loc3_.clickRadius;
            _loc4_ *= _loc4_;
            _loc5_ = _loc3_.clickOffSetX;
            _loc6_ = _loc3_.clickOffSetY;
            _loc7_ = Math.pow(_loc3_.y + _loc6_ - param2,2) + Math.pow(_loc3_.x + _loc5_ - param1,2);
            if(_loc7_ < _loc4_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getSelectedAsset() : RelayStation
      {
         var _loc1_:RelayStation = null;
         for each(_loc1_ in this.assets)
         {
            if(_loc1_.isSelected == true)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getAssetForID(param1:int) : RelayStation
      {
         var _loc2_:RelayStation = null;
         for each(_loc2_ in this.assets)
         {
            if(_loc2_.relayID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function startGlow(param1:MovieClip) : void
      {
         TweenLite.to(param1,1,{
            "alpha":1,
            "onComplete":this.handleGlow,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleGlow(param1:MovieClip) : void
      {
         TweenLite.to(param1,1,{
            "ease":Bounce.easeOut,
            "delay":1,
            "alpha":0,
            "onComplete":this.startGlow,
            "onCompleteParams":[param1]
         });
      }
      
      public function cleanup() : void
      {
         var _loc3_:Station = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:RelayStation = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.stations.length)
         {
            _loc3_ = this.stations[_loc1_];
            _loc4_ = _loc3_.clip;
            if(_loc4_ != null)
            {
               _loc5_ = this.map.getMain().screenManager.getPortalLayer();
               if(_loc5_.contains(_loc4_))
               {
                  this.map.getMain().screenManager.getPortalLayer().removeChild(_loc4_);
               }
               _loc6_ = 0;
               while(_loc6_ < 11)
               {
                  _loc7_ = _loc4_["glow_" + _loc6_];
                  if(_loc7_ != null)
                  {
                     TweenMax.killTweensOf(_loc7_);
                  }
                  _loc6_++;
               }
            }
            _loc3_.removeClip();
            _loc1_++;
         }
         var _loc2_:Sprite = this.map.getMain().screenManager.getShipLayer();
         _loc1_ = 0;
         while(_loc1_ < this.assets.length)
         {
            _loc8_ = this.assets[_loc1_];
            if(_loc2_.contains(_loc8_))
            {
               _loc2_.removeChild(_loc8_);
            }
            _loc1_++;
         }
         this.stations = [];
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Station = null;
         var _loc4_:StationPattern = null;
         if(Settings.unloadResources)
         {
            this.map.addFinisherToList(param1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.stations.length)
         {
            _loc3_ = this.stations[_loc2_];
            _loc4_ = PatternManager.stationPatterns[_loc3_.getTypeID()];
            if(_loc4_.getResKey() == param1.fileVO.id)
            {
               this.attachClip(_loc3_,_loc4_.getResKey());
            }
            _loc2_++;
         }
      }
      
      public function addSpaceStation(param1:int, param2:int, param3:String, param4:int, param5:int) : void
      {
         if(this.stations[param1] != undefined)
         {
            return;
         }
         var _loc6_:StationPattern = PatternManager.stationPatterns[param2];
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:Station = new Station(param1,param2,param3,param4,param5,_loc6_);
         this.stations[param1] = _loc7_;
         if(ResourceManager.fileCollection.isLoaded(_loc6_.getResKey()))
         {
            this.attachClip(_loc7_,_loc6_.getResKey());
         }
         else
         {
            ResourceManager.fileCollection.load(_loc6_.getResKey(),this.onClipLoaded);
         }
      }
      
      public function getStations() : Array
      {
         return this.stations;
      }
   }
}


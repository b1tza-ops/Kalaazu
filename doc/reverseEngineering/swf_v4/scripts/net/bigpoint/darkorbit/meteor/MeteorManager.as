package net.bigpoint.darkorbit.meteor
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.geom.Rectangle;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MeteorManager
   {
      
      public static const logger:ILogger = Log.getLogger("Client.MeteorManager");
      
      private var meteorSwarms:Array;
      
      private var map:Map;
      
      public function MeteorManager(param1:Map)
      {
         super();
         this.map = param1;
         this.meteorSwarms = [];
      }
      
      public function displayMeteor(param1:MeteorPattern) : void
      {
         var _loc2_:ResourcePattern = PatternManager.meteorPatterns[int(param1.getTypeID())];
         if(ResourceManager.fileCollection.isLoaded(_loc2_.getResKey()))
         {
            this.attachClip(param1,_loc2_);
         }
         else
         {
            ResourceManager.fileCollection.load(_loc2_.getResKey(),this.onClipLoaded);
         }
      }
      
      private function attachClip(param1:MeteorPattern, param2:ResourcePattern) : void
      {
         var _loc3_:MeteorSwarm = new MeteorSwarm(this,param2.getResKey(),new Rectangle(0,0,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight()),param1.getDelay(),param1.getSpeed());
         param1.clip = _loc3_;
         this.map.getMain().screenManager.getMeteorLayer(param1.getLayerIndex()).addChild(_loc3_);
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:MeteorPattern = null;
         var _loc4_:ResourcePattern = null;
         if(Settings.unloadResources)
         {
            this.map.addFinisherToList(param1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.meteorSwarms.length)
         {
            _loc3_ = this.meteorSwarms[_loc2_];
            _loc4_ = PatternManager.meteorPatterns[int(_loc3_.getTypeID())];
            if(_loc4_.getResKey() == param1.fileVO.id)
            {
               this.attachClip(_loc3_,_loc4_);
            }
            _loc2_++;
         }
      }
      
      public function cleanup() : void
      {
         var _loc2_:MeteorPattern = null;
         var _loc3_:MeteorSwarm = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.meteorSwarms.length)
         {
            _loc2_ = this.meteorSwarms[_loc1_];
            _loc3_ = MeteorSwarm(_loc2_.clip);
            _loc3_.cleanup();
            this.map.getMain().screenManager.getMeteorLayer(_loc2_.getLayerIndex()).removeChild(_loc3_);
            _loc2_.removeClip();
            _loc1_++;
         }
         this.meteorSwarms = [];
      }
      
      public function prepareMeteors(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:MeteorPattern = new MeteorPattern(param1,param2,param3,param4);
         this.meteorSwarms.push(_loc5_);
         this.displayMeteor(_loc5_);
      }
      
      public function getMap() : Map
      {
         return this.map;
      }
   }
}


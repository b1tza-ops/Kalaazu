package net.bigpoint.darkorbit
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.collectable.CollectablePattern;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import net.bigpoint.darkorbit.ship.EngineSmokePattern;
   
   public class ObjectPoolManager
   {
      
      public static var engineSmokePool:Array = [];
      
      public static var rocketSmokePool:Array = [];
      
      public static var collectablePool:Array = [];
      
      public static var laserPool:Array = [];
      
      private static const ENGINESMOKE_POOL_SIZE:int = 2500;
      
      private static const ROCKETSMOKE_POOL_SIZE:int = 1000;
      
      public function ObjectPoolManager()
      {
         super();
      }
      
      public static function precache() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:CollectablePattern = null;
         var _loc4_:ExplosionPattern = null;
         for each(_loc1_ in PatternManager.collectableClasses)
         {
            for each(_loc3_ in _loc1_)
            {
               if(_loc3_.useBitmapClip && _loc3_.precache)
               {
                  new BitmapClip(ResourceManager.getMovieClip(_loc3_.getResKey(),"mc"),_loc3_.getResKey());
               }
            }
         }
         for each(_loc2_ in PatternManager.pyroClasses)
         {
            for each(_loc4_ in _loc2_)
            {
               if(Boolean(_loc4_.useBitmapClip) && _loc4_.precache)
               {
                  new BitmapClip(ResourceManager.getMovieClip(_loc4_.getResKey(),"mc"),_loc4_.getResKey());
               }
            }
         }
      }
      
      public static function init() : void
      {
         var _loc1_:EngineSmokePattern = null;
         var _loc2_:RocketSmokePattern = null;
         for each(_loc1_ in PatternManager.engineSmokePatterns)
         {
            createEngineSmokePool(_loc1_.resKey,ENGINESMOKE_POOL_SIZE);
         }
         for each(_loc2_ in PatternManager.rocketSmokePatterns)
         {
            createRocketSmokePool(_loc2_.resKey,ROCKETSMOKE_POOL_SIZE);
         }
      }
      
      public static function createEngineSmokePool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BitmapClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            _loc6_ = new BitmapClip(_loc5_,param1);
            _loc4_.push(_loc6_);
            _loc7_++;
         }
         engineSmokePool[param1] = _loc4_;
      }
      
      public static function createLaserPool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            _loc5_.gotoAndStop(1);
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            _loc4_.push(_loc5_);
            _loc6_++;
         }
         laserPool[param1] = _loc4_;
      }
      
      public static function createRocketSmokePool(param1:String, param2:int) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BitmapClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc5_ = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            _loc6_ = new BitmapClip(_loc5_,param1);
            _loc4_.push(_loc6_);
            _loc7_++;
         }
         rocketSmokePool[param1] = _loc4_;
      }
      
      public static function getRocketSmokeClip(param1:String) : BitmapClip
      {
         var _loc2_:Array = rocketSmokePool[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.pop();
      }
      
      public static function addRocketSmokeClip(param1:BitmapClip) : void
      {
         var _loc2_:Array = rocketSmokePool[param1.cacheID];
         _loc2_.push(param1);
      }
      
      public static function createCollectablePool(param1:String, param2:int) : void
      {
         var _loc6_:MovieClip = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < param2)
         {
            _loc6_ = MovieClip(_loc3_.getEmbededMovieClip("mc"));
            _loc6_.mouseEnabled = Main.mouseEventsEnabled;
            _loc6_.mouseChildren = Main.mouseEventsEnabled;
            _loc4_.push(_loc6_);
            _loc5_++;
         }
         collectablePool[param1] = _loc4_;
      }
   }
}


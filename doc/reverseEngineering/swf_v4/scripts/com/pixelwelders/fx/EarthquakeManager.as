package com.pixelwelders.fx
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class EarthquakeManager
   {
      
      private static var _instance:EarthquakeManager;
      
      private var activeEarthquakes:Dictionary = new Dictionary();
      
      private var rotationQuivers:Dictionary = new Dictionary();
      
      public function EarthquakeManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("EarthquakeManager is a Singleton and can only be accessed through EarthquakeManager.getInstance()");
         }
      }
      
      public static function getInstance() : EarthquakeManager
      {
         if(_instance == null)
         {
            _instance = new EarthquakeManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function addQuake(param1:DisplayObject, param2:Number = 10, param3:Number = -1) : void
      {
         var _loc4_:Earthquake = null;
         if(this.activeEarthquakes[param1] == null)
         {
            _loc4_ = new Earthquake(param1,param2,param3);
            this.activeEarthquakes[param1] = _loc4_;
         }
      }
      
      public function killQuake(param1:DisplayObject) : void
      {
         var _loc2_:Earthquake = this.activeEarthquakes[param1];
         if(_loc2_ != null)
         {
            _loc2_.killQuake();
         }
         delete this.activeEarthquakes[param1];
         _loc2_ = null;
      }
      
      public function addRotationQuiver(param1:DisplayObject, param2:Number = 10) : void
      {
         var _loc3_:RotationQuiver = null;
         if(this.rotationQuivers[param1] == null)
         {
            _loc3_ = new RotationQuiver(param1,param2);
            this.rotationQuivers[param1] = _loc3_;
         }
      }
      
      public function killQuiver(param1:DisplayObject) : void
      {
         var _loc2_:RotationQuiver = this.rotationQuivers[param1];
         if(_loc2_ != null)
         {
            _loc2_.killQuiver();
         }
         delete this.rotationQuivers[param1];
         _loc2_ = null;
      }
   }
}


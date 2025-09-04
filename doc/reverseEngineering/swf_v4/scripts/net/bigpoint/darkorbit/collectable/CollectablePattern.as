package net.bigpoint.darkorbit.collectable
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   
   public class CollectablePattern extends AudibleResourcePattern
   {
      
      public static const logger:ILogger = Log.getLogger("CollectablePattern");
      
      public static var TYPE_BOX:int = 0;
      
      public static var TYPE_ORE:int = 1;
      
      public static var TYPE_BEACON:int = 2;
      
      public static var TYPE_FIREWORKS_BOX:int = 3;
      
      public static var BEACON_FRONTIER_ID:int = 111;
      
      private var collectableClass:int;
      
      private var duration:int;
      
      public var hasObjectPool:Boolean;
      
      public var useBitmapClip:Boolean;
      
      public var precache:Boolean;
      
      public var hasSimpleRapresentation:Boolean = false;
      
      public var isHarvestable:Boolean = false;
      
      public function CollectablePattern(param1:int, param2:int, param3:String)
      {
         super(param2,param3);
         this.collectableClass = param1;
         this.duration = 1000;
      }
      
      public function getCollectableClass() : int
      {
         return this.collectableClass;
      }
      
      public function getDuration() : int
      {
         return this.duration;
      }
      
      public function setDuration(param1:int) : void
      {
         this.duration = param1;
      }
   }
}


package net.bigpoint.darkorbit.nebula
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class NebulaManager
   {
      
      public static const logger:ILogger = Log.getLogger("NebulaManager");
      
      private var nebulas:Array;
      
      private var map:Map;
      
      public function NebulaManager(param1:Map)
      {
         super();
         this.map = param1;
         this.nebulas = [];
      }
      
      public function showNebula(param1:int, param2:int) : void
      {
         var _loc3_:Nebula = new Nebula(param1,param2);
         this.nebulas.push(_loc3_);
         var _loc4_:ResourcePattern = PatternManager.nebulaPatterns[int(param1)];
         if(ResourceManager.fileCollection.isLoaded(_loc4_.getResKey()))
         {
            this.attachClip(_loc3_,_loc4_);
         }
         else
         {
            ResourceManager.fileCollection.load(_loc4_.getResKey(),this.onClipLoaded);
         }
      }
      
      private function attachClip(param1:Nebula, param2:ResourcePattern) : void
      {
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Nebula = null;
         var _loc4_:ResourcePattern = null;
         if(Settings.unloadResources)
         {
            this.map.addFinisherToList(param1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.nebulas.length)
         {
            _loc3_ = this.nebulas[_loc2_];
            if(_loc3_ != null)
            {
               _loc4_ = PatternManager.nebulaPatterns[int(_loc3_.getTypeID())];
               if(_loc4_.getResKey() == param1.fileVO.id)
               {
                  this.attachClip(_loc3_,_loc4_);
               }
            }
            _loc2_++;
         }
      }
      
      public function updateNebula() : void
      {
      }
      
      public function cleanup() : void
      {
      }
   }
}


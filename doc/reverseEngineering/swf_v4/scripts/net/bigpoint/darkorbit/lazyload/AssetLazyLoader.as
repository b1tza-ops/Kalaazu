package net.bigpoint.darkorbit.lazyload
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.events.EventDispatcher;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class AssetLazyLoader extends EventDispatcher
   {
      
      private static const logger:ILogger = Log.getLogger("AssetLazyLoader");
      
      public static const ASSET_LOADED:String = "ASSET_LOADED";
      
      public var resKeyForThisLoader:String;
      
      public function AssetLazyLoader()
      {
         super();
      }
      
      public function loadAsset(param1:String) : void
      {
         this.resKeyForThisLoader = param1;
         ResourceManager.lazyGetAsset(param1,this.handleAssetLoaded,this.handleAssetLoadingError);
      }
      
      private function handleAssetLoaded(param1:SWFFinisher = null) : void
      {
         dispatchEvent(new LazyLoadEvent(ASSET_LOADED,this.resKeyForThisLoader));
      }
      
      private function handleAssetLoadingError() : void
      {
      }
   }
}


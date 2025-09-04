package net.bigpoint.darkorbit.fireworks
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class FireworksAddons
   {
      
      private var pendingAssets:Dictionary;
      
      private var pendingAssetsCount:int;
      
      private var loadingCompleteCallback:Function;
      
      public function FireworksAddons()
      {
         super();
         this.pendingAssets = new Dictionary();
         this.pendingAssetsCount = 0;
      }
      
      public function load(param1:Array, param2:Function) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.loadingCompleteCallback = param2;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(this.pendingAssets[_loc4_] == null)
            {
               if(!ResourceManager.fileCollection.isLoaded(_loc4_))
               {
                  this.pendingAssets[_loc4_] = true;
                  ++this.pendingAssetsCount;
               }
            }
            _loc3_++;
         }
         if(this.pendingAssetsCount == 0)
         {
            this.loadingCompleteCallback();
         }
         else
         {
            for(_loc5_ in this.pendingAssets)
            {
               ResourceManager.fileCollection.load(_loc5_,this.handleRequestedAssetLoaded);
            }
         }
      }
      
      private function handleRequestedAssetLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:String = param1.fileVO.id;
         if(this.pendingAssets[_loc2_] != null)
         {
            delete this.pendingAssets[_loc2_];
            --this.pendingAssetsCount;
            if(this.pendingAssetsCount == 0)
            {
               this.loadingCompleteCallback();
            }
         }
      }
   }
}


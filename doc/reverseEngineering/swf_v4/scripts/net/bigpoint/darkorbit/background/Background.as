package net.bigpoint.darkorbit.background
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.mapfactory.ReloadableTiledMap;
   import net.bigpoint.as3toolbox.mapfactory.TiledMap;
   import net.bigpoint.as3toolbox.mapfactory.TiledMapEvent;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   import net.bigpoint.darkorbit.pattern.Pattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Background extends DynamicResource
   {
      
      private var parallaxFactor:int;
      
      private var layerIndex:int;
      
      public var isMain:Boolean;
      
      public var isPOIZone:Boolean;
      
      public var hideLensflare:Boolean;
      
      public var shiftX:int;
      
      public var shiftY:int;
      
      public var scale:Number;
      
      public var width:int;
      
      public var height:int;
      
      public var offsetX:int = 0;
      
      public var offsetY:int = 0;
      
      public var equalNeighborsAllowed:Boolean = false;
      
      public var maskID:int;
      
      public var maskBd:BitmapData;
      
      public var tiledMap:TiledMap;
      
      private var tilesToLoadQueue:Vector.<String>;
      
      public function Background(param1:int, param2:Boolean, param3:int, param4:int, param5:Boolean, param6:int, param7:int, param8:Number, param9:int, param10:Boolean = false, param11:BitmapData = null)
      {
         super(param1);
         this.isMain = param2;
         this.parallaxFactor = param3;
         this.layerIndex = param4;
         this.hideLensflare = param5;
         this.shiftX = param6;
         this.shiftY = param7;
         this.scale = param8;
         this.maskID = param9;
         this.isPOIZone = param10;
         this.maskBd = param11;
      }
      
      public function initReloadableTiledMap() : void
      {
         this.tilesToLoadQueue = new Vector.<String>();
         this.tiledMap.addEventListener(TiledMapEvent.LOAD_REQUEST,this.handleTiledMapLoadRequest);
      }
      
      private function handleTiledMapLoadRequest(param1:TiledMapEvent) : void
      {
         var _loc2_:String = param1.fileKey;
         this.tilesToLoadQueue.push(_loc2_);
         var _loc3_:Pattern = PatternManager.backgroundPatterns[getTypeID()];
         if(ResourceManager.fileCollection.isLoaded(BackgroundPattern(_loc3_).getResKey()))
         {
            this.handleTileContainerLoaded();
         }
         else
         {
            this.loadTileContainer(BackgroundPattern(_loc3_).getResKey());
         }
      }
      
      private function loadTileContainer(param1:String) : void
      {
         ResourceManager.fileCollection.load(param1,this.handleTileContainerLoaded);
      }
      
      private function handleTileContainerLoaded() : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:String = null;
         var _loc1_:Pattern = PatternManager.backgroundPatterns[getTypeID()];
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(BackgroundPattern(_loc1_).getResKey()));
         while(this.tilesToLoadQueue.length > 0)
         {
            _loc4_ = this.tilesToLoadQueue.pop();
            _loc3_ = _loc2_.getEmbededBitmapData(_loc4_);
            ReloadableTiledMap(this.tiledMap).updateReloadableTile(_loc4_,_loc3_);
         }
      }
      
      public function getParallaxFactor() : int
      {
         return this.parallaxFactor;
      }
      
      public function getLayerIndex() : int
      {
         return this.layerIndex;
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         if(clip != null)
         {
            _loc1_ = 0;
            while(_loc1_ < clip.numChildren)
            {
               clip.removeChildAt(0);
               _loc1_++;
            }
            if(clip.parent.contains(clip))
            {
               clip.parent.removeChild(clip);
            }
            clip = null;
         }
         if(this.tiledMap != null)
         {
            this.tiledMap.removeEventListener(TiledMapEvent.LOAD_REQUEST,this.handleTiledMapLoadRequest);
            this.tiledMap.cleanup();
            this.tiledMap = null;
         }
      }
   }
}


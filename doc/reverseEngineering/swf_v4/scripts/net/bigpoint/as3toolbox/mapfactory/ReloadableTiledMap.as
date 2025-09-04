package net.bigpoint.as3toolbox.mapfactory
{
   import flash.display.BitmapData;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ReloadableTiledMap extends TiledMap
   {
      
      private var placeHolder:BitmapData;
      
      private var timestampedTiles:Array = [];
      
      private var requestedReloadableTiles:Array = [];
      
      private var reloadableTilesToUpdate:Array = [];
      
      private var removeDelayInSec:int;
      
      private var reloadedTileRemover:Timer;
      
      private var fadeIn:Boolean;
      
      public function ReloadableTiledMap(param1:Array, param2:Vector.<Tile>, param3:int, param4:int, param5:int, param6:int, param7:BitmapData = null, param8:int = 5, param9:Boolean = false, param10:Boolean = false)
      {
         super(null,param2,param3,param4,param5,param6,param10);
         this.map = param1;
         this.placeHolder = param7;
         this.removeDelayInSec = param8 * 1000;
         this.fadeIn = param9;
         if(param8 != -1)
         {
            this.startReloadedTileHandler();
         }
         init();
      }
      
      override internal function copyTiles() : void
      {
         var _loc5_:ReloadableSimpleTile = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Tile = null;
         var _loc10_:BitmapData = null;
         var _loc11_:ReloadableSimpleTile = null;
         var _loc12_:SimpleTile = null;
         if(this.parent == null)
         {
            return;
         }
         this.timestampedTiles.length = 0;
         var _loc1_:int = pX + maxFitTilesX - 1;
         var _loc2_:int = pY + maxFitTilesY - 1;
         var _loc3_:int = 0;
         canvas.bitmapData.lock();
         canvas.bitmapData.fillRect(canvas.bitmapData.rect,0);
         var _loc4_:int = pY;
         while(_loc4_ < _loc2_ - dY)
         {
            _loc6_ = 0;
            _loc7_ = pX;
            while(_loc7_ < _loc1_ - dX)
            {
               if(_loc7_ < 0 || _loc7_ >= max_tiles_x || _loc4_ < 0 || _loc4_ >= max_tiles_y)
               {
                  _loc8_ = int(tiles.length - 1);
               }
               else
               {
                  _loc8_ = (map[_loc4_][_loc7_] as IMapElement).getTileID();
               }
               if(_loc8_ != -1)
               {
                  _loc9_ = tiles[_loc8_];
                  _loc10_ = null;
                  if(_loc9_ is ReloadableSimpleTile)
                  {
                     _loc11_ = _loc9_ as ReloadableSimpleTile;
                     if(_loc11_.cacheID != null)
                     {
                        if(!SimpleTile.bitmapDataCache[_loc11_.cacheID])
                        {
                           if(this.placeHolder == null)
                           {
                              this.createPlaceHolderTile();
                           }
                           _loc10_ = this.placeHolder;
                           if(!this.requestedReloadableTiles[_loc11_.fileKey])
                           {
                              this.requestedReloadableTiles[_loc11_.fileKey] = _loc11_;
                              _loc11_.valid = true;
                           }
                        }
                        else
                        {
                           _loc10_ = SimpleTile.bitmapDataCache[_loc11_.cacheID];
                           this.timestampedTiles[_loc8_] = true;
                        }
                     }
                     else if(_loc11_.bitmapData == null)
                     {
                        if(this.placeHolder == null)
                        {
                           this.createPlaceHolderTile();
                        }
                        _loc10_ = this.placeHolder;
                        if(!this.requestedReloadableTiles[_loc11_.fileKey])
                        {
                           this.requestedReloadableTiles[_loc11_.fileKey] = _loc11_;
                           _loc11_.valid = true;
                        }
                     }
                     else
                     {
                        _loc10_ = _loc11_.bitmapData;
                        this.timestampedTiles[_loc8_] = true;
                     }
                  }
                  else if(_loc9_ is SimpleTile)
                  {
                     _loc12_ = _loc9_ as SimpleTile;
                     if(_loc12_.cacheID != null)
                     {
                        _loc10_ = SimpleTile.bitmapDataCache[_loc12_.cacheID];
                     }
                     else
                     {
                        _loc10_ = _loc12_.bitmapData;
                     }
                  }
                  if(_loc10_ != null)
                  {
                     point.x = _loc6_ * tileRect.width + tileRect.width;
                     point.y = _loc3_ * tileRect.height + tileRect.height;
                     _loc6_++;
                     canvas.bitmapData.copyPixels(_loc10_,tileRect,point);
                  }
               }
               _loc7_++;
            }
            _loc3_++;
            _loc4_++;
         }
         if(debug)
         {
            canvas.bitmapData.draw(this.grid);
         }
         canvas.bitmapData.unlock();
         for each(_loc5_ in this.requestedReloadableTiles)
         {
            this.loadRequestedTile(_loc5_);
         }
      }
      
      private function createPlaceHolderTile() : void
      {
         this.placeHolder = new BitmapData(tileWidth,tileHeight,true,0);
      }
      
      private function loadRequestedTile(param1:ReloadableSimpleTile) : void
      {
         delete this.requestedReloadableTiles[param1.fileKey];
         this.reloadableTilesToUpdate[param1.fileKey] = param1;
         var _loc2_:TiledMapEvent = new TiledMapEvent(TiledMapEvent.LOAD_REQUEST);
         _loc2_.fileKey = param1.fileKey;
         dispatchEvent(_loc2_);
      }
      
      public function updateReloadableTile(param1:String, param2:BitmapData) : void
      {
         var _loc3_:ReloadableSimpleTile = null;
         if(this.reloadableTilesToUpdate[param1])
         {
            _loc3_ = this.reloadableTilesToUpdate[param1];
            delete this.reloadableTilesToUpdate[param1];
            if(_loc3_.valid)
            {
               _loc3_.updateBitmapData(param2);
               this.copyTiles();
            }
         }
      }
      
      private function handleReloadedTileRemover(param1:TimerEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Tile = null;
         var _loc6_:ReloadableSimpleTile = null;
         var _loc2_:int = getTimer();
         for(_loc3_ in this.timestampedTiles)
         {
            _loc5_ = tiles[_loc3_];
            (_loc5_ as ReloadableSimpleTile).timestamp = _loc2_;
         }
         _loc4_ = 0;
         while(_loc4_ < tiles.length)
         {
            _loc5_ = tiles[_loc4_];
            if(_loc5_ is ReloadableSimpleTile)
            {
               _loc6_ = _loc5_ as ReloadableSimpleTile;
               if(_loc2_ - _loc6_.timestamp > this.removeDelayInSec)
               {
                  _loc6_.removeBitmapData();
                  _loc6_.valid = false;
               }
            }
            _loc4_++;
         }
      }
      
      private function startReloadedTileHandler() : void
      {
         var _loc2_:Tile = null;
         var _loc1_:int = 0;
         while(_loc1_ < tiles.length)
         {
            _loc2_ = tiles[_loc1_];
            if(_loc2_ is ReloadableSimpleTile)
            {
               if(this.reloadedTileRemover == null)
               {
                  this.reloadedTileRemover = new Timer(1000,0);
                  this.reloadedTileRemover.addEventListener(TimerEvent.TIMER,this.handleReloadedTileRemover);
                  this.reloadedTileRemover.start();
               }
            }
            _loc1_++;
         }
      }
      
      override public function cleanup(param1:Boolean = false) : void
      {
         super.cleanup(param1);
         this.reloadedTileRemover.stop();
         this.reloadedTileRemover.removeEventListener(TimerEvent.TIMER,this.handleReloadedTileRemover);
         this.reloadedTileRemover = null;
      }
   }
}


package net.bigpoint.as3toolbox.mapfactory
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class TiledMap extends Sprite
   {
      
      protected var map:Array;
      
      private var vpWidth:int;
      
      private var vpHeight:int;
      
      protected var tiles:Vector.<Tile>;
      
      protected var max_tiles_x:int;
      
      protected var max_tiles_y:int;
      
      protected var point:Point;
      
      protected var canvas:Bitmap;
      
      protected var maxFitTilesX:int;
      
      protected var maxFitTilesY:int;
      
      private var border:Shape;
      
      protected var pX:int;
      
      protected var pY:int;
      
      private var lastPX:int = -1;
      
      private var lastPY:int = -1;
      
      protected var debug:Boolean;
      
      protected var dX:int;
      
      protected var dY:int;
      
      protected var grid:Shape;
      
      private var effectTimer:Timer;
      
      protected var tileRect:Rectangle;
      
      protected var tileWidth:int;
      
      protected var tileHeight:int;
      
      public function TiledMap(param1:Array, param2:Vector.<Tile>, param3:int, param4:int, param5:int, param6:int, param7:Boolean = false)
      {
         super();
         this.map = param1;
         this.tiles = param2;
         this.vpWidth = param3;
         this.vpHeight = param4;
         this.tileWidth = param5;
         this.tileHeight = param6;
         this.tileRect = new Rectangle();
         this.tileRect.width = param5;
         this.tileRect.height = param6;
         this.debug = param7;
         this.point = new Point();
         if(param1 != null)
         {
            this.init();
         }
      }
      
      public static function createMap(param1:int, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:MapElement = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_[_loc4_] = new Array();
            _loc5_ = 0;
            while(_loc5_ < param1)
            {
               _loc6_ = new MapElement();
               _loc6_.setTileID(-1);
               _loc3_[_loc4_][_loc5_] = _loc6_;
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function init() : void
      {
         this.startEffectTimer();
         this.createTransparentTile();
         this.createCanvas();
         this.max_tiles_y = this.map.length;
         this.max_tiles_x = (this.map[0] as Array).length;
         if(this.debug)
         {
            this.border = new Shape();
            this.border.graphics.lineStyle(2,255);
            this.border.graphics.drawRect(0,0,this.vpWidth,this.vpHeight);
            this.addChild(this.border);
            this.drawGrid();
         }
         this.copyTiles();
      }
      
      private function startEffectTimer() : void
      {
         var _loc1_:Tile = null;
         var _loc2_:Array = null;
         for each(_loc1_ in this.tiles)
         {
            if(_loc1_ is SimpleTile)
            {
               _loc2_ = SimpleTile(_loc1_).effects;
               if(_loc2_ != null && _loc2_.length > 0)
               {
                  this.effectTimer = new Timer(250,0);
                  this.effectTimer.addEventListener(TimerEvent.TIMER,this.handleEffectTimer);
                  this.effectTimer.start();
                  break;
               }
            }
         }
      }
      
      private function handleEffectTimer(param1:TimerEvent) : void
      {
         var _loc2_:Tile = null;
         var _loc3_:Array = null;
         var _loc4_:ITileEffect = null;
         for each(_loc2_ in this.tiles)
         {
            if(_loc2_ is SimpleTile)
            {
               _loc3_ = SimpleTile(_loc2_).effects;
               if(_loc3_ != null)
               {
                  for each(_loc4_ in _loc3_)
                  {
                     _loc4_.update();
                  }
               }
            }
         }
         this.copyTiles();
      }
      
      private function createTransparentTile() : void
      {
         if(this.tileWidth == 0 || this.tileHeight == 0)
         {
            throw new Error("tileWidth or tileHeight is invalid!");
         }
         var _loc1_:BitmapData = new BitmapData(this.tileWidth,this.tileHeight,true,0);
         this.tiles.push(new SimpleTile(this.tiles.length,_loc1_));
      }
      
      private function createCanvas() : void
      {
         this.maxFitTilesX = Math.ceil(this.vpWidth / this.tileWidth) + 2;
         this.maxFitTilesY = Math.ceil(this.vpHeight / this.tileHeight) + 2;
         if(this.debug)
         {
            this.canvas = new Bitmap(new BitmapData(this.vpWidth + this.tileWidth * 2,this.vpHeight + this.tileHeight * 2,false,65280));
         }
         else
         {
            this.canvas = new Bitmap(new BitmapData(this.vpWidth + this.tileWidth * 2,this.vpHeight + this.tileHeight * 2,true,0));
         }
         this.canvas.x = -this.tileWidth;
         this.canvas.y = -this.tileHeight;
         this.canvas.pixelSnapping = PixelSnapping.NEVER;
         this.addChild(this.canvas);
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.map != null)
         {
            _loc3_ = this.pX * this.tileWidth;
            _loc4_ = this.pY * this.tileHeight;
            if(this.pX != this.lastPX || this.pY != this.lastPY)
            {
               this.copyTiles();
            }
            this.lastPX = this.pX;
            this.lastPY = this.pY;
            this.pX = param1 / this.tileWidth * -1;
            this.pY = param2 / this.tileHeight * -1;
            this.canvas.x = param1 + _loc3_ - this.tileWidth;
            this.canvas.y = param2 + _loc4_ - this.tileHeight;
         }
      }
      
      internal function copyTiles() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Tile = null;
         var _loc9_:BitmapData = null;
         var _loc10_:SimpleTile = null;
         if(this.parent == null)
         {
            return;
         }
         var _loc1_:int = this.pX + this.maxFitTilesX - 1;
         var _loc2_:int = this.pY + this.maxFitTilesY - 1;
         var _loc3_:int = 0;
         this.canvas.bitmapData.lock();
         this.canvas.bitmapData.fillRect(this.canvas.bitmapData.rect,0);
         var _loc4_:int = this.pY;
         while(_loc4_ < _loc2_ - this.dY)
         {
            _loc5_ = 0;
            _loc6_ = this.pX;
            while(_loc6_ < _loc1_ - this.dX)
            {
               if(_loc6_ < 0 || _loc6_ >= this.max_tiles_x || _loc4_ < 0 || _loc4_ >= this.max_tiles_y)
               {
                  _loc7_ = int(this.tiles.length - 1);
               }
               else
               {
                  _loc7_ = (this.map[_loc4_][_loc6_] as IMapElement).getTileID();
               }
               if(_loc7_ != -1)
               {
                  _loc8_ = this.tiles[_loc7_];
                  _loc9_ = null;
                  _loc10_ = _loc8_ as SimpleTile;
                  if(_loc10_.cacheID != null)
                  {
                     _loc9_ = SimpleTile.bitmapDataCache[_loc10_.cacheID];
                  }
                  else
                  {
                     _loc9_ = _loc10_.bitmapData;
                  }
                  if(_loc9_ != null)
                  {
                     this.point.x = _loc5_ * this.tileWidth + this.tileWidth;
                     this.point.y = _loc3_ * this.tileHeight + this.tileHeight;
                     _loc5_++;
                     this.canvas.bitmapData.copyPixels(_loc9_,this.tileRect,this.point);
                  }
               }
               _loc6_++;
            }
            _loc3_++;
            _loc4_++;
         }
         if(this.debug)
         {
            this.canvas.bitmapData.draw(this.grid);
         }
         this.canvas.bitmapData.unlock();
      }
      
      private function drawGrid() : void
      {
         this.grid = new Shape();
         this.grid.graphics.lineStyle(1,65280);
         var _loc1_:int = this.tileHeight;
         var _loc2_:int = 0;
         while(_loc2_ < this.max_tiles_y)
         {
            this.grid.graphics.beginFill(65280);
            this.grid.graphics.moveTo(this.tileWidth,_loc1_);
            this.grid.graphics.lineTo(this.max_tiles_x * this.tileWidth,_loc1_);
            this.grid.graphics.endFill();
            _loc1_ += this.tileHeight;
            _loc2_++;
         }
         var _loc3_:int = this.tileWidth;
         var _loc4_:int = 0;
         while(_loc4_ < this.max_tiles_x)
         {
            this.grid.graphics.beginFill(65280);
            this.grid.graphics.moveTo(_loc3_,this.tileHeight);
            this.grid.graphics.lineTo(_loc3_,this.max_tiles_y * this.tileWidth);
            this.grid.graphics.endFill();
            _loc3_ += this.tileWidth;
            _loc4_++;
         }
      }
      
      public function cleanup(param1:Boolean = false) : void
      {
         var _loc2_:Tile = null;
         var _loc3_:SimpleTile = null;
         var _loc4_:BitmapData = null;
         this.map = null;
         this.canvas.bitmapData.dispose();
         for each(_loc2_ in this.tiles)
         {
            if(_loc2_ is SimpleTile)
            {
               _loc3_ = _loc2_ as SimpleTile;
               _loc3_.effects = [];
               if(_loc3_.bitmapData != null)
               {
                  _loc3_.bitmapData.dispose();
                  _loc3_.bitmapData = null;
               }
            }
         }
         this.tiles = null;
         if(parent != null)
         {
            parent.removeChild(this);
         }
         if(param1)
         {
            for each(_loc4_ in SimpleTile.bitmapDataCache)
            {
               _loc4_.dispose();
            }
            SimpleTile.bitmapDataCache = [];
         }
      }
      
      public function removeBitmapDataFromCache(param1:String) : void
      {
         if(SimpleTile.bitmapDataCache[param1])
         {
            (SimpleTile.bitmapDataCache[param1] as BitmapData).dispose();
            delete SimpleTile.bitmapDataCache[param1];
         }
      }
   }
}


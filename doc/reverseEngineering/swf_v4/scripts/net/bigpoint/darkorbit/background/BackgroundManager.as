package net.bigpoint.darkorbit.background
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.mapfactory.MapElement;
   import net.bigpoint.as3toolbox.mapfactory.ReloadableSimpleTile;
   import net.bigpoint.as3toolbox.mapfactory.ReloadableTiledMap;
   import net.bigpoint.as3toolbox.mapfactory.SimpleTile;
   import net.bigpoint.as3toolbox.mapfactory.Tile;
   import net.bigpoint.as3toolbox.mapfactory.TiledMap;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.map.MinimapManager;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.Pattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.Ship;
   
   public class BackgroundManager
   {
      
      public static const logger:ILogger = Log.getLogger("BackgroundManager");
      
      private var resourceQueue:Array = [];
      
      private var map:Map;
      
      public function BackgroundManager(param1:Map)
      {
         super();
         this.map = param1;
         param1.getMain().screenManager.backgrounds = new Vector.<Background>();
      }
      
      public static function getRandomCount(param1:int, param2:int) : int
      {
         return param1 + Math.floor(Math.random() * (param2 - param1 + 1));
      }
      
      public function createBackground(param1:int, param2:Boolean, param3:int, param4:int, param5:Boolean, param6:int, param7:int, param8:Number, param9:int, param10:Boolean = false, param11:BitmapData = null) : void
      {
         var _loc14_:MovieClip = null;
         var _loc15_:Sprite = null;
         var _loc12_:Pattern = PatternManager.backgroundPatterns[int(param1)];
         if(_loc12_ == null)
         {
            return;
         }
         var _loc13_:Background = new Background(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         this.map.getMain().screenManager.backgrounds.push(_loc13_);
         if(Settings.qualityBackground == Settings.QUALITY_HIGH || param2 && Settings.qualityBackground > Settings.QUALITY_LOW || param10 && Settings.qualityPoizone == Settings.QUALITY_HIGH)
         {
            if(_loc12_.getContentType() == Pattern.CONTENT_RESOURCE)
            {
               if(ResourceManager.fileCollection.isLoaded(BackgroundPattern(_loc12_).getResKey()))
               {
                  this.attachClip(_loc13_,BackgroundPattern(_loc12_));
               }
               else
               {
                  this.loadBackgroundResource(BackgroundPattern(_loc12_));
               }
            }
            else if(_loc12_.getContentType() == Pattern.CONTENT_CUSTOM)
            {
               _loc14_ = this.createCustomBackground(CustomBackgroundPattern(_loc12_).getWidth(),CustomBackgroundPattern(_loc12_).getHeight(),false,CustomBackgroundPattern(_loc12_).getColor());
               _loc13_.clip = _loc14_;
               _loc15_ = this.map.getMain().screenManager.getBackgroundLayer(param4);
               _loc15_.addChild(_loc14_);
            }
         }
         else if((Settings.qualityBackground == Settings.QUALITY_LOW || !MinimapManager.isInitialized) && !param10)
         {
            this.map.getMinimapManager().createMinimap();
         }
      }
      
      private function createCustomBackground(param1:int, param2:int, param3:Boolean, param4:uint) : MovieClip
      {
         var _loc5_:BitmapData = new BitmapData(param1,param2,param3,param4);
         var _loc6_:MovieClip = new MovieClip();
         _loc6_.mouseEnabled = Main.mouseEventsEnabled;
         _loc6_.mouseChildren = Main.mouseEventsEnabled;
         _loc6_.addChild(new Bitmap(_loc5_));
         var _loc7_:MovieClip = new MovieClip();
         _loc7_.mouseEnabled = Main.mouseEventsEnabled;
         _loc7_.addChild(_loc6_);
         _loc6_.x = _loc5_.width - _loc5_.width / this.map.getScaleFactor();
         _loc6_.y = _loc5_.height - _loc5_.height / this.map.getScaleFactor();
         return _loc7_;
      }
      
      private function loadBackgroundResource(param1:BackgroundPattern) : void
      {
         var _loc2_:String = param1.getResKey();
         var _loc3_:int = 0;
         while(_loc3_ < this.resourceQueue.length)
         {
            if(this.resourceQueue[_loc3_] == _loc2_)
            {
               return;
            }
            _loc3_++;
         }
         this.resourceQueue.push(_loc2_);
         ResourceManager.fileCollection.load(_loc2_,this.onClipLoaded);
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Background = null;
         var _loc4_:BackgroundPattern = null;
         if(Settings.unloadResources)
         {
            this.map.addFinisherToList(param1);
         }
         var _loc2_:String = param1.fileVO.id;
         for each(_loc3_ in this.map.getMain().screenManager.backgrounds)
         {
            if(_loc3_ != null)
            {
               _loc4_ = BackgroundPattern(PatternManager.backgroundPatterns[_loc3_.getTypeID()]);
               if(_loc4_.getResKey() == _loc2_)
               {
                  this.attachClip(_loc3_,_loc4_);
               }
            }
         }
      }
      
      private function attachClip(param1:Background, param2:BackgroundPattern) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Vector.<Tile> = null;
         var _loc18_:int = 0;
         var _loc19_:SimpleTile = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:TiledMap = null;
         var _loc23_:Ship = null;
         var _loc24_:BitmapData = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:ResourcePattern = null;
         var _loc29_:BitmapData = null;
         var _loc30_:BitmapData = null;
         var _loc31_:BitmapData = null;
         var _loc32_:MovieClip = null;
         var _loc33_:MovieClip = null;
         var _loc3_:String = param2.getResKey();
         if(param1.clip != null)
         {
            _loc6_ = this.map.getMain().screenManager.getBackgroundLayer(param1.getLayerIndex());
            if(_loc6_.contains(param1.clip))
            {
               _loc6_.removeChild(param1.clip);
            }
            param1.clip = null;
         }
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc3_));
         if(param2.isTiled)
         {
            _loc8_ = _loc4_.getDefinitions();
            _loc7_ = int(_loc8_.length);
            if(param2.width > 0 && param2.height > 0)
            {
               param1.width = param2.width;
               param1.height = param2.height;
            }
            else if(param2.order == "ASC" || param2.order == "DESC")
            {
               param1.width = Math.round(this.map.serious_width / 10 * param1.scale);
               param1.height = Math.round(this.map.serious_height / 10 * param1.scale);
            }
            else
            {
               param1.width = Math.round(this.map.serious_width / param1.getParallaxFactor() * param1.scale);
               param1.height = Math.round(this.map.serious_height / param1.getParallaxFactor() * param1.scale);
            }
            if(param1.scale != 1)
            {
               param1.offsetX = -Math.round((param1.width - param1.width / param1.scale) / 2) + param1.shiftX;
               param1.offsetY = -Math.round((param1.height - param1.height / param1.scale) / 2) + param1.shiftY;
            }
            else
            {
               param1.offsetX = param1.shiftX;
               param1.offsetY = param1.shiftY;
            }
            _loc9_ = Math.round(param1.width / param2.tileWidth);
            _loc10_ = Math.round(param1.height / param2.tileHeight);
            _loc9_ = _loc9_ < 1 ? 1 : _loc9_;
            _loc10_ = _loc10_ < 1 ? 1 : _loc10_;
            _loc11_ = param1.equalNeighborsAllowed;
            if(_loc9_ >= 1 && _loc10_ >= 1)
            {
               _loc14_ = TiledMap.createMap(_loc9_,_loc10_);
               if(param1.maskID > 0 || param1.maskBd != null)
               {
                  if(param1.maskID > 0)
                  {
                     _loc28_ = PatternManager.backgroundMaskPatterns[param1.maskID];
                     _loc24_ = ResourceManager.getBitmapData(_loc28_.resKey,"mask");
                  }
                  else
                  {
                     _loc24_ = param1.maskBd;
                  }
                  _loc25_ = param1.width / _loc24_.width;
                  _loc15_ = 0;
                  while(_loc15_ < _loc10_)
                  {
                     _loc16_ = 0;
                     while(_loc16_ < _loc9_)
                     {
                        _loc26_ = Math.round((_loc16_ * param2.tileWidth + param2.tileWidth / 2) / _loc25_);
                        _loc27_ = Math.round((_loc15_ * param2.tileHeight + param2.tileHeight / 2) / _loc25_);
                        if(_loc24_.getPixel32(_loc26_,_loc27_) == 0)
                        {
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(0);
                        }
                        else if(_loc11_ || _loc7_ <= 1)
                        {
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(getRandomCount(1,_loc7_));
                        }
                        else
                        {
                           if(_loc15_ == 0 && _loc16_ == 0)
                           {
                              _loc13_ = getRandomCount(1,_loc7_);
                           }
                           else if(_loc15_ == 0)
                           {
                              while((_loc14_[_loc15_][_loc16_ - 1] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           else if(_loc16_ == 0)
                           {
                              while((_loc14_[_loc15_ - 1][_loc16_] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           else
                           {
                              while((_loc14_[_loc15_][_loc16_ - 1] as MapElement).getTileID() == _loc13_ || (_loc14_[_loc15_ - 1][_loc16_] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(_loc13_);
                        }
                        _loc16_++;
                     }
                     _loc15_++;
                  }
               }
               else
               {
                  if(param2.order != null)
                  {
                     if(_loc8_ != null && _loc8_.indexOf("placeholder") >= 0)
                     {
                        _loc29_ = _loc4_.getEmbededBitmapData("placeholder");
                        _loc7_--;
                     }
                     switch(param2.order)
                     {
                        case "DESC":
                           _loc12_ = _loc7_;
                           break;
                        case "ASC":
                        default:
                           _loc12_ = 1;
                     }
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc10_)
                  {
                     _loc16_ = 0;
                     while(_loc16_ < _loc9_)
                     {
                        if(param2.order != null)
                        {
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(_loc12_);
                           switch(param2.order)
                           {
                              case "DESC":
                                 if(--_loc12_ < 1)
                                 {
                                    _loc12_ = _loc7_;
                                 }
                                 break;
                              case "ASC":
                              default:
                                 _loc12_++;
                                 if(_loc12_ > _loc7_)
                                 {
                                    _loc12_ = 1;
                                 }
                           }
                        }
                        else if(_loc11_ || _loc7_ <= 1)
                        {
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(getRandomCount(1,_loc7_));
                        }
                        else
                        {
                           if(_loc15_ == 0 && _loc16_ == 0)
                           {
                              _loc13_ = getRandomCount(1,_loc7_);
                           }
                           else if(_loc15_ == 0)
                           {
                              while((_loc14_[_loc15_][_loc16_ - 1] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           else if(_loc16_ == 0)
                           {
                              while((_loc14_[_loc15_ - 1][_loc16_] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           else
                           {
                              while((_loc14_[_loc15_][_loc16_ - 1] as MapElement).getTileID() == _loc13_ || (_loc14_[_loc15_ - 1][_loc16_] as MapElement).getTileID() == _loc13_)
                              {
                                 _loc13_ = getRandomCount(1,_loc7_);
                              }
                           }
                           (_loc14_[_loc15_][_loc16_] as MapElement).setTileID(_loc13_);
                        }
                        _loc16_++;
                     }
                     _loc15_++;
                  }
               }
               _loc17_ = new Vector.<Tile>();
               _loc18_ = 0;
               if(param1.maskID > 0 || param1.maskBd != null)
               {
                  if(param2.isReloadable)
                  {
                     _loc17_.push(new ReloadableSimpleTile(_loc18_,"blank"));
                  }
                  else
                  {
                     _loc30_ = this.getColoredBitmapData(param2.tileWidth,param2.tileHeight);
                     _loc17_.push(new SimpleTile(_loc18_,_loc30_,_loc3_ + _loc18_));
                  }
               }
               else
               {
                  _loc17_.push(null);
               }
               _loc19_ = null;
               _loc18_ = 1;
               while(_loc18_ <= _loc7_)
               {
                  if(param2.isReloadable)
                  {
                     _loc19_ = new ReloadableSimpleTile(_loc18_,this.getFileName(_loc18_));
                  }
                  else
                  {
                     _loc19_ = new SimpleTile(_loc18_,_loc4_.getEmbededBitmapData(this.getFileName(_loc18_)),_loc3_ + _loc18_);
                  }
                  _loc17_.push(_loc19_);
                  _loc18_++;
               }
               _loc20_ = ScreenManager.MASTER_SCREEN_WIDTH;
               _loc21_ = ScreenManager.MASTER_SCREEN_HEIGHT;
               if(param2.isReloadable)
               {
                  _loc22_ = new ReloadableTiledMap(_loc14_,_loc17_,_loc20_,_loc21_,param2.tileWidth,param2.tileHeight,_loc29_);
                  param1.tiledMap = _loc22_;
                  param1.initReloadableTiledMap();
               }
               else
               {
                  _loc22_ = new TiledMap(_loc14_,_loc17_,_loc20_,_loc21_,param2.tileWidth,param2.tileHeight);
                  param1.tiledMap = _loc22_;
               }
               _loc23_ = this.map.getShipManager().getHero();
               if(_loc23_ != null)
               {
                  param1.tiledMap.setPosition(_loc23_.x,_loc23_.y);
               }
               _loc5_ = this.map.getMain().screenManager.getBackgroundLayer(param1.getLayerIndex());
               _loc5_.addChild(param1.tiledMap);
               if(param1.maskBd != null)
               {
                  param1.maskBd.dispose();
                  param1.maskBd = null;
               }
            }
         }
         else
         {
            _loc31_ = _loc4_.getEmbededBitmapData("background");
            if(!MinimapManager.isInitialized && param1.isMain)
            {
               this.map.getMinimapManager().createMinimap(_loc3_);
            }
            _loc32_ = new MovieClip();
            _loc32_.addChild(new Bitmap(_loc31_));
            _loc33_ = new MovieClip();
            _loc33_.addChild(_loc32_);
            if(this.map.serious_width / param1.getParallaxFactor() != _loc31_.width)
            {
               param1.offsetX = Math.round((this.map.serious_width / param1.getParallaxFactor() - _loc31_.width) / 2) + param1.shiftX;
               param1.offsetY = Math.round((this.map.serious_height / param1.getParallaxFactor() - _loc31_.height) / 2) + param1.shiftY;
            }
            param1.clip = _loc33_;
            _loc33_.alpha = 0;
            _loc5_ = this.map.getMain().screenManager.getBackgroundLayer(param1.getLayerIndex());
            _loc5_.addChild(_loc33_);
            TweenLite.to(_loc33_,1,{"alpha":1});
         }
      }
      
      private function getFileName(param1:int = -1) : String
      {
         if(param1 == -1)
         {
            param1 = getRandomCount(1,12);
         }
         var _loc2_:String = "tile_";
         if(param1 < 10)
         {
            _loc2_ = _loc2_ + "0" + param1;
         }
         else
         {
            _loc2_ += param1;
         }
         return _loc2_;
      }
      
      public function getColoredBitmapData(param1:int, param2:int, param3:uint = 0) : BitmapData
      {
         return new BitmapData(param1,param2,true,param3);
      }
      
      public function getBackground(param1:int = 0) : Background
      {
         var _loc2_:Background = null;
         for each(_loc2_ in this.map.getMain().screenManager.backgrounds)
         {
            if(_loc2_ != null)
            {
               if(_loc2_.getLayerIndex() == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function updateBackgroundQuality(param1:int) : void
      {
         var _loc2_:Pattern = null;
         var _loc3_:Background = null;
         if(Settings.qualityBackground != param1)
         {
            for each(_loc3_ in this.map.getMain().screenManager.backgrounds)
            {
               if(_loc3_ != null)
               {
                  _loc2_ = PatternManager.backgroundPatterns[_loc3_.getTypeID()];
                  switch(Settings.qualityBackground)
                  {
                     case Settings.QUALITY_LOW:
                        if(!_loc3_.isPOIZone)
                        {
                           _loc3_.cleanup();
                        }
                        break;
                     case Settings.QUALITY_MEDIUM:
                     case Settings.QUALITY_GOOD:
                        if(!_loc3_.isPOIZone && !_loc3_.isMain)
                        {
                           _loc3_.cleanup();
                        }
                        if(_loc3_.isMain && _loc3_.clip == null && _loc3_.tiledMap == null)
                        {
                           if(ResourceManager.fileCollection.isLoaded(BackgroundPattern(_loc2_).getResKey()))
                           {
                              this.attachClip(_loc3_,BackgroundPattern(_loc2_));
                           }
                           else
                           {
                              this.loadBackgroundResource(BackgroundPattern(_loc2_));
                           }
                        }
                        break;
                     case Settings.QUALITY_HIGH:
                        if(_loc3_.clip == null && _loc3_.tiledMap == null)
                        {
                           if(ResourceManager.fileCollection.isLoaded(BackgroundPattern(_loc2_).getResKey()))
                           {
                              this.attachClip(_loc3_,BackgroundPattern(_loc2_));
                           }
                           else
                           {
                              this.loadBackgroundResource(BackgroundPattern(_loc2_));
                           }
                        }
                        break;
                  }
               }
            }
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:Background = null;
         for each(_loc1_ in this.map.getMain().screenManager.backgrounds)
         {
            if(_loc1_ != null)
            {
               _loc1_.cleanup();
            }
         }
         this.map.getMain().screenManager.backgrounds = new Vector.<Background>();
         this.resourceQueue = [];
      }
   }
}


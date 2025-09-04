package net.bigpoint.darkorbit.portal
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.map.MiniMap;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PortalManager
   {
      
      public static const logger:ILogger = Log.getLogger("PortalManager");
      
      private var portals:Vector.<Portal> = new Vector.<Portal>();
      
      private var portalAssets:Vector.<BitmapClip> = new Vector.<BitmapClip>();
      
      private var _map:Map;
      
      private var halfScreenWidth:int;
      
      private var halfScreenHeight:int;
      
      public function PortalManager(param1:Map)
      {
         super();
         this._map = param1;
         this.halfScreenWidth = ScreenManager.getHalfScreenWidth();
         this.halfScreenHeight = ScreenManager.getHalfScreenHeight();
      }
      
      public function deletePortal(param1:int) : void
      {
         var _loc4_:Portal = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc2_:Sprite = this._map.getMain().screenManager.getPortalLayer();
         var _loc3_:int = 0;
         while(_loc3_ < this.portals.length)
         {
            _loc4_ = this.portals[_loc3_];
            if(_loc4_.getID() == param1)
            {
               _loc5_ = _loc4_.clip;
               if(_loc5_ != null && _loc2_.contains(_loc5_))
               {
                  _loc2_.removeChild(_loc5_);
               }
               _loc6_ = _loc4_.getActiveClip();
               if(_loc6_ != null && _loc2_.contains(_loc6_))
               {
                  _loc2_.removeChild(_loc6_);
               }
               _loc4_.cleanup();
               this.portals.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function deleteAllPortals() : void
      {
         this.cleanup();
      }
      
      public function cleanup() : void
      {
         var _loc3_:BitmapClip = null;
         var _loc4_:Portal = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc1_:Sprite = this._map.getMain().screenManager.getPortalLayer();
         var _loc2_:int = 0;
         while(_loc2_ < this.portals.length)
         {
            _loc4_ = this.portals[_loc2_];
            _loc5_ = _loc4_.clip;
            if(_loc5_ != null && _loc1_.contains(_loc5_))
            {
               _loc1_.removeChild(_loc5_);
            }
            _loc6_ = _loc4_.getActiveClip();
            if(_loc6_ != null && _loc1_.contains(_loc6_))
            {
               _loc1_.removeChild(_loc6_);
            }
            _loc4_.cleanup();
            _loc2_++;
         }
         for each(_loc3_ in this.portalAssets)
         {
            if(_loc3_ != null && _loc1_.contains(_loc3_))
            {
               _loc1_.removeChild(_loc3_);
            }
         }
         this.portals = new Vector.<Portal>();
         this.portalAssets = new Vector.<BitmapClip>();
      }
      
      private function attachClip(param1:Portal, param2:String) : void
      {
         var _loc6_:int = 0;
         var _loc7_:PortalAssetPattern = null;
         var _loc8_:SWFFinisher = null;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param2));
         var _loc4_:MovieClip = MovieClip(_loc3_.getEmbededMovieClip("pulseAnimation"));
         _loc4_.mouseEnabled = Main.mouseEventsEnabled;
         _loc4_.mouseChildren = Main.mouseEventsEnabled;
         _loc4_.x = param1.getPosX();
         _loc4_.y = param1.getPosY();
         _loc4_.play();
         param1.clip = _loc4_;
         var _loc5_:MovieClip = MovieClip(_loc3_.getEmbededMovieClip("activeAnimation"));
         _loc5_.x = param1.getPosX();
         _loc5_.y = param1.getPosY();
         _loc5_.mouseEnabled = Main.mouseEventsEnabled;
         _loc5_.mouseChildren = Main.mouseEventsEnabled;
         _loc5_.play();
         param1.setActiveClip(_loc5_);
         this._map.getMain().screenManager.getPortalLayer().addChild(_loc4_);
         for each(_loc6_ in param1.assetIDs)
         {
            _loc7_ = PatternManager.portalAssetPatterns[_loc6_];
            if(ResourceManager.fileCollection.isLoaded(_loc7_.getResKey()))
            {
               _loc8_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc7_.getResKey()));
               this.onAssetLoaded(_loc8_);
            }
            else
            {
               ResourceManager.fileCollection.load(_loc7_.getResKey(),this.onAssetLoaded);
            }
         }
      }
      
      private function attachAsset(param1:Portal, param2:String) : void
      {
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param2));
         var _loc4_:PortalPattern = PatternManager.portalPatterns[int(param1.getTypeID())];
         if(_loc4_ == null)
         {
            logger.fatal("portal pattern for typeID:" + param1.getTypeID() + " not found!");
         }
         var _loc5_:BitmapClip = new BitmapClip(_loc3_.getEmbededMovieClip("mc",true),param2);
         _loc5_.x = param1.getPosX() + _loc4_.getWidth() / 2 + 50;
         _loc5_.y = param1.getPosY() + _loc4_.getHeight() / 2;
         this.portalAssets.push(_loc5_);
         this._map.getMain().screenManager.getPortalLayer().addChild(_loc5_);
      }
      
      private function onAssetLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Portal = null;
         var _loc4_:PortalAssetPattern = null;
         var _loc5_:int = 0;
         if(Settings.unloadResources)
         {
            this._map.addFinisherToList(param1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.portals.length)
         {
            _loc3_ = this.portals[_loc2_];
            for each(_loc5_ in _loc3_.assetIDs)
            {
               _loc4_ = PatternManager.portalAssetPatterns[_loc5_];
               if(_loc4_ == null)
               {
                  logger.fatal("portalAsset pattern for typeID:" + _loc5_ + " not found!");
               }
               else if(_loc4_.getResKey() == param1.fileVO.id)
               {
                  this.attachAsset(_loc3_,_loc4_.getResKey());
               }
            }
            _loc2_++;
         }
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Portal = null;
         var _loc4_:PortalPattern = null;
         if(Settings.unloadResources)
         {
            this._map.addFinisherToList(param1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.portals.length)
         {
            _loc3_ = this.portals[_loc2_];
            _loc4_ = PatternManager.portalPatterns[int(_loc3_.getTypeID())];
            if(_loc4_ == null)
            {
               logger.fatal("portal pattern for typeID:" + _loc3_.getTypeID() + " not found!");
            }
            else if(_loc4_.getResKey() == param1.fileVO.id)
            {
               this.attachClip(_loc3_,_loc4_.getResKey());
            }
            _loc2_++;
         }
      }
      
      public function playPortalAnimation(param1:int, param2:Boolean = false) : void
      {
         var _loc4_:Portal = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:PortalPattern = null;
         var _loc8_:SWFFinisher = null;
         var _loc9_:MovieClip = null;
         var _loc10_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.portals.length)
         {
            _loc4_ = this.portals[_loc3_];
            if(_loc4_ != null && _loc4_.getID() == param1)
            {
               _loc5_ = _loc4_.clip;
               _loc6_ = _loc4_.getActiveClip();
               if(_loc5_ != null)
               {
                  _loc5_.alpha = 1;
                  TweenLite.to(_loc5_,0.5,{"alpha":0});
               }
               if(_loc6_ != null)
               {
                  if(!this._map.getMain().screenManager.getPortalLayer().contains(_loc6_))
                  {
                     this._map.getMain().screenManager.getPortalLayer().addChild(_loc6_);
                  }
                  _loc6_.x = _loc4_.getPosX();
                  _loc6_.y = _loc4_.getPosY();
                  _loc6_.alpha = 0;
                  TweenLite.to(_loc6_,0.5,{"alpha":1});
               }
               _loc7_ = PatternManager.portalPatterns[int(_loc4_.getTypeID())];
               _loc8_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("portalAnimation0"));
               _loc9_ = MovieClip(_loc8_.getEmbededMovieClip("mc"));
               _loc9_.x = _loc4_.getPosX();
               _loc9_.y = _loc4_.getPosY();
               this._map.getMain().screenManager.getPortalLayer().addChild(_loc9_);
               ScreenManager.playAnimation(_loc9_,30);
               if(param2)
               {
                  TweenMax.delayedCall(6,this.restoreIdleGate,[param1]);
               }
               if(_loc7_ != null)
               {
                  _loc10_ = _loc7_.getSoundID();
                  if(_loc10_ != -1)
                  {
                     AudioManager.playSoundEffect(_loc10_,false,false,_loc9_.x,_loc9_.y);
                  }
               }
               break;
            }
            _loc3_++;
         }
      }
      
      private function restoreIdleGate(param1:int) : void
      {
         var _loc3_:Portal = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.portals.length)
         {
            _loc3_ = this.portals[_loc2_];
            if(_loc3_.getID() == param1)
            {
               _loc4_ = _loc3_.clip;
               _loc5_ = _loc3_.getActiveClip();
               if(_loc4_ != null)
               {
                  _loc4_.alpha = 1;
                  TweenLite.to(_loc4_,0.5,{"alpha":1});
               }
               if(_loc5_ != null)
               {
                  if(this._map.getMain().screenManager.getPortalLayer().contains(_loc5_))
                  {
                     _loc5_.alpha = 1;
                     TweenLite.to(_loc5_,0.5,{"alpha":0});
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function createPortal(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Boolean, param7:Vector.<int>) : void
      {
         var _loc10_:MiniMap = null;
         if(this.portalExist(param1))
         {
            return;
         }
         var _loc8_:Portal = new Portal(param1,param2,param3,param4,param5,param6,param7);
         this.portals.push(_loc8_);
         var _loc9_:PortalPattern = PatternManager.portalPatterns[int(_loc8_.getTypeID())];
         ResourceManager.fileCollection.load(_loc9_.getResKey(),this.onClipLoaded);
         _loc10_ = this._map.getMinimapManager().getMiniMap();
         if(_loc10_ != null)
         {
            _loc10_.redrawEntities();
         }
      }
      
      public function getPortals() : Vector.<Portal>
      {
         return this.portals;
      }
      
      private function portalExist(param1:int) : Boolean
      {
         var _loc3_:Portal = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.portals.length)
         {
            _loc3_ = this.portals[_loc2_];
            if(_loc3_.getID() == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}


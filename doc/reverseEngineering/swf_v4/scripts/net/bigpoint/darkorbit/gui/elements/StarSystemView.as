package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import fl.transitions.easing.None;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   
   public class StarSystemView extends Sprite
   {
      
      private var maps:Array = [];
      
      private var finisher:SWFFinisher;
      
      private var connectionManager:ConnectionManager;
      
      public var lastSelectedMapForJump:MapItem;
      
      private var tween:TweenLite;
      
      public var idleSystem:Boolean = false;
      
      public function StarSystemView()
      {
         super();
      }
      
      public function init(param1:Array, param2:Array, param3:String) : void
      {
         var _loc4_:MapItem = null;
         var _loc5_:Bitmap = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("spacemap"));
         this.addChild(this.finisher.getEmbededBitmap(param3));
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            _loc6_ = int(param1[_loc8_]);
            _loc7_ = Point(param2[_loc6_]);
            _loc5_ = this.finisher.getEmbededBitmap("map_" + _loc6_);
            _loc4_ = new MapItem(_loc6_,_loc5_);
            _loc4_.setPosition(_loc7_.x + 1,_loc7_.y + 1);
            this.maps[_loc6_] = _loc4_;
            this.addChild(_loc4_);
            this.setBlock(_loc4_);
            _loc8_++;
         }
      }
      
      public function update(param1:int, param2:Array, param3:Array, param4:Array) : void
      {
         var _loc5_:MapItem = null;
         this.removeListeners();
         var _loc6_:int = 0;
         while(_loc6_ < this.maps.length)
         {
            _loc5_ = this.maps[_loc6_];
            if(_loc5_ != null)
            {
               this.cleanup(_loc5_);
            }
            _loc6_++;
         }
         this.setCurrentMap(param1);
         this.setUriLockedMaps(param4);
         this.setLevelLockedMaps(param3);
         this.setAvailableMaps(param2);
         this.setSystemActive();
      }
      
      private function cleanup(param1:MapItem) : void
      {
         var _loc2_:int = 0;
         if(param1.numChildren > 1)
         {
            _loc2_ = 1;
            while(_loc2_ < param1.numChildren - 1)
            {
               param1.removeChildAt(_loc2_);
               _loc2_++;
            }
         }
      }
      
      private function setAvailableMaps(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:MapItem = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Array = [];
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            _loc3_ = param1[_loc8_];
            _loc6_ = int(_loc3_[0]);
            _loc4_ = _loc3_[1];
            _loc9_ = 0;
            while(_loc9_ < _loc4_.length)
            {
               _loc7_ = int(_loc4_[_loc9_]);
               _loc2_.push(_loc7_);
               _loc5_ = this.getMap(_loc7_);
               if(_loc5_ != null)
               {
                  _loc5_.mapName = InGameCatalog.getInstance().mapNames[_loc7_];
                  _loc5_.price = _loc6_;
                  this.setAvailable(_loc5_);
               }
               _loc9_++;
            }
            _loc8_++;
         }
         this.addListeners(_loc2_);
      }
      
      private function setUriLockedMaps(param1:Array) : void
      {
         var _loc2_:MapItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = int(param1[_loc4_]);
            _loc2_ = this.getMap(_loc3_);
            if(_loc2_ != null)
            {
               _loc2_.mapName = InGameCatalog.getInstance().mapNames[_loc3_];
               _loc2_.price = -1;
               this.setUriLock(_loc2_);
            }
            _loc4_++;
         }
      }
      
      private function setLevelLockedMaps(param1:Array) : void
      {
         var _loc2_:MapItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = int(param1[_loc4_]);
            _loc2_ = this.getMap(_loc3_);
            if(_loc2_ != null)
            {
               _loc2_.mapName = InGameCatalog.getInstance().mapNames[_loc3_];
               _loc2_.price = -1;
               this.setLevelLock(_loc2_);
            }
            _loc4_++;
         }
      }
      
      public function setSelectedMapForJump(param1:int) : void
      {
         var _loc2_:MapItem = null;
         if(this.getMap(param1) != null)
         {
            if(this.lastSelectedMapForJump != null)
            {
               _loc2_ = this.getMap(this.lastSelectedMapForJump.id);
               if(_loc2_.numChildren > 2)
               {
                  _loc2_.removeChildAt(2);
               }
            }
            _loc2_ = this.getMap(param1);
            if(_loc2_ != null)
            {
               this.lastSelectedMapForJump = _loc2_;
               this.lastSelectedMapForJump.addChild(this.getLoaderAsset());
            }
         }
      }
      
      public function startCastingCostTick(param1:int, param2:int) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:TextField = null;
         var _loc5_:Sprite = null;
         if(this.getMap(param2) != null)
         {
            _loc3_ = Sprite(this.lastSelectedMapForJump.getChildAt(2));
            _loc4_ = _loc3_.getChildAt(1) as TextField;
            _loc5_ = _loc3_.getChildAt(0) as Sprite;
            if(param1 > -1)
            {
               this.idleSystem = true;
               this.tween = TweenLite.to(_loc5_,param1,{
                  "ease":None.easeNone,
                  "rotation":-180 * param1,
                  "onUpdate":this.setText,
                  "onUpdateParams":[_loc4_]
               });
            }
            else
            {
               this.idleSystem = false;
               TweenLite.killTweensOf(_loc5_);
               _loc3_.getChildAt(1).rotation = 0;
               TextField(_loc3_.getChildAt(1)).text = "";
            }
         }
      }
      
      private function setSystemActive() : void
      {
         this.idleSystem = false;
      }
      
      private function setText(param1:TextField) : void
      {
         param1.text = (this.tween.duration - Math.round(this.tween.currentTime)).toString();
      }
      
      private function getLoaderAsset() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = this.finisher.getEmbededBitmap("jump_cpu_loading_animation");
         _loc3_.cacheAsBitmap = true;
         _loc3_.x = -_loc3_.width * 0.5;
         _loc3_.y = -_loc3_.height * 0.5;
         _loc2_.x = this.lastSelectedMapForJump.width * 0.5;
         _loc2_.y = this.lastSelectedMapForJump.height * 0.5;
         _loc2_.addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = Styles.h2Fmt;
         _loc4_.setTextFormat(Styles.h2Fmt);
         _loc4_.type = TextFieldType.DYNAMIC;
         _loc4_.textColor = 15327936;
         _loc4_.embedFonts = true;
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         _loc4_.selectable = false;
         _loc4_.width = 40;
         _loc4_.x = this.lastSelectedMapForJump.width * 0.5 - 2;
         _loc4_.y = Math.round(this.lastSelectedMapForJump.height * 0.3);
         if(this.lastSelectedMapForJump.height > 50)
         {
            _loc4_.y = Math.round(this.lastSelectedMapForJump.height * 0.3) + 15;
         }
         _loc1_.addChild(_loc2_);
         _loc1_.addChild(_loc4_);
         return _loc1_;
      }
      
      private function setAvailable(param1:MapItem) : void
      {
         this.addAsset(param1,null);
      }
      
      private function setLevelLock(param1:MapItem) : void
      {
         var _loc2_:Bitmap = this.finisher.getEmbededBitmap("marker_level_locked");
         this.addAsset(param1,_loc2_);
      }
      
      public function setUriLock(param1:MapItem) : void
      {
         var _loc2_:Bitmap = this.finisher.getEmbededBitmap("marker_uri_locked");
         this.addAsset(param1,_loc2_);
      }
      
      private function setBlock(param1:MapItem) : void
      {
         var _loc2_:Bitmap = this.finisher.getEmbededBitmap("marker_blocked");
         this.addAsset(param1,_loc2_);
      }
      
      public function setCurrentMap(param1:int) : void
      {
         var _loc3_:Bitmap = null;
         this.lastSelectedMapForJump = null;
         var _loc2_:MapItem = this.getMap(param1);
         if(_loc2_ != null)
         {
            _loc3_ = this.finisher.getEmbededBitmap("marker_currentMap");
            this.addAsset(_loc2_,_loc3_);
         }
      }
      
      private function addAsset(param1:MapItem, param2:Bitmap = null) : void
      {
         if(param1.numChildren > 1)
         {
            param1.removeChildAt(1);
         }
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(0,0);
         _loc3_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc3_.graphics.endFill();
         if(param2 != null)
         {
            param2.x = (param1.width - param2.width) * 0.5;
            param2.y = (param1.height - param2.height) * 0.5;
            _loc3_.addChild(param2);
         }
         _loc3_.mouseChildren = false;
         _loc3_.mouseEnabled = false;
         param1.addChild(_loc3_);
         param1.useHandCursor = true;
         param1.buttonMode = true;
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function getMap(param1:int) : MapItem
      {
         return this.maps[param1] as MapItem;
      }
      
      public function addListeners(param1:Array) : void
      {
         var _loc2_:MapItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = this.getMap(param1[_loc3_]);
            if(_loc2_ != null)
            {
               _loc2_.addEventListener(MouseEvent.CLICK,this.handleMapItemClicked);
            }
            _loc3_++;
         }
      }
      
      public function removeListeners() : void
      {
         var _loc1_:MapItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.maps.length)
         {
            _loc1_ = this.maps[_loc2_];
            if(_loc1_ != null && _loc1_.hasEventListener(MouseEvent.CLICK))
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.handleMapItemClicked);
            }
            _loc2_++;
         }
      }
      
      private function handleMapItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!this.idleSystem && param1.target is MapItem)
         {
            _loc2_ = MapItem(param1.target).id;
            this.connectionManager.sendCommand(ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.SET_STATUS,_loc2_]);
         }
      }
      
      public function setConnectionManager(param1:ConnectionManager) : void
      {
         this.connectionManager = param1;
      }
      
      public function setAllMapsBlocked() : void
      {
         var _loc1_:MapItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.maps.length)
         {
            _loc1_ = this.maps[_loc2_];
            if(_loc1_ != null)
            {
               this.setUriLock(_loc1_);
            }
            _loc2_++;
         }
      }
      
      public function setUnavailableMap(param1:int) : void
      {
         var _loc2_:MapItem = this.getMap(param1);
         if(_loc2_ != null)
         {
         }
      }
   }
}


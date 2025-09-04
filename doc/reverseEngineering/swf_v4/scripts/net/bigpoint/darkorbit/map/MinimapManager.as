package net.bigpoint.darkorbit.map
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import mx.controls.Image;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.gui.SettingsWindowDecorator;
   import net.bigpoint.darkorbit.gui.elements.SettingsField;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MinimapManager
   {
      
      public static const logger:ILogger = Log.getLogger("MinimapManager");
      
      public static var isInitialized:Boolean = false;
      
      public static var scaleFactor:Number = 8;
      
      public static var mapFactor:Number = 1;
      
      private static const WINDOW_EDGE_BUFFER:Number = 30;
      
      private var miniMap:MiniMap;
      
      private var map:Map;
      
      private const MIN:Number = 3;
      
      private const MAX:Number = 11;
      
      public var backgroundBmd:BitmapData;
      
      private const BACKGROUND_WIDTH:int = 210;
      
      private const BACKGROUND_HEIGHT:int = 131;
      
      private var minimapReskey:String;
      
      public function MinimapManager(param1:Map)
      {
         super();
         this.map = param1;
      }
      
      public function createMinimap(param1:String = null) : void
      {
         if(!Settings.createMinimap)
         {
            return;
         }
         if(param1 != null)
         {
            this.minimapReskey = param1;
            isInitialized = true;
            this.loadBackground(param1);
         }
         else
         {
            this.attachBackground(this.minimapReskey);
         }
      }
      
      private function loadBackground(param1:String) : void
      {
         if(ResourceManager.fileCollection.isLoaded(param1))
         {
            this.attachBackground(param1);
         }
         else
         {
            ResourceManager.fileCollection.load(param1,this.handleBackgroundLoaded);
         }
      }
      
      private function handleBackgroundLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:String = param1.fileVO.id;
         this.attachBackground(_loc2_);
      }
      
      private function attachBackground(param1:String = null) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Point = null;
         var _loc5_:SWFFinisher = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Image = null;
         var _loc9_:Number = NaN;
         var _loc10_:Matrix = null;
         if(this.backgroundBmd == null && param1 == null || SettingsWindowDecorator.getComboBoxSettingValue(SettingsField.TYPE_QUALITY_BACKGROUND) == 0)
         {
            _loc2_ = new BitmapData(210,131,false,0);
         }
         else if(param1 != null)
         {
            _loc5_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1));
            _loc2_ = _loc5_.getEmbededBitmapData("background");
         }
         if(_loc2_ != null)
         {
            _loc6_ = Math.round(_loc2_.width);
            _loc7_ = Math.round(_loc2_.height);
            _loc8_ = new Image();
            _loc8_.load(new Bitmap(_loc2_,"auto",true));
            _loc9_ = mapFactor * this.BACKGROUND_WIDTH / _loc2_.width;
            if(_loc9_ < 1)
            {
               _loc9_ = 0.1;
            }
            else
            {
               _loc9_ = 1;
            }
            _loc10_ = new Matrix();
            _loc10_.scale(_loc9_,_loc9_);
            this.backgroundBmd = new BitmapData(_loc6_ * _loc9_,_loc7_ * _loc9_);
            this.backgroundBmd.draw(_loc8_.content,_loc10_);
         }
         var _loc4_:SimpleWindow = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_MINIMAP);
         if(_loc4_ == null)
         {
            this.map.getMain().getGuiManager().createMinimapWindow();
            _loc4_ = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_MINIMAP);
         }
         if(this.miniMap != null)
         {
            this.cleanup();
         }
         this.miniMap = new MiniMap(this,this.backgroundBmd,scaleFactor * mapFactor,_loc3_);
         this.miniMap.addPredefinedPosition(new Point(30,20));
         _loc4_.addContainer(this.miniMap);
         this.miniMap.setPredefinedPosition();
         _loc4_.setDimension(this.miniMap.width + 25,this.miniMap.height + 25);
         this.miniMap.updateThreatIndicator(Settings.enemyCount);
         this.checkMiniMapIsInsideClientBounds(_loc4_);
      }
      
      private function checkMiniMapIsInsideClientBounds(param1:SimpleWindow) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:Number = ScreenManager.getScreenWidth();
         var _loc4_:Number = ScreenManager.getScreenHeight();
         var _loc5_:Point = new Point(param1.x,param1.y);
         if(_loc5_.x + this.miniMap.width > _loc3_)
         {
            _loc6_ = _loc5_.x + param1.getWindowDimension().x + WINDOW_EDGE_BUFFER - _loc3_;
            param1.x -= _loc6_;
            _loc2_ = true;
         }
         if(_loc5_.y + this.miniMap.height > _loc4_)
         {
            _loc7_ = _loc5_.y + param1.getWindowDimension().y + WINDOW_EDGE_BUFFER - _loc4_;
            param1.y -= _loc7_;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.saveSetting();
            param1.saveWindowSetting(true);
         }
      }
      
      public function cleanup() : void
      {
         if(!Settings.createMinimap)
         {
            return;
         }
         isInitialized = false;
         if(this.miniMap != null)
         {
            this.miniMap.cleanup();
         }
         var _loc1_:SimpleWindow = this.map.getMain().getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_MINIMAP);
         if(_loc1_ != null)
         {
            _loc1_.removeContainer(this.miniMap);
         }
      }
      
      public function getMiniMap() : MiniMap
      {
         return this.miniMap;
      }
      
      public function zoomIn() : void
      {
         if(this.backgroundBmd != null)
         {
            if(scaleFactor > this.MIN)
            {
               this.cleanup();
               --scaleFactor;
               this.createMinimap();
            }
         }
         this.saveSetting();
      }
      
      public function zoomOut() : void
      {
         if(this.backgroundBmd != null)
         {
            if(scaleFactor < this.MAX)
            {
               this.cleanup();
               ++scaleFactor;
               this.createMinimap();
            }
         }
         this.saveSetting();
      }
      
      private function saveSetting() : void
      {
         this.map.getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_MINIMAP_SCALE + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,scaleFactor.toString()]);
      }
      
      public function getMap() : Map
      {
         return this.map;
      }
   }
}


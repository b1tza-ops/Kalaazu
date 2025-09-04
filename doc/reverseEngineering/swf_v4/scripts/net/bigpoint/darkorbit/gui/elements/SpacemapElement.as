package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.map.Map;
   
   public class SpacemapElement extends SimpleElement
   {
      
      private var guiManager:GuiManager;
      
      private var blink_0:MovieClip;
      
      private var blink_1:MovieClip;
      
      private var positions:Array = [];
      
      private var mapContainer:MovieClip;
      
      private var textField:TextField;
      
      public function SpacemapElement(param1:GuiManager)
      {
         super(TYPE_SPACEMAP);
         this.guiManager = param1;
      }
      
      public function init(param1:Array) : void
      {
         this.positions = param1;
         this.mapContainer = new MovieClip();
         this.mapContainer.mouseEnabled = Main.mouseEventsEnabled;
         this.mapContainer.mouseChildren = Main.mouseEventsEnabled;
         this.addChild(this.mapContainer);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("spacemap"));
         this.blink_0 = _loc2_.getEmbededMovieClip("blink_0");
         this.blink_0.mouseEnabled = Main.mouseEventsEnabled;
         this.blink_1 = _loc2_.getEmbededMovieClip("blink_1");
         this.blink_1.mouseEnabled = Main.mouseEventsEnabled;
         this.addChild(this.blink_0);
         this.addChild(this.blink_1);
         this.textField = new TextField();
         var _loc3_:TextFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215);
         this.textField.defaultTextFormat = _loc3_;
         this.textField.embedFonts = Styles.simpleEmbed;
         this.textField.wordWrap = true;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.text = BPLocale.getText("noSpacemapData");
         this.addChild(this.textField);
         this.update();
      }
      
      public function update() : void
      {
         var _loc4_:SWFFinisher = null;
         var _loc5_:Bitmap = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.mapContainer.numChildren)
         {
            this.mapContainer.removeChild(this.mapContainer.getChildAt(_loc1_));
            _loc1_++;
         }
         var _loc2_:int = -1;
         var _loc3_:Map = this.guiManager.getMain().screenManager.map;
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.getCurrentStarSystemIndex();
         }
         if(_loc2_ != -1)
         {
            _loc4_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("spacemap"));
            _loc5_ = _loc4_.getEmbededBitmap("normal_page_" + _loc3_.getCurrentStarSystemIndex());
            _loc5_.x = 10;
            this.mapContainer.addChild(_loc5_);
            this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).setDimension(_loc5_.width + 12,_loc5_.height + 34);
            _loc6_ = _loc3_.getMapID();
            _loc7_ = this.positions[_loc6_];
            if(_loc6_ == 16 || _loc6_ == 29)
            {
               this.blink_1.visible = true;
               this.blink_0.visible = false;
            }
            else
            {
               this.blink_1.visible = false;
               this.blink_0.visible = true;
            }
            this.textField.visible = false;
            this.blink_0.x = _loc7_.x + 10;
            this.blink_0.y = _loc7_.y;
            this.blink_1.x = _loc7_.x + 10;
            this.blink_1.y = _loc7_.y;
         }
         else
         {
            this.blink_1.visible = false;
            this.blink_0.visible = false;
            this.textField.visible = true;
            this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).setDimension(300,150);
            this.textField.width = 280;
            this.textField.height = 100;
            this.textField.x = 8;
            this.textField.y = 8;
         }
      }
   }
}


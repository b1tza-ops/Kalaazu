package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.SpacemapElement;
   import net.bigpoint.darkorbit.gui.elements.StarSystemView;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   
   public class SpacemapWindowDecorator
   {
      
      private static const BORDER:int = 10;
      
      private var guiManager:GuiManager;
      
      public function SpacemapWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         var _loc2_:Array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
         var _loc3_:Array = [16,17,18,19,20,21,22,23,24,25,26,27,28,29,91,92,93];
         var _loc4_:Array = [];
         _loc4_[1] = new Point(0,185);
         _loc4_[2] = new Point(107,185);
         _loc4_[3] = new Point(204,136);
         _loc4_[4] = new Point(204,235);
         _loc4_[5] = new Point(506,0);
         _loc4_[6] = new Point(408,38);
         _loc4_[7] = new Point(303,87);
         _loc4_[8] = new Point(508,97);
         _loc4_[9] = new Point(506,375);
         _loc4_[10] = new Point(407,326);
         _loc4_[11] = new Point(508,192);
         _loc4_[12] = new Point(301,283);
         _loc4_[13] = new Point(302,182);
         _loc4_[14] = new Point(398,151);
         _loc4_[15] = new Point(401,219);
         _loc4_[16] = new Point(272,138);
         _loc4_[17] = new Point(164,171);
         _loc4_[18] = new Point(84,107);
         _loc4_[19] = new Point(84,238);
         _loc4_[20] = new Point(0,171);
         _loc4_[21] = new Point(506,131);
         _loc4_[22] = new Point(506,43);
         _loc4_[23] = new Point(619,93);
         _loc4_[24] = new Point(619,0);
         _loc4_[25] = new Point(487,269);
         _loc4_[26] = new Point(519,363);
         _loc4_[27] = new Point(594,269);
         _loc4_[28] = new Point(628,363);
         _loc4_[29] = new Point(230,297);
         _loc4_[91] = new Point(202,60);
         _loc4_[92] = new Point(296,18);
         _loc4_[93] = new Point(388,60);
         var _loc5_:int = 15;
         var _loc6_:int = 34;
         var _loc7_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("spacemap"));
         var _loc8_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SPACEMAP);
         var _loc9_:SpacemapElement = new SpacemapElement(this.guiManager);
         _loc9_.init(_loc4_);
         _loc9_.x = _loc5_;
         _loc9_.y = _loc6_;
         _loc8_.addElement(_loc9_);
         param1.addContainer(_loc8_);
         var _loc10_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc11_:ConnectionManager = this.guiManager.getMain().getConnectionManager();
         var _loc12_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_SWITCHER);
         var _loc13_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1);
         var _loc14_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2);
         var _loc15_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_BOTTOM_BAR);
         var _loc16_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_INFO_DISPLAY);
         var _loc17_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_PRICE_DISPLAY);
         var _loc18_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_BUTTON);
         var _loc19_:SimpleElement = new SimpleElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_VOUCHER_LABEL);
         var _loc20_:StarSystemView = new StarSystemView();
         _loc20_.init(_loc2_,_loc4_,"advanced_page_0");
         _loc20_.setConnectionManager(_loc11_);
         _loc20_.setPosition(60,_loc6_);
         var _loc21_:StarSystemView = new StarSystemView();
         _loc21_.init(_loc3_,_loc4_,"advanced_page_1");
         _loc21_.setConnectionManager(_loc11_);
         _loc21_.setPosition(_loc5_,_loc6_);
         _loc13_.addChild(_loc20_);
         _loc14_.addChild(_loc21_);
         var _loc22_:Bitmap = _loc7_.getEmbededBitmap("bottom_bar");
         _loc22_.x = 5;
         _loc22_.y = _loc6_;
         var _loc23_:Bitmap = _loc7_.getEmbededBitmap("advanced_jump_icon");
         _loc23_.x = BORDER;
         _loc23_.y = _loc6_;
         var _loc24_:TextField = new TextField();
         _loc24_.x = _loc23_.x + _loc23_.width + BORDER;
         _loc24_.y = _loc6_ + 2;
         _loc24_.text = BPLocale.getText("title_advanced_jump_cpu");
         this.formatLabelTextfield(_loc24_);
         _loc15_.addChild(_loc22_);
         _loc15_.addChild(_loc23_);
         _loc15_.addChild(_loc24_);
         var _loc25_:TextField = new TextField();
         this.formatLabelTextfield(_loc25_);
         _loc25_.text = BPLocale.getText("label_current_map");
         var _loc26_:TextField = new TextField();
         this.formatLabelTextfield(_loc26_);
         _loc26_.text = BPLocale.getText("label_selected_map");
         _loc26_.y = 40;
         var _loc27_:Bitmap = _loc7_.getEmbededBitmap("from_to_display");
         _loc27_.x = BORDER + Math.max(_loc26_.width,_loc25_.width);
         _loc27_.y = 5;
         var _loc28_:TextField = new TextField();
         this.formatInfoTextfield(_loc28_);
         _loc28_.x = _loc27_.x;
         _loc28_.y = _loc27_.y - 5;
         _loc28_.width = 50;
         var _loc29_:TextField = new TextField();
         this.formatInfoTextfield(_loc29_);
         _loc29_.x = _loc27_.x;
         _loc29_.y = _loc27_.y + 35;
         _loc29_.width = 50;
         _loc16_.x = 30;
         _loc16_.y = 505;
         _loc16_.addChild(_loc27_);
         _loc16_.addChild(_loc28_);
         _loc16_.addChild(_loc29_);
         _loc16_.addChild(_loc25_);
         _loc16_.addChild(_loc26_);
         var _loc30_:Bitmap = _loc7_.getEmbededBitmap("price_display");
         var _loc31_:TextField = new TextField();
         _loc31_.width = _loc30_.width;
         this.formatInfoTextfield(_loc31_);
         _loc31_.y = 5;
         _loc17_.x = 310;
         _loc17_.y = 500;
         _loc17_.addChild(_loc30_);
         _loc17_.addChild(_loc31_);
         TooltipControl.getInstance().addToolTip(_loc17_,BPLocale.getText("label_cpu_jump_price"));
         var _loc32_:TextField = new TextField();
         _loc32_.name = "text";
         _loc32_.y = 0;
         _loc32_.defaultTextFormat = Styles.centeredHeavyFmt;
         _loc32_.embedFonts = Styles.centeredHeavyEmbed;
         _loc32_.width = _loc30_.width + 100;
         _loc32_.height = Styles.centeredHeavyFontHeight + 5;
         _loc19_.addChild(_loc32_);
         _loc19_.x = 260;
         _loc19_.y = 545;
         var _loc33_:MovieClip = _loc7_.getEmbededMovieClip("jumpButton");
         var _loc34_:TextField = new TextField();
         _loc34_.width = _loc33_.width;
         this.formatInfoTextfield(_loc34_);
         _loc34_.text = BPLocale.getText("label_jump_now");
         _loc34_.y = 10;
         _loc34_.mouseEnabled = false;
         _loc34_.selectable = false;
         _loc18_.x = 500;
         _loc18_.y = 515;
         _loc18_.buttonMode = true;
         _loc18_.useHandCursor = true;
         _loc18_.addChild(_loc33_);
         _loc18_.addChild(_loc34_);
         var _loc35_:Sprite = new Sprite();
         var _loc36_:TextField = new TextField();
         this.formatLabelTextfield(_loc36_);
         _loc36_.width = 350;
         _loc36_.mouseEnabled = false;
         _loc12_.x = 30;
         _loc12_.y = 40;
         _loc35_.graphics.beginFill(0,0);
         _loc35_.graphics.drawRect(0,0,_loc36_.width,_loc36_.height);
         _loc35_.graphics.endFill();
         _loc35_.useHandCursor = true;
         _loc35_.buttonMode = true;
         _loc35_.addChild(_loc36_);
         _loc12_.addChild(_loc35_);
         _loc10_.addElement(_loc13_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc14_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc15_,SimpleContainer.ALIGN_VERTICAL);
         _loc10_.addElement(_loc17_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc16_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc18_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc12_,SimpleContainer.NO_ALIGN);
         _loc10_.addElement(_loc19_,SimpleContainer.NO_ALIGN);
         param1.addContainer(_loc10_);
         this.guiManager.updateJumpVoucherLabel();
      }
      
      private function formatLabelTextfield(param1:TextField) : void
      {
         param1.defaultTextFormat = Styles.h3Fmt;
         param1.textColor = 16777215;
         param1.embedFonts = true;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
      }
      
      private function formatInfoTextfield(param1:TextField) : void
      {
         param1.defaultTextFormat = Styles.h2Fmt;
         param1.type = TextFieldType.DYNAMIC;
         param1.textColor = 16777215;
         param1.embedFonts = true;
         param1.autoSize = TextFieldAutoSize.CENTER;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
      }
   }
}


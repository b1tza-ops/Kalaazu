package net.bigpoint.darkorbit.gui.elements.slider
{
   import com.bigpoint.utils.BPLocale;
   import fl.controls.Slider;
   import fl.controls.SliderDirection;
   import fl.events.SliderEvent;
   import flash.display.Shape;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.SettingsWindowDecorator;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SliderComponent extends SimpleElement
   {
      
      public static const SLIDER_GAP:int = 20;
      
      public static const SLIDER_WIDTH:int = 350;
      
      private var typeID:int;
      
      private var labelKey:String;
      
      private var elements:Array;
      
      public var slider:Slider;
      
      private var currentValueTxt:TextField;
      
      public function SliderComponent(param1:int, param2:String, param3:Array)
      {
         super(SimpleElement.TYPE_SLIDER);
         this.typeID = param1;
         this.labelKey = param2;
         this.elements = param3;
         this.init();
      }
      
      private function init() : void
      {
         var _loc4_:TextField = null;
         var _loc5_:Shape = null;
         var _loc6_:SliderInterval = null;
         var _loc1_:TextField = new TextField();
         _loc1_.selectable = false;
         _loc1_.defaultTextFormat = Styles.strongStdFmt;
         _loc1_.textColor = 16777215;
         _loc1_.text = BPLocale.getText(this.labelKey);
         _loc1_.border = false;
         _loc1_.embedFonts = Styles.strongStdEmbed;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.height = Styles.strongStdFontHeight + 6;
         _loc1_.y = 0;
         addChild(_loc1_);
         this.currentValueTxt = new TextField();
         this.currentValueTxt.selectable = false;
         this.currentValueTxt.defaultTextFormat = Styles.strongStdFmt;
         this.currentValueTxt.textColor = 15327936;
         this.currentValueTxt.border = false;
         this.currentValueTxt.embedFonts = Styles.strongStdEmbed;
         this.currentValueTxt.autoSize = TextFieldAutoSize.LEFT;
         this.currentValueTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.currentValueTxt.height = Styles.strongStdFontHeight + 6;
         this.currentValueTxt.x = _loc1_.width + 10;
         this.currentValueTxt.y = 0;
         addChild(this.currentValueTxt);
         var _loc2_:int = Math.round(SLIDER_WIDTH / (this.elements.length - 1));
         var _loc3_:int = SLIDER_GAP;
         for each(_loc6_ in this.elements)
         {
            _loc4_ = new TextField();
            _loc4_.selectable = false;
            _loc4_.defaultTextFormat = Styles.logFmt;
            _loc4_.embedFonts = Styles.logEmbed;
            _loc4_.text = BPLocale.getText(_loc6_.labelKey);
            _loc4_.border = false;
            _loc4_.selectable = false;
            _loc4_.autoSize = TextFieldAutoSize.LEFT;
            _loc4_.antiAliasType = AntiAliasType.ADVANCED;
            _loc4_.height = Styles.logFontHeight + 5;
            _loc4_.x = _loc3_ - _loc4_.width / 2;
            _loc4_.y = _loc4_.height;
            addChild(_loc4_);
            _loc3_ += _loc2_;
         }
         this.slider = new Slider();
         this.slider.direction = SliderDirection.HORIZONTAL;
         this.slider.move(SLIDER_GAP,_loc1_.height + 20);
         this.slider.setSize(SLIDER_WIDTH,10);
         this.slider.maximum = this.elements.length - 1;
         this.slider.minimum = 0;
         this.slider.snapInterval = 1;
         addChild(this.slider);
         this.slider.addEventListener(SliderEvent.CHANGE,this.handleSliderChanged);
      }
      
      public function setSelectedInterval(param1:int) : void
      {
         this.slider.value = param1;
      }
      
      public function getSelectedInterval() : int
      {
         return int(this.slider.value);
      }
      
      public function setSetting() : void
      {
         SettingsWindowDecorator.setSettableSettingValue(this.typeID,String(this.slider.value));
      }
      
      public function resetSetting() : void
      {
         var _loc1_:int = SettingsWindowDecorator.getSliderSettingValue(this.typeID);
         this.setSelectedInterval(_loc1_);
         if(!Settings.qualityCustomized)
         {
            this.setCurrentValueText(SliderInterval(this.elements[_loc1_]).labelKey);
         }
         else
         {
            this.setCurrentValueText("quality_custom");
         }
      }
      
      public function setCurrentValueText(param1:String) : void
      {
         this.currentValueTxt.text = BPLocale.getText(param1);
      }
      
      private function handleSliderChanged(param1:SliderEvent) : void
      {
         this.setSelectedInterval(this.slider.value);
         this.setCurrentValueText(SliderInterval(this.elements[this.slider.value]).labelKey);
      }
   }
}


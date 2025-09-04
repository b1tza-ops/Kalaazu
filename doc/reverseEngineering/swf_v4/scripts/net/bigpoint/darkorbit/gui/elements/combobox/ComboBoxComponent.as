package net.bigpoint.darkorbit.gui.elements.combobox
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import fl.controls.ComboBox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.SettingsWindowDecorator;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class ComboBoxComponent extends SimpleElement
   {
      
      public static const COMBO_GAP:int = 20;
      
      public var type:int;
      
      public var labelKey:String;
      
      private var labelTxt:TextField;
      
      private var elements:Array;
      
      public var isAdvanced:Boolean;
      
      private var tooltipKey:String;
      
      private var comboBox:ComboBox;
      
      private var ttipIcon:Sprite;
      
      public function ComboBoxComponent(param1:int, param2:String, param3:Array, param4:String = "", param5:Boolean = false)
      {
         super(SimpleElement.TYPE_COMBOBOX);
         this.type = param1;
         this.elements = param3;
         this.labelKey = param2;
         this.isAdvanced = param5;
         this.tooltipKey = param4;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:ComboboxItem = null;
         var _loc2_:ToolTipHook = null;
         this.labelTxt = new TextField();
         this.labelTxt.selectable = false;
         this.labelTxt.defaultTextFormat = Styles.strongStdFmt;
         this.labelTxt.textColor = 16777215;
         this.labelTxt.text = BPLocale.getText(this.labelKey);
         this.labelTxt.border = false;
         this.labelTxt.embedFonts = Styles.strongStdEmbed;
         this.labelTxt.autoSize = TextFieldAutoSize.LEFT;
         this.labelTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.labelTxt.wordWrap = true;
         this.labelTxt.height = Styles.strongStdFontHeight;
         this.labelTxt.width = 140;
         this.labelTxt.y = 0;
         addChild(this.labelTxt);
         this.comboBox = new ComboBox();
         this.comboBox.y = this.labelTxt.height + 2;
         this.comboBox.mouseFocusEnabled = false;
         for each(_loc1_ in this.elements)
         {
            this.comboBox.addItem({
               "id":_loc1_.getID(),
               "label":_loc1_.getValue()
            });
         }
         this.comboBox.addEventListener(Event.CHANGE,this.handleComboboxSelection);
         this.addChild(this.comboBox);
         if(this.tooltipKey != "")
         {
            this.ttipIcon = new Sprite();
            this.ttipIcon.addChild(SWFFinisher(ResourceManager.fileCollection.getFinisher("icons")).getEmbededBitmap("general_help"));
            this.ttipIcon.x = this.comboBox.x + this.comboBox.width + 5;
            this.ttipIcon.y = this.comboBox.y + 4;
            this.addChild(this.ttipIcon);
            _loc2_ = TooltipControl.getInstance().addToolTip(this.ttipIcon,BPLocale.getText(this.tooltipKey));
            _loc2_.showImmediately = true;
         }
      }
      
      public function setSelected(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < this.comboBox.length)
         {
            _loc2_ = this.comboBox.getItemAt(_loc3_);
            if(_loc2_.id == param1)
            {
               this.comboBox.selectedIndex = _loc3_;
            }
            _loc3_++;
         }
      }
      
      public function getSelectedID() : int
      {
         var _loc1_:Object = this.comboBox.getItemAt(this.comboBox.selectedIndex);
         return _loc1_.id;
      }
      
      public function setSetting() : void
      {
         var _loc1_:int = this.getSelectedID();
         SettingsWindowDecorator.setSettableSettingValue(this.type,String(_loc1_));
      }
      
      public function resetSetting() : void
      {
         var _loc1_:int = SettingsWindowDecorator.getComboBoxSettingValue(this.type);
         this.setSelected(_loc1_);
      }
      
      private function handleComboboxSelection(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function show(param1:Boolean) : void
      {
         this.labelTxt.visible = param1;
         this.comboBox.visible = param1;
         if(this.ttipIcon != null)
         {
            this.ttipIcon.visible = param1;
         }
      }
   }
}


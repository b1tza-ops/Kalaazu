package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class ButtonElement extends SimpleElement
   {
      
      public static var TYPE_SAVE_SETTINGS:int = 0;
      
      public static var TYPE_CANCEL_SETTINGS:int = 1;
      
      public static var TYPE_CANCEL_LOGOUT:int = 2;
      
      public static var TYPE_SELL_ORE:int = 3;
      
      public static var TYPE_LAB_BTN:int = 4;
      
      public static const TYPE_RECONNECT:int = 5;
      
      public static const TYPE_CLOSE_APP:int = 6;
      
      public static const TYPE_OK:int = 7;
      
      public static const TYPE_UPDATE:int = 8;
      
      public static const TYPE_CANCEL:int = 9;
      
      public static const TYPE_REFINEMENT_UPDATE:int = 10;
      
      public static const TYPE_REFINEMENT_REFINEMENT:int = 11;
      
      public static var TYPE_RESET_SETTINGS:int = 12;
      
      public static const TYPE_SETTINGS_TAB_GAMEPLAY:int = 13;
      
      public static const TYPE_SETTINGS_TAB_DISPLAY:int = 14;
      
      public static const TYPE_SETTINGS_TAB_SOUND:int = 15;
      
      public static const TYPE_TUTORIAL_CONTINUE:int = 16;
      
      public static const TYPE_TUTORIAL_FASTER:int = 17;
      
      public static var TYPE_TRADE_ORE:int = 18;
      
      public static const TYPE_SETTINGS_TAB_INTERFACE:int = 19;
      
      public static const TYPE_ADVANCED_SETTINGS:int = 20;
      
      public static const TYPE_TRADE_SHOP:int = 21;
      
      public static const TYPE_TRADE_URIDIUM:int = 22;
      
      private var _type:int;
      
      private var label:String;
      
      private var buttonContainer:MovieClip;
      
      private var buttonMC:MovieClip;
      
      private var textField:TextField;
      
      private var format:TextFormat;
      
      private var embedFonts:Boolean;
      
      public function ButtonElement(param1:int, param2:String, param3:MovieClip, param4:TextFormat = null, param5:Boolean = true)
      {
         super(SimpleElement.TYPE_SIMPLE_BUTTON);
         this._type = param1;
         this.label = param2;
         this.embedFonts = param5;
         this.buttonContainer = param3;
         this.buttonMC = param3["buttonMC"];
         if(param4 == null)
         {
            this.format = Styles.plainStdFmt;
         }
         else
         {
            this.format = param4;
         }
         this.init();
      }
      
      private function init() : void
      {
         this.textField = new TextField();
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.buttonContainer.addChild(this.textField);
         this.buttonMC.gotoAndStop(1);
         this.buttonContainer.buttonMode = true;
         this.textField.defaultTextFormat = new TextFormat(this.format.font,this.format.size,16777215);
         this.textField.embedFonts = this.embedFonts;
         this.labelText = this.label;
         this.textField.mouseEnabled = false;
         this.buttonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.buttonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.addChild(this.buttonContainer);
      }
      
      public function set labelText(param1:String) : void
      {
         this.textField.text = param1;
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.x = 2;
         this.textField.y = 2;
         this.textField.width += 2;
         this.textField.height = int(this.format.size) + 5;
         this.buttonMC.width = this.textField.width + 5;
         this.buttonMC.height = int(this.format.size) + 9;
      }
      
      public function changeTextColour(param1:uint) : void
      {
         this.textField.textColor = param1;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(this.buttonMC.currentFrame == 1)
         {
            this.buttonMC.gotoAndStop(2);
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this.buttonMC.currentFrame == 2)
         {
            this.buttonMC.gotoAndStop(1);
         }
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function cleanup() : void
      {
         this.removeButtonListeners();
      }
      
      public function addButtonListeners() : void
      {
         this.buttonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.buttonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function removeButtonListeners() : void
      {
         this.buttonContainer.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.buttonContainer.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function setDisableStatus() : void
      {
         this.buttonMC.gotoAndStop(2);
      }
      
      public function setEnableStatus() : void
      {
         this.buttonMC.gotoAndStop(1);
      }
      
      public function setTextPosY(param1:int) : void
      {
         this.textField.y = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this.buttonMC.width = param1;
         if(this.textField.width < param1 - 5)
         {
            this.textField.x = (param1 - this.textField.width) * 0.5;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         this.buttonMC.height = param1;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1)
         {
            this.buttonMC.gotoAndStop(3);
         }
         else
         {
            this.buttonMC.gotoAndStop(1);
         }
      }
   }
}


package net.bigpoint.darkorbit.gui.elements
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class TextFieldElement extends SimpleElement
   {
      
      private var _textField:TextField;
      
      private var tfWidth:int;
      
      private var tfHeight:int;
      
      private var text:String;
      
      private var align:String;
      
      private var format:TextFormat;
      
      private var border:Boolean;
      
      public function TextFieldElement(param1:int, param2:int, param3:TextFormat, param4:String = null, param5:String = "center", param6:Boolean = false)
      {
         super(SimpleElement.TYPE_TEXT);
         this.tfWidth = param1;
         this.tfHeight = param2;
         this.format = param3;
         this.text = param4;
         this.align = param5;
         this.border = param6;
         this.init();
      }
      
      public function init() : void
      {
         this.format.align = this.align;
         this._textField = new TextField();
         this._textField.defaultTextFormat = this.format;
         this._textField.embedFonts = Styles.simpleEmbed;
         this._textField.wordWrap = true;
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this._textField.width = this.tfWidth;
         this._textField.height = this.tfHeight;
         this._textField.border = this.border;
         this._textField.selectable = false;
         if(this.text != null)
         {
            this._textField.text = this.text;
         }
         this.addChild(this._textField);
      }
      
      public function updateText(param1:String) : void
      {
         this._textField.text = param1;
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
   }
}


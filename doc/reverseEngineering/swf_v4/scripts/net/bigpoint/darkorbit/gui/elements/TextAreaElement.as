package net.bigpoint.darkorbit.gui.elements
{
   import fl.controls.TextArea;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class TextAreaElement extends SimpleElement
   {
      
      public var textArea:TextArea;
      
      private var tfWidth:int;
      
      private var tfHeight:int;
      
      private var text:String;
      
      private var align:String;
      
      private var border:Boolean;
      
      public function TextAreaElement(param1:int, param2:int, param3:String = "center", param4:Boolean = false)
      {
         super(SimpleElement.TYPE_TEXT);
         this.tfWidth = param1;
         this.tfHeight = param2;
         this.text = this.text;
         this.align = param3;
         this.border = param4;
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:TextFormat = new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215);
         _loc1_.align = this.align;
         this.textArea = new TextArea();
         this.textArea.width = this.tfWidth;
         this.textArea.height = this.tfHeight;
         this.textArea.editable = false;
         this.textArea.textField.selectable = false;
         this.textArea.textField.border = this.border;
         this.textArea.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textArea.setStyle("textFormat",_loc1_);
         this.textArea.setStyle("embedFonts",Styles.logEmbed);
         this.addChild(this.textArea);
      }
   }
}


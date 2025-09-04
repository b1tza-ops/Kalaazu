package mx.core
{
   use namespace mx_internal;
   
   public class EmbeddedFont
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      private var _bold:Boolean;
      
      private var _fontName:String;
      
      private var _fontStyle:String;
      
      private var _italic:Boolean;
      
      public function EmbeddedFont(param1:String, param2:Boolean, param3:Boolean)
      {
         super();
         this.initialize(param1,param2,param3);
      }
      
      public function get bold() : Boolean
      {
         return this._bold;
      }
      
      public function get fontName() : String
      {
         return this._fontName;
      }
      
      public function get fontStyle() : String
      {
         return this._fontStyle;
      }
      
      public function get italic() : Boolean
      {
         return this._italic;
      }
      
      public function initialize(param1:String, param2:Boolean, param3:Boolean) : void
      {
         this._bold = param2;
         this._italic = param3;
         this._fontName = param1;
         this._fontStyle = EmbeddedFontRegistry.getInstance().getFontStyle(param2,param3);
      }
   }
}


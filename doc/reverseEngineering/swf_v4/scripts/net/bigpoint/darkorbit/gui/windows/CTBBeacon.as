package net.bigpoint.darkorbit.gui.windows
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreElement;
   
   public class CTBBeacon extends Sprite
   {
      
      private var id:int;
      
      private var scoreElement:CTBScoreElement;
      
      public var _companyID:int;
      
      private var homeSymbol:Bitmap;
      
      private var textField:TextField;
      
      public function CTBBeacon(param1:CTBScoreElement, param2:int, param3:int)
      {
         super();
         this.id = param2;
         this.scoreElement = param1;
         this._companyID = param3;
         this.init();
      }
      
      public function setHighlight() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("ctb_" + Hero.factionID);
         this.addChildAt(_loc2_,0);
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("company_symbol_" + this._companyID);
         _loc2_.x = 3.5;
         this.addChild(_loc2_);
         this.homeSymbol = _loc1_.getEmbededBitmap("home_symbol");
         this.homeSymbol.x = 17;
         this.addChild(this.homeSymbol);
      }
      
      public function update(param1:int) : void
      {
         var _loc2_:TextFormat = null;
         if(!this.scoreElement.contains(this))
         {
            this.scoreElement.addChild(this);
         }
         if(param1 == 0)
         {
            this.homeSymbol.visible = true;
            if(this.textField != null)
            {
               this.textField.visible = false;
            }
         }
         else
         {
            this.homeSymbol.visible = false;
            if(this.textField == null)
            {
               _loc2_ = new TextFormat(Styles.simpleFmt.font,11,16777215);
               this.textField = new TextField();
               this.textField.x = 17;
               this.textField.y = -3;
               this.textField.defaultTextFormat = _loc2_;
               this.textField.embedFonts = Styles.simpleEmbed;
               this.textField.wordWrap = true;
               this.textField.antiAliasType = AntiAliasType.ADVANCED;
               this.textField.width = this.scoreElement.getBackground().width - this.textField.x;
               this.textField.height = 10;
               this.textField.selectable = false;
               this.addChild(this.textField);
            }
            this.textField.text = InGameCatalog.instance.mapNames[param1];
         }
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function get companyID() : int
      {
         return this._companyID;
      }
      
      public function set companyID(param1:int) : void
      {
         this._companyID = param1;
      }
   }
}


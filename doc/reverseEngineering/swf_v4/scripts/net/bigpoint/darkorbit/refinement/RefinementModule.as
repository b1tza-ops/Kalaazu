package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.display.Bitmap;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class RefinementModule extends SimpleElement
   {
      
      public static const logger:ILogger = Log.getLogger("RefinementModule");
      
      public static const TYPE_SOURCE:int = 0;
      
      public static const TYPE_TARGET:int = 1;
      
      private var _languageKey:String;
      
      private var _type:int;
      
      protected var _labelName:RefinementLabel;
      
      protected var _labelAmmount:RefinementLabel;
      
      protected var _background:Bitmap;
      
      protected var finisher:SWFFinisher;
      
      protected var resKey:String;
      
      protected var _refinementManager:RefinementManager;
      
      protected var gap:int = 4;
      
      public function RefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String)
      {
         super(SimpleElement.TYPE_REFINEMENT_MODULE);
         this._refinementManager = param1;
         this._type = param2;
         this._languageKey = param3;
         this.resKey = param4;
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("refinement"));
      }
      
      protected function setLabels() : void
      {
         this._labelName = new RefinementLabel(this);
         this._labelName.y = this.background.y - this._labelName.height - this.gap;
         this._labelName.setText(BPLocale.getText(this._languageKey));
         this.addChild(this._labelName);
         this._labelAmmount = new RefinementLabel(this);
         this._labelAmmount.y = this.background.height + this.gap;
         this.addChild(this._labelAmmount);
      }
      
      public function get refinementManager() : RefinementManager
      {
         return this._refinementManager;
      }
      
      public function get labelName() : RefinementLabel
      {
         return this._labelName;
      }
      
      public function get labelAmmount() : RefinementLabel
      {
         return this._labelAmmount;
      }
      
      public function get background() : Bitmap
      {
         return this._background;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get languageKey() : String
      {
         return this._languageKey;
      }
   }
}


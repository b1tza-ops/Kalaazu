package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.utils.BPLocale;
   import flash.display.Bitmap;
   
   public class TargetRefinementModule extends RefinementModule
   {
      
      private var _targetIcon:Bitmap;
      
      private var _identifier:String;
      
      private var _ammountKey:String;
      
      private var _oreIcon:OreIcon;
      
      public function TargetRefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String, param5:String, param6:String)
      {
         super(param1,param2,param3,param4);
         this._identifier = param5;
         this._ammountKey = param6;
         this.init();
      }
      
      public function removeOreIcon() : void
      {
         if(this._oreIcon != null && this.contains(this._oreIcon))
         {
            this.removeChild(this._oreIcon);
         }
         this._oreIcon = null;
      }
      
      public function setOreIcon(param1:OreIcon) : void
      {
         this._oreIcon = param1;
         this._oreIcon.x = this.targetIcon.x + 1;
         this._oreIcon.y = this.targetIcon.y + 1;
         this.addChild(this._oreIcon);
      }
      
      private function init() : void
      {
         var _loc1_:int = 4;
         _background = finisher.getEmbededBitmap("targetSlot");
         this.addChild(_background);
         var _loc2_:Bitmap = finisher.getEmbededBitmap(resKey);
         _loc2_.x = _background.width / 2 - _loc2_.width / 2;
         _loc2_.y = _background.height / 2 - _loc2_.height / 2;
         this.addChild(_loc2_);
         this._targetIcon = finisher.getEmbededBitmap("targetIcon");
         this._targetIcon.x = _loc1_;
         this._targetIcon.y = _background.height - this._targetIcon.height - _loc1_;
         this.addChild(this._targetIcon);
         setLabels();
         this.setAmmount(0);
      }
      
      public function get targetIcon() : Bitmap
      {
         return this._targetIcon;
      }
      
      public function get identifier() : String
      {
         return this._identifier;
      }
      
      public function setAmmount(param1:int) : void
      {
         labelAmmount.setText(BPLocale.getText(this._ammountKey).replace("%COUNT%",param1.toString()));
      }
      
      public function get oreIcon() : OreIcon
      {
         return this._oreIcon;
      }
   }
}


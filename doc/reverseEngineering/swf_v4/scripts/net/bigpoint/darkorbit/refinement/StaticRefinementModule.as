package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   
   public class StaticRefinementModule extends RefinementModule
   {
      
      private var _oreCount:int = 0;
      
      private var translatedToolTip:String;
      
      public function StaticRefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String, param5:String = null)
      {
         super(param1,param2,param3,param4);
         this.translatedToolTip = param5;
         this.init();
      }
      
      public function updateAmmount() : void
      {
         labelAmmount.setText(this._oreCount.toString());
      }
      
      public function setOreCount(param1:int) : void
      {
         this._oreCount = param1;
      }
      
      private function init() : void
      {
         _background = finisher.getEmbededBitmap("sourceSlot");
         this.addChild(_background);
         var _loc1_:Bitmap = finisher.getEmbededBitmap(resKey);
         _loc1_.x = _background.width / 2 - _loc1_.width / 2;
         _loc1_.y = _background.height / 2 - _loc1_.height / 2;
         this.addChild(_loc1_);
         setLabels();
         this.setAmmount(0);
         if(this.translatedToolTip != null)
         {
            TooltipControl.getInstance().addToolTip(this,this.translatedToolTip);
         }
      }
      
      public function setAmmount(param1:int) : void
      {
         labelAmmount.setText(param1.toString());
      }
   }
}


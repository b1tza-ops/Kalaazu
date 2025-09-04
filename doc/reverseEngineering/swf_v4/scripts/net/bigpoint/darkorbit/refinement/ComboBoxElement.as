package net.bigpoint.darkorbit.refinement
{
   import fl.controls.ComboBox;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class ComboBoxElement extends SimpleElement
   {
      
      private var guiManager:GuiManager;
      
      private var _comboBox:ComboBox;
      
      private var amounts:Array = [1,5,10,50,100,500,1000];
      
      public function ComboBoxElement(param1:GuiManager)
      {
         super(TYPE_COMBO_BOX_ELEMENT);
         this.guiManager = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._comboBox = new ComboBox();
         addChild(this._comboBox);
      }
      
      public function setAvailableAmmount(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.amounts.length)
         {
            _loc3_ = int(this.amounts[_loc2_]);
            if(_loc3_ < param1)
            {
               this._comboBox.addItem({"label":this.amounts[_loc2_]});
            }
            _loc2_++;
         }
         this._comboBox.addItem({"label":param1});
      }
      
      public function get comboBox() : ComboBox
      {
         return this._comboBox;
      }
   }
}


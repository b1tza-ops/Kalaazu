package net.bigpoint.darkorbit.gui.elements.combobox
{
   public class ComboboxItem
   {
      
      private var id:int;
      
      private var value:String;
      
      public function ComboboxItem(param1:int, param2:String)
      {
         super();
         this.value = param2;
         this.id = param1;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function getValue() : String
      {
         return this.value;
      }
      
      public function toString() : String
      {
         return "ComboboxItem id:" + this.id + " value:" + this.value;
      }
   }
}


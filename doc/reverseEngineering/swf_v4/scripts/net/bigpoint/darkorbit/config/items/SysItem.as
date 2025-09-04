package net.bigpoint.darkorbit.config.items
{
   public class SysItem
   {
      
      public var id:String;
      
      public var name:String;
      
      public var packageName:String;
      
      public var category:String;
      
      public function SysItem(param1:String, param2:String, param3:String, param4:String = "")
      {
         super();
         this.id = param1;
         this.name = param2;
         this.packageName = param3;
         this.category = param4;
      }
   }
}


package net.bigpoint.darkorbit.pattern
{
   public class BackgroundPattern extends ResourcePattern
   {
      
      public var isTiled:Boolean;
      
      public var isReloadable:Boolean;
      
      public var width:int;
      
      public var height:int;
      
      public var tileWidth:int;
      
      public var tileHeight:int;
      
      public var order:String;
      
      public function BackgroundPattern(param1:int, param2:String, param3:Boolean, param4:Boolean, param5:int, param6:int, param7:String, param8:int, param9:int)
      {
         super(param1,param2);
         this.isTiled = param3;
         this.isReloadable = param4;
         this.tileWidth = param5;
         this.tileHeight = param6;
         if(param7 != "")
         {
            this.order = param7;
         }
         this.width = param8;
         this.height = param9;
      }
   }
}


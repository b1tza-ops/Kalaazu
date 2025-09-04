package net.bigpoint
{
   public class AmmoPrice
   {
      
      public static const CURRENCY_URIDIUM:int = 0;
      
      public static const CURRENCY_CREDITS:int = 1;
      
      public static var CATEGORY_LASER:int = 0;
      
      public static var CATEGORY_ROCKET:int = 1;
      
      public var ammoID:int;
      
      public var amount:int;
      
      public var summedPrice:int;
      
      public var currency:int;
      
      public var category:int;
      
      public function AmmoPrice(param1:int, param2:int, param3:int, param4:int, param5:String)
      {
         super();
         this.category = param1;
         this.ammoID = param3;
         this.amount = param2;
         this.summedPrice = param4;
         if(param5 == "U")
         {
            this.currency = CURRENCY_URIDIUM;
         }
         else if(param5 == "C")
         {
            this.currency = CURRENCY_CREDITS;
         }
      }
   }
}


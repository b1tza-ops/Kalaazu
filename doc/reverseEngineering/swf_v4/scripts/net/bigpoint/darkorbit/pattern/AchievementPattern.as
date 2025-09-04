package net.bigpoint.darkorbit.pattern
{
   public class AchievementPattern extends Pattern
   {
      
      public static var MAX_ID:int;
      
      public var languageKey:String;
      
      public var priceValue:Number = -1;
      
      public var priceCurrency:String;
      
      public function AchievementPattern(param1:int, param2:String)
      {
         super(param1,CONTENT_CUSTOM);
         this.languageKey = param2;
      }
   }
}


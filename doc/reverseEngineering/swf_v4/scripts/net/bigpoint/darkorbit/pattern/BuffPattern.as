package net.bigpoint.darkorbit.pattern
{
   public class BuffPattern
   {
      
      public static const SINGULARITY_BUFF:int = 1;
      
      public static const SPEEDLEACH_BUFF:int = 2;
      
      public static const TRADE_BUFF:int = 3;
      
      public static const WEAKENSHIELD_BUFF:int = 4;
      
      public var id:int;
      
      public var resKey:String;
      
      public var languageKey:String;
      
      public var effect:int;
      
      public function BuffPattern(param1:int, param2:String, param3:String, param4:int)
      {
         super();
         this.id = param1;
         this.resKey = param2;
         this.languageKey = param3;
         this.effect = param4;
      }
   }
}


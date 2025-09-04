package com.bigpoint.utils
{
   public class TextReplacement
   {
      
      public static const TYPE_PLAIN:int = 0;
      
      public static const TYPE_NUMBER:int = 1;
      
      public static const TYPE_KEY:int = 2;
      
      public static const TYPE_TIME:int = 3;
      
      public var value:String;
      
      public var type:int;
      
      public var wildcard:String;
      
      public var precision:int = 0;
      
      public function TextReplacement(param1:String = "%!", param2:int = 0, param3:String = "")
      {
         super();
         this.wildcard = param1;
         this.type = param2;
         this.value = param3;
      }
   }
}


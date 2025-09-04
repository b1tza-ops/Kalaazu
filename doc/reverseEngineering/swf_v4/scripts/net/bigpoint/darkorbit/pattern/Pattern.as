package net.bigpoint.darkorbit.pattern
{
   public class Pattern
   {
      
      public static const CONTENT_RESOURCE:int = 0;
      
      public static const CONTENT_CUSTOM:int = 1;
      
      protected var patternID:int;
      
      private var contentType:int;
      
      public function Pattern(param1:int, param2:int)
      {
         super();
         this.patternID = param1;
         this.contentType = param2;
      }
      
      public function getPatternID() : int
      {
         return this.patternID;
      }
      
      public function getContentType() : int
      {
         return this.contentType;
      }
   }
}


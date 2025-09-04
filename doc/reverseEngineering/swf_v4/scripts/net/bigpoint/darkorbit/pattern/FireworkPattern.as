package net.bigpoint.darkorbit.pattern
{
   public class FireworkPattern extends AudibleResourcePattern
   {
      
      public static const CLASS_RED:int = 0;
      
      public static const CLASS_BLUE:int = 1;
      
      public static const CLASS_GREEN:int = 2;
      
      public static const CLASS_RED_WHITE_BLUE:int = 3;
      
      public var useBitmapClip:Boolean;
      
      public var precache:Boolean;
      
      private var patternClass:int;
      
      public function FireworkPattern(param1:int, param2:int, param3:String)
      {
         super(param2,param3);
         this.patternClass = param1;
      }
      
      public function getPatternClass() : int
      {
         return this.patternClass;
      }
   }
}


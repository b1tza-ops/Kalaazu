package net.bigpoint.darkorbit.combat
{
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   
   public class RocketPattern extends AudibleResourcePattern
   {
      
      public static const TYPE_DEFAULT_ROCKETS:int = 0;
      
      public static const TYPE_ROCKET_LAUNCHER:int = 100;
      
      public static const R310:int = 1;
      
      public static const PLT_2026:int = 2;
      
      public static const PLT_2021:int = 3;
      
      public static const PLT_3030:int = 4;
      
      public static const PLD_8:int = 5;
      
      public static const WIZ:int = 6;
      
      public static const HSTRM01:int = 7;
      
      public static const UBR100:int = 8;
      
      public static const ECO10:int = 9;
      
      public static const DCR_250:int = 10;
      
      private var rocketClass:int;
      
      public function RocketPattern(param1:int, param2:int, param3:String)
      {
         super(param2,param3);
         this.rocketClass = param1;
      }
      
      public function getRocketClass() : int
      {
         return this.rocketClass;
      }
      
      public function toString() : String
      {
         return "RocketPattern id:" + patternID + " resKey:" + resKey + " class:" + this.rocketClass;
      }
   }
}


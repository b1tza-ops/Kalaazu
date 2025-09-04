package net.bigpoint.darkorbit.combat
{
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   
   public class ExplosionPattern extends AudibleResourcePattern
   {
      
      public static const TYPE_SHIP_EXPLOSION:int = 0;
      
      public static const TYPE_MINE_EXPLOSION:int = 1;
      
      public static const TYPE_LASER_DAMAGE:int = 2;
      
      public static const TYPE_ROCKET_DAMAGE:int = 3;
      
      public static const TYPE_SMARTBOMB_EXPLOSION:int = 4;
      
      public static const TYPE_INSTASHIELD:int = 5;
      
      public var useBitmapClip:Boolean;
      
      public var precache:Boolean;
      
      public var displayShockwave:Boolean;
      
      private var patternClass:int;
      
      public function ExplosionPattern(param1:int, param2:int, param3:String)
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


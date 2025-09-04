package net.bigpoint.darkorbit.pattern
{
   public class ShockwavePattern extends AudibleResourcePattern
   {
      
      public var radius:int = 300;
      
      public var duration:Number = 2;
      
      public var beginScale:Number = 1;
      
      public var endScale:Number = 0.25;
      
      public var maxShockwaves:int = 40;
      
      public var shakeScreen:Boolean;
      
      public function ShockwavePattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
   }
}


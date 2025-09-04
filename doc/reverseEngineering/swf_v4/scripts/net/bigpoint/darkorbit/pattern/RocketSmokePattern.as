package net.bigpoint.darkorbit.pattern
{
   public class RocketSmokePattern extends ResourcePattern
   {
      
      public var particleInterval:int;
      
      public var particleDuration:Number;
      
      public function RocketSmokePattern(param1:int, param2:String, param3:int, param4:Number)
      {
         super(param1,param2);
         this.particleInterval = param3;
         this.particleDuration = param4;
      }
   }
}


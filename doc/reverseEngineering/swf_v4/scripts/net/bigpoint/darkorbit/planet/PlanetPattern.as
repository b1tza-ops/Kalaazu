package net.bigpoint.darkorbit.planet
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class PlanetPattern extends ResourcePattern
   {
      
      private var radius:int;
      
      private var quarterPlanet:Boolean;
      
      public var radiusAndPaddingSquared:Number;
      
      public function PlanetPattern(param1:int, param2:String, param3:int)
      {
         super(param1,param2);
         this.radius = param3;
         this.radiusAndPaddingSquared = (param3 + 5) * (param3 + 5);
      }
      
      public function getRadius() : int
      {
         return this.radius;
      }
      
      public function isQuarterPlanet() : Boolean
      {
         return this.quarterPlanet;
      }
      
      public function setQuarterPlanet(param1:Boolean) : void
      {
         this.quarterPlanet = param1;
      }
   }
}


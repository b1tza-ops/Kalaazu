package net.bigpoint.darkorbit.ship
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class EngineSmokePattern extends ResourcePattern
   {
      
      private var rotation:Boolean;
      
      public function EngineSmokePattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function hasRotation() : Boolean
      {
         return this.rotation;
      }
      
      public function setRotation(param1:Boolean) : void
      {
         this.rotation = param1;
      }
   }
}


package net.bigpoint.darkorbit.meteor
{
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   
   public class MeteorPattern extends DynamicResource
   {
      
      private var delay:int;
      
      private var speed:int;
      
      private var layerIndex:int;
      
      public function MeteorPattern(param1:int, param2:int, param3:int, param4:int)
      {
         super(param1);
         this.delay = param2;
         this.speed = param3;
         this.layerIndex = param4;
      }
      
      public function getDelay() : int
      {
         return this.delay;
      }
      
      public function getSpeed() : int
      {
         return this.speed;
      }
      
      public function getLayerIndex() : int
      {
         return this.layerIndex;
      }
   }
}


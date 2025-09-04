package net.bigpoint.darkorbit.nebula
{
   import net.bigpoint.darkorbit.pattern.DynamicResource;
   
   public class Nebula extends DynamicResource
   {
      
      private var layerIndex:int;
      
      public function Nebula(param1:int, param2:int)
      {
         super(param1);
         this.layerIndex = param2;
      }
      
      public function getLayerIndex() : int
      {
         return this.layerIndex;
      }
   }
}


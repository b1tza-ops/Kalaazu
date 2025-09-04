package net.bigpoint.darkorbit.mine
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class MinePulsePattern extends ResourcePattern
   {
      
      public var color:uint;
      
      public var alpha:Number;
      
      public var scale:Number;
      
      public function MinePulsePattern(param1:int, param2:String, param3:uint, param4:Number, param5:Number)
      {
         super(param1,param2);
         this.color = param3;
         this.alpha = param4;
         this.scale = param5;
      }
   }
}


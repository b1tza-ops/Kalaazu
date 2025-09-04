package net.bigpoint.darkorbit.mine
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class MinePattern extends ResourcePattern
   {
      
      public static const MINE_ACM1:int = 1;
      
      public static const MINE_EMP01:int = 2;
      
      public static const MINE_SAB01:int = 3;
      
      public static const MINE_DDM01:int = 4;
      
      public var explodeType:int = 0;
      
      public var useBitmapClip:Boolean;
      
      public var shake:Boolean;
      
      public var hasStaticEffect:Boolean;
      
      public function MinePattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
   }
}


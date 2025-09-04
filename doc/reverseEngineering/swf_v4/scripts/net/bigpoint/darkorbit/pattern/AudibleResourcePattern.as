package net.bigpoint.darkorbit.pattern
{
   public class AudibleResourcePattern extends ResourcePattern
   {
      
      private var soundID:int = -1;
      
      public function AudibleResourcePattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function getSoundID() : int
      {
         return this.soundID;
      }
      
      public function setSoundID(param1:int) : void
      {
         this.soundID = param1;
      }
   }
}


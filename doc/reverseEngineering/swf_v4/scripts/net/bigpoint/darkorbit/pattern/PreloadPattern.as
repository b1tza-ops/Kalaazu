package net.bigpoint.darkorbit.pattern
{
   public class PreloadPattern extends ResourcePattern
   {
      
      private var precache:Boolean;
      
      public function PreloadPattern(param1:int, param2:String, param3:Boolean)
      {
         super(param1,param2);
         this.precache = param3;
      }
      
      public function isPrecached() : Boolean
      {
         return this.precache;
      }
   }
}


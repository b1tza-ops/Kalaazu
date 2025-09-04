package net.bigpoint.darkorbit.portal
{
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   
   public class PortalPattern extends AudibleResourcePattern
   {
      
      private var width:int;
      
      private var height:int;
      
      private var tdm:Boolean;
      
      public function PortalPattern(param1:int, param2:String, param3:int, param4:int)
      {
         super(param1,param2);
         this.width = param3;
         this.height = param4;
      }
      
      public function getWidth() : int
      {
         return this.width;
      }
      
      public function getHeight() : int
      {
         return this.height;
      }
      
      public function isTDM() : Boolean
      {
         return this.tdm;
      }
      
      public function setTDM(param1:Boolean) : void
      {
         this.tdm = param1;
      }
   }
}


package net.bigpoint.darkorbit.pattern
{
   public class ResourcePattern extends Pattern
   {
      
      public var resKey:String;
      
      private var preload:Boolean;
      
      private var precache:Boolean;
      
      private var unload:Boolean = true;
      
      public function ResourcePattern(param1:int, param2:String)
      {
         super(param1,Pattern.CONTENT_RESOURCE);
         this.resKey = param2;
      }
      
      public function getResKey() : String
      {
         return this.resKey;
      }
      
      public function isPreload() : Boolean
      {
         return this.preload;
      }
      
      public function setPreload(param1:Boolean) : void
      {
         this.preload = param1;
      }
      
      public function isPrecache() : Boolean
      {
         return this.precache;
      }
      
      public function setPrecache(param1:Boolean) : void
      {
         this.precache = param1;
      }
      
      public function isUnload() : Boolean
      {
         return this.unload;
      }
      
      public function setUnload(param1:Boolean) : void
      {
         this.unload = param1;
      }
   }
}


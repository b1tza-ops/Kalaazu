package net.bigpoint.darkorbit.lazyload
{
   import flash.events.Event;
   
   public class LazyLoadEvent extends Event
   {
      
      public static const ASSET_LOADED:String = "ASSET_LOADED";
      
      public var resKey:String;
      
      public function LazyLoadEvent(param1:String, param2:String = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.resKey = param2;
      }
   }
}


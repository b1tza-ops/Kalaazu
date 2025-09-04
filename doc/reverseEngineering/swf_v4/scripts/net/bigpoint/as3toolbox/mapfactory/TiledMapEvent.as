package net.bigpoint.as3toolbox.mapfactory
{
   import flash.events.Event;
   
   public class TiledMapEvent extends Event
   {
      
      public static const LOAD_REQUEST:String = "loadRequest";
      
      public var fileKey:String;
      
      public function TiledMapEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}


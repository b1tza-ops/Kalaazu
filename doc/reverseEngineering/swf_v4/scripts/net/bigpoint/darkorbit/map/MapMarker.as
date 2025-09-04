package net.bigpoint.darkorbit.map
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class MapMarker
   {
      
      public var id:int;
      
      public var count:int;
      
      public var mc:MovieClip;
      
      public var x:int;
      
      public var y:int;
      
      public function MapMarker(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this.id = param1;
         this.count = param4;
         this.mc = ResourceManager.getMovieClip("minimap","minimapmarker");
         this.x = param2;
         this.y = param3;
      }
   }
}


package net.bigpoint.as3toolbox.mapfactory
{
   public class MapElement implements IMapElement
   {
      
      private var tileID:int;
      
      public function MapElement()
      {
         super();
      }
      
      public function getTileID() : int
      {
         return this.tileID;
      }
      
      public function setTileID(param1:int) : void
      {
         this.tileID = param1;
      }
   }
}


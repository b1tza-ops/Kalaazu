package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class MapItem extends Sprite
   {
      
      public var id:int;
      
      public var price:int;
      
      public var mapName:String;
      
      public function MapItem(param1:int, param2:Bitmap)
      {
         super();
         this.id = param1;
         this.addChild(param2);
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}


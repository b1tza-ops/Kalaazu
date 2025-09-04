package net.bigpoint.darkorbit.gui
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class CollectableReplacementIcon extends Sprite
   {
      
      public function CollectableReplacementIcon(param1:Bitmap)
      {
         super();
         this.initIcon(param1);
      }
      
      private function initIcon(param1:Bitmap) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.x = -Math.round(param1.width * 0.5);
         param1.y = -Math.round(param1.height * 0.5);
         mouseEnabled = true;
         mouseChildren = true;
         cacheAsBitmap = true;
         addChild(param1);
      }
   }
}


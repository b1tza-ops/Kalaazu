package net.bigpoint.darkorbit.gui.windows.components.buff
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.BuffPattern;
   
   public class BuffItem extends Sprite
   {
      
      public var id:int;
      
      private var languageKey:String;
      
      private var resKey:String;
      
      public var tooltip:ToolTipHook;
      
      public var pattern:BuffPattern;
      
      public function BuffItem(param1:BuffPattern)
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
         this.id = param1.id;
         this.languageKey = param1.languageKey;
         this.resKey = param1.resKey;
         this.pattern = param1;
         this.setIcon(this.resKey);
      }
      
      private function setIcon(param1:String) : void
      {
         var _loc2_:Bitmap = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui")).getEmbededBitmap(param1);
         addChild(_loc2_);
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}


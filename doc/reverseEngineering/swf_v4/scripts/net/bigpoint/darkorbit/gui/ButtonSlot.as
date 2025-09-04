package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.menu.ActionButton;
   
   public class ButtonSlot
   {
      
      public static const logger:ILogger = Log.getLogger("ButtonSlot");
      
      protected var mc:MovieClip;
      
      private var actionButton:ActionButton;
      
      private var menuButton:MenuButton;
      
      private var resKey:String;
      
      private var keyboardIcons:MovieClip;
      
      private var guiManager:GuiManager;
      
      public function ButtonSlot(param1:String, param2:GuiManager, param3:int = -1)
      {
         super();
         this.resKey = param1;
         this.guiManager = param2;
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.mc = new MovieClip();
         this.mc.mouseEnabled = Main.mouseEventsEnabled;
         var _loc5_:Bitmap = _loc4_.getEmbededBitmap(param1);
         this.mc.addChild(_loc5_);
         this.mc.visible = false;
         if(param3 != -1)
         {
            this.keyboardIcons = _loc4_.getEmbededMovieClip("keyboardIcons");
            this.keyboardIcons.cacheAsBitmap = true;
            this.keyboardIcons.gotoAndStop(param3);
            this.keyboardIcons.x = _loc5_.width * 0.5 - this.keyboardIcons.width * 0.5 + 1;
            this.keyboardIcons.y = _loc5_.height - this.keyboardIcons.width + 1;
            this.mc.addChild(this.keyboardIcons);
         }
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         if(this.actionButton != null)
         {
            this.actionButton.getMovieclip().visible = param1;
            if(this.guiManager.getMenuManager().getMainMenu().guiLocked)
            {
               this.mc.visible = param1;
            }
         }
      }
      
      public function addActionButton(param1:ActionButton) : void
      {
         this.actionButton = param1;
         var _loc2_:MovieClip = this.actionButton.getMovieclip();
         _loc2_.x = 0;
         _loc2_.y = 0;
         this.mc.addChild(_loc2_);
         if(this.keyboardIcons != null)
         {
            this.mc.swapChildren(_loc2_,this.keyboardIcons);
         }
         this.mc.visible = true;
         this.guiManager.getMenuManager().updateTechs();
      }
      
      public function addMenu(param1:MenuButton) : void
      {
         this.menuButton = param1;
         this.mc.addChild(param1.getMC());
         this.mc.visible = true;
      }
      
      public function removeActionButton() : void
      {
         if(this.actionButton != null)
         {
            this.mc.removeChild(this.actionButton.getMovieclip());
            this.actionButton = null;
         }
      }
      
      public function getMC() : MovieClip
      {
         return this.mc;
      }
      
      public function getActionButton() : ActionButton
      {
         return this.actionButton;
      }
      
      public function getResKey() : String
      {
         return this.resKey;
      }
      
      public function isAllocated() : Boolean
      {
         if(this.actionButton != null || this.menuButton != null)
         {
            return true;
         }
         return false;
      }
   }
}


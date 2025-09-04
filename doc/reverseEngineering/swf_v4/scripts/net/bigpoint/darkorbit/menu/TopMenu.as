package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.gui.ActionEvent;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   
   public class TopMenu extends Sprite
   {
      
      public static const logger:ILogger = Log.getLogger("TopMenu");
      
      private var guiManager:GuiManager;
      
      private var staticButtonSlots:Array = [];
      
      private var buttons:Array = [];
      
      public function TopMenu(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:Point = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:ActionButton2 = null;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("sticky_nav_bg.png");
         var _loc3_:Bitmap = _loc1_.getEmbededBitmap("sticky_nav_logo.png");
         addChild(_loc2_);
         addChild(_loc3_);
         _loc3_.x = 36;
         this.x = ScreenManager.getScreenWidth() - _loc2_.width;
         for each(_loc7_ in Main.gameXML.topMenu.staticButtonSlots.staticButtonSlot)
         {
            _loc4_ = parseInt(_loc7_.attribute("id"));
            _loc5_ = parseInt(_loc7_.attribute("iconXPos")) + this.x;
            _loc6_ = parseInt(_loc7_.attribute("iconYPos")) + this.y;
            _loc9_ = new Point();
            _loc9_.x = _loc5_;
            _loc9_.y = _loc6_;
            this.staticButtonSlots[_loc4_] = _loc9_;
         }
         for each(_loc8_ in Main.gameXML.topMenu.buttons.button)
         {
            _loc4_ = parseInt(_loc8_.attribute("id"));
            _loc5_ = parseInt(_loc8_.attribute("iconXPos"));
            _loc6_ = parseInt(_loc8_.attribute("iconYPos"));
            _loc10_ = _loc8_.attribute("resKey");
            _loc11_ = null;
            _loc12_ = false;
            if(_loc8_.attribute("counter").length() > 0)
            {
               _loc12_ = Main.parseBooleanFromString(_loc8_.attribute("counter"));
            }
            if(_loc8_.attribute("languageKey").length() > 0)
            {
               _loc11_ = _loc8_.attribute("languageKey");
            }
            _loc13_ = new ActionButton2(this.guiManager,_loc10_,_loc4_,ActionButton2.TYPE_DYNAMIC_BUTTON,_loc12_,_loc11_);
            _loc13_.init();
            _loc13_.getMovieClip().x = _loc5_;
            _loc13_.getMovieClip().y = _loc6_;
            _loc13_.addEventListener(ActionEvent.ACTION,this.onAction);
            this.buttons[_loc4_] = _loc13_;
            this.addChild(_loc13_.getMovieClip());
         }
      }
      
      public function onAction(param1:ActionEvent) : void
      {
         var _loc2_:ActionButton2 = param1.target as ActionButton2;
         if(_loc2_.getButtonContainer().buttonMode == false)
         {
            return;
         }
         switch(param1.getActionID())
         {
            case SuperActionButton.ACTION_ACTIVATE_GATE:
               this.guiManager.getMain().screenManager.map.getEventManager().activateGate();
               break;
            case SuperActionButton.ACTION_FASTREPAIR:
               this.guiManager.getMain().screenManager.map.getEventManager().activateInstaRepair();
         }
      }
      
      public function getStaticButtonsSlotPosition(param1:int) : Point
      {
         var _loc2_:Point = this.staticButtonSlots[param1];
         if(_loc2_ == null)
         {
            logger.fatal("no static slot position found for id:" + param1);
         }
         return _loc2_;
      }
      
      public function getGuiManager() : GuiManager
      {
         return this.guiManager;
      }
      
      public function setButtonAccess(param1:int, param2:Boolean) : void
      {
         var _loc3_:ActionButton2 = null;
         for each(_loc3_ in this.buttons)
         {
            if(_loc3_.getActionID() == param1)
            {
               if(param2)
               {
                  _loc3_.unlockButton();
               }
               else
               {
                  _loc3_.lockButton();
               }
            }
         }
      }
      
      public function setWindowAccess(param1:int, param2:Boolean) : void
      {
         var _loc3_:SimpleWindow = this.guiManager.getWindow(param1);
         if(_loc3_ != null)
         {
            if(param2)
            {
               _loc3_.unlockWindow();
            }
            else
            {
               _loc3_.lockWindow();
            }
         }
      }
      
      public function getButton(param1:int) : ActionButton2
      {
         return this.buttons[param1];
      }
      
      public function flashButtonIcon(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:ActionButton2 = this.buttons[param1];
         if(_loc4_ != null)
         {
            _loc4_.flashIcon(param2);
            if(param3)
            {
               _loc4_.startPointer();
            }
         }
      }
      
      public function stopFlashButtonIcon(param1:int) : void
      {
         var _loc2_:ActionButton2 = this.buttons[param1];
         if(_loc2_ != null)
         {
            _loc2_.stopFlashIcon();
         }
      }
      
      public function refresh() : void
      {
         var _loc1_:ActionButton2 = null;
         for each(_loc1_ in this.buttons)
         {
            if(this.guiManager.getMenuManager().isButtonBlacklisted(_loc1_.getActionID()))
            {
               _loc1_.getMovieClip().visible = false;
            }
            else
            {
               _loc1_.getMovieClip().visible = true;
            }
         }
      }
   }
}


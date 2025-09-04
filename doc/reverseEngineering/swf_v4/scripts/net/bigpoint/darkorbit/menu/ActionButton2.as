package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.gui.ActionEvent;
   import net.bigpoint.darkorbit.gui.BitmapFont;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.map.Map;
   
   public class ActionButton2 extends SuperActionButton
   {
      
      public static const logger:ILogger = Log.getLogger("ActionButton2");
      
      public static var TYPE_STATIC_BUTTON:int = 0;
      
      public static var TYPE_DYNAMIC_BUTTON:int = 1;
      
      private var resKey:String;
      
      private var buttonType:int;
      
      private var languageKey:String;
      
      public function ActionButton2(param1:GuiManager, param2:String, param3:int, param4:int, param5:Boolean = false, param6:String = null)
      {
         super();
         this.guiManager = param1;
         this.resKey = param2;
         this.actionID = param3;
         this.buttonType = param4;
         this.hasCounter = param5;
         this.languageKey = param6;
      }
      
      public function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         buttonContainer = new MovieClip();
         if(this.buttonType == TYPE_STATIC_BUTTON)
         {
            if(actionID == ACTION_LOGOUT)
            {
               actionNormal = _loc1_.getEmbededBitmap("comb03_std.png");
               actionHover = _loc1_.getEmbededBitmap("comb03_hover.png");
            }
            else
            {
               actionNormal = _loc1_.getEmbededBitmap("comb02_std.png");
               actionHover = _loc1_.getEmbededBitmap("comb02_hover.png");
            }
            actionSelected = _loc1_.getEmbededBitmap("comb02_selected.png");
         }
         else if(this.buttonType == TYPE_DYNAMIC_BUTTON)
         {
            actionNormal = _loc1_.getEmbededBitmap("comb02_std.png");
            actionHover = _loc1_.getEmbededBitmap("comb02_hover.png");
            actionSelected = _loc1_.getEmbededBitmap("comb02_selected.png");
         }
         this.selectedIcon = _loc1_.getEmbededBitmap("comb02_flash.png");
         if(actionSelected != null)
         {
            actionSelected.x = -1;
            actionSelected.y = -2;
         }
         actionDisabled = _loc1_.getEmbededBitmap("comb00_deactivated.png");
         actionDisabled.visible = false;
         buttonContainer.addChild(_loc1_.getEmbededBitmap("slot"));
         buttonContainer.addChild(actionNormal);
         buttonContainer.addChild(actionHover);
         actionHover.visible = false;
         buttonContainer.addChild(actionSelected);
         actionSelected.visible = false;
         buttonContainer.addChild(_loc1_.getEmbededBitmap(this.resKey));
         buttonContainer.addChild(actionDisabled);
         buttonContainer.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         buttonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         buttonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         buttonContainer.buttonMode = true;
         if(hasCounter)
         {
            bitmapFont = new BitmapFont(this);
            bitmapFont.y = 9;
            buttonContainer.addChild(bitmapFont);
            bitmapFont.setText("0");
         }
         if(this.languageKey != null)
         {
            TooltipControl.getInstance().addToolTip(buttonContainer,BPLocale.getText(this.languageKey));
         }
         selectedIcon.visible = false;
         buttonContainer.addChild(selectedIcon);
      }
      
      public function getMovieClip() : MovieClip
      {
         return buttonContainer;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Map = guiManager.getMain().screenManager.map;
         if(_loc2_ != null)
         {
            if(_loc2_.getEventManager().isControlsLocked())
            {
               return;
            }
         }
         var _loc3_:ActionEvent = new ActionEvent(ActionEvent.ACTION);
         _loc3_.setActionID(actionID);
         dispatchEvent(_loc3_);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(actionSelected.visible || buttonContainer.buttonMode == false)
         {
            return;
         }
         actionHover.alpha = 0;
         actionHover.visible = true;
         TweenLite.to(actionHover,0.5,{"alpha":1});
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(actionHover,0.5,{
            "alpha":0,
            "onComplete":setInvisible,
            "onCompleteParams":[actionHover]
         });
      }
      
      public function setDeselected() : void
      {
         actionSelected.visible = false;
      }
      
      public function setSelected() : void
      {
         actionSelected.visible = true;
      }
   }
}


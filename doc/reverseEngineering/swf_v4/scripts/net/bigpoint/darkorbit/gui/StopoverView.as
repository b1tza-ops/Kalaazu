package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class StopoverView extends Sprite
   {
      
      private static const DESTROYER_TYPE_PLAYER:String = "PLAYER";
      
      private static const DESTROYER_TYPE_NPC:String = "NPC";
      
      private static const DESTROYER_TYPE_RADIATION:String = "RADIATION";
      
      private static const DESTROYER_TYPE_UNKNOWN:String = "UNKNOWN";
      
      private var guiManager:GuiManager;
      
      private var leaveButton:ButtonElement;
      
      private var showDetailsButton:ButtonElement;
      
      private var buttonPadding:int;
      
      private var combinedWidth:Number = 8;
      
      private var repairView:SimpleWindow;
      
      private var msgLabel:TextField;
      
      private var _repairRequested:Boolean;
      
      private var executePrimeAction:Function;
      
      public function StopoverView(param1:GuiManager, param2:int, param3:int)
      {
         super();
         this.guiManager = param1;
         var _loc4_:Sprite = new Sprite();
         var _loc5_:String = GradientType.RADIAL;
         var _loc6_:Array = [0,0];
         var _loc7_:Array = [0,0.5];
         var _loc8_:Array = [0,255];
         var _loc9_:Matrix = new Matrix();
         _loc9_.createGradientBox(param3,param3,param2 * 0.5 - param3 * 0.5,param2 * 0.5 - param3 * 0.5);
         var _loc10_:String = SpreadMethod.PAD;
         _loc4_.graphics.beginGradientFill(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         _loc4_.graphics.drawRect(0,0,param2,param3);
         _loc4_.graphics.endFill();
         addChild(_loc4_);
         this.msgLabel = new TextField();
         var _loc11_:TextFormat = new TextFormat(Styles.systemSplashFmt.font,Styles.systemSplashFmt.size,16777215);
         _loc11_.align = TextFormatAlign.CENTER;
         this.msgLabel.defaultTextFormat = _loc11_;
         this.msgLabel.embedFonts = Styles.systemSplashEmbed;
         this.msgLabel.x = param2 * 0.2;
         this.msgLabel.y = param3 * 0.33;
         this.msgLabel.width = param2 * 0.6;
         this.msgLabel.wordWrap = true;
         this.msgLabel.multiline = true;
         this.msgLabel.selectable = false;
         this.msgLabel.autoSize = TextFieldAutoSize.CENTER;
         addChild(this.msgLabel);
         this.buttonPadding = 8;
         this.showDetailsButton = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("btn_repair"),ResourceManager.getMovieClip("ui","button1"),Styles.h1Fmt);
         this.showDetailsButton.addEventListener(MouseEvent.CLICK,this.handleShowDetailsButtonClick);
         this.showDetailsButton.y = param3 * 0.66;
         this.leaveButton = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("btn_leaveGame"),ResourceManager.getMovieClip("ui","button1"),Styles.h1Fmt);
         this.leaveButton.addEventListener(MouseEvent.CLICK,this.handleLeaveButtonClick);
         this.leaveButton.y = param3 * 0.66;
         this.combinedWidth = this.showDetailsButton.width + this.leaveButton.width + this.buttonPadding;
         this.showDetailsButton.x = (param2 - this.combinedWidth) * 0.5;
         this.leaveButton.x = this.showDetailsButton.x + this.showDetailsButton.width + this.buttonPadding;
         this.msgLabel.alpha = 0;
         TweenLite.to(this.msgLabel,0.5,{"alpha":1});
         _loc4_.alpha = 0;
         this.fadeInUi();
         TweenLite.to(_loc4_,2.5,{
            "alpha":1,
            "ease":Cubic.easeIn
         });
      }
      
      public function updateKillMessage(param1:String, param2:int, param3:String) : void
      {
         var _loc4_:String = null;
         switch(param1)
         {
            case DESTROYER_TYPE_NPC:
               _loc4_ = BPLocale.getText("msg_destruction_by_npc").replace(/%nick%/,param3);
               break;
            case DESTROYER_TYPE_PLAYER:
               _loc4_ = BPLocale.getText("msg_destruction_by_player").replace(/%nick%/,param3);
               break;
            case DESTROYER_TYPE_RADIATION:
               _loc4_ = BPLocale.getText("msg_destruction_by_rad_zone");
               break;
            default:
               _loc4_ = BPLocale.getText("msg_destruction_by_unknown_reason");
         }
         this.msgLabel.text = _loc4_;
      }
      
      private function handleShowDetailsButtonClick(param1:MouseEvent = null) : void
      {
         this.updateRepairView();
      }
      
      private function updateRepairView() : void
      {
         var _loc1_:SimpleContainer = null;
         var _loc2_:TextFieldElement = null;
         var _loc3_:ButtonElement = null;
         var _loc4_:ButtonElement = null;
         if(this.repairView == null)
         {
            this._repairRequested = false;
            this.repairView = this.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_REPAIR_SHIP);
            this.repairView.alpha = 0;
            _loc1_ = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_REPAIR_SHIP);
            _loc2_ = new TextFieldElement(this.repairView.getWindowDimension().x - 32,int(Styles.simpleFmt.size),new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),Hero.repairInfo.getMessage());
            _loc2_.textField.autoSize = TextFieldAutoSize.CENTER;
            _loc2_.textField.wordWrap = true;
            _loc2_.textField.multiline = true;
            _loc1_.addElement(_loc2_);
            this.repairView.addContainer(_loc1_);
            _loc3_ = new ButtonElement(ButtonElement.TYPE_OK,Hero.repairInfo.getRepairButtonLabel(),ResourceManager.getMovieClip("ui","button1"));
            _loc3_.addEventListener(MouseEvent.CLICK,this.handlePrimeButtonClick);
            _loc4_ = new ButtonElement(ButtonElement.TYPE_CANCEL,BPLocale.getText("btn_hangar"),ResourceManager.getMovieClip("ui","button1"));
            _loc4_.addEventListener(MouseEvent.CLICK,this.handleLeaveButtonClick);
            _loc1_.addElement(_loc3_,SimpleContainer.ALIGN_VERTICAL_CENTER);
            _loc1_.addElement(_loc4_,SimpleContainer.ALIGN_HORIZONTAL);
            _loc3_.y += 8;
            _loc4_.y = _loc3_.y;
            this.combinedWidth = _loc3_.width + _loc4_.width + this.buttonPadding;
            _loc3_.x = (this.repairView.getWindowDimension().x - 32 - this.combinedWidth) * 0.5;
            _loc4_.x = _loc3_.x + _loc3_.width + this.buttonPadding;
            _loc1_.addPredefinedPosition(new Point(15,30));
            _loc1_.setPredefinedPosition();
            this.repairView.addContainer(_loc1_);
            this.repairView.setDimension(this.repairView.getWindowDimension().x,_loc2_.textField.height + 56);
            this.repairView.parent.removeChild(this.repairView);
            this.guiManager.getMain().screenManager.getWindowLayer2().addChild(this.repairView);
            TweenLite.to(this.repairView,0.5,{"alpha":1});
            TweenLite.to(this.msgLabel,0.5,{"alpha":0});
            this.fadeOutUi();
            if(Hero.repairInfo.isRepairPossible())
            {
               this.executePrimeAction = this.requestRepair;
            }
            else
            {
               this.executePrimeAction = this.openPaymentSection;
            }
         }
      }
      
      private function handlePrimeButtonClick(param1:MouseEvent = null) : void
      {
         this.executePrimeAction();
      }
      
      private function openPaymentSection() : void
      {
         var paymentLink:String = null;
         if(ExternalInterface.available)
         {
            paymentLink = Main.gameXML.tradeWindow.weblinks2.link.(@type == "1").@url;
            ExternalInterface.call("referToURL",Settings.dynamicHost + paymentLink);
            TweenMax.delayedCall(1,ExternalInterface.call,["bpCloseWindow"]);
         }
      }
      
      private function requestRepair() : void
      {
         if(!this._repairRequested)
         {
            this.guiManager.getMain().screenManager.zoomIn();
            this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.BUY,["s"]);
            this._repairRequested = true;
         }
      }
      
      private function handleFadeOutUiComplete(param1:MouseEvent = null) : void
      {
         if(this.showDetailsButton != null)
         {
            if(contains(this.showDetailsButton))
            {
               removeChild(this.showDetailsButton);
            }
            this.showDetailsButton.removeEventListener(MouseEvent.CLICK,this.handleShowDetailsButtonClick);
            this.showDetailsButton = null;
         }
         if(this.leaveButton != null)
         {
            if(contains(this.leaveButton))
            {
               removeChild(this.leaveButton);
            }
            this.leaveButton.removeEventListener(MouseEvent.CLICK,this.handleLeaveButtonClick);
            this.leaveButton = null;
         }
      }
      
      private function handleLeaveButtonClick(param1:MouseEvent = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("bpCloseWindow");
         }
         else
         {
            System.exit(0);
         }
      }
      
      private function fadeInUi(param1:MouseEvent = null) : void
      {
         if(!contains(this.showDetailsButton))
         {
            addChild(this.showDetailsButton);
         }
         if(!contains(this.leaveButton))
         {
            addChild(this.leaveButton);
         }
         this.showDetailsButton.alpha = 0;
         TweenLite.to(this.showDetailsButton,0.5,{"alpha":1});
         this.leaveButton.alpha = 0;
         TweenLite.to(this.leaveButton,0.5,{"alpha":1});
      }
      
      private function fadeOutUi(param1:MouseEvent = null) : void
      {
         TweenLite.to(this.showDetailsButton,0.5,{
            "alpha":0,
            "onComplete":this.handleFadeOutUiComplete
         });
         TweenLite.to(this.leaveButton,0.5,{"alpha":0});
      }
      
      public function dispose() : void
      {
         var _loc3_:ButtonElement = null;
         this.handleFadeOutUiComplete();
         if(this.repairView == null)
         {
            this.repairView = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REPAIR_SHIP);
         }
         var _loc1_:SimpleContainer = this.repairView.getContainer(SimpleContainer.CLASS_REPAIR_SHIP);
         var _loc2_:Array = _loc1_.getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.type == ButtonElement.TYPE_CANCEL)
            {
               _loc3_.removeEventListener(MouseEvent.CLICK,this.handlePrimeButtonClick);
            }
            else if(_loc3_.type == ButtonElement.TYPE_OK)
            {
               _loc3_.removeEventListener(MouseEvent.CLICK,this.handleLeaveButtonClick);
            }
         }
         this.guiManager.closeWindow(this.repairView);
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
   }
}


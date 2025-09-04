package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Elastic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.gui.ButtonSlot;
   import net.bigpoint.darkorbit.gui.MenuButton;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MainMenu extends Sprite
   {
      
      private var menuManager:MenuManager;
      
      private var menuSlots:Array = [];
      
      private var poolSlots:Array = [];
      
      private var poolContainer:Sprite = new Sprite();
      
      private var poolSubContainer:Sprite = new Sprite();
      
      private var maxVisiblePoolSlots:int;
      
      private var scrollRightMC:MovieClip;
      
      private var scrollLeftMC:MovieClip;
      
      private var subActionSlot:MovieClip;
      
      private var scrollButtonsLocked:Boolean = false;
      
      private var _menuButtons:Array = [];
      
      private var lastScrollButton:int;
      
      private var dragger:MovieClip;
      
      private var lock:MovieClip;
      
      private var timer:Timer;
      
      private var lastPosition:Point = new Point();
      
      private var _guiLocked:Boolean = true;
      
      private var grid:Sprite;
      
      public function MainMenu(param1:MenuManager)
      {
         super();
         this.menuManager = param1;
      }
      
      public function onMouseUp() : void
      {
         var _loc1_:ConnectionManager = null;
         this.timer.stop();
         this.timer.reset();
         this.stopDrag();
         if(this.lastPosition.x != this.x || this.lastPosition.y != this.y)
         {
            if(this.checkPosition())
            {
               _loc1_ = this.menuManager.getGuiManager().getMain().getConnectionManager();
               _loc1_.sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_MAINMENU_POSITION + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,this.x + ServerCommands.SETTING_PROPERTY_SEPERATOR + this.y]);
               this.lastPosition.x = this.x;
               this.lastPosition.y = this.y;
            }
         }
      }
      
      public function checkPosition() : Boolean
      {
         var _loc1_:int = this.menuManager.getSlotWidth();
         if(this.x + _loc1_ / 2 < 20 || this.x + _loc1_ > ScreenManager.getScreenWidth() || this.y < 0 || this.y + 20 > ScreenManager.getScreenHeight() - 0)
         {
            TweenLite.to(this,0.5,{
               "ease":Elastic.easeOut,
               "x":this.lastPosition.x,
               "y":this.lastPosition.y
            });
            return false;
         }
         return true;
      }
      
      public function init() : void
      {
         var _loc1_:ButtonSlot = null;
         var _loc2_:int = 0;
         var _loc10_:XML = null;
         var _loc11_:ResolutionPattern = null;
         var _loc12_:Point = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc17_:MenuButton = null;
         this.maxVisiblePoolSlots = Main.gameXML.menu.@maxVisiblePoolSlots;
         _loc2_ = 0;
         while(_loc2_ < Main.gameXML.menu.@menuSlots)
         {
            _loc1_ = new ButtonSlot("slot",this.menuManager.getGuiManager());
            _loc1_.getMC().x = this.menuManager.getSlotWidth() / 2 + _loc2_ * this.menuManager.getSlotWidth() + _loc2_ * this.menuManager.getGap();
            this.addChild(_loc1_.getMC());
            this.menuSlots.push(_loc1_);
            _loc2_++;
         }
         var _loc3_:int = int(Main.gameXML.menu.@poolSlots);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == 0)
            {
               _loc1_ = new ButtonSlot("slot",this.menuManager.getGuiManager());
               _loc1_.getMC().x = this.menuManager.getSlotWidth() / 2 + 2;
               _loc1_.getMC().y = this.menuManager.getSlotHeight() * 5 / 3;
               this.subActionSlot = _loc1_.getMC();
               this.subActionSlot.visible = false;
               this.addChild(_loc1_.getMC());
               this.poolSlots.push(_loc1_);
            }
            _loc1_ = new ButtonSlot("slot",this.menuManager.getGuiManager());
            _loc1_.getMC().x = _loc2_ * _loc1_.getMC().width + _loc2_ * this.menuManager.getGap();
            this.poolSubContainer.addChild(_loc1_.getMC());
            this.poolSlots.push(_loc1_);
            _loc2_++;
         }
         this.x = 1;
         this.poolSubContainer.x = -1;
         this.poolContainer.addChild(this.poolSubContainer);
         this.poolContainer.y = this.menuManager.getSlotHeight() / 3 * 2 + this.menuManager.getGap() * 2;
         this.addChild(this.poolContainer);
         this.y = this.menuManager.getSlotHeight() / 3 * 2 + this.menuManager.getGap() * 2;
         var _loc4_:Sprite = new Sprite();
         _loc4_.x = -1;
         _loc4_.y = -2;
         _loc4_.graphics.beginFill(16711680);
         _loc4_.graphics.drawRect(0,0,this.maxVisiblePoolSlots * this.menuManager.getSlotWidth() + this.maxVisiblePoolSlots * this.menuManager.getGap() - 1,this.poolContainer.height + 5);
         this.poolContainer.addChild(_loc4_);
         this.poolContainer.mask = _loc4_;
         var _loc5_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.scrollRightMC = MovieClip(_loc5_.getEmbededMovieClip("scrollRight"));
         this.scrollRightMC.x = this.maxVisiblePoolSlots * (this.menuManager.getSlotWidth() + this.menuManager.getGap()) - this.menuManager.getGap() / 2;
         this.scrollRightMC.y = this.menuManager.getSlotHeight() / 3 * 2 + this.menuManager.getGap() * 2;
         this.scrollRightMC.buttonMode = true;
         this.scrollRightMC.gotoAndStop(1);
         this.addChild(this.scrollRightMC);
         this.scrollRightMC.addEventListener(MouseEvent.CLICK,this.onScroolPoolRight);
         this.scrollRightMC.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownRight);
         this.scrollRightMC.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverRightScrollButton);
         this.scrollRightMC.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutRightScrollButton);
         this.scrollLeftMC = MovieClip(_loc5_.getEmbededMovieClip("scrollLeft"));
         this.scrollLeftMC.x = -this.menuManager.getGap();
         this.scrollLeftMC.y = this.menuManager.getSlotHeight() / 3 * 2 + this.menuManager.getGap() * 2;
         this.scrollLeftMC.buttonMode = true;
         this.scrollLeftMC.gotoAndStop(1);
         this.addChild(this.scrollLeftMC);
         this.scrollLeftMC.addEventListener(MouseEvent.CLICK,this.onScroolPoolLeft);
         this.scrollLeftMC.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownLeft);
         this.scrollLeftMC.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverLeftScrollButton);
         this.scrollLeftMC.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutLeftScrollButton);
         this.setPoolSlotVisibility(false);
         var _loc6_:int = 0;
         var _loc7_:String = Main.gameXML.menu.menuButtons.@stdIcon;
         var _loc8_:String = Main.gameXML.menu.menuButtons.@hoverIcon;
         var _loc9_:String = Main.gameXML.menu.menuButtons.@selectedIcon;
         for each(_loc10_ in Main.gameXML.menu.menuButtons.menuButton)
         {
            _loc13_ = int(_loc10_.@id);
            _loc14_ = String(_loc10_.@resKey);
            _loc15_ = null;
            _loc16_ = Main.parseBooleanFromString(_loc10_.@subAction);
            if(_loc10_.@languageKey.length() > 0)
            {
               _loc15_ = String(_loc10_.@languageKey);
            }
            _loc17_ = new MenuButton(_loc13_,_loc14_,_loc16_,_loc7_,_loc8_,_loc9_,this,_loc15_);
            this._menuButtons[_loc13_] = _loc17_;
            _loc1_ = this.menuSlots[_loc6_];
            _loc1_.addMenu(_loc17_);
            _loc6_++;
         }
         this.dragger = MovieClip(_loc5_.getEmbededMovieClip("dragger"));
         this.dragger.x = -7;
         this.dragger.x += this.menuManager.getSlotWidth() / 2;
         this.dragger.y = -14;
         this.dragger.buttonMode = true;
         this.dragger.gotoAndStop(1);
         this.dragger.addEventListener(MouseEvent.MOUSE_DOWN,this.onMenuDragger);
         this.dragger.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverDragger);
         this.dragger.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutDragger);
         this.addChild(this.dragger);
         this.dragger.visible = false;
         this.lock = MovieClip(_loc5_.getEmbededMovieClip("lock"));
         this.lock.buttonMode = true;
         this.lock.gotoAndStop(1);
         this.lock.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuickMenuLock);
         this.lock.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverLock);
         this.lock.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutLock);
         this.lock.x = -3;
         this.lock.y = 8;
         this.addChild(this.lock);
         _loc11_ = PatternManager.resolutionPatterns[Settings.resolutionID];
         _loc12_ = _loc11_.getMainMenuPosition();
         if(_loc12_ != null)
         {
            this.x = _loc12_.x;
            this.y = _loc12_.y;
         }
         this.menuManager.updateAmmunitionDisplay();
         this.timer = new Timer(250,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
      
      private function onMouseOverRightScrollButton(param1:MouseEvent) : void
      {
         this.scrollRightMC.gotoAndStop(2);
      }
      
      private function onMouseOutRightScrollButton(param1:MouseEvent) : void
      {
         this.scrollRightMC.gotoAndStop(1);
      }
      
      private function onMouseOverLeftScrollButton(param1:MouseEvent) : void
      {
         this.scrollLeftMC.gotoAndStop(2);
      }
      
      private function onMouseOutLeftScrollButton(param1:MouseEvent) : void
      {
         this.scrollLeftMC.gotoAndStop(1);
      }
      
      private function onMouseOverDragger(param1:MouseEvent) : void
      {
         this.dragger.gotoAndStop(2);
      }
      
      private function onMouseOutDragger(param1:MouseEvent) : void
      {
         this.dragger.gotoAndStop(1);
      }
      
      public function setPoolSlotVisibility(param1:Boolean) : void
      {
         if(param1)
         {
            this.poolSubContainer.x = 0;
         }
         this.poolContainer.visible = param1;
         this.updateScrollButtons();
         this.menuManager.updateSelectableButtons();
         this.menuManager.updateAllButtonAmounts();
      }
      
      public function updateScrollButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ButtonSlot = null;
         var _loc3_:MenuButton = null;
         if(!this.poolContainer.visible)
         {
            this.scrollRightMC.visible = false;
            this.scrollLeftMC.visible = false;
         }
         else
         {
            this.scrollRightMC.visible = true;
            this.scrollLeftMC.visible = true;
            if(this.poolSubContainer.x < 0)
            {
               this.scrollLeftMC.visible = true;
            }
            else
            {
               this.scrollLeftMC.visible = false;
            }
            _loc1_ = 0;
            for each(_loc2_ in this.poolSlots)
            {
               if(_loc2_.isAllocated())
               {
                  _loc1_++;
                  _loc2_.getMC().visible = true;
               }
               else
               {
                  _loc2_.getMC().visible = false;
               }
            }
            for each(_loc3_ in this._menuButtons)
            {
               if(_loc3_.isPreselected() && _loc3_.hasSubAction())
               {
                  _loc1_--;
                  break;
               }
            }
            if(_loc1_ * this.menuManager.getSlotWidth() + this.menuManager.getGap() + this.poolSubContainer.x > this.maxVisiblePoolSlots * (this.menuManager.getSlotWidth() + this.menuManager.getGap()))
            {
               this.scrollRightMC.visible = true;
            }
            else
            {
               this.scrollRightMC.visible = false;
            }
         }
         this.scrollButtonsLocked = false;
         this.menuManager.updateSelectableButtons();
      }
      
      private function onScroolPoolLeft(param1:MouseEvent) : void
      {
         if(this.scrollButtonsLocked)
         {
            return;
         }
         this.scrollButtonsLocked = true;
         TweenLite.to(this.poolSubContainer,0.25,{
            "ease":Cubic.easeOut,
            "x":this.poolSubContainer.x + this.menuManager.getSlotWidth() + this.menuManager.getGap(),
            "onComplete":this.updateScrollButtons
         });
      }
      
      private function onScroolPoolRight(param1:MouseEvent) : void
      {
         if(this.scrollButtonsLocked)
         {
            return;
         }
         this.scrollButtonsLocked = true;
         TweenLite.to(this.poolSubContainer,0.25,{
            "ease":Cubic.easeOut,
            "x":this.poolSubContainer.x - this.menuManager.getSlotWidth() - this.menuManager.getGap(),
            "onComplete":this.updateScrollButtons
         });
      }
      
      private function onMenuDragger(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function getVisibleCountGap() : int
      {
         var _loc2_:MenuButton = null;
         var _loc1_:int = 1;
         for each(_loc2_ in this._menuButtons)
         {
            if(_loc2_.isPreselected() && _loc2_.hasSubAction())
            {
               _loc1_--;
               break;
            }
         }
         return _loc1_ * this.menuManager.getSlotWidth() + this.menuManager.getGap() + this.poolSubContainer.x;
      }
      
      private function onMouseDownRight(param1:MouseEvent) : void
      {
         this.lastScrollButton = 1;
         this.timer.start();
      }
      
      private function onMouseDownLeft(param1:MouseEvent) : void
      {
         this.lastScrollButton = 0;
         this.timer.start();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(this.lastScrollButton == 0)
         {
            if(this.scrollLeftMC.visible)
            {
               this.onScroolPoolLeft(null);
            }
         }
         else if(this.lastScrollButton == 1)
         {
            if(this.scrollRightMC.visible)
            {
               this.onScroolPoolRight(null);
            }
         }
      }
      
      public function showMenuDragger() : void
      {
         this.dragger.visible = true;
      }
      
      public function hideMenuDragger() : void
      {
         this.dragger.visible = false;
      }
      
      public function getMenuButton(param1:int) : MenuButton
      {
         return this._menuButtons[param1];
      }
      
      public function getTimer() : Timer
      {
         return this.timer;
      }
      
      public function getPoolSlots() : Array
      {
         return this.poolSlots;
      }
      
      public function getSubActionSlot() : MovieClip
      {
         return this.subActionSlot;
      }
      
      public function getMenuManager() : MenuManager
      {
         return this.menuManager;
      }
      
      public function getMenuButtons() : Array
      {
         return this._menuButtons;
      }
      
      private function onMouseOverLock(param1:MouseEvent) : void
      {
         if(this._guiLocked)
         {
            this.lock.gotoAndStop(2);
         }
         else
         {
            this.lock.gotoAndStop(4);
         }
      }
      
      private function onMouseOutLock(param1:MouseEvent) : void
      {
         if(this._guiLocked)
         {
            this.lock.gotoAndStop(1);
         }
         else
         {
            this.lock.gotoAndStop(3);
         }
      }
      
      private function onQuickMenuLock(param1:MouseEvent) : void
      {
         if(this._guiLocked)
         {
            this._guiLocked = false;
            this.lock.gotoAndStop(4);
            this.menuManager.getMainMenu().showMenuDragger();
            this.menuManager.getQuickMenu().showMenuDragger();
            this.menuManager.getQuickMenu().showSlots();
            this.menuManager.addOnMouseUpListeners();
            this.createGrid();
         }
         else if(!this._guiLocked)
         {
            this._guiLocked = true;
            this.lock.gotoAndStop(2);
            this.menuManager.getMainMenu().hideMenuDragger();
            this.menuManager.getQuickMenu().hideMenuDragger();
            this.menuManager.getQuickMenu().hideSlots();
            this.menuManager.removeOnMouseUpListeners();
            this.removeGrid();
         }
      }
      
      private function createGrid() : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = 1;
         if(this.grid == null)
         {
            this.grid = new Sprite();
            this.grid.graphics.lineStyle(_loc1_,16777215);
            _loc5_ = 0;
            while(_loc5_ < ScreenManager.getScreenHeight() / Settings.gridSize)
            {
               this.grid.graphics.moveTo(0,_loc5_ * Settings.gridSize);
               this.grid.graphics.lineTo(2000,_loc5_ * Settings.gridSize);
               _loc5_++;
            }
            _loc6_ = 0;
            while(_loc6_ < ScreenManager.getScreenWidth() / Settings.gridSize)
            {
               this.grid.graphics.moveTo(_loc6_ * Settings.gridSize,0);
               this.grid.graphics.lineTo(_loc6_ * Settings.gridSize,2000);
               _loc6_++;
            }
            this.grid.mouseEnabled = false;
            this.grid.mouseChildren = false;
         }
         var _loc2_:Sprite = ScreenManager.getWindowLayer();
         this.grid.alpha = 0;
         _loc2_.addChildAt(this.grid,0);
         TweenLite.to(this.grid,0.5,{"alpha":0.3});
         var _loc3_:Array = this.menuManager.getGuiManager().getWindows();
         for each(_loc4_ in _loc3_)
         {
            _loc4_.createFullDragger();
         }
      }
      
      private function removeGrid() : void
      {
         var _loc2_:SimpleWindow = null;
         if(this.grid != null)
         {
            TweenLite.to(this.grid,0.25,{
               "alpha":0,
               "onComplete":this.grid.parent.removeChild,
               "onCompleteParams":[this.grid]
            });
         }
         var _loc1_:Array = this.menuManager.getGuiManager().getWindows();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.removeFullDragger();
         }
      }
      
      public function get guiLocked() : Boolean
      {
         return this._guiLocked;
      }
      
      public function set guiLocked(param1:Boolean) : void
      {
         this._guiLocked = param1;
      }
   }
}


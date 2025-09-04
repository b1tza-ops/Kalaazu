package net.bigpoint.darkorbit.gui.windows
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Expo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SimpleWindow extends MovieClip
   {
      
      public static const ZOOM_IN:String = "SimpleWindow.zoomIn";
      
      public static const ZOOM_OUT:String = "SimpleWindow.zoomOut";
      
      public static const ON_CLOSE:String = "SimpleWindow.onClose";
      
      public static const ON_RESIZE:String = "SimpleWindow.onResize";
      
      public static const ON_RESIZED:String = "SimpleWindow.onResized";
      
      public static const ON_MOVE:String = "SimpleWindow.onMove";
      
      public static const ON_MAXIMIZED:String = "SimpleWindow.onMaximized";
      
      public static const ON_MINIMIZED:String = "SimpleWindow.onMinimized";
      
      public static const ON_MINIMIZE:String = "SimpleWindow.onMinimize";
      
      public static const ON_MAXIMIZE_CLICKED:String = "SimpleWindow.onMaximizeClicked";
      
      public static const ON_MINIMIZE_CLICKED:String = "SimpleWindow.onMinimizeClicked";
      
      public static var POSITION_CENTER:int = 0;
      
      public static var POSITION_CENTER_HORIZONTAL:int = 1;
      
      public static var NO_ALIGN:int = 0;
      
      public static var ALIGN_VERTICAL:int = 1;
      
      public static var ALIGN_HORIZONTAL:int = 2;
      
      public static const WINDOW_CLASS_USER:int = 0;
      
      public static const WINDOW_CLASS_SHIP:int = 1;
      
      public static const WINDOW_CLASS_MINIMAP:int = 3;
      
      public static const WINDOW_CLASS_SETTINGS:int = 4;
      
      public static const WINDOW_CLASS_LOG:int = 5;
      
      public static const WINDOW_CLASS_TRADE:int = 6;
      
      public static const WINDOW_CLASS_LOGOUT:int = 7;
      
      public static const WINDOW_CLASS_CONNECTION:int = 8;
      
      public static const WINDOW_CLASS_BETA:int = 9;
      
      public static const WINDOW_CLASS_QUEST_SYSTEM:int = 10;
      
      public static const WINDOW_CLASS_HELP:int = 11;
      
      public static const WINDOW_CLASS_CONNECTION_LOST:int = 12;
      
      public static const WINDOW_CLASS_SPACEMAP:int = 13;
      
      public static const WINDOW_CLASS_HERO_DESTROYED:int = 14;
      
      public static const WINDOW_CLASS_BOOSTER:int = 15;
      
      public static const WINDOW_CLASS_SPACEBALL:int = 16;
      
      public static const WINDOW_CLASS_INVASION:int = 17;
      
      public static const WINDOW_CLASS_CTB:int = 18;
      
      public static const WINDOW_CLASS_TDM:int = 19;
      
      public static const WINDOW_CLASS_CHAT:int = 20;
      
      public static const WINDOW_CLASS_WARNING_PROMPT:int = 21;
      
      public static const WINDOW_CLASS_COMMAND_LINE:int = 22;
      
      public static const WINDOW_CLASS_GROUP_SYSTEM:int = 23;
      
      public static const WINDOW_CLASS_REFINEMENT:int = 24;
      
      public static const WINDOW_CLASS_REFINEMENT_UPDATE:int = 25;
      
      public static const WINDOW_CLASS_REFINEMENT_COUNT:int = 26;
      
      public static const WINDOW_CLASS_REFINEMENT_REFINE:int = 27;
      
      public static const WINDOW_CLASS_RESET_PROMPT:int = 28;
      
      public static const WINDOW_CLASS_SESSION_END:int = 29;
      
      public static const WINDOW_CLASS_REPAIR_SHIP:int = 30;
      
      public static const WINDOW_CLASS_AUTOSTART_WARNING:int = 31;
      
      public static const WINDOW_CLASS_ACHIEVMENT:int = 32;
      
      public static const WINDOW_CLASS_TECHS:int = 33;
      
      public static const WINDOW_CLASS_JACKPOTBATTLE:int = 34;
      
      public static const WINDOW_CLASS_NETWORK_MONITOR:int = 35;
      
      public static const WINDOW_CLASS_PET:int = 36;
      
      public static const WINDOW_CLASS_RANKED_HUNT_EVENT:int = 37;
      
      public static var SLOT_TYPE_NO_SLOT:int = 0;
      
      public static var SLOT_TYPE_STATIC:int = 1;
      
      public static var SLOT_TYPE_DYNAMIC_LEFT:int = 2;
      
      public static var SLOT_TYPE_DYNAMIC_RIGHT:int = 3;
      
      public static var WINDOW_TYPE_NORMAL:int = 0;
      
      public static var WINDOW_TYPE_WARNING:int = 1;
      
      private var windowContainer:MovieClip;
      
      private var window:MovieClip;
      
      public var resizementBounds:Rectangle;
      
      public var resizer:MovieClip;
      
      private var dragger:MovieClip;
      
      private var minimizeClicked:Boolean = false;
      
      private var closeButton:MovieClip;
      
      private var directionArrowTimer:Timer;
      
      private var directionArrow:MovieClip;
      
      private var zoominButton:MovieClip;
      
      private var zoomoutButton:MovieClip;
      
      private var closeBtnInitDistance:Number;
      
      private var zoominBtnInitDistance:Number;
      
      private var zoomoutBtnInitDistance:Number;
      
      private var minimizeButton:MovieClip;
      
      public var label:TextField;
      
      private var flashWindowCount:int;
      
      private var showCloseButton:Boolean;
      
      private var showLabel:Boolean = true;
      
      private var draggable:Boolean;
      
      private var resizable:Boolean;
      
      private var zoomable:Boolean;
      
      private var _modal:Boolean;
      
      private var fullDragger:Sprite;
      
      private var maximizeClicked:Boolean;
      
      private var displayDigits:Boolean;
      
      private var lastResizerPosition:Point;
      
      protected var guiManager:GuiManager;
      
      protected var dimensions:Array;
      
      private var containers:Array;
      
      private var oldResizerX:Number;
      
      private var oldResizerY:Number;
      
      private var blocker:Sprite;
      
      private var lastPosition:Point;
      
      private var minimizeIcon:MovieClip;
      
      private var minimizedWindowCount:int;
      
      private var _tweening:Boolean;
      
      public var classID:int;
      
      private var rootContainerMask:Sprite;
      
      private var rootContainer:MovieClip;
      
      private var icon:Bitmap;
      
      private var windowMask:MovieClip;
      
      private var slot:Bitmap;
      
      private var normalIcon:Bitmap;
      
      private var alwaysAtTop:Boolean;
      
      private var hoverIcon:Bitmap;
      
      private var selectedIcon:BitmapClip;
      
      private var actionDeactivated:Bitmap;
      
      private var maximizeOnClick:Boolean;
      
      private var minimizeOnClick:Boolean;
      
      private var slotType:int;
      
      private var windowType:int;
      
      private var saveSettings:Boolean;
      
      public var maxWindowWidth:int = 750;
      
      public var maxWindowHeight:int = 750;
      
      public var minWindowHeight:int = 100;
      
      public var shortcut:String;
      
      private var supportTransparency:Boolean;
      
      private var overlay:Sprite;
      
      public function SimpleWindow(param1:GuiManager, param2:int, param3:SWFFinisher, param4:Boolean = true, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false, param8:Boolean = true, param9:Boolean = true, param10:int = 0, param11:Boolean = false, param12:String = "comb02_std.png", param13:String = "comb02_hover.png", param14:int = 0, param15:Boolean = false, param16:String = null, param17:Boolean = false)
      {
         var _loc19_:MovieClip = null;
         this.dimensions = [];
         this.containers = [];
         this.rootContainer = new MovieClip();
         super();
         this.cacheAsBitmap = true;
         this.guiManager = param1;
         this.classID = param2;
         this.slotType = param10;
         this.maximizeOnClick = param8;
         this.minimizeOnClick = param9;
         this.windowType = param14;
         this.saveSettings = param15;
         this.shortcut = param16;
         this.supportTransparency = param17;
         this.lastResizerPosition = new Point();
         this.lastPosition = new Point();
         this.alwaysAtTop = param11;
         if(param1.isWindowBlacklisted(param2))
         {
            this.visible = false;
         }
         var _loc18_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.slot = _loc18_.getEmbededBitmap("slot");
         this.normalIcon = _loc18_.getEmbededBitmap(param12);
         this.hoverIcon = _loc18_.getEmbededBitmap(param13);
         this.actionDeactivated = _loc18_.getEmbededBitmap("comb00_deactivated.png");
         this.selectedIcon = new BitmapClip(_loc18_.getEmbededMovieClip("windowFlashIcon"),"windowFlashIcon");
         this.selectedIcon.gotoAndStop(2);
         this.selectedIcon.x = -3;
         this.selectedIcon.y = -4;
         this.slot.x = -3;
         this.slot.y = -4;
         this.normalIcon.x = -3;
         this.normalIcon.y = -4;
         this.hoverIcon.x = -3;
         this.hoverIcon.y = -4;
         this.actionDeactivated.x = -3;
         this.actionDeactivated.y = -4;
         this.addChild(this.rootContainer);
         if(!(param6 && param4))
         {
            if(param6 && !param4)
            {
               this.windowContainer = MovieClip(param3.getEmbededMovieClip("windowContainer5"));
            }
            else if(param7 && !param4)
            {
               this.windowContainer = MovieClip(param3.getEmbededMovieClip("windowContainer3"));
            }
            else if(param4)
            {
               this.windowContainer = MovieClip(param3.getEmbededMovieClip("windowContainer2"));
            }
            else if(!param4)
            {
               this.windowContainer = MovieClip(param3.getEmbededMovieClip("windowContainer1"));
            }
         }
         this.windowContainer.addEventListener(MouseEvent.CLICK,this.handleWindowToFront);
         if(!Settings.showWindowsBackground && param17)
         {
            this.windowContainer.alpha = 0;
         }
         _loc19_ = this.windowContainer["windowMaskContainer"];
         _loc19_.mouseEnabled = false;
         _loc19_.cacheAsBitmap = true;
         this.windowMask = _loc19_["windowMask"];
         this.windowMask.mouseEnabled = false;
         var _loc20_:MovieClip = this.windowContainer["pattern"];
         _loc20_.mouseEnabled = false;
         _loc20_.cacheAsBitmap = true;
         _loc20_.mask = _loc19_;
         this.showCloseButton = param7;
         this.showLabel = this.showLabel;
         if(this._modal)
         {
            this.draggable = false;
         }
         else
         {
            this.draggable = param5;
         }
         this._modal = this._modal;
         if(param6)
         {
            param4 = false;
         }
         else
         {
            this.resizable = param4;
         }
         this.zoomable = param6;
         this.init();
         this.rootContainerMask = new Sprite();
         this.rootContainerMask.graphics.beginFill(16711680);
         this.rootContainerMask.graphics.drawRect(0,0,100,100);
         this.rootContainer.addChild(this.rootContainerMask);
         this.rootContainer.mask = this.rootContainerMask;
         var _loc21_:int = ScreenManager.getScreenWidth();
         if(this.maxWindowWidth > _loc21_)
         {
            this.maxWindowWidth = _loc21_ - 100;
         }
         var _loc22_:int = ScreenManager.getScreenHeight();
         if(this.maxWindowHeight > _loc22_)
         {
            this.maxWindowHeight = _loc22_ - 100;
         }
      }
      
      public function addLockOverlay(param1:int, param2:int, param3:int, param4:int, param5:uint = 4473924, param6:Number = 0.3) : void
      {
         this.lockWindow();
         if(this.overlay == null)
         {
            this.overlay = new Sprite();
            this.overlay.graphics.beginFill(param5,param6);
            this.overlay.graphics.drawRect(param1,param2,param3,param4);
            this.overlay.graphics.endFill();
            this.overlay.buttonMode = true;
            this.overlay.useHandCursor = true;
            this.addChild(this.overlay);
         }
      }
      
      public function removeLockOverlay() : void
      {
         if(this.overlay != null)
         {
            this.removeChild(this.overlay);
            this.overlay = null;
         }
         this.unlockWindow();
      }
      
      private function snapToGrid() : void
      {
         this.x = Math.floor(this.x / Settings.gridSize) * Settings.gridSize;
         this.y = Math.floor(this.y / Settings.gridSize) * Settings.gridSize;
      }
      
      private function handleWindowToFront(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(this.parent);
         _loc2_.swapChildren(this,_loc2_.getChildAt(_loc2_.numChildren - 1));
      }
      
      public function flashWindowIcon(param1:int = -1, param2:Boolean = false) : void
      {
         this.flashWindowCount = param1;
         TweenMax.killTweensOf(this.selectedIcon);
         this.selectedIcon.alpha = 0;
         this.selectedIcon.visible = true;
         TweenLite.to(this.selectedIcon,0.25,{
            "alpha":1,
            "onComplete":this.endFlash,
            "onCompleteParams":[this.selectedIcon,param2]
         });
      }
      
      public function startPointer() : void
      {
         this.stopPointer();
         this.directionArrow = ResourceManager.getMovieClip("ui","windowArrow");
         this.directionArrow.mouseEnabled = false;
         this.directionArrow.mouseChildren = false;
         this.directionArrow.x = this.getDynamicXPos();
         this.directionArrow.y = this.getDynamicYPos();
         this.directionArrow.scaleX = 0.7;
         this.directionArrow.scaleY = 0.7;
         this.directionArrow.rotation = -90;
         this.directionArrow.alpha = 0;
         this.updateArrowRotation(null);
         TweenLite.to(this.directionArrow,0.5,{"alpha":1});
         this.stage.addChild(this.directionArrow);
         this.handleWindowPointer1(this.directionArrow);
         this.directionArrowTimer = new Timer(40,0);
         this.directionArrowTimer.addEventListener(TimerEvent.TIMER,this.updateArrowRotation);
         this.directionArrowTimer.start();
      }
      
      private function getDynamicXPos() : int
      {
         var _loc1_:Point = this.localToGlobal(new Point(this.stage.x,this.stage.y));
         _loc1_.x += 14;
         return _loc1_.x;
      }
      
      private function getDynamicYPos() : int
      {
         var _loc1_:Point = this.localToGlobal(new Point(this.stage.x,this.stage.y));
         _loc1_.y += 14;
         return _loc1_.y;
      }
      
      public function stopPointer() : void
      {
         if(this.directionArrow != null)
         {
            TweenMax.killTweensOf(this.directionArrow);
            if(this.stage.contains(this.directionArrow))
            {
               TweenLite.to(this.directionArrow,0.5,{
                  "alpha":0,
                  "onComplete":this.directionArrow.parent.removeChild,
                  "onCompleteParams":[this.directionArrow]
               });
            }
         }
         if(this.directionArrowTimer != null)
         {
            this.directionArrowTimer.stop();
            this.directionArrowTimer.removeEventListener(TimerEvent.TIMER,this.updateArrowRotation);
         }
      }
      
      private function handleWindowPointer1(param1:MovieClip) : void
      {
         TweenLite.to(param1,0.5,{
            "x":this.getDynamicXPos(),
            "y":this.getDynamicYPos(),
            "onComplete":this.handleWindowPointer2,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleWindowPointer2(param1:MovieClip) : void
      {
         var _loc2_:int = int(40 * Math.cos(param1.rotation * Math.PI / 180));
         var _loc3_:int = int(40 * Math.sin(param1.rotation * Math.PI / 180));
         TweenLite.to(param1,0.5,{
            "x":this.getDynamicXPos() + _loc2_,
            "y":this.getDynamicYPos() + _loc3_,
            "onComplete":this.handleWindowPointer1,
            "onCompleteParams":[param1]
         });
      }
      
      private function updateArrowRotation(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Number = int(Math.atan2(this.y - ScreenManager.getHalfScreenHeight(),this.x - ScreenManager.getHalfScreenWidth()) * 180 / Math.PI);
         if(_loc2_ != 0)
         {
            _loc3_ = Math.round(_loc2_ + 180);
            this.directionArrow.rotation = _loc3_;
         }
      }
      
      public function endFlash(param1:DisplayObject, param2:Boolean) : void
      {
         TweenLite.to(param1,0.25,{
            "alpha":0,
            "onComplete":this.setBitmapInvisible,
            "onCompleteParams":[param1,param2]
         });
      }
      
      public function stopFlashWindowIcon() : void
      {
         this.flashWindowCount = 0;
         this.stopPointer();
      }
      
      protected function setBitmapInvisible(param1:DisplayObject, param2:Boolean) : void
      {
         param1.visible = false;
         if(this.flashWindowCount == -1)
         {
            this.flashWindowIcon(this.flashWindowCount,param2);
         }
         else
         {
            --this.flashWindowCount;
            if(this.flashWindowCount > 0)
            {
               this.flashWindowIcon(this.flashWindowCount,param2);
            }
            else
            {
               this.stopPointer();
            }
         }
      }
      
      public function checkPosition() : Boolean
      {
         var _loc1_:int = 80;
         if(this.x + _loc1_ < 0 || this.x + _loc1_ > ScreenManager.getScreenWidth() || this.y < -40 || this.y + 20 > ScreenManager.getScreenHeight() - 0)
         {
            this.resetPosition();
            return false;
         }
         return true;
      }
      
      public function setIcon(param1:Bitmap) : void
      {
         this.minimizeIcon = new MovieClip();
         this.slot.visible = false;
         this.normalIcon.visible = false;
         this.minimizeIcon.addChild(this.slot);
         this.minimizeIcon.addChild(this.normalIcon);
         this.hoverIcon.visible = false;
         this.minimizeIcon.addChild(this.hoverIcon);
         this.selectedIcon.visible = false;
         this.minimizeIcon.addChild(this.selectedIcon);
         this.actionDeactivated.visible = false;
         this.icon = param1;
         param1.x = 2;
         param1.y = 2;
         this.minimizeIcon.addChild(param1);
         if(!this._modal)
         {
            if(this.slotType != SLOT_TYPE_NO_SLOT)
            {
               this.minimizeIcon.addEventListener(MouseEvent.CLICK,this.toggleVisibility);
               this.minimizeIcon.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownIcon);
               this.minimizeIcon.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
               this.minimizeIcon.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
               this.minimizeIcon.buttonMode = true;
               if(!Settings.showWindowsBackground && this.supportTransparency)
               {
                  this.minimizeIcon.alpha = 0;
               }
            }
         }
         this.addChild(this.minimizeIcon);
         this.minimizeIcon.addChild(this.actionDeactivated);
      }
      
      public function setListeners() : void
      {
         this.setDraggerListeners();
         this.setResizerListeners();
         this.setZoomButtonListeners();
      }
      
      public function removeListeners() : void
      {
         this.removeDraggerTransparencyListeners();
         this.removeResizerTransparencyListeners();
         this.removeZoomButtonTransparencyListeners();
      }
      
      private function setDraggerListeners() : void
      {
         this.dragger.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverDragger);
         this.dragger.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutDragger);
      }
      
      private function setResizerListeners() : void
      {
         this.resizer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverResizer);
         this.resizer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutResizer);
      }
      
      private function setZoomButtonListeners() : void
      {
         this.zoominButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
         this.zoominButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
         this.zoomoutButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
         this.zoomoutButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
      }
      
      private function removeDraggerTransparencyListeners() : void
      {
         this.dragger.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverDragger);
         this.dragger.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutDragger);
      }
      
      private function removeResizerTransparencyListeners() : void
      {
         this.resizer.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverResizer);
         this.resizer.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutResizer);
      }
      
      private function removeZoomButtonTransparencyListeners() : void
      {
         this.zoominButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
         this.zoominButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
         this.zoomoutButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
         this.zoomoutButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
      }
      
      private function handleMouseOverMinimizeIcon(param1:MouseEvent) : void
      {
         if(!Settings.showWindowsBackground && this.supportTransparency)
         {
            this.fadeInWindow();
         }
         if(this.classID == SimpleWindow.WINDOW_CLASS_HELP)
         {
            TooltipControl.getInstance().toggleStickyToolTips();
         }
         if(this.isMaximized())
         {
            return;
         }
         this.hoverIcon.visible = true;
         TweenLite.to(this.hoverIcon,0.5,{"alpha":1});
      }
      
      public function fadeOutWindow() : void
      {
         if(this.supportTransparency && this.isMaximized())
         {
            TweenLite.to(this.windowContainer,0.25,{"alpha":0});
            TweenLite.to(this.minimizeIcon,0.25,{"alpha":0});
         }
      }
      
      public function fadeInWindow() : void
      {
         if(this.supportTransparency && this.isMaximized())
         {
            this.windowContainer.visible = true;
            TweenLite.to(this.windowContainer,0.25,{"alpha":Settings.maxWindowsTransparency});
            TweenLite.to(this.minimizeIcon,0.25,{"alpha":Settings.maxWindowsTransparency});
         }
      }
      
      private function handleMouseOutMinimizeIcon(param1:MouseEvent) : void
      {
         if(!Settings.showWindowsBackground && this.supportTransparency)
         {
            TweenLite.to(this.windowContainer,0.25,{"alpha":0});
            if(this.isMaximized() && !this.minimizeClicked)
            {
               TweenLite.to(this.minimizeIcon,0.25,{"alpha":0});
            }
         }
         if(this.classID == SimpleWindow.WINDOW_CLASS_HELP)
         {
            TooltipControl.getInstance().toggleStickyToolTips();
         }
         TweenLite.to(this.hoverIcon,0.5,{
            "alpha":0,
            "onComplete":this.setInvisible,
            "onCompleteParams":[this.hoverIcon]
         });
      }
      
      protected function setInvisible(param1:Bitmap) : void
      {
         if(TweenMax.isTweening(param1))
         {
            return;
         }
         param1.visible = false;
      }
      
      public function toggleVisibility(param1:MouseEvent) : void
      {
         var request:URLRequest = null;
         var evt:MouseEvent = param1;
         if(this.classID == SimpleWindow.WINDOW_CLASS_HELP)
         {
            request = new URLRequest(Main.helpLink);
            try
            {
               navigateToURL(request,"_blank");
            }
            catch(e:Error)
            {
            }
            return;
         }
         if(this.actionDeactivated.visible)
         {
            return;
         }
         if(TweenMax.isTweening(this.rootContainer) || TweenMax.isTweening(this.rootContainerMask))
         {
            return;
         }
         if(this.rootContainer.visible)
         {
            this.maximizeClicked = false;
            if(this.minimizeOnClick)
            {
               this.minimize();
               this.saveWindowSetting(false);
            }
            dispatchEvent(new Event(SimpleWindow.ON_MINIMIZE_CLICKED));
         }
         else
         {
            this.maximizeClicked = true;
            if(this.maximizeOnClick)
            {
               this.maximize();
               this.saveWindowSetting(true);
            }
            dispatchEvent(new Event(SimpleWindow.ON_MAXIMIZE_CLICKED));
         }
      }
      
      public function saveWindowSetting(param1:Boolean = false) : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:String = null;
         if(!this.saveSettings)
         {
            return;
         }
         var _loc2_:Array = this.guiManager.getWindows();
         var _loc3_:String = "";
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.isSaveSettings())
            {
               _loc5_ = "0";
               if(_loc4_ != this)
               {
                  if(_loc4_.isMaximized())
                  {
                     _loc5_ = "1";
                  }
               }
               else if(param1)
               {
                  _loc5_ = "1";
               }
               _loc3_ += _loc4_.classID + ServerCommands.SETTING_PROPERTY_SEPERATOR + _loc4_.lastPosition.x + ServerCommands.SETTING_PROPERTY_SEPERATOR + _loc4_.lastPosition.y + ServerCommands.SETTING_PROPERTY_SEPERATOR + _loc5_ + ServerCommands.SETTING_PROPERTY_SEPERATOR;
            }
         }
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.WINDOW_SETTINGS + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,Main.removeCommaAtEnd(_loc3_)]);
      }
      
      public function isMaximized() : Boolean
      {
         if(this.rootContainer.visible)
         {
            return true;
         }
         return false;
      }
      
      public function minimize(param1:Boolean = true) : void
      {
         this.minimizeClicked = true;
         this._tweening = true;
         this.maximizeClicked = false;
         parent.removeChild(this);
         this.guiManager.getMain().screenManager.getIconLayer().addChild(this);
         dispatchEvent(new Event(SimpleWindow.ON_MINIMIZE));
         this.lastPosition.x = this.x;
         this.lastPosition.y = this.y;
         if(this.slotType == SLOT_TYPE_DYNAMIC_LEFT)
         {
            this.minimizedWindowCount = this.guiManager.getMinimizedWindowCount();
            this.guiManager.increaseMinimizedWindowCount();
            this.guiManager.addToLeftDynamicSlot(this.classID);
         }
         if(param1)
         {
            TweenLite.to(this.rootContainerMask,0.25,{
               "ease":Expo.easeOut,
               "height":25,
               "onComplete":this.onMinimizedVertical
            });
            this.slot.alpha = 0;
            this.slot.visible = true;
            TweenLite.to(this.slot,0.25,{"alpha":1});
            this.normalIcon.alpha = 0;
            this.normalIcon.visible = true;
            TweenLite.to(this.normalIcon,0.25,{"alpha":1});
         }
         else
         {
            this.slot.visible = true;
            this.normalIcon.visible = true;
            this.onMinimized(this.rootContainer,false);
         }
      }
      
      private function onMinimizedVertical() : void
      {
         TweenLite.to(this.rootContainerMask,0.25,{
            "ease":Expo.easeOut,
            "width":0,
            "onComplete":this.onMinimized,
            "onCompleteParams":[this.rootContainer,true]
         });
         TweenLite.to(this.rootContainer,0.25,{"alpha":0});
      }
      
      private function onMinimized(param1:MovieClip, param2:Boolean = true) : void
      {
         var _loc3_:Point = null;
         this.minimizeClicked = false;
         if(!Settings.showWindowsBackground && this.supportTransparency)
         {
            this.minimizeIcon.alpha = Settings.maxWindowsTransparency;
         }
         param1.visible = false;
         if(this.slotType == SLOT_TYPE_STATIC)
         {
            _loc3_ = this.guiManager.getTopMenu().getStaticButtonsSlotPosition(this.classID);
            if(param2)
            {
               TweenLite.to(this,0.5,{
                  "ease":Expo.easeOut,
                  "x":_loc3_.x
               });
               TweenLite.to(this,0.5,{
                  "ease":Expo.easeOut,
                  "y":_loc3_.y
               });
            }
            else
            {
               this.x = _loc3_.x;
               this.y = _loc3_.y;
            }
         }
         else if(this.slotType == SLOT_TYPE_DYNAMIC_LEFT)
         {
            this.guiManager.resortLeftSlots();
         }
         TweenLite.to(this.icon,0.5,{
            "x":1,
            "y":1
         });
         dispatchEvent(new Event(SimpleWindow.ON_MINIMIZED));
         this.selectedIcon.x = -3;
         this.selectedIcon.y = -4;
         this.selectedIcon.gotoAndStop(1);
         this._tweening = false;
      }
      
      public function maximize() : void
      {
         this._tweening = true;
         this.maximizeClicked = true;
         parent.removeChild(this);
         if(this.classID == SimpleWindow.WINDOW_CLASS_SETTINGS)
         {
            this.guiManager.getMain().screenManager.getWindowLayer2().addChild(this);
         }
         else
         {
            ScreenManager.getWindowLayer().addChild(this);
         }
         if(this.slotType == SLOT_TYPE_DYNAMIC_LEFT)
         {
            this.guiManager.decreaseMinimizedWindowCount();
            this.guiManager.removeFromLeftDynamicSlot(this.classID);
         }
         TweenLite.to(this,0.5,{
            "ease":Expo.easeOut,
            "x":this.lastPosition.x,
            "y":this.lastPosition.y,
            "onComplete":this.onCompleteLastPosition
         });
         TweenLite.to(this.icon,0.5,{
            "x":2,
            "y":2
         });
      }
      
      private function onCompleteLastPosition() : void
      {
         this.rootContainer.visible = true;
         this.rootContainerMask.width = 0;
         TweenLite.to(this.rootContainerMask,0.25,{
            "ease":Expo.easeOut,
            "width":this.window.width,
            "onComplete":this.onMaximizedVertical
         });
         TweenLite.to(this.rootContainer,0.25,{"alpha":1});
         this.rootContainerMask.height = 25;
         TweenLite.to(this.slot,0.25,{
            "alpha":0,
            "onComplete":this.onMaximized2,
            "onCompleteParams":[this.slot]
         });
         TweenLite.to(this.normalIcon,0.25,{
            "alpha":0,
            "onComplete":this.onMaximized2,
            "onCompleteParams":[this.normalIcon]
         });
         TweenMax.delayedCall(0.25,this.onMaximized3);
      }
      
      private function onMaximizedVertical() : void
      {
         TweenLite.to(this.rootContainerMask,0.25,{
            "ease":Expo.easeOut,
            "height":this.window.height
         });
      }
      
      private function onMaximized2(param1:Bitmap) : void
      {
         param1.visible = true;
         this.createFullDragger();
      }
      
      private function onMaximized3() : void
      {
         if(!Settings.showWindowsBackground && this.supportTransparency)
         {
            TweenLite.to(this.minimizeIcon,0.25,{"alpha":0});
            TweenLite.to(this.windowContainer,0.25,{"alpha":0});
         }
         dispatchEvent(new Event(SimpleWindow.ON_MAXIMIZED));
         this.selectedIcon.x = -1;
         this.selectedIcon.y = -4;
         this.selectedIcon.gotoAndStop(2);
         this._tweening = false;
      }
      
      public function setPredefinedDimension() : void
      {
         var _loc1_:Point = null;
         if(this.isDisplayDigits())
         {
            _loc1_ = this.dimensions[1];
            if(_loc1_ == null)
            {
               _loc1_ = this.dimensions[0];
            }
            this.setDimension(_loc1_.x,_loc1_.y);
         }
         else
         {
            _loc1_ = this.dimensions[0];
            this.setDimension(_loc1_.x,_loc1_.y);
         }
      }
      
      public function addWindowDimension(param1:Point) : void
      {
         this.dimensions.push(param1);
      }
      
      public function setPosition(param1:int) : void
      {
         switch(param1)
         {
            case POSITION_CENTER:
               this.x = ScreenManager.getHalfScreenWidth() - this.window.width / 2;
               this.y = ScreenManager.getHalfScreenHeight() - this.window.height / 2;
               break;
            case POSITION_CENTER_HORIZONTAL:
               this.x = ScreenManager.getHalfScreenWidth() - this.window.width / 2;
         }
         if(this._modal)
         {
            this.blocker.x = -this.x;
            this.blocker.y = -this.y;
         }
      }
      
      private function init() : void
      {
         this.window = this.windowContainer["window"];
         this.dragger = this.windowContainer["dragger"];
         this.resizer = this.windowContainer["resizer"];
         this.zoominButton = this.windowContainer["zoominButton"];
         this.zoomoutButton = this.windowContainer["zoomoutButton"];
         this.closeButton = this.windowContainer["closeBtn"];
         this.minimizeButton = this.windowContainer["minimizeBtn"];
         this.window.cacheAsBitmap = true;
         if(this.dragger != null)
         {
            this.dragger.cacheAsBitmap = true;
         }
         if(this.resizer != null)
         {
            this.resizer.cacheAsBitmap = true;
         }
         if(this.zoominButton != null)
         {
            this.zoominButton.cacheAsBitmap = true;
         }
         if(this.zoomoutButton != null)
         {
            this.zoomoutButton.cacheAsBitmap = true;
         }
         if(this.closeButton != null)
         {
            this.closeButton.cacheAsBitmap = true;
         }
         if(this.minimizeButton != null)
         {
            this.minimizeButton.cacheAsBitmap = true;
         }
         if(this.showCloseButton)
         {
            this.closeBtnInitDistance = this.window.width - this.closeButton.x;
            this.closeButton.gotoAndStop(1);
            this.closeButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverCloseBtn);
            this.closeButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutCloseBtn);
            this.closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseBtnClick);
            this.closeButton.buttonMode = true;
         }
         else
         {
            this.windowContainer.removeChild(this.closeButton);
         }
         if(this.draggable)
         {
            this.dragger.alpha = 0;
            this.dragger.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
            this.dragger.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownDragger);
            if(!Settings.showWindowsBackground && this.supportTransparency)
            {
               this.setDraggerListeners();
            }
            this.updateDraggerButtonMode();
         }
         else
         {
            this.windowContainer.removeChild(this.dragger);
         }
         if(this.resizable)
         {
            this.resizer.alpha = 0;
            this.resizer.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownResizer);
            if(!Settings.showWindowsBackground && this.supportTransparency)
            {
               this.setResizerListeners();
            }
            this.resizer.buttonMode = true;
         }
         else
         {
            this.windowContainer.removeChild(this.resizer);
         }
         if(this.zoomable)
         {
            this.zoominBtnInitDistance = this.window.width - this.zoominButton.x;
            this.zoominButton.gotoAndStop(1);
            this.zoominButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverZoominBtn);
            this.zoominButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutZoominBtn);
            this.zoominButton.addEventListener(MouseEvent.CLICK,this.handleZoominBtnClick);
            this.zoominButton.buttonMode = true;
            this.zoomoutBtnInitDistance = this.window.width - this.zoomoutButton.x;
            this.zoomoutButton.gotoAndStop(1);
            this.zoomoutButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleZoomoutBtnMouseOver);
            this.zoomoutButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleZoomoutBtnMouseOut);
            this.zoomoutButton.addEventListener(MouseEvent.CLICK,this.handleZoomoutBtnClick);
            this.zoomoutButton.buttonMode = true;
            if(!Settings.showWindowsBackground && this.supportTransparency)
            {
               this.setZoomButtonListeners();
            }
         }
         else
         {
            this.windowContainer.removeChild(this.zoominButton);
            this.windowContainer.removeChild(this.zoomoutButton);
         }
         if(this.showLabel)
         {
            this.label = this.windowContainer["label"];
            this.label.defaultTextFormat = Styles.windowTitleFmt;
            this.label.embedFonts = Styles.windowTitleEmbed;
            this.label.height = Styles.windowTitleFontHeight + 8;
            this.label.autoSize = TextFieldAutoSize.LEFT;
            this.label.mouseEnabled = false;
         }
         this.rootContainer.addChild(this.windowContainer);
      }
      
      private function handleMouseOverDragger(param1:MouseEvent) : void
      {
         this.fadeInWindow();
      }
      
      private function handleMouseOutDragger(param1:MouseEvent) : void
      {
         this.fadeOutWindow();
      }
      
      public function handleMouseDownResizer(param1:MouseEvent) : void
      {
         this.guiManager.setCheckResizableWindows(true);
         if(this.resizementBounds != null)
         {
            this.resizer.startDrag(false,this.resizementBounds);
         }
         else
         {
            this.resizer.startDrag();
         }
      }
      
      public function handleMouseOverResizer(param1:MouseEvent) : void
      {
         this.fadeInWindow();
      }
      
      public function handleMouseOutResizer(param1:MouseEvent) : void
      {
         this.fadeOutWindow();
      }
      
      public function checkSize() : void
      {
         if(this.lastResizerPosition.x != this.resizer.x || this.lastResizerPosition.y != this.resizer.y)
         {
            dispatchEvent(new Event(SimpleWindow.ON_RESIZED));
         }
         this.lastResizerPosition.x = this.resizer.x;
         this.lastResizerPosition.y = this.resizer.y;
      }
      
      private function handleMouseDownDragger(param1:MouseEvent) : void
      {
         if(Settings.dragWindowsAlways || !this.guiManager.getMenuManager().getMainMenu().guiLocked)
         {
            this.guiManager.setCheckWindowPositions(true);
            this.startDrag();
            this.parent.swapChildren(this,parent.getChildAt(parent.numChildren - 1));
         }
      }
      
      private function handleMouseUpDragger(param1:MouseEvent) : void
      {
         this.snapToGrid();
         this.saveWindowPosition();
      }
      
      private function onMouseDownIcon(param1:MouseEvent) : void
      {
         if(this.rootContainer.visible)
         {
            return;
         }
         if(!this.isMaximized())
         {
            return;
         }
         this.startDrag();
      }
      
      public function autoSize() : void
      {
         this.setWidth(-1);
         this.setHeight(-1);
      }
      
      private function getAutoHeight() : int
      {
         var _loc3_:SimpleContainer = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.containers.length)
         {
            _loc3_ = this.containers[_loc2_];
            if(_loc3_.height > _loc1_)
            {
               _loc1_ = _loc3_.height;
            }
            _loc2_++;
         }
         return _loc1_ + 25;
      }
      
      private function getAutoWidth() : int
      {
         var _loc3_:SimpleContainer = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.containers.length)
         {
            _loc3_ = this.containers[_loc2_];
            _loc1_ += _loc3_.width;
            _loc2_++;
         }
         return _loc1_ + 15;
      }
      
      public function setDimension(param1:int, param2:int) : void
      {
         this.setWidth(param1);
         this.setHeight(param2);
      }
      
      public function getWindowDimension() : Point
      {
         return new Point(this.resizer.x,this.resizer.y);
      }
      
      private function saveResizerPosition() : void
      {
         if(this.resizable)
         {
            this.lastResizerPosition.x = this.resizer.x;
            this.lastResizerPosition.y = this.resizer.y;
         }
      }
      
      public function setWidth(param1:int) : void
      {
         if(param1 == -1)
         {
            param1 = this.getAutoWidth();
         }
         this.resizer.x = param1;
         this.saveResizerPosition();
         this.window.width = this.resizer.x + this.resizer.width;
         this.rootContainerMask.width = this.window.width;
         if(this.windowMask != null)
         {
            this.windowMask.width = this.window.width;
         }
      }
      
      public function setHeight(param1:int) : void
      {
         if(param1 == -1)
         {
            param1 = this.getAutoHeight();
         }
         this.resizer.y = param1;
         this.saveResizerPosition();
         this.window.height = this.resizer.y + this.resizer.height;
         this.rootContainerMask.height = this.window.height;
         if(this.windowMask != null)
         {
            this.windowMask.height = this.window.height;
         }
      }
      
      public function refreshMask() : void
      {
         ++this.oldResizerX;
         this.refreshWindow();
      }
      
      public function refreshWindow() : void
      {
         if(this.resizable || this.zoomable)
         {
            if(this.resizer.x != this.oldResizerX || this.resizer.y != this.oldResizerY)
            {
               if(this.resizer.x < 150)
               {
                  this.resizer.x = 150;
               }
               if(this.resizer.y < this.minWindowHeight)
               {
                  this.resizer.y = this.minWindowHeight;
               }
               if(this.resizer.x > this.maxWindowWidth)
               {
                  this.resizer.x = this.maxWindowWidth;
               }
               if(this.resizer.y > this.maxWindowHeight)
               {
                  this.resizer.y = this.maxWindowHeight;
               }
               this.window.width = this.resizer.x + this.resizer.width;
               this.window.height = this.resizer.y + this.resizer.height;
               if(this.windowMask != null)
               {
                  this.windowMask.width = this.window.width;
                  this.windowMask.height = this.window.height;
                  this.rootContainerMask.width = this.window.width;
                  this.rootContainerMask.height = this.window.height;
               }
               dispatchEvent(new Event(SimpleWindow.ON_RESIZE));
            }
         }
         this.oldResizerX = this.resizer.x;
         this.oldResizerY = this.resizer.y;
         if(this.draggable)
         {
            this.dragger.width = this.window.width;
         }
         if(this.showCloseButton)
         {
            this.closeButton.x = this.window.width - this.closeBtnInitDistance;
         }
         if(this.zoomable)
         {
            this.zoominButton.x = this.window.width - this.zoominBtnInitDistance;
            this.zoomoutButton.x = this.window.width - this.zoomoutBtnInitDistance;
         }
      }
      
      private function handleMouseOverCloseBtn(param1:MouseEvent) : void
      {
         this.closeButton.gotoAndStop(2);
      }
      
      private function handleMouseOutCloseBtn(param1:MouseEvent) : void
      {
         this.closeButton.gotoAndStop(1);
      }
      
      private function handleCloseBtnClick(param1:MouseEvent) : void
      {
         this.cleanup();
      }
      
      private function handleMouseOverZoominBtn(param1:MouseEvent) : void
      {
         this.zoominButton.gotoAndStop(2);
      }
      
      private function handleMouseOutZoominBtn(param1:MouseEvent) : void
      {
         this.zoominButton.gotoAndStop(1);
      }
      
      private function handleZoominBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SimpleWindow.ZOOM_IN));
      }
      
      private function handleZoomoutBtnMouseOver(param1:MouseEvent) : void
      {
         this.zoomoutButton.gotoAndStop(2);
      }
      
      private function handleZoomoutBtnMouseOut(param1:MouseEvent) : void
      {
         this.zoomoutButton.gotoAndStop(1);
      }
      
      private function handleZoomoutBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SimpleWindow.ZOOM_OUT));
      }
      
      public function cleanup() : void
      {
         this.windowContainer.removeEventListener(MouseEvent.CLICK,this.handleWindowToFront);
         if(this.showCloseButton)
         {
            this.closeButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverCloseBtn);
            this.closeButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutCloseBtn);
            this.closeButton.removeEventListener(MouseEvent.CLICK,this.handleCloseBtnClick);
         }
         if(this.draggable)
         {
            this.dragger.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
            this.dragger.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownDragger);
            this.removeDraggerTransparencyListeners();
         }
         if(this.resizable)
         {
            this.resizer.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownResizer);
            this.removeResizerTransparencyListeners();
         }
         if(this.zoomable)
         {
            this.zoominButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverZoominBtn);
            this.zoominButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutZoominBtn);
            this.zoominButton.removeEventListener(MouseEvent.CLICK,this.handleZoominBtnClick);
            this.zoomoutButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleZoomoutBtnMouseOver);
            this.zoomoutButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleZoomoutBtnMouseOut);
            this.zoomoutButton.removeEventListener(MouseEvent.CLICK,this.handleZoomoutBtnClick);
            this.removeZoomButtonTransparencyListeners();
         }
         if(this.minimizeIcon != null)
         {
            this.minimizeIcon.removeEventListener(MouseEvent.CLICK,this.toggleVisibility);
            this.minimizeIcon.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
            this.minimizeIcon.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
            this.minimizeIcon.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownIcon);
         }
         TweenLite.to(this,0.25,{
            "alpha":0,
            "onComplete":this.handleCloseWindowComplete
         });
         this.modal = false;
         this.stopPointer();
      }
      
      public function setLabelText(param1:String) : void
      {
         var _loc2_:String = BPLocale.getText(param1);
         if(this.classID == SimpleWindow.WINDOW_CLASS_HELP)
         {
            TooltipControl.getInstance().addToolTip(this.minimizeIcon,_loc2_ + "\n" + Main.version);
            return;
         }
         if(_loc2_ != null)
         {
            this.label.text = _loc2_;
            if(this.minimizeIcon != null)
            {
               TooltipControl.getInstance().addToolTip(this.minimizeIcon,_loc2_);
            }
         }
      }
      
      private function handleCloseWindowComplete() : void
      {
         delete this.guiManager.getWindows()[int(this.classID)];
         parent.removeChild(this);
         dispatchEvent(new Event(SimpleWindow.ON_CLOSE));
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         this.guiManager.setCheckWindowPositions(false);
         if(!this.checkPosition())
         {
            return;
         }
         if(!this.rootContainer.visible)
         {
            return;
         }
         if(this.lastPosition.x != this.x || this.lastPosition.y != this.y)
         {
            dispatchEvent(new Event(SimpleWindow.ON_MOVE));
         }
         this.lastPosition.x = this.x;
         this.lastPosition.y = this.y;
         this.saveWindowSetting(true);
      }
      
      private function saveWindowPosition() : void
      {
         this.guiManager.setCheckWindowPositions(false);
         if(!this.checkPosition())
         {
            return;
         }
         if(!this.rootContainer.visible)
         {
            return;
         }
         if(this.lastPosition.x != this.x || this.lastPosition.y != this.y)
         {
            dispatchEvent(new Event(SimpleWindow.ON_MOVE));
         }
         this.lastPosition.x = this.x;
         this.lastPosition.y = this.y;
         this.saveWindowSetting(true);
      }
      
      public function getWindow() : MovieClip
      {
         return this.window;
      }
      
      public function addContainer(param1:SimpleContainer) : void
      {
         this.containers.push(param1);
         this.rootContainer.addChild(param1);
      }
      
      public function removeContainerAt(param1:int) : void
      {
         var _loc2_:SimpleContainer = this.containers[param1];
         if(_loc2_ != null)
         {
            if(this.rootContainer.contains(_loc2_))
            {
               this.rootContainer.removeChild(_loc2_);
               this.containers.splice(param1,1);
            }
         }
      }
      
      public function getContainer(param1:int) : SimpleContainer
      {
         var _loc3_:SimpleContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.containers.length)
         {
            _loc3_ = this.containers[_loc2_];
            if(_loc3_.getClassID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeContainer(param1:SimpleContainer) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.containers.length)
         {
            _loc3_ = this.containers[_loc2_];
            if(_loc3_ == param1)
            {
               this.rootContainer.removeChild(param1);
               this.containers.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function getContainerAt(param1:int) : SimpleContainer
      {
         return this.containers[param1];
      }
      
      public function getID() : int
      {
         return this.classID;
      }
      
      public function isResizable() : Boolean
      {
         return this.resizable;
      }
      
      public function lockWindow() : void
      {
         this.actionDeactivated.visible = true;
         this.minimizeIcon.buttonMode = false;
      }
      
      public function isLocked() : Boolean
      {
         if(this.actionDeactivated.visible && !this.minimizeIcon.buttonMode)
         {
            return true;
         }
         return false;
      }
      
      public function unlockWindow() : void
      {
         this.actionDeactivated.visible = false;
         this.minimizeIcon.buttonMode = true;
      }
      
      public function isDisplayDigits() : Boolean
      {
         return this.displayDigits;
      }
      
      public function setDisplayDigits(param1:Boolean) : void
      {
         this.displayDigits = param1;
      }
      
      public function getSlotType() : int
      {
         return this.slotType;
      }
      
      public function isMaximizeClicked() : Boolean
      {
         return this.maximizeClicked;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = int(param1);
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = int(param1);
      }
      
      public function resetPosition() : void
      {
         TweenLite.to(this,0.5,{
            "ease":Elastic.easeOut,
            "x":this.lastPosition.x,
            "y":this.lastPosition.y
         });
         this.guiManager.setCheckWindowPositions(false);
      }
      
      public function setLastPosition() : void
      {
         this.lastPosition.x = this.x;
         this.lastPosition.y = this.y;
      }
      
      public function get modal() : Boolean
      {
         return this._modal;
      }
      
      public function set modal(param1:Boolean) : void
      {
         this._modal = param1;
         if(this._modal && this.blocker == null)
         {
            this.blocker = new Sprite();
            this.blocker.graphics.beginFill(4278190080);
            this.blocker.graphics.drawRect(0,0,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight());
            this.blocker.alpha = 0.5;
            this.parent.addChild(this.blocker);
            this.parent.swapChildren(this,this.blocker);
         }
         else if(this.blocker != null && this.parent.contains(this.blocker))
         {
            this.parent.removeChild(this.blocker);
         }
      }
      
      public function isSaveSettings() : Boolean
      {
         return this.saveSettings;
      }
      
      public function get tweeening() : Boolean
      {
         return this._tweening;
      }
      
      public function getRootContainer() : MovieClip
      {
         return this.rootContainer;
      }
      
      public function setResizementBounds(param1:Rectangle) : void
      {
         this.resizementBounds = param1;
      }
      
      public function createFullDragger() : void
      {
         if(!this.guiManager.getMenuManager().getMainMenu().guiLocked && this.saveSettings && this.isMaximized())
         {
            if(this.fullDragger != null && this.contains(this.fullDragger))
            {
               this.removeFullDragger();
            }
            this.fullDragger = new Sprite();
            this.fullDragger.graphics.beginFill(16711680);
            this.fullDragger.graphics.drawRect(0,0,this.window.width,this.window.height);
            this.fullDragger.alpha = 0.3;
            this.fullDragger.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownDragger);
            this.fullDragger.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpDragger);
            this.fullDragger.buttonMode = true;
            this.addChild(this.fullDragger);
         }
      }
      
      public function removeFullDragger() : void
      {
         if(this.saveSettings && this.fullDragger != null && this.isMaximized())
         {
            this.fullDragger.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownDragger);
            this.fullDragger.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpDragger);
            this.removeChild(this.fullDragger);
         }
      }
      
      public function updateDraggerButtonMode() : void
      {
         if(this.dragger != null)
         {
            this.dragger.buttonMode = Settings.dragWindowsAlways;
         }
      }
      
      public function blink() : void
      {
         var _loc1_:Number = this.windowContainer.alpha;
         this.windowContainer.alpha = 1;
         this.minimizeIcon.alpha = 1;
         TweenMax.to(this.rootContainer,0.5,{
            "onComplete":this.resetWindowContainerStatus,
            "onCompleteParams":[_loc1_],
            "repeat":10,
            "yoyo":true,
            "glowFilter":{
               "color":15327936,
               "quality":2,
               "alpha":2,
               "blurX":30,
               "blurY":30,
               "remove":true
            }
         });
      }
      
      private function resetWindowContainerStatus(param1:Number) : void
      {
         this.windowContainer.alpha = param1;
         this.minimizeIcon.alpha = param1;
      }
   }
}


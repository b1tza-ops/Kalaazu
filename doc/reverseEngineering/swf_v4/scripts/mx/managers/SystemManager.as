package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.Font;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexSprite;
   import mx.core.IChildList;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.IRawChildrenContainer;
   import mx.core.IUIComponent;
   import mx.core.RSLItem;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.FlexEvent;
   import mx.events.RSLEvent;
   import mx.events.Request;
   import mx.events.SandboxMouseEvent;
   import mx.preloaders.Preloader;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   public class SystemManager extends MovieClip implements IChildList, IFlexDisplayObject, IFlexModuleFactory, ISystemManager
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      private static const IDLE_THRESHOLD:Number = 1000;
      
      private static const IDLE_INTERVAL:Number = 100;
      
      mx_internal static var allSystemManagers:Dictionary = new Dictionary(true);
      
      mx_internal var topLevel:Boolean = true;
      
      private var isDispatchingResizeEvent:Boolean;
      
      mx_internal var isStageRoot:Boolean = true;
      
      mx_internal var isBootstrapRoot:Boolean = false;
      
      private var _topLevelSystemManager:ISystemManager;
      
      mx_internal var childManager:ISystemManagerChildManager;
      
      private var _stage:Stage;
      
      mx_internal var nestLevel:int = 0;
      
      mx_internal var preloader:Preloader;
      
      private var mouseCatcher:Sprite;
      
      mx_internal var topLevelWindow:IUIComponent;
      
      mx_internal var idleCounter:int = 0;
      
      private var idleTimer:Timer;
      
      private var nextFrameTimer:Timer = null;
      
      private var lastFrame:int;
      
      private var readyForKickOff:Boolean;
      
      private var _height:Number;
      
      private var _width:Number;
      
      private var _applicationIndex:int = 1;
      
      private var _cursorChildren:SystemChildrenList;
      
      private var _cursorIndex:int = 0;
      
      private var _document:Object;
      
      private var _fontList:Object = null;
      
      private var _explicitHeight:Number;
      
      private var _explicitWidth:Number;
      
      private var _focusPane:Sprite;
      
      private var _noTopMostIndex:int = 0;
      
      private var _numModalWindows:int = 0;
      
      private var _popUpChildren:SystemChildrenList;
      
      private var _rawChildren:SystemRawChildrenList;
      
      mx_internal var _screen:Rectangle;
      
      private var _toolTipChildren:SystemChildrenList;
      
      private var _toolTipIndex:int = 0;
      
      private var _topMostIndex:int = 0;
      
      mx_internal var _mouseX:*;
      
      mx_internal var _mouseY:*;
      
      private var implMap:Object = {};
      
      public function SystemManager()
      {
         super();
         if(this.stage)
         {
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
         }
         if(SystemManagerGlobals.topLevelSystemManagers.length > 0 && !this.stage)
         {
            this.mx_internal::topLevel = false;
         }
         if(!this.stage)
         {
            this.mx_internal::isStageRoot = false;
         }
         if(this.mx_internal::topLevel)
         {
            SystemManagerGlobals.topLevelSystemManagers.push(this);
         }
         stop();
         if(Boolean(root) && Boolean(root.loaderInfo))
         {
            root.loaderInfo.addEventListener(Event.INIT,this.initHandler);
         }
      }
      
      public static function getSWFRoot(param1:Object) : DisplayObject
      {
         var p:* = undefined;
         var sm:ISystemManager = null;
         var domain:ApplicationDomain = null;
         var cls:Class = null;
         var object:Object = param1;
         var className:String = getQualifiedClassName(object);
         for(p in mx_internal::allSystemManagers)
         {
            sm = p as ISystemManager;
            domain = sm.loaderInfo.applicationDomain;
            try
            {
               cls = Class(domain.getDefinition(className));
               if(object is cls)
               {
                  return sm as DisplayObject;
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      private static function getChildListIndex(param1:IChildList, param2:Object) : int
      {
         var childList:IChildList = param1;
         var f:Object = param2;
         var index:int = -1;
         try
         {
            index = childList.getChildIndex(DisplayObject(f));
         }
         catch(e:ArgumentError)
         {
         }
         return index;
      }
      
      private function deferredNextFrame() : void
      {
         if(currentFrame + 1 > totalFrames)
         {
            return;
         }
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
         }
         else
         {
            this.nextFrameTimer = new Timer(100);
            this.nextFrameTimer.addEventListener(TimerEvent.TIMER,this.nextFrameTimerHandler);
            this.nextFrameTimer.start();
         }
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function get stage() : Stage
      {
         var _loc2_:DisplayObject = null;
         if(this._stage)
         {
            return this._stage;
         }
         var _loc1_:Stage = super.stage;
         if(_loc1_)
         {
            this._stage = _loc1_;
            return _loc1_;
         }
         if(!this.mx_internal::topLevel && Boolean(this._topLevelSystemManager))
         {
            this._stage = this._topLevelSystemManager.stage;
            return this._stage;
         }
         if(!this.mx_internal::isStageRoot && this.mx_internal::topLevel)
         {
            _loc2_ = this.getTopLevelRoot();
            if(_loc2_)
            {
               this._stage = _loc2_.stage;
               return this._stage;
            }
         }
         return null;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get numChildren() : int
      {
         return this.mx_internal::noTopMostIndex - this.mx_internal::applicationIndex;
      }
      
      public function get application() : IUIComponent
      {
         return IUIComponent(this._document);
      }
      
      mx_internal function get applicationIndex() : int
      {
         return this._applicationIndex;
      }
      
      mx_internal function set applicationIndex(param1:int) : void
      {
         this._applicationIndex = param1;
      }
      
      public function get cursorChildren() : IChildList
      {
         if(!this.mx_internal::topLevel)
         {
            return this._topLevelSystemManager.cursorChildren;
         }
         if(!this._cursorChildren)
         {
            this._cursorChildren = new SystemChildrenList(this,new QName(mx_internal,"toolTipIndex"),new QName(mx_internal,"cursorIndex"));
         }
         return this._cursorChildren;
      }
      
      mx_internal function get cursorIndex() : int
      {
         return this._cursorIndex;
      }
      
      mx_internal function set cursorIndex(param1:int) : void
      {
         var _loc2_:int = param1 - this._cursorIndex;
         this._cursorIndex = param1;
      }
      
      public function get document() : Object
      {
         return this._document;
      }
      
      public function set document(param1:Object) : void
      {
         this._document = param1;
      }
      
      public function get embeddedFontList() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(this._fontList == null)
         {
            this._fontList = {};
            _loc1_ = this.info()["fonts"];
            for(_loc2_ in _loc1_)
            {
               this._fontList[_loc2_] = _loc1_[_loc2_];
            }
            if(!this.mx_internal::topLevel && Boolean(this._topLevelSystemManager))
            {
               _loc3_ = this._topLevelSystemManager.embeddedFontList;
               for(_loc2_ in _loc3_)
               {
                  this._fontList[_loc2_] = _loc3_[_loc2_];
               }
            }
         }
         return this._fontList;
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(param1:Number) : void
      {
         this._explicitHeight = param1;
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(param1:Number) : void
      {
         this._explicitWidth = param1;
      }
      
      public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      public function set focusPane(param1:Sprite) : void
      {
         if(param1)
         {
            this.addChild(param1);
            param1.x = 0;
            param1.y = 0;
            param1.scrollRect = null;
            this._focusPane = param1;
         }
         else
         {
            this.removeChild(this._focusPane);
            this._focusPane = null;
         }
      }
      
      public function get isProxy() : Boolean
      {
         return false;
      }
      
      public function get measuredHeight() : Number
      {
         return this.mx_internal::topLevelWindow ? this.mx_internal::topLevelWindow.getExplicitOrMeasuredHeight() : loaderInfo.height;
      }
      
      public function get measuredWidth() : Number
      {
         return this.mx_internal::topLevelWindow ? this.mx_internal::topLevelWindow.getExplicitOrMeasuredWidth() : loaderInfo.width;
      }
      
      mx_internal function get noTopMostIndex() : int
      {
         return this._noTopMostIndex;
      }
      
      mx_internal function set noTopMostIndex(param1:int) : void
      {
         var _loc2_:int = param1 - this._noTopMostIndex;
         this._noTopMostIndex = param1;
         this.mx_internal::topMostIndex += _loc2_;
      }
      
      final mx_internal function get $numChildren() : int
      {
         return super.numChildren;
      }
      
      public function get numModalWindows() : int
      {
         return this._numModalWindows;
      }
      
      public function set numModalWindows(param1:int) : void
      {
         this._numModalWindows = param1;
      }
      
      public function get preloadedRSLs() : Dictionary
      {
         return null;
      }
      
      public function get preloaderBackgroundAlpha() : Number
      {
         return this.info()["backgroundAlpha"];
      }
      
      public function get preloaderBackgroundColor() : uint
      {
         var _loc1_:* = this.info()["backgroundColor"];
         if(_loc1_ == undefined)
         {
            return 4294967295;
         }
         return _loc1_;
      }
      
      public function get preloaderBackgroundImage() : Object
      {
         return this.info()["backgroundImage"];
      }
      
      public function get preloaderBackgroundSize() : String
      {
         return this.info()["backgroundSize"];
      }
      
      public function get popUpChildren() : IChildList
      {
         if(!this.mx_internal::topLevel)
         {
            return this._topLevelSystemManager.popUpChildren;
         }
         if(!this._popUpChildren)
         {
            this._popUpChildren = new SystemChildrenList(this,new QName(mx_internal,"noTopMostIndex"),new QName(mx_internal,"topMostIndex"));
         }
         return this._popUpChildren;
      }
      
      public function get rawChildren() : IChildList
      {
         if(!this._rawChildren)
         {
            this._rawChildren = new SystemRawChildrenList(this);
         }
         return this._rawChildren;
      }
      
      public function get screen() : Rectangle
      {
         if(!this.mx_internal::_screen)
         {
            this.Stage_resizeHandler();
         }
         if(!this.mx_internal::isStageRoot)
         {
            this.Stage_resizeHandler();
         }
         return this.mx_internal::_screen;
      }
      
      public function get toolTipChildren() : IChildList
      {
         if(!this.mx_internal::topLevel)
         {
            return this._topLevelSystemManager.toolTipChildren;
         }
         if(!this._toolTipChildren)
         {
            this._toolTipChildren = new SystemChildrenList(this,new QName(mx_internal,"topMostIndex"),new QName(mx_internal,"toolTipIndex"));
         }
         return this._toolTipChildren;
      }
      
      mx_internal function get toolTipIndex() : int
      {
         return this._toolTipIndex;
      }
      
      mx_internal function set toolTipIndex(param1:int) : void
      {
         var _loc2_:int = param1 - this._toolTipIndex;
         this._toolTipIndex = param1;
         this.mx_internal::cursorIndex += _loc2_;
      }
      
      public function get topLevelSystemManager() : ISystemManager
      {
         if(this.mx_internal::topLevel)
         {
            return this;
         }
         return this._topLevelSystemManager;
      }
      
      mx_internal function get topMostIndex() : int
      {
         return this._topMostIndex;
      }
      
      mx_internal function set topMostIndex(param1:int) : void
      {
         var _loc2_:int = param1 - this._topMostIndex;
         this._topMostIndex = param1;
         this.mx_internal::toolTipIndex += _loc2_;
      }
      
      final mx_internal function $addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get childAllowsParent() : Boolean
      {
         try
         {
            return loaderInfo.childAllowsParent;
         }
         catch(error:Error)
         {
         }
         return false;
      }
      
      public function get parentAllowsChild() : Boolean
      {
         try
         {
            return loaderInfo.parentAllowsChild;
         }
         catch(error:Error)
         {
         }
         return false;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var request:DynamicEvent = null;
         var type:String = param1;
         var listener:Function = param2;
         var useCapture:Boolean = param3;
         var priority:int = param4;
         var useWeakReference:Boolean = param5;
         if(type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN || type == Event.ACTIVATE || type == Event.DEACTIVATE)
         {
            try
            {
               if(this.stage)
               {
                  this.stage.addEventListener(type,this.stageEventHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
            }
         }
         if(hasEventListener("addEventListener"))
         {
            request = new DynamicEvent("addEventListener",false,true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            request.priority = priority;
            request.useWeakReference = useWeakReference;
            if(!dispatchEvent(request))
            {
               return;
            }
         }
         if(type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
         {
            try
            {
               if(this.stage)
               {
                  this.stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler,false,0,true);
               }
               else
               {
                  super.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
               super.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
            }
         }
         if(type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
         {
            if(type == FlexEvent.RENDER)
            {
               type = Event.RENDER;
            }
            else
            {
               type = Event.ENTER_FRAME;
            }
            try
            {
               if(this.stage)
               {
                  this.stage.addEventListener(type,listener,useCapture,priority,useWeakReference);
               }
               else
               {
                  super.addEventListener(type,listener,useCapture,priority,useWeakReference);
               }
            }
            catch(error:SecurityError)
            {
               super.addEventListener(type,listener,useCapture,priority,useWeakReference);
            }
            if(Boolean(this.stage) && type == Event.RENDER)
            {
               this.stage.invalidate();
            }
            return;
         }
         if(type == FlexEvent.IDLE && !this.idleTimer)
         {
            this.idleTimer = new Timer(IDLE_INTERVAL);
            this.idleTimer.addEventListener(TimerEvent.TIMER,this.idleTimer_timerHandler);
            this.idleTimer.start();
            this.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
            this.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      final mx_internal function $removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var request:DynamicEvent = null;
         var type:String = param1;
         var listener:Function = param2;
         var useCapture:Boolean = param3;
         if(hasEventListener("removeEventListener"))
         {
            request = new DynamicEvent("removeEventListener",false,true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            if(!dispatchEvent(request))
            {
               return;
            }
         }
         if(type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
         {
            if(type == FlexEvent.RENDER)
            {
               type = Event.RENDER;
            }
            else
            {
               type = Event.ENTER_FRAME;
            }
            try
            {
               if(this.stage)
               {
                  this.stage.removeEventListener(type,listener,useCapture);
               }
            }
            catch(error:SecurityError)
            {
            }
            super.removeEventListener(type,listener,useCapture);
            return;
         }
         if(type == FlexEvent.IDLE)
         {
            super.removeEventListener(type,listener,useCapture);
            if(!hasEventListener(FlexEvent.IDLE) && Boolean(this.idleTimer))
            {
               this.idleTimer.stop();
               this.idleTimer = null;
               this.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
               this.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            }
         }
         else
         {
            super.removeEventListener(type,listener,useCapture);
         }
         if(type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN || type == Event.ACTIVATE || type == Event.DEACTIVATE)
         {
            if(!hasEventListener(type))
            {
               try
               {
                  if(this.stage)
                  {
                     this.stage.removeEventListener(type,this.stageEventHandler,false);
                  }
               }
               catch(error:SecurityError)
               {
               }
            }
         }
         if(type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
         {
            if(!hasEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE))
            {
               try
               {
                  if(this.stage)
                  {
                     this.stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
                  }
               }
               catch(error:SecurityError)
               {
               }
               super.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
            }
         }
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:int = this.numChildren;
         if(param1.parent == this)
         {
            _loc2_--;
         }
         return this.addChildAt(param1,_loc2_);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         ++this.mx_internal::noTopMostIndex;
         var _loc3_:DisplayObjectContainer = param1.parent;
         if(_loc3_)
         {
            _loc3_.removeChild(param1);
         }
         return this.mx_internal::rawChildren_addChildAt(param1,this.mx_internal::applicationIndex + param2);
      }
      
      final mx_internal function $addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         return super.addChildAt(param1,param2);
      }
      
      final mx_internal function $removeChildAt(param1:int) : DisplayObject
      {
         return super.removeChildAt(param1);
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         --this.mx_internal::noTopMostIndex;
         return this.mx_internal::rawChildren_removeChild(param1);
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         --this.mx_internal::noTopMostIndex;
         return this.mx_internal::rawChildren_removeChildAt(this.mx_internal::applicationIndex + param1);
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return super.getChildAt(this.mx_internal::applicationIndex + param1);
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         return super.getChildByName(param1);
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         return super.getChildIndex(param1) - this.mx_internal::applicationIndex;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,this.mx_internal::applicationIndex + param2);
      }
      
      override public function getObjectsUnderPoint(param1:Point) : Array
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:int = this.mx_internal::topMostIndex;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = super.getChildAt(_loc4_);
            if(_loc5_ is DisplayObjectContainer)
            {
               _loc6_ = DisplayObjectContainer(_loc5_).getObjectsUnderPoint(param1);
               if(_loc6_)
               {
                  _loc2_ = _loc2_.concat(_loc6_);
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      override public function contains(param1:DisplayObject) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         if(super.contains(param1))
         {
            if(param1.parent == this)
            {
               _loc2_ = super.getChildIndex(param1);
               if(_loc2_ < this.mx_internal::noTopMostIndex)
               {
                  return true;
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < this.mx_internal::noTopMostIndex)
               {
                  _loc4_ = super.getChildAt(_loc3_);
                  if(_loc4_ is IRawChildrenContainer)
                  {
                     if(IRawChildrenContainer(_loc4_).rawChildren.contains(param1))
                     {
                        return true;
                     }
                  }
                  if(_loc4_ is DisplayObjectContainer)
                  {
                     if(DisplayObjectContainer(_loc4_).contains(param1))
                     {
                        return true;
                     }
                  }
                  _loc3_++;
               }
            }
         }
         return false;
      }
      
      public function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *
      {
         return undefined;
      }
      
      public function create(... rest) : Object
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:String = this.info()["mainClassName"];
         if(_loc2_ == null)
         {
            _loc4_ = loaderInfo.loaderURL;
            _loc5_ = int(_loc4_.lastIndexOf("."));
            _loc6_ = int(_loc4_.lastIndexOf("/"));
            _loc2_ = _loc4_.substring(_loc6_ + 1,_loc5_);
         }
         var _loc3_:Class = Class(this.getDefinitionByName(_loc2_));
         return _loc3_ ? new _loc3_() : null;
      }
      
      public function info() : Object
      {
         return {};
      }
      
      mx_internal function initialize() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Class = null;
         var _loc13_:Object = null;
         var _loc14_:RSLItem = null;
         if(this.mx_internal::isStageRoot)
         {
            this._width = this.stage.stageWidth;
            this._height = this.stage.stageHeight;
         }
         else
         {
            this._width = loaderInfo.width;
            this._height = loaderInfo.height;
         }
         this.mx_internal::preloader = new Preloader();
         this.mx_internal::preloader.addEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY,this.preloader_preloaderDocFrameReadyHandler);
         this.mx_internal::preloader.addEventListener(Event.COMPLETE,this.mx_internal::preloader_completeHandler);
         this.mx_internal::preloader.addEventListener(FlexEvent.PRELOADER_DONE,this.preloader_preloaderDoneHandler);
         this.mx_internal::preloader.addEventListener(RSLEvent.RSL_COMPLETE,this.preloader_rslCompleteHandler);
         if(!this._popUpChildren)
         {
            this._popUpChildren = new SystemChildrenList(this,new QName(mx_internal,"noTopMostIndex"),new QName(mx_internal,"topMostIndex"));
         }
         this._popUpChildren.addChild(this.mx_internal::preloader);
         var _loc1_:Array = this.info()["rsls"];
         var _loc2_:Array = this.info()["cdRsls"];
         var _loc3_:Boolean = true;
         if(this.info()["usePreloader"] != undefined)
         {
            _loc3_ = Boolean(this.info()["usePreloader"]);
         }
         var _loc4_:Class = this.info()["preloader"] as Class;
         var _loc5_:Array = [];
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc11_ = LoaderUtil.normalizeURL(this.loaderInfo);
            _loc12_ = Class(this.getDefinitionByName("mx.core::CrossDomainRSLItem"));
            _loc6_ = int(_loc2_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc13_ = new _loc12_(_loc2_[_loc7_]["rsls"],_loc2_[_loc7_]["policyFiles"],_loc2_[_loc7_]["digests"],_loc2_[_loc7_]["types"],_loc2_[_loc7_]["isSigned"],_loc11_,this);
               _loc5_.push(_loc13_);
               _loc7_++;
            }
         }
         if(_loc1_ != null && _loc1_.length > 0)
         {
            if(_loc11_ == null)
            {
               _loc11_ = LoaderUtil.normalizeURL(this.loaderInfo);
            }
            _loc6_ = int(_loc1_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc14_ = new RSLItem(_loc1_[_loc7_].url,_loc11_,this);
               _loc5_.push(_loc14_);
               _loc7_++;
            }
         }
         var _loc8_:String = loaderInfo.parameters["resourceModuleURLs"];
         var _loc9_:Array = _loc8_ ? _loc8_.split(",") : null;
         var _loc10_:ApplicationDomain = !this.mx_internal::topLevel && this.parent is Loader ? Loader(this.parent).contentLoaderInfo.applicationDomain : this.info()["currentDomain"] as ApplicationDomain;
         this.mx_internal::preloader.initialize(_loc3_,_loc4_,this.preloaderBackgroundColor,this.preloaderBackgroundAlpha,this.preloaderBackgroundImage,this.preloaderBackgroundSize,this.mx_internal::isStageRoot ? this.stage.stageWidth : loaderInfo.width,this.mx_internal::isStageRoot ? this.stage.stageHeight : loaderInfo.height,null,null,_loc5_,_loc9_,_loc10_);
      }
      
      mx_internal function rawChildren_addChild(param1:DisplayObject) : DisplayObject
      {
         this.mx_internal::childManager.addingChild(param1);
         super.addChild(param1);
         this.mx_internal::childManager.childAdded(param1);
         return param1;
      }
      
      mx_internal function rawChildren_addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(this.mx_internal::childManager)
         {
            this.mx_internal::childManager.addingChild(param1);
         }
         super.addChildAt(param1,param2);
         if(this.mx_internal::childManager)
         {
            this.mx_internal::childManager.childAdded(param1);
         }
         return param1;
      }
      
      mx_internal function rawChildren_removeChild(param1:DisplayObject) : DisplayObject
      {
         this.mx_internal::childManager.removingChild(param1);
         super.removeChild(param1);
         this.mx_internal::childManager.childRemoved(param1);
         return param1;
      }
      
      mx_internal function rawChildren_removeChildAt(param1:int) : DisplayObject
      {
         var _loc2_:DisplayObject = super.getChildAt(param1);
         this.mx_internal::childManager.removingChild(_loc2_);
         super.removeChildAt(param1);
         this.mx_internal::childManager.childRemoved(_loc2_);
         return _loc2_;
      }
      
      mx_internal function rawChildren_getChildAt(param1:int) : DisplayObject
      {
         return super.getChildAt(param1);
      }
      
      mx_internal function rawChildren_getChildByName(param1:String) : DisplayObject
      {
         return super.getChildByName(param1);
      }
      
      mx_internal function rawChildren_getChildIndex(param1:DisplayObject) : int
      {
         return super.getChildIndex(param1);
      }
      
      mx_internal function rawChildren_setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
      }
      
      mx_internal function rawChildren_getObjectsUnderPoint(param1:Point) : Array
      {
         return super.getObjectsUnderPoint(param1);
      }
      
      mx_internal function rawChildren_contains(param1:DisplayObject) : Boolean
      {
         return super.contains(param1);
      }
      
      public function allowDomain(... rest) : void
      {
      }
      
      public function allowInsecureDomain(... rest) : void
      {
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         return !isNaN(this.explicitWidth) ? this.explicitWidth : this.measuredWidth;
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         return !isNaN(this.explicitHeight) ? this.explicitHeight : this.measuredHeight;
      }
      
      public function move(param1:Number, param2:Number) : void
      {
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
         if(this.mx_internal::isStageRoot)
         {
            return;
         }
         if(this.mouseCatcher)
         {
            this.mouseCatcher.width = param1;
            this.mouseCatcher.height = param2;
         }
         if(this._width != param1 || this._height != param2)
         {
            this._width = param1;
            this._height = param2;
            dispatchEvent(new Event(Event.RESIZE));
         }
      }
      
      public function getDefinitionByName(param1:String) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:ApplicationDomain = !this.mx_internal::topLevel && this.parent is Loader ? Loader(this.parent).contentLoaderInfo.applicationDomain : this.info()["currentDomain"] as ApplicationDomain;
         if(_loc2_.hasDefinition(param1))
         {
            _loc3_ = _loc2_.getDefinition(param1);
         }
         return _loc3_;
      }
      
      public function isTopLevel() : Boolean
      {
         return this.mx_internal::topLevel;
      }
      
      public function isTopLevelRoot() : Boolean
      {
         return this.mx_internal::isStageRoot || this.mx_internal::isBootstrapRoot;
      }
      
      public function isTopLevelWindow(param1:DisplayObject) : Boolean
      {
         return param1 is IUIComponent && IUIComponent(param1) == this.mx_internal::topLevelWindow;
      }
      
      public function isFontFaceEmbedded(param1:TextFormat) : Boolean
      {
         var _loc9_:Font = null;
         var _loc10_:String = null;
         var _loc2_:String = param1.font;
         var _loc3_:Boolean = Boolean(param1.bold);
         var _loc4_:Boolean = Boolean(param1.italic);
         var _loc5_:Array = Font.enumerateFonts();
         var _loc6_:int = int(_loc5_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = Font(_loc5_[_loc7_]);
            if(_loc9_.fontName == _loc2_)
            {
               _loc10_ = "regular";
               if(_loc3_ && _loc4_)
               {
                  _loc10_ = "boldItalic";
               }
               else if(_loc3_)
               {
                  _loc10_ = "bold";
               }
               else if(_loc4_)
               {
                  _loc10_ = "italic";
               }
               if(_loc9_.fontStyle == _loc10_)
               {
                  return true;
               }
            }
            _loc7_++;
         }
         if(!_loc2_ || !this.embeddedFontList || !this.embeddedFontList[_loc2_])
         {
            return false;
         }
         var _loc8_:Object = this.embeddedFontList[_loc2_];
         return !(_loc3_ && !_loc8_.bold || _loc4_ && !_loc8_.italic || !_loc3_ && !_loc4_ && !_loc8_.regular);
      }
      
      private function resizeMouseCatcher() : void
      {
         var g:Graphics = null;
         var s:Rectangle = null;
         if(this.mouseCatcher)
         {
            try
            {
               g = this.mouseCatcher.graphics;
               s = this.screen;
               g.clear();
               g.beginFill(0,0);
               g.drawRect(0,0,s.width,s.height);
               g.endFill();
            }
            catch(e:SecurityError)
            {
            }
         }
      }
      
      private function initHandler(param1:Event) : void
      {
         var docFrame:int;
         var event:Event = param1;
         if(!this.mx_internal::isStageRoot)
         {
            if(root.loaderInfo.parentAllowsChild)
            {
               try
               {
                  if(!this.parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot",false,true)) || !root.loaderInfo.sharedEvents.hasEventListener("bridgeNewApplication"))
                  {
                     this.mx_internal::isBootstrapRoot = true;
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         mx_internal::allSystemManagers[this] = this.loaderInfo.url;
         root.loaderInfo.removeEventListener(Event.INIT,this.initHandler);
         if(!SystemManagerGlobals.info)
         {
            SystemManagerGlobals.info = this.info();
         }
         if(!SystemManagerGlobals.parameters)
         {
            SystemManagerGlobals.parameters = loaderInfo.parameters;
         }
         if(this.getSandboxRoot() == this)
         {
            this.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true,1000);
            this.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,true,1000);
         }
         if(this.isTopLevelRoot() && Boolean(this.stage))
         {
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,1000);
            this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,false,1000);
         }
         docFrame = totalFrames == 1 ? 0 : 1;
         this.addEventListener(Event.ENTER_FRAME,this.docFrameListener);
         this.mx_internal::initialize();
      }
      
      private function docFrameListener(param1:Event) : void
      {
         if(currentFrame == 2)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.docFrameListener);
            if(totalFrames > 2)
            {
               this.addEventListener(Event.ENTER_FRAME,this.extraFrameListener);
            }
            this.mx_internal::docFrameHandler();
         }
      }
      
      private function extraFrameListener(param1:Event) : void
      {
         if(this.lastFrame == currentFrame)
         {
            return;
         }
         this.lastFrame = currentFrame;
         if(currentFrame + 1 > totalFrames)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.extraFrameListener);
         }
         this.extraFrameHandler();
      }
      
      private function preloader_preloaderDocFrameReadyHandler(param1:Event) : void
      {
         this.mx_internal::preloader.removeEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY,this.preloader_preloaderDocFrameReadyHandler);
         this.deferredNextFrame();
      }
      
      private function preloader_preloaderDoneHandler(param1:Event) : void
      {
         var _loc2_:IUIComponent = this.mx_internal::topLevelWindow;
         this.mx_internal::preloader.removeEventListener(FlexEvent.PRELOADER_DONE,this.preloader_preloaderDoneHandler);
         this.mx_internal::preloader.removeEventListener(RSLEvent.RSL_COMPLETE,this.preloader_rslCompleteHandler);
         this._popUpChildren.removeChild(this.mx_internal::preloader);
         this.mx_internal::preloader = null;
         this.mouseCatcher = new FlexSprite();
         this.mouseCatcher.name = "mouseCatcher";
         ++this.mx_internal::noTopMostIndex;
         super.addChildAt(this.mouseCatcher,0);
         this.resizeMouseCatcher();
         if(!this.mx_internal::topLevel)
         {
            this.mouseCatcher.visible = false;
            mask = this.mouseCatcher;
         }
         ++this.mx_internal::noTopMostIndex;
         super.addChildAt(DisplayObject(_loc2_),1);
         _loc2_.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
         dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
      }
      
      private function preloader_rslCompleteHandler(param1:RSLEvent) : void
      {
         if(param1.loaderInfo)
         {
            this.preloadedRSLs[param1.loaderInfo] = param1.url.url;
         }
      }
      
      mx_internal function docFrameHandler(param1:Event = null) : void
      {
         if(this.readyForKickOff)
         {
            this.mx_internal::kickOff();
         }
      }
      
      mx_internal function preloader_completeHandler(param1:Event) : void
      {
         this.mx_internal::preloader.removeEventListener(Event.COMPLETE,this.mx_internal::preloader_completeHandler);
         this.readyForKickOff = true;
         if(currentFrame >= 2)
         {
            this.mx_internal::kickOff();
         }
      }
      
      mx_internal function kickOff() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Class = null;
         if(this.document)
         {
            return;
         }
         if(!this.isTopLevel())
         {
            SystemManagerGlobals.topLevelSystemManagers[0].dispatchEvent(new FocusEvent(FlexEvent.NEW_CHILD_APPLICATION,false,false,this));
         }
         Singleton.registerClass("mx.core::IEmbeddedFontRegistry",Class(this.getDefinitionByName("mx.core::EmbeddedFontRegistry")));
         Singleton.registerClass("mx.styles::IStyleManager",Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.styles::IStyleManager2",Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.managers::IBrowserManager",Class(this.getDefinitionByName("mx.managers::BrowserManagerImpl")));
         Singleton.registerClass("mx.managers::ICursorManager",Class(this.getDefinitionByName("mx.managers::CursorManagerImpl")));
         Singleton.registerClass("mx.managers::IHistoryManager",Class(this.getDefinitionByName("mx.managers::HistoryManagerImpl")));
         Singleton.registerClass("mx.managers::ILayoutManager",Class(this.getDefinitionByName("mx.managers::LayoutManager")));
         Singleton.registerClass("mx.managers::IPopUpManager",Class(this.getDefinitionByName("mx.managers::PopUpManagerImpl")));
         Singleton.registerClass("mx.managers::IToolTipManager2",Class(this.getDefinitionByName("mx.managers::ToolTipManagerImpl")));
         var _loc1_:Class = null;
         var _loc2_:Object = this.info()["useNativeDragManager"];
         var _loc3_:Boolean = _loc2_ == null ? true : String(_loc2_) == "true";
         if(_loc3_)
         {
            _loc1_ = Class(this.getDefinitionByName("mx.managers::NativeDragManagerImpl"));
         }
         if(_loc1_ == null)
         {
            _loc1_ = Class(this.getDefinitionByName("mx.managers::DragManagerImpl"));
         }
         Singleton.registerClass("mx.managers::IDragManager",_loc1_);
         Singleton.registerClass("mx.core::ITextFieldFactory",Class(this.getDefinitionByName("mx.core::TextFieldFactory")));
         var _loc4_:Array = this.info()["mixins"];
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = Class(this.getDefinitionByName(_loc4_[_loc6_]));
               _loc7_["init"](this);
               _loc6_++;
            }
         }
         _loc7_ = Singleton.getClass("mx.managers::IActiveWindowManager");
         if(_loc7_)
         {
            this.registerImplementation("mx.managers::IActiveWindowManager",new _loc7_(this));
         }
         _loc7_ = Singleton.getClass("mx.managers::IMarshalSystemManager");
         if(_loc7_)
         {
            this.registerImplementation("mx.managers::IMarshalSystemManager",new _loc7_(this));
         }
         this.initializeTopLevelWindow(null);
         this.deferredNextFrame();
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyboardEvent = null;
         if(!param1.cancelable)
         {
            switch(param1.keyCode)
            {
               case Keyboard.UP:
               case Keyboard.DOWN:
               case Keyboard.PAGE_UP:
               case Keyboard.PAGE_DOWN:
               case Keyboard.HOME:
               case Keyboard.END:
               case Keyboard.LEFT:
               case Keyboard.RIGHT:
               case Keyboard.ENTER:
                  param1.stopImmediatePropagation();
                  _loc2_ = new KeyboardEvent(param1.type,param1.bubbles,true,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey);
                  param1.target.dispatchEvent(_loc2_);
            }
         }
      }
      
      private function mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:MouseEvent = null;
         if(!param1.cancelable)
         {
            param1.stopImmediatePropagation();
            _loc2_ = new MouseEvent(param1.type,param1.bubbles,true,param1.localX,param1.localY,param1.relatedObject,param1.ctrlKey,param1.altKey,param1.shiftKey,param1.buttonDown,param1.delta);
            param1.target.dispatchEvent(_loc2_);
         }
      }
      
      private function extraFrameHandler(param1:Event = null) : void
      {
         var _loc3_:Class = null;
         var _loc2_:Object = this.info()["frames"];
         if(Boolean(_loc2_) && Boolean(_loc2_[currentLabel]))
         {
            _loc3_ = Class(this.getDefinitionByName(_loc2_[currentLabel]));
            _loc3_["frame"](this);
         }
         this.deferredNextFrame();
      }
      
      private function nextFrameTimerHandler(param1:TimerEvent) : void
      {
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
            this.nextFrameTimer.removeEventListener(TimerEvent.TIMER,this.nextFrameTimerHandler);
            this.nextFrameTimer.reset();
         }
      }
      
      private function initializeTopLevelWindow(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:ISystemManager = null;
         var _loc6_:DisplayObject = null;
         if(!this.parent && this.parentAllowsChild)
         {
            return;
         }
         if(!this.mx_internal::topLevel)
         {
            if(!this.parent)
            {
               return;
            }
            _loc4_ = this.parent.parent;
            if(!_loc4_)
            {
               return;
            }
            while(_loc4_)
            {
               if(_loc4_ is IUIComponent)
               {
                  _loc5_ = IUIComponent(_loc4_).systemManager;
                  if((Boolean(_loc5_)) && !_loc5_.isTopLevel())
                  {
                     _loc5_ = _loc5_.topLevelSystemManager;
                  }
                  this._topLevelSystemManager = _loc5_;
                  break;
               }
               _loc4_ = _loc4_.parent;
            }
         }
         if(this.isTopLevelRoot() && Boolean(this.stage))
         {
            this.stage.addEventListener(Event.RESIZE,this.Stage_resizeHandler,false,0,true);
         }
         else if(this.mx_internal::topLevel && Boolean(this.stage))
         {
            _loc6_ = this.getSandboxRoot();
            if(_loc6_ != this)
            {
               _loc6_.addEventListener(Event.RESIZE,this.Stage_resizeHandler,false,0,true);
            }
         }
         if(this.mx_internal::isStageRoot && Boolean(this.stage))
         {
            this._width = this.stage.stageWidth;
            this._height = this.stage.stageHeight;
            if(this._width == 0 && this._height == 0 && loaderInfo.width != this._width && loaderInfo.height != this._height)
            {
               this._width = loaderInfo.width;
               this._height = loaderInfo.height;
            }
            _loc2_ = this._width;
            _loc3_ = this._height;
         }
         else
         {
            _loc2_ = loaderInfo.width;
            _loc3_ = loaderInfo.height;
         }
         this.mx_internal::childManager.initializeTopLevelWindow(_loc2_,_loc3_);
      }
      
      private function appCreationCompleteHandler(param1:FlexEvent) : void
      {
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function invalidateParentSizeAndDisplayList() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(!this.mx_internal::topLevel && Boolean(this.parent))
         {
            _loc1_ = this.parent.parent;
            while(_loc1_)
            {
               if(_loc1_ is IInvalidating)
               {
                  IInvalidating(_loc1_).invalidateSize();
                  IInvalidating(_loc1_).invalidateDisplayList();
                  return;
               }
               _loc1_ = _loc1_.parent;
            }
         }
         dispatchEvent(new Event("invalidateParentSizeAndDisplayList"));
      }
      
      private function Stage_resizeHandler(param1:Event = null) : void
      {
         var w:Number;
         var h:Number;
         var align:String;
         var x:Number;
         var y:Number;
         var m:Number = NaN;
         var n:Number = NaN;
         var event:Event = param1;
         if(this.isDispatchingResizeEvent)
         {
            return;
         }
         w = 0;
         h = 0;
         try
         {
            m = loaderInfo.width;
            n = loaderInfo.height;
         }
         catch(error:Error)
         {
            if(!mx_internal::_screen)
            {
               mx_internal::_screen = new Rectangle();
            }
            return;
         }
         align = StageAlign.TOP_LEFT;
         try
         {
            if(this.stage)
            {
               w = this.stage.stageWidth;
               h = this.stage.stageHeight;
               align = this.stage.align;
            }
         }
         catch(error:SecurityError)
         {
            if(hasEventListener("getScreen"))
            {
               dispatchEvent(new Event("getScreen"));
               if(mx_internal::_screen)
               {
                  w = mx_internal::_screen.width;
                  h = mx_internal::_screen.height;
               }
            }
         }
         x = (m - w) / 2;
         y = (n - h) / 2;
         if(align == StageAlign.TOP)
         {
            y = 0;
         }
         else if(align == StageAlign.BOTTOM)
         {
            y = n - h;
         }
         else if(align == StageAlign.LEFT)
         {
            x = 0;
         }
         else if(align == StageAlign.RIGHT)
         {
            x = m - w;
         }
         else if(align == StageAlign.TOP_LEFT || align == "LT")
         {
            y = 0;
            x = 0;
         }
         else if(align == StageAlign.TOP_RIGHT)
         {
            y = 0;
            x = m - w;
         }
         else if(align == StageAlign.BOTTOM_LEFT)
         {
            y = n - h;
            x = 0;
         }
         else if(align == StageAlign.BOTTOM_RIGHT)
         {
            y = n - h;
            x = m - w;
         }
         if(!this.mx_internal::_screen)
         {
            this.mx_internal::_screen = new Rectangle();
         }
         this.mx_internal::_screen.x = x;
         this.mx_internal::_screen.y = y;
         this.mx_internal::_screen.width = w;
         this.mx_internal::_screen.height = h;
         if(this.mx_internal::isStageRoot)
         {
            this._width = this.stage.stageWidth;
            this._height = this.stage.stageHeight;
         }
         if(event)
         {
            this.resizeMouseCatcher();
            this.isDispatchingResizeEvent = true;
            dispatchEvent(event);
            this.isDispatchingResizeEvent = false;
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.mx_internal::idleCounter = 0;
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         this.mx_internal::idleCounter = 0;
      }
      
      private function idleTimer_timerHandler(param1:TimerEvent) : void
      {
         ++this.mx_internal::idleCounter;
         if(this.mx_internal::idleCounter * IDLE_INTERVAL > IDLE_THRESHOLD)
         {
            dispatchEvent(new FlexEvent(FlexEvent.IDLE));
         }
      }
      
      override public function get mouseX() : Number
      {
         if(this.mx_internal::_mouseX === undefined)
         {
            return super.mouseX;
         }
         return this.mx_internal::_mouseX;
      }
      
      override public function get mouseY() : Number
      {
         if(this.mx_internal::_mouseY === undefined)
         {
            return super.mouseY;
         }
         return this.mx_internal::_mouseY;
      }
      
      private function getTopLevelSystemManager(param1:DisplayObject) : ISystemManager
      {
         var _loc3_:ISystemManager = null;
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.root);
         if((!_loc2_ || _loc2_ is Stage) && param1 is IUIComponent)
         {
            _loc2_ = DisplayObjectContainer(IUIComponent(param1).systemManager);
         }
         if(_loc2_ is ISystemManager)
         {
            _loc3_ = ISystemManager(_loc2_);
            if(!_loc3_.isTopLevel())
            {
               _loc3_ = _loc3_.topLevelSystemManager;
            }
         }
         return _loc3_;
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         try
         {
            return super.parent;
         }
         catch(e:SecurityError)
         {
         }
         return null;
      }
      
      public function getTopLevelRoot() : DisplayObject
      {
         var sm:ISystemManager = null;
         var parent:DisplayObject = null;
         var lastParent:DisplayObject = null;
         try
         {
            sm = this;
            if(sm.topLevelSystemManager)
            {
               sm = sm.topLevelSystemManager;
            }
            parent = DisplayObject(sm).parent;
            lastParent = DisplayObject(sm);
            while(parent)
            {
               if(parent is Stage)
               {
                  return lastParent;
               }
               lastParent = parent;
               parent = parent.parent;
            }
         }
         catch(error:SecurityError)
         {
         }
         return null;
      }
      
      public function getSandboxRoot() : DisplayObject
      {
         var parent:DisplayObject = null;
         var lastParent:DisplayObject = null;
         var loader:Loader = null;
         var loaderInfo:LoaderInfo = null;
         var sm:ISystemManager = this;
         try
         {
            if(sm.topLevelSystemManager)
            {
               sm = sm.topLevelSystemManager;
            }
            parent = DisplayObject(sm).parent;
            if(parent is Stage)
            {
               return DisplayObject(sm);
            }
            if(Boolean(parent) && !parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot",false,true)))
            {
               return this;
            }
            lastParent = this;
            while(parent)
            {
               if(parent is Stage)
               {
                  return lastParent;
               }
               if(!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot",false,true)))
               {
                  return lastParent;
               }
               if(parent is Loader)
               {
                  loader = Loader(parent);
                  loaderInfo = loader.contentLoaderInfo;
                  if(!loaderInfo.childAllowsParent)
                  {
                     return loaderInfo.content;
                  }
               }
               if(parent.hasEventListener("systemManagerRequest"))
               {
                  lastParent = parent;
               }
               parent = parent.parent;
            }
         }
         catch(error:Error)
         {
         }
         return lastParent != null ? lastParent : DisplayObject(sm);
      }
      
      public function registerImplementation(param1:String, param2:Object) : void
      {
         var _loc3_:Object = this.implMap[param1];
         if(!_loc3_)
         {
            this.implMap[param1] = param2;
         }
      }
      
      public function getImplementation(param1:String) : Object
      {
         return this.implMap[param1];
      }
      
      public function getVisibleApplicationRect(param1:Rectangle = null) : Rectangle
      {
         var _loc2_:Request = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Point = null;
         if(hasEventListener("getVisibleApplicationRect"))
         {
            _loc2_ = new Request("getVisibleApplicationRect",false,true);
            if(!dispatchEvent(_loc2_))
            {
               return Rectangle(_loc2_.value);
            }
         }
         if(!param1)
         {
            param1 = getBounds(DisplayObject(this));
            _loc3_ = this.screen;
            _loc4_ = new Point(Math.max(0,param1.x),Math.max(0,param1.y));
            _loc4_ = localToGlobal(_loc4_);
            param1.x = _loc4_.x;
            param1.y = _loc4_.y;
            param1.width = _loc3_.width;
            param1.height = _loc3_.height;
         }
         return param1;
      }
      
      public function deployMouseShields(param1:Boolean) : void
      {
         var _loc2_:DynamicEvent = null;
         if(hasEventListener("deployMouseShields"))
         {
            _loc2_ = new DynamicEvent("deployMouseShields");
            _loc2_.deploy = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      private function stageEventHandler(param1:Event) : void
      {
         if(param1.target is Stage && Boolean(this.mouseCatcher))
         {
            this.mouseCatcher.dispatchEvent(param1);
         }
      }
      
      private function mouseLeaveHandler(param1:Event) : void
      {
         dispatchEvent(new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE));
      }
   }
}


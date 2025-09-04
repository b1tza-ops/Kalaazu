package mx.managers
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.FlexEvent;
   import mx.managers.layoutClasses.PriorityQueue;
   
   use namespace mx_internal;
   
   public class LayoutManager extends EventDispatcher implements ILayoutManager
   {
      
      private static var instance:LayoutManager;
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      private var updateCompleteQueue:PriorityQueue = new PriorityQueue();
      
      private var invalidatePropertiesQueue:PriorityQueue = new PriorityQueue();
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var invalidateClientPropertiesFlag:Boolean = false;
      
      private var invalidateSizeQueue:PriorityQueue = new PriorityQueue();
      
      private var invalidateSizeFlag:Boolean = false;
      
      private var invalidateClientSizeFlag:Boolean = false;
      
      private var invalidateDisplayListQueue:PriorityQueue = new PriorityQueue();
      
      private var invalidateDisplayListFlag:Boolean = false;
      
      private var waitedAFrame:Boolean = false;
      
      private var listenersAttached:Boolean = false;
      
      private var originalFrameRate:Number;
      
      private var targetLevel:int = 2147483647;
      
      private var systemManager:ISystemManager;
      
      private var _usePhasedInstantiation:Boolean = false;
      
      private var _usingBridge:int = -1;
      
      public function LayoutManager()
      {
         super();
         this.systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
      }
      
      public static function getInstance() : LayoutManager
      {
         if(!instance)
         {
            instance = new LayoutManager();
         }
         return instance;
      }
      
      public function get usePhasedInstantiation() : Boolean
      {
         return this._usePhasedInstantiation;
      }
      
      public function set usePhasedInstantiation(param1:Boolean) : void
      {
         var stage:Stage = null;
         var value:Boolean = param1;
         if(this._usePhasedInstantiation != value)
         {
            this._usePhasedInstantiation = value;
            try
            {
               stage = this.systemManager.stage;
               if(stage)
               {
                  if(value)
                  {
                     this.originalFrameRate = stage.frameRate;
                     stage.frameRate = 1000;
                  }
                  else
                  {
                     stage.frameRate = this.originalFrameRate;
                  }
               }
            }
            catch(e:SecurityError)
            {
            }
         }
      }
      
      public function invalidateProperties(param1:ILayoutManagerClient) : void
      {
         if(!this.invalidatePropertiesFlag && Boolean(this.systemManager))
         {
            this.invalidatePropertiesFlag = true;
            if(!this.listenersAttached)
            {
               this.attachListeners(this.systemManager);
            }
         }
         if(this.targetLevel <= param1.nestLevel)
         {
            this.invalidateClientPropertiesFlag = true;
         }
         this.invalidatePropertiesQueue.addObject(param1,param1.nestLevel);
      }
      
      public function invalidateSize(param1:ILayoutManagerClient) : void
      {
         if(!this.invalidateSizeFlag && Boolean(this.systemManager))
         {
            this.invalidateSizeFlag = true;
            if(!this.listenersAttached)
            {
               this.attachListeners(this.systemManager);
            }
         }
         if(this.targetLevel <= param1.nestLevel)
         {
            this.invalidateClientSizeFlag = true;
         }
         this.invalidateSizeQueue.addObject(param1,param1.nestLevel);
      }
      
      public function invalidateDisplayList(param1:ILayoutManagerClient) : void
      {
         if(!this.invalidateDisplayListFlag && Boolean(this.systemManager))
         {
            this.invalidateDisplayListFlag = true;
            if(!this.listenersAttached)
            {
               this.attachListeners(this.systemManager);
            }
         }
         else if(!this.invalidateDisplayListFlag && !this.systemManager)
         {
         }
         this.invalidateDisplayListQueue.addObject(param1,param1.nestLevel);
      }
      
      private function validateProperties() : void
      {
         var _loc1_:ILayoutManagerClient = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallest());
         while(_loc1_)
         {
            _loc1_.validateProperties();
            if(!_loc1_.updateCompletePendingFlag)
            {
               this.updateCompleteQueue.addObject(_loc1_,_loc1_.nestLevel);
               _loc1_.updateCompletePendingFlag = true;
            }
            _loc1_ = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallest());
         }
         if(this.invalidatePropertiesQueue.isEmpty())
         {
            this.invalidatePropertiesFlag = false;
         }
      }
      
      private function validateSize() : void
      {
         var _loc1_:ILayoutManagerClient = ILayoutManagerClient(this.invalidateSizeQueue.removeLargest());
         while(_loc1_)
         {
            _loc1_.validateSize();
            if(!_loc1_.updateCompletePendingFlag)
            {
               this.updateCompleteQueue.addObject(_loc1_,_loc1_.nestLevel);
               _loc1_.updateCompletePendingFlag = true;
            }
            _loc1_ = ILayoutManagerClient(this.invalidateSizeQueue.removeLargest());
         }
         if(this.invalidateSizeQueue.isEmpty())
         {
            this.invalidateSizeFlag = false;
         }
      }
      
      private function validateDisplayList() : void
      {
         var _loc1_:ILayoutManagerClient = ILayoutManagerClient(this.invalidateDisplayListQueue.removeSmallest());
         while(_loc1_)
         {
            _loc1_.validateDisplayList();
            if(!_loc1_.updateCompletePendingFlag)
            {
               this.updateCompleteQueue.addObject(_loc1_,_loc1_.nestLevel);
               _loc1_.updateCompletePendingFlag = true;
            }
            _loc1_ = ILayoutManagerClient(this.invalidateDisplayListQueue.removeSmallest());
         }
         if(this.invalidateDisplayListQueue.isEmpty())
         {
            this.invalidateDisplayListFlag = false;
         }
      }
      
      private function doPhasedInstantiation() : void
      {
         var _loc1_:ILayoutManagerClient = null;
         if(this.usePhasedInstantiation)
         {
            if(this.invalidatePropertiesFlag)
            {
               this.validateProperties();
               this.systemManager.document.dispatchEvent(new Event("validatePropertiesComplete"));
            }
            else if(this.invalidateSizeFlag)
            {
               this.validateSize();
               this.systemManager.document.dispatchEvent(new Event("validateSizeComplete"));
            }
            else if(this.invalidateDisplayListFlag)
            {
               this.validateDisplayList();
               this.systemManager.document.dispatchEvent(new Event("validateDisplayListComplete"));
            }
         }
         else
         {
            if(this.invalidatePropertiesFlag)
            {
               this.validateProperties();
            }
            if(this.invalidateSizeFlag)
            {
               this.validateSize();
            }
            if(this.invalidateDisplayListFlag)
            {
               this.validateDisplayList();
            }
         }
         if(this.invalidatePropertiesFlag || this.invalidateSizeFlag || this.invalidateDisplayListFlag)
         {
            this.attachListeners(this.systemManager);
         }
         else
         {
            this.usePhasedInstantiation = false;
            this.listenersAttached = false;
            _loc1_ = ILayoutManagerClient(this.updateCompleteQueue.removeLargest());
            while(_loc1_)
            {
               if(!_loc1_.initialized && _loc1_.processedDescriptors)
               {
                  _loc1_.initialized = true;
               }
               if(_loc1_.hasEventListener(FlexEvent.UPDATE_COMPLETE))
               {
                  _loc1_.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
               }
               _loc1_.updateCompletePendingFlag = false;
               _loc1_ = ILayoutManagerClient(this.updateCompleteQueue.removeLargest());
            }
            dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
         }
      }
      
      public function validateNow() : void
      {
         var _loc1_:int = 0;
         if(!this.usePhasedInstantiation)
         {
            _loc1_ = 0;
            while(this.listenersAttached && _loc1_++ < 100)
            {
               this.doPhasedInstantiation();
            }
         }
      }
      
      public function validateClient(param1:ILayoutManagerClient, param2:Boolean = false) : void
      {
         var _loc3_:ILayoutManagerClient = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = this.targetLevel;
         if(this.targetLevel == int.MAX_VALUE)
         {
            this.targetLevel = param1.nestLevel;
         }
         while(!_loc5_)
         {
            _loc5_ = true;
            _loc3_ = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallestChild(param1));
            while(_loc3_)
            {
               _loc3_.validateProperties();
               if(!_loc3_.updateCompletePendingFlag)
               {
                  this.updateCompleteQueue.addObject(_loc3_,_loc3_.nestLevel);
                  _loc3_.updateCompletePendingFlag = true;
               }
               _loc3_ = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallestChild(param1));
            }
            if(this.invalidatePropertiesQueue.isEmpty())
            {
               this.invalidatePropertiesFlag = false;
               this.invalidateClientPropertiesFlag = false;
            }
            _loc3_ = ILayoutManagerClient(this.invalidateSizeQueue.removeLargestChild(param1));
            while(_loc3_)
            {
               _loc3_.validateSize();
               if(!_loc3_.updateCompletePendingFlag)
               {
                  this.updateCompleteQueue.addObject(_loc3_,_loc3_.nestLevel);
                  _loc3_.updateCompletePendingFlag = true;
               }
               if(this.invalidateClientPropertiesFlag)
               {
                  _loc3_ = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallestChild(param1));
                  if(_loc3_)
                  {
                     this.invalidatePropertiesQueue.addObject(_loc3_,_loc3_.nestLevel);
                     _loc5_ = false;
                     break;
                  }
               }
               _loc3_ = ILayoutManagerClient(this.invalidateSizeQueue.removeLargestChild(param1));
            }
            if(this.invalidateSizeQueue.isEmpty())
            {
               this.invalidateSizeFlag = false;
               this.invalidateClientSizeFlag = false;
            }
            if(!param2)
            {
               _loc3_ = ILayoutManagerClient(this.invalidateDisplayListQueue.removeSmallestChild(param1));
               while(_loc3_)
               {
                  _loc3_.validateDisplayList();
                  if(!_loc3_.updateCompletePendingFlag)
                  {
                     this.updateCompleteQueue.addObject(_loc3_,_loc3_.nestLevel);
                     _loc3_.updateCompletePendingFlag = true;
                  }
                  if(this.invalidateClientPropertiesFlag)
                  {
                     _loc3_ = ILayoutManagerClient(this.invalidatePropertiesQueue.removeSmallestChild(param1));
                     if(_loc3_)
                     {
                        this.invalidatePropertiesQueue.addObject(_loc3_,_loc3_.nestLevel);
                        _loc5_ = false;
                        break;
                     }
                  }
                  if(this.invalidateClientSizeFlag)
                  {
                     _loc3_ = ILayoutManagerClient(this.invalidateSizeQueue.removeLargestChild(param1));
                     if(_loc3_)
                     {
                        this.invalidateSizeQueue.addObject(_loc3_,_loc3_.nestLevel);
                        _loc5_ = false;
                        break;
                     }
                  }
                  _loc3_ = ILayoutManagerClient(this.invalidateDisplayListQueue.removeSmallestChild(param1));
               }
               if(this.invalidateDisplayListQueue.isEmpty())
               {
                  this.invalidateDisplayListFlag = false;
               }
            }
         }
         if(_loc6_ == int.MAX_VALUE)
         {
            this.targetLevel = int.MAX_VALUE;
            if(!param2)
            {
               _loc3_ = ILayoutManagerClient(this.updateCompleteQueue.removeLargestChild(param1));
               while(_loc3_)
               {
                  if(!_loc3_.initialized)
                  {
                     _loc3_.initialized = true;
                  }
                  if(_loc3_.hasEventListener(FlexEvent.UPDATE_COMPLETE))
                  {
                     _loc3_.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
                  }
                  _loc3_.updateCompletePendingFlag = false;
                  _loc3_ = ILayoutManagerClient(this.updateCompleteQueue.removeLargestChild(param1));
               }
            }
         }
      }
      
      public function isInvalid() : Boolean
      {
         return this.invalidatePropertiesFlag || this.invalidateSizeFlag || this.invalidateDisplayListFlag;
      }
      
      private function waitAFrame(param1:Event) : void
      {
         this.systemManager.removeEventListener(Event.ENTER_FRAME,this.waitAFrame);
         this.systemManager.addEventListener(Event.ENTER_FRAME,this.doPhasedInstantiationCallback);
         this.waitedAFrame = true;
      }
      
      private function attachListeners(param1:ISystemManager) : void
      {
         if(!this.waitedAFrame)
         {
            param1.addEventListener(Event.ENTER_FRAME,this.waitAFrame);
         }
         else
         {
            param1.addEventListener(Event.ENTER_FRAME,this.doPhasedInstantiationCallback);
            if(!this.usePhasedInstantiation)
            {
               if(Boolean(param1) && (param1.stage || this.usingBridge(param1)))
               {
                  param1.addEventListener(Event.RENDER,this.doPhasedInstantiationCallback);
                  if(param1.stage)
                  {
                     param1.stage.invalidate();
                  }
               }
            }
         }
         this.listenersAttached = true;
      }
      
      private function doPhasedInstantiationCallback(param1:Event) : void
      {
         var callLaterErrorEvent:DynamicEvent = null;
         var event:Event = param1;
         if(UIComponentGlobals.mx_internal::callLaterSuspendCount > 0)
         {
            return;
         }
         this.systemManager.removeEventListener(Event.ENTER_FRAME,this.doPhasedInstantiationCallback);
         this.systemManager.removeEventListener(Event.RENDER,this.doPhasedInstantiationCallback);
         if(!UIComponentGlobals.catchCallLaterExceptions)
         {
            this.doPhasedInstantiation();
         }
         else
         {
            try
            {
               this.doPhasedInstantiation();
            }
            catch(e:Error)
            {
               callLaterErrorEvent = new DynamicEvent("callLaterError");
               callLaterErrorEvent.error = e;
               callLaterErrorEvent.source = this;
               systemManager.dispatchEvent(callLaterErrorEvent);
            }
         }
      }
      
      private function usingBridge(param1:ISystemManager) : Boolean
      {
         if(this._usingBridge == 0)
         {
            return false;
         }
         if(this._usingBridge == 1)
         {
            return true;
         }
         if(!param1)
         {
            return false;
         }
         var _loc2_:Object = param1.getImplementation("mx.managers::IMarshalSystemManager");
         if(!_loc2_)
         {
            this._usingBridge = 0;
            return false;
         }
         if(_loc2_.useSWFBridge())
         {
            this._usingBridge = 1;
            return true;
         }
         this._usingBridge = 0;
         return false;
      }
   }
}


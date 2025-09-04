package net.bigpoint.as3toolbox.bitmapclip
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   internal class AnimationManager
   {
      
      private static var clipList:Object;
      
      private static var stage:Stage;
      
      private static var enterFrameHandlerAdded:Boolean;
      
      private static var deltaTime:int = 0;
      
      private static var oldDeltaTime:int = -1;
      
      public function AnimationManager()
      {
         super();
      }
      
      public static function initStage(param1:Stage) : void
      {
         if(stage == null)
         {
            stage = param1;
         }
      }
      
      internal static function initCollections() : void
      {
         clipList = new Vector.<BitmapClip>();
      }
      
      private static function handleEnterFrame(param1:Event) : void
      {
         var _loc4_:BitmapClip = null;
         if(clipList.length == 0)
         {
            stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
            enterFrameHandlerAdded = false;
            return;
         }
         var _loc2_:int = getTimer();
         deltaTime = _loc2_ - oldDeltaTime;
         oldDeltaTime = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < clipList.length)
         {
            _loc4_ = clipList[_loc3_] as BitmapClip;
            if(_loc4_.remove)
            {
               clipList.splice(_loc3_,1);
               _loc3_--;
               if(_loc4_._autoDeleteCache && _loc4_.parent == null)
               {
                  _loc4_.unregisterCacheID();
               }
            }
            else
            {
               _loc4_.update(deltaTime);
            }
            _loc3_++;
         }
      }
      
      internal static function addClip(param1:BitmapClip) : void
      {
         var _loc2_:BitmapClip = null;
         if(clipList == null)
         {
            initCollections();
         }
         for each(_loc2_ in clipList)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         clipList.push(param1);
      }
      
      internal static function addEnterFrameHandler() : void
      {
         if(!enterFrameHandlerAdded)
         {
            oldDeltaTime = getTimer();
            stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
            enterFrameHandlerAdded = true;
         }
      }
   }
}


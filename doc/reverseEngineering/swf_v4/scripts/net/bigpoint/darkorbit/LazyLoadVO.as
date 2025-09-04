package net.bigpoint.darkorbit
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LazyLoadVO
   {
      
      private static var logger:ILogger = Log.getLogger("LazyLoadVO");
      
      public var callbackCompleteList:Array = [];
      
      public var callbackErrorList:Array = [];
      
      public var isLoaded:Boolean = false;
      
      private var resKey:String;
      
      public function LazyLoadVO(param1:String, param2:Function, param3:Function)
      {
         super();
         this.resKey = param1;
         this.addCompleteCallback(param2);
         this.addErrorCallback(param3);
      }
      
      public function load() : void
      {
         if(!ResourceManager.fileCollection.isLoaded(this.resKey))
         {
            ResourceManager.fileCollection.load(this.resKey,this.assetLoaded);
         }
      }
      
      public function assetLoaded(param1:SWFFinisher = null) : void
      {
         this.isLoaded = true;
         this.callAllCompleteCallbacks();
      }
      
      public function assetLoadError() : void
      {
         this.callAllErrorCallbacks();
      }
      
      public function callAllCompleteCallbacks() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.callbackCompleteList.length)
         {
            this.callbackCompleteList[_loc1_](null);
            _loc1_++;
         }
      }
      
      public function callAllErrorCallbacks() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.callbackErrorList.length)
         {
            this.callbackErrorList[_loc1_]();
            _loc1_++;
         }
      }
      
      public function addCompleteCallback(param1:Function) : void
      {
         this.callbackCompleteList.push(param1);
      }
      
      public function addErrorCallback(param1:Function) : void
      {
         this.callbackErrorList.push(param1);
      }
   }
}


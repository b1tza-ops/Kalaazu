package net.bigpoint.darkorbit.pattern
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class BannerAdPattern
   {
      
      private static const logger:ILogger = Log.getLogger("BannerAdPattern");
      
      public static const BANNERAD_SWF_PREFIX:String = "bannerad_";
      
      public static const BANNERAD_IMAGE_SUFFIX:String = "_text0";
      
      public var id:int;
      
      public var price:Number = -1;
      
      public var baseKey:String;
      
      public var paymentKey:String;
      
      public var footerKey:String;
      
      public var windowID:int;
      
      public var assetCount:int;
      
      public function BannerAdPattern(param1:int, param2:String, param3:String, param4:int)
      {
         super();
         this.id = param1;
         this.windowID = 4000 + param1;
         this.baseKey = param2;
         this.paymentKey = param3;
         this.assetCount = param4;
      }
      
      public function getSWFLibID() : String
      {
         return BANNERAD_SWF_PREFIX + this.baseKey;
      }
      
      public function getImageLibID(param1:String) : String
      {
         return param1 + "_" + BANNERAD_SWF_PREFIX + this.baseKey + BANNERAD_IMAGE_SUFFIX;
      }
   }
}


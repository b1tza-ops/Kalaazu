package net.bigpoint.darkorbit.lazyload
{
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.BannerAdPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class BannerAdLazyLoader extends EventDispatcher
   {
      
      public static const RESOURCE_LINK:String = "flashinput/dynamicPaymentItems.php";
      
      public static const XML_TEMPLATE:String = "<catalog><achievements><item id=\"2\" price=\"1.9900\" currency=\"EUR\"/><item id=\"4\" price=\"0.9900\" currency=\"EUR\"/><item id=\"6\" price=\"0.9900\" currency=\"EUR\"/><item id=\"7\" price=\"0.9900\" currency=\"EUR\"/><item id=\"9\" price=\"0.9900\" currency=\"EUR\"/><item id=\"10\" price=\"0.9900\" currency=\"EUR\"/><item id=\"11\" price=\"0.9900\" currency=\"EUR\"/><item id=\"12\" price=\"0.9900\" currency=\"EUR\"/></achievements><specialOffer><item id=\"1\" price=\"0.9900\" currency=\"EUR\"/><item id=\"2\" price=\"4.9900\" currency=\"EUR\"/><item id=\"3\" price=\"4.9900\" currency=\"EUR\"/><item id=\"4\" price=\"1.9900\" currency=\"EUR\"/></specialOffer></catalog>";
      
      public static const BANNERAD_LOADED:String = "BANNERAD_LOADED";
      
      private static var logger:ILogger = Log.getLogger("BannerAdLazyLoader");
      
      private var pattern:BannerAdPattern;
      
      public function BannerAdLazyLoader(param1:BannerAdPattern)
      {
         super();
         this.pattern = param1;
      }
      
      public static function loadBannerAdPatternAddon() : void
      {
         var _loc1_:URLRequest = null;
         _loc1_ = new URLRequest(Settings.dynamicHost + RESOURCE_LINK);
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,handleBannerAddonsXMLLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,handleXMLLoadingError);
         _loc2_.load(_loc1_);
      }
      
      private static function handleXMLLoadingError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,handleBannerAddonsXMLLoaded);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleXMLLoadingError);
      }
      
      private static function handleBannerAddonsXMLLoaded(param1:Event) : void
      {
         var bannerPatternXML:XML = null;
         var event:Event = param1;
         event.target.removeEventListener(Event.COMPLETE,handleBannerAddonsXMLLoaded);
         event.target.removeEventListener(IOErrorEvent.IO_ERROR,handleXMLLoadingError);
         try
         {
            bannerPatternXML = XML(event.currentTarget.data);
         }
         catch(e:Error)
         {
         }
         if(bannerPatternXML == null || bannerPatternXML.specialOffer.item.length() == 0)
         {
            bannerPatternXML = new XML(XML_TEMPLATE);
         }
         PatternManager.parseSpecialOfferPrices(bannerPatternXML.specialOffer.item);
      }
      
      public function loadBannerAd() : void
      {
         var _loc1_:String = this.pattern.getSWFLibID();
         if(!ResourceManager.fileCollection.isLoaded(_loc1_))
         {
            ResourceManager.fileCollection.load(_loc1_,this.handleBannerAdSWFLoaded);
         }
      }
      
      private function handleBannerAdSWFLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:String = this.pattern.getImageLibID(Settings.language);
         if(this.pattern.assetCount > 0)
         {
            if(!ResourceManager.fileCollection.isLoaded(_loc2_))
            {
               ResourceManager.fileCollection.load(_loc2_,this.handleBannerImageLoaded);
            }
         }
         else
         {
            this.handleBannerImageLoaded();
         }
      }
      
      public function isLoaded() : Boolean
      {
         if(this.pattern.assetCount > 0)
         {
            return ResourceManager.fileCollection.isLoaded(this.pattern.getImageLibID(Settings.language));
         }
         return ResourceManager.fileCollection.isLoaded(this.pattern.getSWFLibID());
      }
      
      private function handleBannerImageLoaded(param1:ImageFinisher = null) : void
      {
         dispatchEvent(new Event(BANNERAD_LOADED));
      }
   }
}


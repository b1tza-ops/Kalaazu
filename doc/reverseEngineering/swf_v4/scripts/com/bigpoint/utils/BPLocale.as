package com.bigpoint.utils
{
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import mx.formatters.NumberBaseRoundType;
   import mx.formatters.NumberFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   
   public class BPLocale
   {
      
      private static var _language:String;
      
      private static var _host:String;
      
      private static var _path:String;
      
      private static var _ed:EventDispatcher;
      
      public static var THOUSANDS_SEPARATOR:String;
      
      public static var DECIMALS_SEPARATOR:String;
      
      private static var intFormatter:NumberFormatter;
      
      private static var floatFormatter:NumberFormatter;
      
      private static const logger:ILogger = Log.getLogger("BPLocale");
      
      private static var _textMap:Array = [];
      
      public function BPLocale()
      {
         super();
      }
      
      public static function load(param1:int = 1) : void
      {
         loadLanguage(_host + _path.replace(/%LANG%/,_language),param1);
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         _ed.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         _ed.dispatchEvent(param1);
      }
      
      private static function loadLanguage(param1:String, param2:int = 1) : void
      {
         var _loc3_:URLRequest = null;
         var _loc4_:String = "lang_dev.xml";
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(Event.COMPLETE,languageLoaded);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,errorLoadingLanguage);
         if(param2 == Main.ENV_LOCAL_SERVER)
         {
            _loc3_ = new URLRequest("xml/" + _loc4_);
         }
         else
         {
            _loc3_ = new URLRequest(param1);
         }
         _loc5_.load(_loc3_);
         setNumberSeparators();
      }
      
      private static function setNumberSeparators() : void
      {
         setText("thousands_separator",",");
         setText("decimal_separator",".");
         updateNumberSeparators();
      }
      
      private static function updateNumberSeparators() : void
      {
         if(getText("decimal_separator") != " " && getText("thousands_separator") != " " && getText("thousands_separator") != getText("decimal_separator"))
         {
            THOUSANDS_SEPARATOR = getText("thousands_separator");
            DECIMALS_SEPARATOR = getText("decimal_separator");
            intFormatter = new NumberFormatter();
            intFormatter.thousandsSeparatorTo = THOUSANDS_SEPARATOR;
            intFormatter.decimalSeparatorTo = DECIMALS_SEPARATOR;
            intFormatter.rounding = NumberBaseRoundType.NEAREST;
            floatFormatter = new NumberFormatter();
            floatFormatter.thousandsSeparatorTo = THOUSANDS_SEPARATOR;
            floatFormatter.decimalSeparatorTo = DECIMALS_SEPARATOR;
            floatFormatter.rounding = NumberBaseRoundType.NEAREST;
         }
      }
      
      private static function errorLoadingLanguage(param1:IOErrorEvent) : void
      {
         _ed.dispatchEvent(new BPLocaleEvent(BPLocaleEvent.LANGUAGE_LOADING_ERROR));
         logger.info("lang load error");
      }
      
      public static function replaceWithFormattedPrice(param1:Number, param2:String, param3:RegExp, param4:String) : String
      {
         return PriceFormatter.instance.format(param1,param2,param3,param4);
      }
      
      private static function languageLoaded(param1:Event) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         _loc2_ = new XML(param1.target.data);
         for each(_loc3_ in _loc2_.item)
         {
            setText(_loc3_.@id,_loc3_.valueOf());
         }
         updateNumberSeparators();
         dispatchEvent(new BPLocaleEvent(BPLocaleEvent.LANGUAGELOADED));
      }
      
      public static function initProxy(param1:Dictionary) : void
      {
         var _loc2_:Object = null;
         for(_loc2_ in param1)
         {
            setText(String(_loc2_),String(param1[_loc2_]));
         }
      }
      
      public static function getText(param1:String) : String
      {
         var _loc2_:Object = _textMap[param1];
         if(_loc2_ != null)
         {
            return String(_loc2_);
         }
         return "";
      }
      
      private static function setText(param1:String, param2:String) : void
      {
         _textMap[param1] = param2;
      }
      
      public static function setEntry(param1:String, param2:String) : void
      {
         _textMap[param1] = param2;
      }
      
      public static function get language() : String
      {
         return _language;
      }
      
      public static function set language(param1:String) : void
      {
         _language = param1;
      }
      
      public static function get host() : String
      {
         return _host;
      }
      
      public static function set host(param1:String) : void
      {
         _host = param1;
      }
      
      public static function get path() : String
      {
         return _path;
      }
      
      public static function set path(param1:String) : void
      {
         _path = param1;
      }
      
      public static function round(param1:Number, param2:int = 0) : String
      {
         floatFormatter.precision = param2;
         return floatFormatter.format(param1);
      }
      
      public static function roundInteger(param1:Number) : String
      {
         return intFormatter.format(param1);
      }
      
      public static function distillAndWrite(param1:String, param2:TextField, param3:String = "left", param4:TextFormat = null) : Boolean
      {
         var _loc7_:int = 0;
         var _loc5_:Number = param2.width;
         param2.autoSize = param3;
         param2.text = param1;
         if(param4 != null)
         {
            param2.defaultTextFormat = param4;
         }
         if(param2.width <= _loc5_)
         {
            return false;
         }
         var _loc6_:* = param1;
         while(param2.width > _loc5_)
         {
            _loc7_ = _loc6_.length;
            _loc6_ = _loc6_.substring(0,_loc7_ - 3) + "… ";
            param2.text = _loc6_;
         }
         return true;
      }
   }
}


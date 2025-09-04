package com.bigpoint.utils
{
   import flash.events.Event;
   
   public class BPLocaleEvent extends Event
   {
      
      public static const LANGUAGELOADED:String = "BPLocaleEvent.onLanguageLoaded";
      
      public static const LANGUAGE_LOADING_ERROR:String = "BPLocaleEvent.onLanguageLoadingError";
      
      public static const LANGUAGE_PARSING_ERROR:String = "BPLocaleEvent.onLanguageParsingError";
      
      public static const LANGUAGE_TRANSLATION_MISSING:String = "BPLocaleEvent.onLanguageTranslationMissing";
      
      public function BPLocaleEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}


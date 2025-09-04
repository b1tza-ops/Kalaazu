package com.bigpoint.utils
{
   import mx.utils.StringUtil;
   
   public class TextReplacementList
   {
      
      public var textReplacements:Array = [];
      
      public function TextReplacementList()
      {
         super();
      }
      
      public static function parseRawTextReplacement(param1:String) : TextReplacementList
      {
         var _loc3_:Array = null;
         var _loc4_:TextReplacement = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:TextReplacementList = new TextReplacementList();
         param1 = StringUtil.trim(param1);
         if(param1.charAt(0) == "[")
         {
            param1 = param1.substring(1,param1.length - 1);
         }
         if(param1.charAt(param1.length - 1) == "]")
         {
            param1.substring(0,param1.length - 2);
         }
         if(param1.charAt(0) == "{")
         {
            param1 = param1.substring(1,param1.length - 1);
         }
         if(param1.charAt(param1.length - 1) == "}")
         {
            param1.substring(0,param1.length - 2);
         }
         if(param1.indexOf("},{") > 0)
         {
            _loc3_ = param1.split("},{");
         }
         else
         {
            _loc3_ = [param1];
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc4_ = new TextReplacement();
            _loc5_ = (_loc3_[_loc7_] as String).split(",");
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               _loc6_ = (_loc5_[_loc8_] as String).split(":");
               _loc6_[0] = StringUtil.trim(_loc6_[0]);
               _loc6_[1] = StringUtil.trim(_loc6_[1]);
               switch(_loc6_[0])
               {
                  case "w":
                     _loc4_.wildcard = _loc6_[1];
                     break;
                  case "t":
                     _loc4_.type = int(_loc6_[1]);
                     break;
                  case "v":
                     _loc4_.value = _loc6_[1];
                     break;
                  case "p":
                     _loc4_.precision = int(_loc6_[1]);
                     break;
               }
               _loc8_++;
            }
            _loc2_.textReplacements.push(_loc4_);
            _loc7_++;
         }
         return _loc2_;
      }
      
      public function replace(param1:String) : String
      {
         var _loc3_:TextReplacement = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.textReplacements.length)
         {
            _loc3_ = this.textReplacements[_loc2_];
            switch(_loc3_.type)
            {
               case TextReplacement.TYPE_PLAIN:
                  param1 = param1.replace(_loc3_.wildcard,_loc3_.value);
                  break;
               case TextReplacement.TYPE_NUMBER:
                  param1 = param1.replace(_loc3_.wildcard,BPLocale.round(int(_loc3_.value),_loc3_.precision));
                  break;
               case TextReplacement.TYPE_KEY:
                  param1 = param1.replace(_loc3_.wildcard,BPLocale.getText(_loc3_.value));
                  break;
               case TextReplacement.TYPE_TIME:
                  param1 = param1.replace(_loc3_.wildcard,TimeFormatter.formatTime(int(_loc3_.value)));
                  break;
            }
            _loc2_++;
         }
         return param1;
      }
   }
}


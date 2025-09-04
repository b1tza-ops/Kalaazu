package net.bigpoint.darkorbit.pattern
{
   public class OrePattern extends ResourcePattern
   {
      
      public static var ORE_PROMETIUM:int = 1;
      
      public static var ORE_ENDURIUM:int = 2;
      
      public static var ORE_TERBIUM:int = 3;
      
      public static var ORE_XENOMIT:int = 4;
      
      public static var ORE_PROMETID:int = 11;
      
      public static var ORE_DURANIUM:int = 12;
      
      public static var ORE_PROMERIUM:int = 13;
      
      public static var ORE_SEPROM:int = 14;
      
      public static var ORE_PALLADIUM:int = 15;
      
      private var _languageKey:String;
      
      private var _refiners:Array = [];
      
      private var _count:int;
      
      private var _price:int;
      
      public function OrePattern(param1:int, param2:String, param3:String)
      {
         super(param1,param2);
         this._languageKey = param3;
      }
      
      public function get languageKey() : String
      {
         return this._languageKey;
      }
      
      public function parseRefiners(param1:String) : void
      {
         var _loc4_:RefinerInfo = null;
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new RefinerInfo(_loc2_[_loc3_],_loc2_[_loc3_ + 1]);
            this._refiners.push(_loc4_);
            _loc3_++;
            _loc3_++;
         }
      }
      
      public function get refiners() : Array
      {
         return this._refiners;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function set price(param1:int) : void
      {
         this._price = param1;
      }
   }
}


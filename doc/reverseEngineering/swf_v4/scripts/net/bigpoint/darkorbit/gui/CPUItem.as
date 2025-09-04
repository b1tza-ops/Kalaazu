package net.bigpoint.darkorbit.gui
{
   public class CPUItem
   {
      
      public static const TYPE_RADAR:int = 0;
      
      public static const TYPE_JUMP:int = 1;
      
      public static const TYPE_CLOAK:int = 2;
      
      public static const TYPE_AROL:int = 3;
      
      public static const TYPE_ROBOT:int = 4;
      
      public static const TYPE_AIM:int = 5;
      
      public static const TYPE_HM7:int = 6;
      
      public static const TYPE_DRONE_REPAIR:int = 7;
      
      public static const TYPE_AMMOBUY:int = 8;
      
      public static const TYPE_RLLB:int = 9;
      
      public static const TYPE_ROCKETBUY:int = 10;
      
      public static const TYPE_ADVANCED_JUMP:int = 11;
      
      public static const TYPE_SMARTBOMB:int = 12;
      
      public static const TYPE_INSTASHIELD:int = 13;
      
      public static const TYPE_MINETURBO:int = 14;
      
      private var _type:int;
      
      public var amount:int;
      
      public var level:int = 0;
      
      public var state:Boolean;
      
      public function CPUItem(param1:int)
      {
         super();
         this._type = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
   }
}


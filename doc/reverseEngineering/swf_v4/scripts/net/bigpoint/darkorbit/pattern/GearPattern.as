package net.bigpoint.darkorbit.pattern
{
   public class GearPattern
   {
      
      public var id:int;
      
      public var resKey:String;
      
      public var effect:int;
      
      public var standardBackgroundReskey:String;
      
      public var activeBackgroundReskey:String;
      
      public var gearName:String;
      
      public var targetListKey:String;
      
      public var suffix:String;
      
      public function GearPattern(param1:int, param2:String, param3:String, param4:int, param5:String, param6:String, param7:String, param8:String)
      {
         super();
         this.gearName = param2;
         this.id = param1;
         this.resKey = param3;
         this.effect = param4;
         this.standardBackgroundReskey = param5;
         this.activeBackgroundReskey = param6;
         this.suffix = param8;
         this.targetListKey = param7;
      }
   }
}


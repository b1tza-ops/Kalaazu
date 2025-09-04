package net.bigpoint.darkorbit.gui.elements.numericstepper
{
   import flash.events.Event;
   
   public class NumericStepperEvent extends Event
   {
      
      public static const CHANGE:String = "CHANGE";
      
      public var value:int;
      
      public function NumericStepperEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.value = param2;
      }
   }
}


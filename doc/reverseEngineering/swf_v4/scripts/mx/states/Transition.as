package mx.states
{
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   
   use namespace mx_internal;
   
   public class Transition
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      public var effect:IEffect;
      
      public var fromState:String = "*";
      
      public var toState:String = "*";
      
      public var autoReverse:Boolean = false;
      
      public function Transition()
      {
         super();
      }
   }
}


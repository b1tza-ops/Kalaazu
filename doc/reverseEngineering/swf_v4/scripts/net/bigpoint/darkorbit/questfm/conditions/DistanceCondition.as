package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class DistanceCondition extends Condition
   {
      
      public function DistanceCondition()
      {
         super();
      }
      
      override public function get currentVerbose() : String
      {
         return BPLocale.roundInteger(_current);
      }
   }
}


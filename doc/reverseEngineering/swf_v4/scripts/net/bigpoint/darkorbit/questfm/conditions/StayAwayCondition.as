package net.bigpoint.darkorbit.questfm.conditions
{
   public class StayAwayCondition extends Condition
   {
      
      public function StayAwayCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


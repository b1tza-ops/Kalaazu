package net.bigpoint.darkorbit.questfm.conditions
{
   public class KillAnyCondition extends Condition
   {
      
      public function KillAnyCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


package net.bigpoint.darkorbit.questfm.conditions
{
   public class AvoidJumpCondition extends Condition
   {
      
      public function AvoidJumpCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


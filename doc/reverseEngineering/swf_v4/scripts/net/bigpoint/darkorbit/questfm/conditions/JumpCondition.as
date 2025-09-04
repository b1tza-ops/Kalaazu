package net.bigpoint.darkorbit.questfm.conditions
{
   public class JumpCondition extends Condition
   {
      
      public function JumpCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


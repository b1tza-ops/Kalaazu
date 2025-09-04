package net.bigpoint.darkorbit.questfm.conditions
{
   public class AvoidDamagePlayersCondition extends Condition
   {
      
      public function AvoidDamagePlayersCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


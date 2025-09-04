package net.bigpoint.darkorbit.questfm.conditions
{
   public class AvoidDamageNPCsCondition extends Condition
   {
      
      public function AvoidDamageNPCsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


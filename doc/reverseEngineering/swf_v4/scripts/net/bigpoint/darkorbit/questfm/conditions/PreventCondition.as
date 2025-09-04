package net.bigpoint.darkorbit.questfm.conditions
{
   public class PreventCondition extends Condition
   {
      
      public function PreventCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = _definition.TRANS_BASE_KEY;
      }
   }
}


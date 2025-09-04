package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class ClientCondition extends Condition
   {
      
      public function ClientCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_clickFaqButton");
      }
   }
}


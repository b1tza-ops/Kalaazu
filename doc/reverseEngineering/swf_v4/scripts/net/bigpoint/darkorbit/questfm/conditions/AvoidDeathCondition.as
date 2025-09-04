package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class AvoidDeathCondition extends Condition
   {
      
      public function AvoidDeathCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         if(_target > 0)
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_n").replace(/%count%/,_target);
         }
      }
   }
}


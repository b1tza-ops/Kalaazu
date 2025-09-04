package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class InGroupCondition extends Condition
   {
      
      private var _groupSize:int;
      
      public function InGroupCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         this._groupSize = int(param1);
         if(this._groupSize > 2)
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_size").replace(/%count%/,this._groupSize);
         }
         else
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY);
         }
      }
   }
}


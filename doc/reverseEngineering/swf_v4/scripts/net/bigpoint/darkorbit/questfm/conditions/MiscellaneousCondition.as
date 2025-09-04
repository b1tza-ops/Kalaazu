package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class MiscellaneousCondition extends Condition
   {
      
      public function MiscellaneousCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:int = int(param1);
         var _loc3_:String = _definition.TRANS_BASE_KEY + "_" + MiscellaneousConditionTypes.instance.getTranslationSuffix(_loc2_);
         _description = BPLocale.getText("q2_condition_" + _loc3_);
      }
   }
}


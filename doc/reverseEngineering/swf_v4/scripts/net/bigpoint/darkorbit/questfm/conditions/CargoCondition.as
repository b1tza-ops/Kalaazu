package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class CargoCondition extends Condition
   {
      
      public function CargoCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         if(_target == 0)
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
         else
         {
            _target_plain = "/" + _target;
            _description = description.replace(/%count%/,_target);
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


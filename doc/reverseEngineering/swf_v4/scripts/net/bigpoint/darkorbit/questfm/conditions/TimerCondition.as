package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.TimeFormatter;
   
   public class TimerCondition extends Condition
   {
      
      public function TimerCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         _target /= 1000;
         if(_target == 0)
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return TimeFormatter.formatTime(int(_current / 1000));
      }
   }
}


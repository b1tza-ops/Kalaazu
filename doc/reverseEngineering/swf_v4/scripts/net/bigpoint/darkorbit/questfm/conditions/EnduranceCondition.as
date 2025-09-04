package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TimeFormatter;
   
   public class EnduranceCondition extends Condition
   {
      
      private var _timeVerbose:String;
      
      public function EnduranceCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         _target /= 1000;
         _current /= 1000;
         this._timeVerbose = TimeFormatter.formatTime(_target);
         _description = _description.replace(/%TIME%/,this._timeVerbose);
      }
      
      override public function get currentVerbose() : String
      {
         return TimeFormatter.formatTime(_current);
      }
      
      override public function set current(param1:int) : void
      {
         _current = param1 / 1000;
      }
   }
}


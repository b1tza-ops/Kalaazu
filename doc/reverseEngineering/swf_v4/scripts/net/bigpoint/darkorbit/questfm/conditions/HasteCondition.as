package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TimeFormatter;
   
   public class HasteCondition extends Condition
   {
      
      private var _timeVerbose:String;
      
      public function HasteCondition()
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
         return TimeFormatter.formatTime(Math.round(_current / 1000));
      }
   }
}


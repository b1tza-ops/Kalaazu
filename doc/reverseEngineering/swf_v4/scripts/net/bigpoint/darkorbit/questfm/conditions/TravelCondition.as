package net.bigpoint.darkorbit.questfm.conditions
{
   public class TravelCondition extends Condition
   {
      
      public function TravelCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         if(_mandatory)
         {
            _target_plain = "/" + _target;
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


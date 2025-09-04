package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SellOreCondition extends Condition
   {
      
      private var _ore_id:int;
      
      public function SellOreCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         this._ore_id = parseInt(param1);
         var _loc2_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ore_id > 0)
         {
            _loc2_ += "_ore";
         }
         if(_target == 0)
         {
            _loc2_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText(_loc2_);
         _description = _description.replace(/%ore%/,InGameCatalog.instance.ore_names[this._ore_id]);
         _description = description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


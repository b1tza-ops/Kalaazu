package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AvoidDamageCondition extends Condition
   {
      
      private var _damage_type_id:int;
      
      public function AvoidDamageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         this._damage_type_id = parseInt(param1);
         if(_mandatory)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._damage_type_id]);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


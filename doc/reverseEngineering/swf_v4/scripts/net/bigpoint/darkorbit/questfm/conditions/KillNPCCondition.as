package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class KillNPCCondition extends Condition
   {
      
      private var _npc_id:int;
      
      public function KillNPCCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         this._npc_id = parseInt(param1);
         if(mandatory && _target > 0)
         {
            _target_plain = "/" + _target;
         }
         else
         {
            _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
         _description = _description.replace(/%npc%/,InGameCatalog.instance.npc_names[this._npc_id]);
         _helpIconsClipIds = [InGameCatalog.instance.npc_icons[this._npc_id] + "_icon.png"];
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


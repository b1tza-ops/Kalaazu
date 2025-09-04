package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AvoidKillNPCCondition extends Condition
   {
      
      private var _npc_id:int;
      
      public function AvoidKillNPCCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         this._npc_id = parseInt(param1);
         var _loc2_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(_target == 0)
         {
            _loc2_ += "_none";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         if(mandatory)
         {
            _loc2_ += "_challenge";
         }
         _description = BPLocale.getText(_loc2_);
         _description = description.replace(/%npc%/,InGameCatalog.instance.npc_names[this._npc_id]);
         _description = description.replace(/%count%/,_target);
         _helpIconsClipIds = [InGameCatalog.instance.npc_icons[this._npc_id] + "_icon.png"];
      }
      
      override public function get currentVerbose() : String
      {
         if(_target == 0)
         {
            return "";
         }
         return String(_current);
      }
   }
}


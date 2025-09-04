package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class KillNPCsCondition extends Condition
   {
      
      private var _npc_id_count:int;
      
      private var _npc_ids:Array = [];
      
      private var _npc_names_list:String = "";
      
      public function KillNPCsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this._npc_id_count = parseInt(_loc2_.shift());
         var _loc3_:Array = InGameCatalog.instance.npc_names;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            this._npc_ids[_loc4_] = parseInt(_loc2_[_loc4_]);
            if(_loc3_[this._npc_ids[_loc4_]] != null)
            {
               this._npc_names_list += ", " + _loc3_[this._npc_ids[_loc4_]];
            }
            _loc4_++;
         }
         this._npc_names_list = this._npc_names_list.substring(2);
         var _loc5_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         else
         {
            _loc5_ += "_challenge";
         }
         _description = BPLocale.getText(_loc5_);
         _description = description.replace(/%npcs%/,this._npc_names_list);
         if(this._npc_id_count > 0)
         {
            _helpIconsClipIds = [InGameCatalog.instance.npc_icons[this._npc_ids[0]] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


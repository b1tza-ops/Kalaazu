package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SalvageCondition extends Condition
   {
      
      private var _faction_id:int;
      
      private var _ship_type:int;
      
      private var _npc_type:int;
      
      private var _loot_type:int;
      
      private var _ore_id:int;
      
      public function SalvageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this._faction_id = parseInt(_loc2_.shift());
         this._ship_type = parseInt(_loc2_.shift());
         this._npc_type = parseInt(_loc2_.shift());
         this._loot_type = parseInt(_loc2_.shift());
         this._ore_id = parseInt(_loc2_.shift());
         var _loc3_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ore_id == 0)
         {
            _loc3_ += "_any";
         }
         else
         {
            _loc3_ += "_spec";
         }
         if(this._npc_type == 0 && this._ship_type == 0 && this._faction_id == 0)
         {
            _loc3_ += "_any";
         }
         else
         {
            if(this._npc_type > 0)
            {
               _loc3_ += "_npc";
            }
            if(this._ship_type > 0)
            {
               _loc3_ += "_ship";
            }
            if(this._faction_id > 0)
            {
               _loc3_ += "_faction";
            }
         }
         if(_target == 0)
         {
            _loc3_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText(_loc3_);
         _description = description.replace(/%ore%/,InGameCatalog.instance.ore_names[this._ore_id]);
         _description = description.replace(/%npc%/,InGameCatalog.instance.npc_names[this._npc_type]);
         _description = description.replace(/%ship%/,InGameCatalog.instance.ship_names[this._ship_type]);
         _description = description.replace(/%faction%/,InGameCatalog.instance.factions_names[this._faction_id]);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AvoidKillPlayersCondition extends Condition
   {
      
      private var _faction_ids:Array = [];
      
      private var _faction_names_list:String = "";
      
      private var _ship_types:Array = [];
      
      private var _ship_names_list:String = "";
      
      private var _avatar_ids:Array = [];
      
      public function AvoidKillPlayersCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = parseInt(_loc2_.shift());
         var _loc4_:Array = _loc2_.splice(0,_loc3_);
         var _loc5_:int = parseInt(_loc2_.shift());
         var _loc6_:Array = _loc2_.splice(0,_loc5_);
         var _loc7_:Array = InGameCatalog.instance.ship_names;
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            this._ship_types[_loc8_] = parseInt(_loc4_[_loc8_]);
            if(_loc7_[this._ship_types[_loc8_]] != null)
            {
               this._ship_names_list += ", " + _loc7_[this._ship_types[_loc8_]];
            }
            _loc8_++;
         }
         this._ship_names_list = this._ship_names_list.substring(2);
         var _loc9_:Array = InGameCatalog.instance.factions_names;
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_.length)
         {
            this._faction_ids[_loc10_] = parseInt(_loc6_[_loc10_]);
            this._faction_names_list += ", " + _loc9_[this._faction_ids[_loc10_]];
            _loc10_++;
         }
         this._faction_names_list = this._faction_names_list.substring(2);
         var _loc11_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ship_types.length == 0 && this._faction_ids.length == 0 && this._avatar_ids.length == 0)
         {
            _loc11_ += "_any";
         }
         else
         {
            if(this._ship_types.length > 0)
            {
               _loc11_ += "_ship";
            }
            if(this._faction_ids.length > 0)
            {
               _loc11_ += "_faction";
            }
            if(this._avatar_ids.length > 0)
            {
               _loc11_ += "_avatar";
            }
         }
         if(_target == 0)
         {
            _loc11_ += "_none";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText(_loc11_);
         _description = description.replace(/%types%/,this._ship_names_list);
         _description = description.replace(/%faction%/,this._faction_names_list);
         _description = description.replace(/%count%/,_target);
         if(this._ship_types.length > 0)
         {
            _helpIconsClipIds = [InGameCatalog.instance.ship_icons[this._ship_types[0]] + "_icon.png"];
         }
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


package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class StealCondition extends Condition
   {
      
      private var _faction_id:int;
      
      private var _ship_types:Array = [];
      
      private var _ship_names_list:String = "";
      
      public function StealCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this._faction_id = parseInt(_loc2_.shift());
         var _loc3_:Array = InGameCatalog.instance.ship_names;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            this._ship_types[_loc4_] = parseInt(_loc2_[_loc4_]);
            if(_loc3_[this._ship_types[_loc4_]] != null)
            {
               this._ship_names_list += ", " + _loc3_[this._ship_types[_loc4_]];
            }
            _loc4_++;
         }
         this._ship_names_list = this._ship_names_list.substring(2);
         var _loc5_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ship_names_list.length > 0)
         {
            _loc5_ += "_ship";
         }
         else
         {
            _loc5_ += "_any";
         }
         if(this._faction_id > 0)
         {
            _loc5_ += "_faction";
         }
         if(_target == 0)
         {
            _loc5_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText(_loc5_);
         _description = description.replace(/%ship%/,this._ship_names_list);
         _description = description.replace(/%faction%/,InGameCatalog.instance.factions_names[this._faction_id]);
         if(this._ship_types.length > 0)
         {
            _helpIconsClipIds = [InGameCatalog.instance.ship_icons[this._ship_types[0]] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class DamagePlayersCondition extends Condition
   {
      
      private var factionIDs:Array = [];
      
      private var factionNamesList:String = "";
      
      private var shipTypes:Array = [];
      
      private var shipNamesList:String = "";
      
      private var avatarIDs:Array = [];
      
      private var damageTypeID:int;
      
      public function DamagePlayersCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = int(_loc2_.shift());
         var _loc4_:Array = _loc2_.splice(0,_loc3_);
         var _loc5_:int = int(_loc2_.shift());
         var _loc6_:Array = _loc2_.splice(0,_loc5_);
         this.damageTypeID = int(_loc2_.shift());
         this.damageTypeID = int(_loc2_.shift());
         var _loc7_:Array = InGameCatalog.instance.ship_names;
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            this.shipTypes[_loc8_] = int(_loc4_[_loc8_]);
            if(_loc7_[this.shipTypes[_loc8_]] != null)
            {
               this.shipNamesList += ", " + _loc7_[this.shipTypes[_loc8_]];
            }
            _loc8_++;
         }
         this.shipNamesList = this.shipNamesList.substring(2);
         var _loc9_:Array = InGameCatalog.instance.factions_names;
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_.length)
         {
            this.factionIDs[_loc10_] = int(_loc6_[_loc10_]);
            this.factionNamesList += ", " + _loc9_[this.factionIDs[_loc10_]];
            _loc10_++;
         }
         this.factionNamesList = this.factionNamesList.substring(2);
         var _loc11_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this.shipTypes.length == 0 && this.factionIDs.length == 0 && this.avatarIDs.length == 0)
         {
            _loc11_ += "_any";
         }
         else
         {
            if(this.shipTypes.length > 0)
            {
               _loc11_ += "_ships";
            }
            if(this.factionIDs.length > 0)
            {
               _loc11_ += "_faction";
            }
            if(this.avatarIDs.length > 0)
            {
               _loc11_ += "_avatar";
            }
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _loc11_ += "_" + InGameCatalog.instance.damage_types[this.damageTypeID];
         _description = BPLocale.getText(_loc11_);
         _description = description.replace(/%types%/,this.shipNamesList);
         _description = description.replace(/%faction%/,this.factionNamesList);
         if(this.shipTypes.length > 0)
         {
            _helpIconsClipIds = [InGameCatalog.instance.ship_icons[this.shipTypes[0]] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


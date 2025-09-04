package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class DamageNPCsCondition extends Condition
   {
      
      private var npcIDcount:int;
      
      private var npcIDs:Array = [];
      
      private var npcListing:String = "";
      
      private var damageTypeCount:int;
      
      private var damageTypeID:int;
      
      public function DamageNPCsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this.npcIDcount = int(_loc2_.shift());
         var _loc3_:Array = _loc2_.splice(0,this.npcIDcount);
         this.damageTypeCount = int(_loc2_.shift());
         this.damageTypeID = int(_loc2_.shift());
         var _loc4_:Array = InGameCatalog.instance.npc_names;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            this.npcIDs[_loc5_] = int(_loc3_[_loc5_]);
            if(_loc4_[this.npcIDs[_loc5_]] != null)
            {
               this.npcListing += ", " + _loc4_[this.npcIDs[_loc5_]];
            }
            _loc5_++;
         }
         this.npcListing = this.npcListing.substring(2);
         var _loc6_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this.npcIDcount > 0)
         {
            _loc6_ += "_spec";
         }
         _loc6_ += "_" + InGameCatalog.instance.damage_types[this.damageTypeID];
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText(_loc6_);
         _description = description.replace(/%npcs%/,this.npcListing);
         if(this.npcIDcount > 0)
         {
            _helpIconsClipIds = [InGameCatalog.instance.npc_icons[this.npcIDs[0]] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


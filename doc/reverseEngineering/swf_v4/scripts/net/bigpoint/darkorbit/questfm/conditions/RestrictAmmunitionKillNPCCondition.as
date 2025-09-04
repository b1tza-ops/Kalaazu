package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class RestrictAmmunitionKillNPCCondition extends Condition
   {
      
      public function RestrictAmmunitionKillNPCCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc3_:InGameCatalog = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc11_:String = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc2_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         _loc3_ = InGameCatalog.getInstance();
         _loc4_ = param1.split(",");
         _loc5_ = int(_loc4_.shift());
         var _loc6_:int = int(_loc4_.shift());
         switch(_loc6_)
         {
            case 1:
               _loc7_ = int(_loc4_.shift());
               _loc14_ = _loc4_.splice(0,_loc7_);
               break;
            case 2:
               _loc8_ = int(_loc4_.shift());
               _loc15_ = _loc4_.splice(0,_loc8_);
         }
         _loc9_ = "";
         if(_loc5_ > 0)
         {
            _loc9_ = _loc3_.npc_names[_loc5_];
            _loc2_ += "_npc";
         }
         else
         {
            _loc2_ += "_anynpc";
         }
         var _loc10_:Array = [];
         _loc11_ = "";
         if(_loc7_ > 0)
         {
            _loc2_ += "_laser";
            for each(_loc16_ in _loc14_)
            {
               _loc10_.push(_loc3_.batteryNames[_loc16_]);
            }
            _loc11_ = _loc10_.join(", ");
         }
         var _loc12_:Array = [];
         var _loc13_:String = "";
         if(_loc8_ > 0)
         {
            _loc2_ += "_rocket";
            for each(_loc17_ in _loc15_)
            {
               _loc12_.push(_loc3_.rocketNames[_loc17_]);
            }
            _loc13_ = _loc12_.join(", ");
         }
         _target_plain = "/" + BPLocale.round(_target);
         _description = BPLocale.getText(_loc2_);
         _description = _description.replace(/%npc%/,_loc9_);
         _description = _description.replace(/%laser%/,_loc11_);
         _description = _description.replace(/%rocket%/,_loc13_);
         if(_loc5_ > 0)
         {
            _helpIconsClipIds = [_loc3_.npc_icons[_loc5_] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


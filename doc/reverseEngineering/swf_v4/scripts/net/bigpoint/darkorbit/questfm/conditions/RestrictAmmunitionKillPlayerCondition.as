package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class RestrictAmmunitionKillPlayerCondition extends Condition
   {
      
      public function RestrictAmmunitionKillPlayerCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc3_:InGameCatalog = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc2_:* = "q2_condition_" + _definition.TRANS_BASE_KEY;
         _loc3_ = InGameCatalog.getInstance();
         _loc4_ = param1.split(",");
         _loc5_ = int(_loc4_.shift());
         var _loc6_:int = int(_loc4_.shift());
         var _loc7_:int = int(_loc4_.shift());
         switch(_loc7_)
         {
            case 1:
               _loc8_ = int(_loc4_.shift());
               _loc16_ = _loc4_.splice(0,_loc8_);
               break;
            case 2:
               _loc9_ = int(_loc4_.shift());
               _loc17_ = _loc4_.splice(0,_loc9_);
         }
         _loc10_ = "";
         if(_loc5_ > 0)
         {
            _loc10_ = _loc3_.ship_names[_loc5_];
            _loc2_ += "_ship";
         }
         else
         {
            _loc2_ += "_anyship";
         }
         _loc11_ = "";
         if(_loc6_ > 0)
         {
            _loc11_ = _loc3_.factions_names[_loc6_];
            _loc2_ += "_faction";
         }
         else
         {
            _loc2_ += "_anyfaction";
         }
         var _loc12_:Array = [];
         var _loc13_:String = "";
         if(_loc8_ > 0)
         {
            _loc2_ += "_laser";
            for each(_loc18_ in _loc16_)
            {
               _loc12_.push(_loc3_.batteryNames[_loc18_]);
            }
            _loc13_ = _loc12_.join(", ");
         }
         var _loc14_:Array = [];
         _loc15_ = "";
         if(_loc9_ > 0)
         {
            _loc2_ += "_rocket";
            for each(_loc19_ in _loc17_)
            {
               _loc14_.push(_loc3_.rocketNames[_loc19_]);
            }
            _loc15_ = _loc14_.join(", ");
         }
         _target_plain = "/" + BPLocale.round(_target);
         _description = BPLocale.getText(_loc2_);
         _description = _description.replace(/%ship%/,_loc10_);
         _description = _description.replace(/%faction%/,_loc11_);
         _description = _description.replace(/%laser%/,_loc13_);
         _description = _description.replace(/%rocket%/,_loc15_);
         if(_loc5_ > 0)
         {
            _helpIconsClipIds = [_loc3_.ship_icons[_loc5_] + "_icon.png"];
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


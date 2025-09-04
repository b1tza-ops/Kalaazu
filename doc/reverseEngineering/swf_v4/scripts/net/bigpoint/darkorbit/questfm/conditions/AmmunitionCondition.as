package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AmmunitionCondition extends Condition
   {
      
      private var _ammo_type:int;
      
      private var _ammo_grade:int;
      
      public function AmmunitionCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = param1.split(",");
         this._ammo_type = parseInt(_loc2_.shift());
         this._ammo_grade = parseInt(_loc2_.shift());
         var _loc3_:* = _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._ammo_type];
         _loc4_ = "";
         if(this._ammo_grade > 0)
         {
            _loc3_ += "_spec";
            if(this._ammo_type == 1)
            {
               _loc4_ = InGameCatalog.instance.battery_types[this._ammo_grade];
            }
            else if(this._ammo_type == 2)
            {
               _loc4_ = InGameCatalog.instance.rocketNames[this._ammo_grade];
            }
         }
         _description = BPLocale.getText("q2_condition_" + _loc3_);
         _description = description.replace(/%type%/,_loc4_);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}


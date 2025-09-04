package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SaveAmmunitionCondition extends Condition
   {
      
      private var _ammo_type:int;
      
      private var _ammo_grade:int;
      
      public function SaveAmmunitionCondition()
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
         if(_target == 0 && this._ammo_type > 0)
         {
            _loc3_ += "_none";
         }
         if(mandatory && _target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getText("q2_condition_" + _loc3_);
         _description = description.replace(/%type%/,_loc4_);
         _description = description.replace(/%count%/,_target);
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


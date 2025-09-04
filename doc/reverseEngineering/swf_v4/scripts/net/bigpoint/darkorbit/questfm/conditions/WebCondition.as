package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.BPLocale;
   
   public class WebCondition extends Condition
   {
      
      public static const BUY_LASER:int = 0;
      
      public static const BUY_SHIP:int = 1;
      
      public static const BUY_SPEED_GENERATOR:int = 2;
      
      public static const EQUIP_SPEED_GENERATOR:int = 3;
      
      public static const BUY_LASER_AMMUNITION_URI:int = 4;
      
      public static const CREATE_PROMERIUM:int = 5;
      
      public static const USE_PROMERIUM:int = 6;
      
      public static const USE_GG_MATERIALIZER:int = 7;
      
      public static const VERIFY_EMAIL_ADRESS:int = 8;
      
      public static const APPLY_FOR_CLAN_MEMBERSHIP:int = 9;
      
      private var _precise_web_condition_id:int;
      
      public function WebCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         var _loc2_:Array = [];
         _loc2_[BUY_LASER] = "buyLaser_single";
         _loc2_[BUY_SHIP] = "buyShip_bigger";
         _loc2_[BUY_SPEED_GENERATOR] = "buyGenSpeed_single";
         _loc2_[EQUIP_SPEED_GENERATOR] = "equipGenSpeed_single";
         _loc2_[BUY_LASER_AMMUNITION_URI] = "buyAmmoLeastUridium";
         _loc2_[CREATE_PROMERIUM] = "refinePromerium";
         _loc2_[USE_PROMERIUM] = "upgrade_any_promerium";
         _loc2_[USE_GG_MATERIALIZER] = "useGalaxyGatesEnergy";
         _loc2_[VERIFY_EMAIL_ADRESS] = "verifyMail";
         _loc2_[APPLY_FOR_CLAN_MEMBERSHIP] = "applyToClan";
         this._precise_web_condition_id = parseInt(param1);
         _description = BPLocale.getText("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + _loc2_[this._precise_web_condition_id]);
         if(this._precise_web_condition_id == BUY_SHIP)
         {
            _description = _description.replace(/%ship%/,"Phoenix");
         }
         if(this._precise_web_condition_id == BUY_LASER_AMMUNITION_URI)
         {
            _description = _description.replace(/%count%/,_target);
            _target_plain = "/" + _target;
         }
      }
      
      override public function get currentVerbose() : String
      {
         if(this._precise_web_condition_id == BUY_LASER_AMMUNITION_URI)
         {
            return String(_current);
         }
         return "";
      }
   }
}


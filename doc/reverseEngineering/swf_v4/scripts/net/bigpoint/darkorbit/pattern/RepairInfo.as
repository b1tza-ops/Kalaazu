package net.bigpoint.darkorbit.pattern
{
   import com.bigpoint.utils.BPLocale;
   
   public class RepairInfo
   {
      
      private static const BILLING_TYPE_FREE:String = "FREE";
      
      private static const BILLING_TYPE_VOUCHER:String = "VOUCHER";
      
      private static const BILLING_TYPE_URIDIUM:String = "URI";
      
      private static const BILLING_TYPE_IMPOSSIBLE:String = "IMPOSSIBLE";
      
      private static const BILLING_CAUSE_PREMIUM:String = "PREMIUM";
      
      private static const BILLING_CAUSE_SHIP:String = "SHIP";
      
      private static const BILLING_CAUSE_MAP:String = "MAP";
      
      private static const BILLING_CAUSE_EVENT:String = "EVENT";
      
      private static const BILLING_CAUSE_GENERAL:String = "GENERAL";
      
      public var billingType:String;
      
      public var detail:String;
      
      public function RepairInfo(param1:String, param2:String)
      {
         super();
         this.detail = param2;
         this.billingType = param1;
      }
      
      public function isRepairPossible() : Boolean
      {
         return this.billingType != BILLING_TYPE_IMPOSSIBLE;
      }
      
      public function getRepairButtonLabel() : String
      {
         var _loc1_:String = null;
         switch(this.billingType)
         {
            case BILLING_TYPE_FREE:
               _loc1_ = BPLocale.getText("btn_repair_for_free");
               break;
            case BILLING_TYPE_VOUCHER:
               _loc1_ = BPLocale.getText("btn_repair_voucher");
               break;
            case BILLING_TYPE_URIDIUM:
               _loc1_ = BPLocale.getText("btn_repair_for_uri").replace(/%count%/,this.detail);
               break;
            case BILLING_TYPE_IMPOSSIBLE:
               _loc1_ = BPLocale.getText("btn_repair_impossible");
         }
         return _loc1_;
      }
      
      public function getMessage() : String
      {
         var _loc1_:* = null;
         switch(this.billingType)
         {
            case BILLING_TYPE_FREE:
               _loc1_ = BPLocale.getText("msg_repair_now") + " ";
               switch(this.detail)
               {
                  case BILLING_CAUSE_EVENT:
                     _loc1_ += BPLocale.getText("msg_free_repair_cause_event");
                     break;
                  case BILLING_CAUSE_SHIP:
                     _loc1_ += BPLocale.getText("msg_free_repair_cause_ship");
                     break;
                  case BILLING_CAUSE_PREMIUM:
                     _loc1_ += BPLocale.getText("msg_free_repair_cause_premium");
                     break;
                  case BILLING_CAUSE_MAP:
                     _loc1_ += BPLocale.getText("msg_free_repair_cause_map");
                     break;
                  case BILLING_CAUSE_GENERAL:
                     _loc1_ += BPLocale.getText("msg_free_repair_cause_general");
               }
               break;
            case BILLING_TYPE_VOUCHER:
               _loc1_ = BPLocale.getText("msg_repair_now") + " ";
               _loc1_ += BPLocale.getText("msg_repair_voucher") + " ";
               if(this.detail == "1")
               {
                  _loc1_ += BPLocale.getText("msg_repair_addon_one_voucher_left");
               }
               else
               {
                  _loc1_ += BPLocale.getText("msg_repair_addon_vouchers_left").replace(/%count%/,this.detail);
               }
               break;
            case BILLING_TYPE_URIDIUM:
               _loc1_ = BPLocale.getText("msg_repair_now") + " ";
               _loc1_ += BPLocale.getText("msg_repair_for_uri").replace(/%count%/,this.detail);
               break;
            case BILLING_TYPE_IMPOSSIBLE:
               _loc1_ = BPLocale.getText("msg_repair_impossible");
         }
         return _loc1_;
      }
   }
}


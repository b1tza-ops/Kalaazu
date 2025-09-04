package net.bigpoint.darkorbit.questfm.conditions
{
   public class MiscellaneousConditionTypes
   {
      
      private static var _instance:MiscellaneousConditionTypes;
      
      private static var _types:Array = [];
      
      public function MiscellaneousConditionTypes(param1:Function)
      {
         super();
         _types[0] = "NOTHING";
         _types[1] = "ON_ENEMY_MAP";
         _types[2] = "ON_PVP_MAP";
         _types[3] = "VISIBLE";
         _types[4] = "INVISIBLE";
         _types[5] = "IN_RADIATION_AREA";
         _types[6] = "INSTANT_SHIELD_ACTIVE";
         _types[7] = "LOW_ON_LIFE";
         _types[8] = "ATTACKING";
         _types[9] = "ATTACKED";
         _types[10] = "MARTYR";
         _types[11] = "REPAIRING";
         _types[12] = "OUTLAW";
         _types[13] = "ON_HOME_MAP";
         _types[14] = "ON_HOSTILE_HOME_MAP";
         _types[15] = "ON_MARS_MAP";
         _types[16] = "ON_EARTH_MAP";
         _types[17] = "ON_VENUS_MAP";
         _types[18] = "ON_OWN_FACTION_MAP";
         _types[19] = "ON_X_1";
         _types[20] = "ON_X_2";
         _types[21] = "ON_X_3";
         if(param1 !== hidden)
         {
            throw new Error("MiscellaneousConditionTypes is a Singleton and can only be accessed through MiscellaneousConditionTypes.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function get instance() : MiscellaneousConditionTypes
      {
         if(_instance == null)
         {
            _instance = new MiscellaneousConditionTypes(hidden);
         }
         return _instance;
      }
      
      public function getTranslationSuffix(param1:int) : String
      {
         return String(_types[param1]);
      }
   }
}


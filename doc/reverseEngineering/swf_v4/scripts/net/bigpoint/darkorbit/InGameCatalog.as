package net.bigpoint.darkorbit
{
   import com.bigpoint.utils.BPLocale;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.config.items.SysItem;
   
   public class InGameCatalog
   {
      
      private static var _instance:InGameCatalog;
      
      public var mapNames:Array;
      
      private var _ship_names:Array;
      
      private var _npc_names:Array;
      
      private var _ore_names:Array;
      
      private var _factions_names:Array;
      
      private var _damage_types:Array;
      
      public var rocketNames:Array;
      
      public var batteryNames:Array;
      
      private var _explosive_names:Array;
      
      private var _robot_names:Array;
      
      private var _jump_cpu_names:Array;
      
      private var _trade_cpu_names:Array;
      
      public var dronerepair_cpu_names:Array;
      
      private var _aim_cpu_names:Array;
      
      private var _arol_cpu_names:Array;
      
      private var _rllbCpuNames:Array;
      
      public var cloak_cpu_names:Array;
      
      public var boosterNames:Array;
      
      private var _npc_icons:Array;
      
      private var _ship_icons:Array;
      
      public var rocketLauncherNames:Array = [];
      
      public var advancedJumpCPUNames:Array = [];
      
      private var _ore_icons:Array;
      
      public var sysItems:Dictionary;
      
      public function InGameCatalog(param1:Function)
      {
         super();
         this._damage_types = [];
         this._damage_types[0] = "any";
         this._damage_types[1] = "laser";
         this._damage_types[2] = "rocket";
         this._damage_types[3] = "mine";
         this._damage_types[4] = "radiation";
         this._damage_types[5] = "direct";
         this.mapNames = ["¿","1-1","1-2","1-3","1-4","2-1","2-2","2-3","2-4","3-1","3-2","3-3","3-4","4-1","4-2","4-3","4-4","1-5","1-6","1-7","1-8","2-5","2-6","2-7","2-8","3-5","3-6","3-7","3-8","4-5"];
         this.mapNames[42] = "???";
         this.mapNames[50] = "GG";
         this.mapNames[51] = "GG α";
         this.mapNames[52] = "GG β";
         this.mapNames[53] = "GG ɣ";
         this.mapNames[54] = "GG NC";
         this.mapNames[55] = "GG δ";
         this.mapNames[56] = "GG Orb";
         this.mapNames[57] = "GG Y4";
         this.mapNames[61] = "MMO Invasion";
         this.mapNames[62] = "EIC Invasion";
         this.mapNames[63] = "VRU Invasion";
         this.mapNames[64] = "MMO Invasion";
         this.mapNames[65] = "EIC Invasion";
         this.mapNames[66] = "VRU Invasion";
         this.mapNames[67] = "MMO Invasion";
         this.mapNames[68] = "EIC Invasion";
         this.mapNames[69] = "VRU Invasion";
         this.mapNames[81] = "TDM I";
         this.mapNames[82] = "TDM II";
         this.mapNames[91] = "5-1";
         this.mapNames[92] = "5-2";
         this.mapNames[93] = "5-3";
         this.mapNames[101] = "JP Final";
         this.mapNames[102] = "JP 1";
         this.mapNames[103] = "JP 2";
         this.mapNames[104] = "JP 3";
         this.mapNames[105] = "JP 4";
         this.mapNames[106] = "JP 5";
         this.mapNames[107] = "JP 6";
         this.mapNames[108] = "JP 7";
         this.mapNames[109] = "JP 8";
         this.mapNames[110] = "JP 9";
         this.mapNames[111] = "JP 10";
         this.mapNames[112] = "JP 11";
         this.mapNames[113] = "JP 12";
         this.mapNames[114] = "JP 13";
         this.mapNames[115] = "JP 14";
         this.mapNames[116] = "JP 15";
         this.mapNames[117] = "JP 16";
         this.mapNames[118] = "JP 17";
         this.mapNames[119] = "JP 18";
         this.mapNames[120] = "JP 19";
         this.mapNames[121] = "JP 20";
         this.mapNames[122] = "JP 21";
         this.mapNames[123] = "JP 22";
         this.mapNames[124] = "JP 23";
         this.mapNames[125] = "JP 24";
         this.mapNames[126] = "JP 25";
         this.mapNames[200] = "LoW";
         this.rocketLauncherNames[1] = "HST-1";
         this.rocketLauncherNames[2] = "HST-2";
         this.advancedJumpCPUNames[1] = "AJP-01";
         this._ore_names = [];
         this._ore_names[1] = BPLocale.getText("ore_prometium");
         this._ore_names[2] = BPLocale.getText("ore_endurium");
         this._ore_names[3] = BPLocale.getText("ore_terbium");
         this._ore_names[4] = BPLocale.getText("ore_xenomit");
         this._ore_names[11] = BPLocale.getText("ore_prometid");
         this._ore_names[12] = BPLocale.getText("ore_duranium");
         this._ore_names[13] = BPLocale.getText("ore_promerium");
         this._ore_names[14] = BPLocale.getText("ore_seprom");
         this._ore_names[15] = BPLocale.getText("ore_palladium");
         this._ore_icons = [];
         this._ore_icons[1] = "ore_1.png";
         this._ore_icons[2] = "ore_2.png";
         this._ore_icons[3] = "ore_3.png";
         this._factions_names = [];
         this._factions_names[1] = "MMO";
         this._factions_names[2] = "EIC";
         this._factions_names[3] = "VRU";
         this._ship_names = [];
         this._ship_names[1] = "Phoenix";
         this._ship_names[2] = "Yamato";
         this._ship_names[3] = "Leonov";
         this._ship_names[4] = "Defcom";
         this._ship_names[5] = "Liberator";
         this._ship_names[6] = "Piranha";
         this._ship_names[7] = "Nostromo";
         this._ship_names[8] = "Vengeance";
         this._ship_names[9] = "Bigboy";
         this._ship_names[10] = "Goliath";
         this._npc_names = [];
         this._npc_names[1] = "Streuner";
         this._npc_names[2] = "Lordakia";
         this._npc_names[3] = "Devolarium";
         this._npc_names[4] = "Mordon";
         this._npc_names[5] = "Sibelon";
         this._npc_names[6] = "Saimon";
         this._npc_names[7] = "Sibelonit";
         this._npc_names[8] = "Lordakium";
         this._npc_names[9] = "Kristallin";
         this._npc_names[10] = "Kristallon";
         this._npc_names[11] = "StreuneR";
         this._npc_names[12] = "Protegit";
         this._npc_names[13] = "Cubikon";
         this._npc_names[14] = "Boss Streuner";
         this._npc_names[15] = "Boss Lordakia";
         this._npc_names[16] = "Boss Mordon";
         this._npc_names[17] = "Boss Saimon";
         this._npc_names[18] = "Boss Devolarium";
         this._npc_names[19] = "Boss Sibelonit";
         this._npc_names[20] = "Boss Sibelon";
         this._npc_names[21] = "Boss Lordakium";
         this._npc_names[22] = "Boss Kristallin";
         this._npc_names[23] = "Boss Kristallon";
         this._npc_names[24] = "Boss StreuneR";
         this._npc_names[25] = "UFO";
         this._npc_names[26] = "UFONIT";
         this._npc_names[27] = "Aggro-Streuner";
         this._npc_names[28] = "UberStreuner";
         this._npc_names[29] = "UberLordakia";
         this._npc_names[30] = "UberMordon";
         this._npc_names[31] = "UberSaimon";
         this._npc_names[32] = "UberDevolarium";
         this._npc_names[33] = "UberSibelonit";
         this._npc_names[34] = "UberSibelon";
         this._npc_names[35] = "UberLordakium";
         this._npc_names[36] = "UberKristallin";
         this._npc_names[37] = "UberKristallon";
         this._npc_names[38] = "UberStreuneR";
         this._npc_names[39] = "Demaner";
         this._npc_names[40] = "Kucurbium";
         this._npc_names[41] = "BossKucurbium";
         this._npc_names[42] = "Vagrant";
         this._npc_names[43] = "Marauder";
         this._npc_names[44] = "Outcast";
         this._npc_names[45] = "Corsair";
         this._npc_names[46] = "Hooligan";
         this._npc_names[47] = "Ravager";
         this._npc_names[48] = "Convict";
         this._npc_names[49] = "Century Falcon";
         this._npc_names[50] = "Unidentified Destroyer";
         this._npc_names[51] = "Unidentified Dreadnought";
         this._npc_names[52] = "Cubikon";
         this._npc_names[53] = "Protegit";
         this._npc_names[54] = "Ice Meteoroid";
         this._npc_names[55] = "Super Ice Meteoroid";
         this._npc_names[56] = "Icy";
         this._npc_names[57] = "1100101";
         this._npc_names[58] = "Interceptor";
         this._npc_names[59] = "Barracuda";
         this._npc_names[60] = "Saboteur";
         this._npc_names[61] = "Annihilator";
         this._npc_names[62] = "Battleray";
         this._ship_icons = [];
         this._ship_icons[0] = "ship_0";
         this._ship_icons[1] = "ship_1";
         this._ship_icons[2] = "ship_2";
         this._ship_icons[3] = "ship_3";
         this._ship_icons[4] = "ship_4";
         this._ship_icons[5] = "ship_5";
         this._ship_icons[6] = "ship_6";
         this._ship_icons[7] = "ship_7";
         this._ship_icons[8] = "ship_8";
         this._ship_icons[9] = "ship_9";
         this._ship_icons[10] = "ship_10";
         this._ship_icons[30] = "ship_3";
         this._ship_icons[50] = "ship_9";
         this._ship_icons[52] = "ship_10";
         this._ship_icons[53] = "ship_10";
         this._ship_icons[54] = "ship_10";
         this._ship_icons[55] = "ship_10";
         this._ship_icons[56] = "ship_10";
         this._ship_icons[57] = "ship_10";
         this._ship_icons[58] = "ship_8";
         this._ship_icons[59] = "ship_10";
         this._ship_icons[60] = "ship_8";
         this._ship_icons[61] = "ship_10";
         this._ship_icons[62] = "ship_10";
         this._ship_icons[63] = "ship_10";
         this._ship_icons[64] = "ship_10";
         this._ship_icons[65] = "ship_10";
         this._ship_icons[66] = "ship_10";
         this._ship_icons[67] = "ship_10";
         this._npc_icons = [];
         this._npc_icons[1] = "ship_2";
         this._npc_icons[2] = "npc_71";
         this._npc_icons[3] = "npc_72";
         this._npc_icons[4] = "npc_73";
         this._npc_icons[5] = "npc_74";
         this._npc_icons[6] = "npc_75";
         this._npc_icons[7] = "npc_76";
         this._npc_icons[8] = "npc_77";
         this._npc_icons[9] = "npc_78";
         this._npc_icons[10] = "npc_79";
         this._npc_icons[11] = "ship_4";
         this._npc_icons[12] = "npc_81";
         this._npc_icons[13] = "npc_80";
         this._npc_icons[14] = "ship_2";
         this._npc_icons[15] = "npc_71";
         this._npc_icons[16] = "npc_73";
         this._npc_icons[17] = "npc_75";
         this._npc_icons[18] = "npc_72";
         this._npc_icons[19] = "npc_76";
         this._npc_icons[20] = "npc_74";
         this._npc_icons[21] = "npc_77";
         this._npc_icons[22] = "npc_78";
         this._npc_icons[23] = "npc_79";
         this._npc_icons[24] = "ship_4";
         this._npc_icons[25] = "ship_0";
         this._npc_icons[26] = "ship_0";
         this._npc_icons[27] = "ship_2";
         this._npc_icons[28] = "ship_2";
         this._npc_icons[29] = "npc_71";
         this._npc_icons[30] = "npc_73";
         this._npc_icons[31] = "npc_75";
         this._npc_icons[32] = "npc_72";
         this._npc_icons[33] = "npc_76";
         this._npc_icons[34] = "npc_74";
         this._npc_icons[35] = "npc_77";
         this._npc_icons[36] = "npc_78";
         this._npc_icons[37] = "npc_79";
         this._npc_icons[38] = "ship_4";
         this._npc_icons[39] = "npc_unknown_placeholder";
         this._npc_icons[40] = "npc_unknown_placeholder";
         this._npc_icons[41] = "npc_unknown_placeholder";
         this._npc_icons[42] = "npc_unknown_placeholder";
         this._npc_icons[43] = "npc_unknown_placeholder";
         this._npc_icons[44] = "npc_unknown_placeholder";
         this._npc_icons[45] = "npc_unknown_placeholder";
         this._npc_icons[46] = "npc_unknown_placeholder";
         this._npc_icons[47] = "npc_unknown_placeholder";
         this._npc_icons[48] = "npc_unknown_placeholder";
         this._npc_icons[49] = "npc_unknown_placeholder";
         this._npc_icons[50] = "npc_100";
         this._npc_icons[51] = "npc_99";
         this._npc_icons[52] = "npc_80";
         this._npc_icons[53] = "npc_81";
         this._npc_icons[54] = "npc_101";
         this._npc_icons[55] = "npc_101";
         this._npc_icons[56] = "npc_103";
         this._npc_icons[57] = "npc_104";
         this._npc_icons[58] = "npc_pirate_category";
         this._npc_icons[59] = "npc_pirate_category";
         this._npc_icons[60] = "npc_pirate_category";
         this._npc_icons[61] = "npc_pirate_category";
         this._npc_icons[62] = "npc_pirate_category";
         this.batteryNames = [];
         this.batteryNames[1] = "LCB-10";
         this.batteryNames[2] = "MCB-25";
         this.batteryNames[3] = "MCB-50";
         this.batteryNames[4] = "UCB-100";
         this.batteryNames[5] = "SAB-50";
         this.batteryNames[6] = "RSB-75";
         this.rocketNames = [];
         this.rocketNames[RocketPattern.R310] = "R-310";
         this.rocketNames[RocketPattern.PLT_2026] = "PLT-2026";
         this.rocketNames[RocketPattern.PLT_2021] = "PLT-2021";
         this.rocketNames[RocketPattern.PLT_3030] = "PLT-3030";
         this.rocketNames[RocketPattern.PLD_8] = "PLD-8";
         this.rocketNames[RocketPattern.DCR_250] = "DCR-250";
         this.rocketNames[RocketPattern.WIZ] = "WIZ-X";
         this.rocketNames[RocketPattern.HSTRM01] = "HSTRM-01";
         this.rocketNames[RocketPattern.UBR100] = "UBR-100";
         this.rocketNames[RocketPattern.ECO10] = "ECO-10";
         this._explosive_names = [];
         this._explosive_names[1] = "ACM-01";
         this._explosive_names[2] = "SMB-01";
         this._explosive_names[3] = "ISH-01";
         this._explosive_names[4] = "EMP-01";
         this._explosive_names[5] = "FWX-S";
         this._explosive_names[6] = "FWX-M";
         this._explosive_names[7] = "FWX-L";
         this._explosive_names[8] = "EMPM-01";
         this._explosive_names[9] = "SABM-01";
         this._explosive_names[10] = "DDM-01";
         this._robot_names = [];
         this._robot_names[1] = "REP-1";
         this._robot_names[2] = "REP-2";
         this._robot_names[3] = "REP-3";
         this._robot_names[4] = "REP-4";
         this._robot_names[9] = "REP-S";
         this._jump_cpu_names = [];
         this._jump_cpu_names[1] = "JP-01";
         this._jump_cpu_names[2] = "JP-02";
         this._arol_cpu_names = [];
         this._arol_cpu_names[1] = "AROL-X";
         this._rllbCpuNames = [];
         this._rllbCpuNames[1] = "RL-LB1";
         this.cloak_cpu_names = [];
         this.cloak_cpu_names[1] = "CL04K";
         this.cloak_cpu_names[2] = "CL04K XL";
         this._aim_cpu_names = [];
         this._aim_cpu_names[1] = "AIM-01";
         this._aim_cpu_names[2] = "AIM-02";
         this._trade_cpu_names = [];
         this._trade_cpu_names[1] = "HM7";
         this.dronerepair_cpu_names = [];
         this.dronerepair_cpu_names[1] = "DR001";
         this.dronerepair_cpu_names[2] = "DR002";
         this.boosterNames = [];
         this.boosterNames[1] = "XP-B01";
         this.boosterNames[2] = "HON-B01";
         this.boosterNames[3] = "DMG-B01";
         this.boosterNames[4] = "SHD-B01";
         this.boosterNames[5] = "REP-B01";
         this.boosterNames[6] = "SREG-B01";
         this.boosterNames[7] = "RES-B01";
         this.boosterNames[8] = "HP-B01";
         this.boosterNames[9] = "NQR-B01";
         this.boosterNames[10] = "NBX-B01";
         this.boosterNames[11] = "XP-B02";
         this.boosterNames[12] = "HON-B02";
         this.boosterNames[13] = "DMG-B02";
         this.boosterNames[14] = "SHD-B02";
         this.boosterNames[15] = "REP-B02";
         this.boosterNames[16] = "SREG-B02";
         this.boosterNames[17] = "RES-B02";
         this.boosterNames[18] = "HP-B02";
         this.boosterNames[19] = "NQR-B02";
         this.boosterNames[20] = "NBX-B02";
         this.sysItems = new Dictionary();
         this.sysItems["ammunition_specialammo_emp-01"] = new SysItem("emp-01","EMP-01","ammunition.specialammo","emp");
         this.sysItems["resource_logfile"] = new SysItem("logfile","LOGFILE","resource.logfile","log-file");
         this.sysItems["equipment_extra_cpu_ajp-01"] = new SysItem("ajp-01","AJP-01","equipment.extra.cpu","jump-cpu");
         this.sysItems["equipment_extra_cpu_dr-01"] = new SysItem("dr-01","DR-01","equipment.extra.cpu","drone-repair-cpu");
         this.sysItems["equipment_extra_cpu_cl04k-m"] = new SysItem("cl04k-m","CL04K-M","equipment.extra.cpu","cloak-cpu");
         this.sysItems["equipment_extra_cpu_cl04k-xl"] = new SysItem("cl04k-xl","CL04K-XL","equipment.extra.cpu","cloak-cpu");
         this.sysItems["equipment_generator_speed_g3n-6900"] = new SysItem("g3n-6900","G3N-6900","equipment.generator.speed","speed-generator");
         this.sysItems["equipment_generator_speed_g3n-7900"] = new SysItem("g3n-7900","G3N-7900","equipment.generator.speed","speed-generator");
         this.sysItems["equipment_generator_shield_sg3n-b01"] = new SysItem("sg3n-b01","SG3N-B01","equipment.generator.shield","shield-generator");
         this.sysItems["equipment_generator_shield_sg3n-b02"] = new SysItem("sg3n-b02","SG3N-B02","equipment.generator.shield","shield-generator");
         this.sysItems["equipment_weapon_laser_lf-2"] = new SysItem("lf-2","LF-2","equipment.weapons.laser","laser");
         this.sysItems["equipment_weapon_laser_lf-3"] = new SysItem("lf-3","LF-3","equipment.weapons.laser","laser");
         this.sysItems["equipment_weapon_laser_lf-4"] = new SysItem("lf-4","LF-4","equipment.weapons.laser","laser");
         this.sysItems["ship_goliath_design_venom"] = new SysItem("venom","VENOM","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_solace"] = new SysItem("solace","SOLACE","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_spectrum"] = new SysItem("spectrum","SPECTRUM","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_diminisher"] = new SysItem("diminsher","DIMINISHER","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_sentinel"] = new SysItem("sentinel","SENTINEL","ship.goliath.design","skill-design");
         this.sysItems["ship_vengeance_design_adept"] = new SysItem("adept","ADEPT","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_avenger"] = new SysItem("avenger","AVENGER","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_corsair"] = new SysItem("corsair","CORSAIR","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_lightning"] = new SysItem("lightning","LIGHTNING","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_revenge"] = new SysItem("revenge","REVENGE","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_goliath_design_bastion"] = new SysItem("bastion","BASTION","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_enforcer"] = new SysItem("enforcer","ENFORCER","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_exalted"] = new SysItem("exalted","EXALTED","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_veteran"] = new SysItem("veteran","VETERAN","ship.goliath.design","goliath-design");
         if(param1 !== hidden)
         {
            throw new Error("IngameCatalog is a Singleton and can only be accessed through ingameCatalog.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function get instance() : InGameCatalog
      {
         if(_instance == null)
         {
            _instance = new InGameCatalog(hidden);
         }
         return _instance;
      }
      
      public static function getInstance() : InGameCatalog
      {
         if(_instance == null)
         {
            _instance = new InGameCatalog(hidden);
         }
         return _instance;
      }
      
      public function get ship_names() : Array
      {
         return this._ship_names;
      }
      
      public function get npc_names() : Array
      {
         return this._npc_names;
      }
      
      public function get ore_names() : Array
      {
         return this._ore_names;
      }
      
      public function get ore_icons() : Array
      {
         return this._ore_icons;
      }
      
      public function get factions_names() : Array
      {
         return this._factions_names;
      }
      
      public function get damage_types() : Array
      {
         return this._damage_types;
      }
      
      public function get battery_types() : Array
      {
         return this.batteryNames;
      }
      
      public function get explosive_types() : Array
      {
         return this._explosive_names;
      }
      
      public function get robot_names() : Array
      {
         return this._robot_names;
      }
      
      public function get jump_cpu_names() : Array
      {
         return this._jump_cpu_names;
      }
      
      public function get trade_cpu_names() : Array
      {
         return this._trade_cpu_names;
      }
      
      public function get aim_cpu_names() : Array
      {
         return this._aim_cpu_names;
      }
      
      public function get arol_cpu_names() : Array
      {
         return this._arol_cpu_names;
      }
      
      public function get rllbCpuNames() : Array
      {
         return this._rllbCpuNames;
      }
      
      public function get npc_icons() : Array
      {
         return this._npc_icons;
      }
      
      public function set npc_icons(param1:Array) : void
      {
         this._npc_icons = param1;
      }
      
      public function get ship_icons() : Array
      {
         return this._ship_icons;
      }
      
      public function set ship_icons(param1:Array) : void
      {
         this._ship_icons = param1;
      }
   }
}


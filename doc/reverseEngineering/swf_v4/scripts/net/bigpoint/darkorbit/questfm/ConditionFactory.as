package net.bigpoint.darkorbit.questfm
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.questfm.conditions.*;
   
   public class ConditionFactory
   {
      
      private static const logger:ILogger = Log.getLogger("ConditionFactory");
      
      private var conditionDefinitions:Array;
      
      public function ConditionFactory()
      {
         super();
         this.initConditionDefinitions();
      }
      
      private function initConditionDefinitions() : void
      {
         this.conditionDefinitions = [];
         this.conditionDefinitions[ConditionType.TIMER] = new ConditionTypeDefinition(ConditionType.TIMER,"TIMER",TimerCondition,false);
         this.conditionDefinitions[ConditionType.HASTE] = new ConditionTypeDefinition(ConditionType.HASTE,"HASTE",HasteCondition,false);
         this.conditionDefinitions[ConditionType.ENDURANCE] = new ConditionTypeDefinition(ConditionType.ENDURANCE,"ENDURANCE",EnduranceCondition,true);
         this.conditionDefinitions[ConditionType.COUNTDOWN] = new ConditionTypeDefinition(ConditionType.COUNTDOWN,"COUNTDOWN",CountDownCondition,true);
         this.conditionDefinitions[ConditionType.COLLECT] = new ConditionTypeDefinition(ConditionType.COLLECT,"COLLECT",CollectCondition,true);
         this.conditionDefinitions[ConditionType.KILL_NPC] = new ConditionTypeDefinition(ConditionType.KILL_NPC,"KILL_NPC",KillNPCCondition,true);
         this.conditionDefinitions[ConditionType.DAMAGE] = new ConditionTypeDefinition(ConditionType.DAMAGE,"DAMAGE",DamageCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_DAMAGE] = new ConditionTypeDefinition(ConditionType.AVOID_DAMAGE,"AVOID_DAMAGE",AvoidDamageCondition,false);
         this.conditionDefinitions[ConditionType.TAKE_DAMAGE] = new ConditionTypeDefinition(ConditionType.TAKE_DAMAGE,"TAKE_DAMAGE",TakeDamageCondition,true);
         this.conditionDefinitions[ConditionType.AVOID_DEATH] = new ConditionTypeDefinition(ConditionType.AVOID_DEATH,"AVOID_DEATH",AvoidDeathCondition,false);
         this.conditionDefinitions[ConditionType.COORDINATES] = new ConditionTypeDefinition(ConditionType.COORDINATES,"COORDINATES",CoordinatesCondition,true);
         this.conditionDefinitions[ConditionType.DISTANCE] = new ConditionTypeDefinition(ConditionType.DISTANCE,"DISTANCE",DistanceCondition,false);
         this.conditionDefinitions[ConditionType.TRAVEL] = new ConditionTypeDefinition(ConditionType.TRAVEL,"TRAVEL",TravelCondition,true);
         this.conditionDefinitions[ConditionType.FUEL_SHORTAGE] = new ConditionTypeDefinition(ConditionType.FUEL_SHORTAGE,"FUEL_SHORTAGE",FuelShortageCondition,false);
         this.conditionDefinitions[ConditionType.PROXIMITY] = new ConditionTypeDefinition(ConditionType.PROXIMITY,"PROXIMITY",ProximityCondition,true);
         this.conditionDefinitions[ConditionType.MAP] = new ConditionTypeDefinition(ConditionType.MAP,"MAP",MapCondition,true);
         this.conditionDefinitions[ConditionType.MAP_DIVERSE] = new ConditionTypeDefinition(ConditionType.MAP_DIVERSE,"MAP_DIVERSE",MapDiverseCondition,true);
         this.conditionDefinitions[ConditionType.EMPTY] = new ConditionTypeDefinition(ConditionType.EMPTY,"EMPTY",EmptyCondition,true);
         this.conditionDefinitions[ConditionType.MISCELLANEOUS] = new ConditionTypeDefinition(ConditionType.MISCELLANEOUS,"MISCELLANEOUS",MiscellaneousCondition,true);
         this.conditionDefinitions[ConditionType.AMMUNITION] = new ConditionTypeDefinition(ConditionType.AMMUNITION,"AMMUNITION",AmmunitionCondition,false);
         this.conditionDefinitions[ConditionType.SAVE_AMMUNITION] = new ConditionTypeDefinition(ConditionType.SAVE_AMMUNITION,"SAVE_AMMUNITION",SaveAmmunitionCondition,false);
         this.conditionDefinitions[ConditionType.SPEND_AMMUNITION] = new ConditionTypeDefinition(ConditionType.SPEND_AMMUNITION,"SPEND_AMMUNITION",SpendAmmunitionCondition,true);
         this.conditionDefinitions[ConditionType.SALVAGE] = new ConditionTypeDefinition(ConditionType.SALVAGE,"SALVAGE",SalvageCondition,true);
         this.conditionDefinitions[ConditionType.STEAL] = new ConditionTypeDefinition(ConditionType.STEAL,"STEAL",StealCondition,true);
         this.conditionDefinitions[ConditionType.KILL_NPCS] = new ConditionTypeDefinition(ConditionType.KILL_NPCS,"KILL_NPCS",KillNPCsCondition,true);
         this.conditionDefinitions[ConditionType.KILL_PLAYERS] = new ConditionTypeDefinition(ConditionType.KILL_PLAYERS,"KILL_PLAYERS",KillPlayersCondition,true);
         this.conditionDefinitions[ConditionType.DAMAGE_NPCS] = new ConditionTypeDefinition(ConditionType.DAMAGE_NPCS,"DAMAGE_NPCS",DamageNPCsCondition,true);
         this.conditionDefinitions[ConditionType.DAMAGE_PLAYERS] = new ConditionTypeDefinition(ConditionType.DAMAGE_PLAYERS,"DAMAGE_PLAYERS",DamagePlayersCondition,true);
         this.conditionDefinitions[ConditionType.VISIT_MAP] = new ConditionTypeDefinition(ConditionType.VISIT_MAP,"VISIT_MAP",VisitMapCondition,true);
         this.conditionDefinitions[ConditionType.DIE] = new ConditionTypeDefinition(ConditionType.DIE,"DIE",DieCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_KILL_NPC] = new ConditionTypeDefinition(ConditionType.AVOID_KILL_NPC,"AVOID_KILL_NPC",AvoidKillNPCCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_KILL_NPCS] = new ConditionTypeDefinition(ConditionType.AVOID_KILL_NPCS,"AVOID_KILL_NPCS",AvoidKillNPCsCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_KILL_PLAYERS] = new ConditionTypeDefinition(ConditionType.AVOID_KILL_PLAYERS,"AVOID_KILL_PLAYERS",AvoidKillPlayersCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_DAMAGE_NPCS] = new ConditionTypeDefinition(ConditionType.AVOID_DAMAGE_NPCS,"AVOID_DAMAGE_NPCS",AvoidDamageNPCsCondition,false);
         this.conditionDefinitions[ConditionType.AVOID_DAMAGE_PLAYERS] = new ConditionTypeDefinition(ConditionType.AVOID_DAMAGE_PLAYERS,"AVOID_DAMAGE_PLAYERS",AvoidDamagePlayersCondition,false);
         this.conditionDefinitions[ConditionType.PREVENT] = new ConditionTypeDefinition(ConditionType.PREVENT,"PREVENT",PreventCondition,false);
         this.conditionDefinitions[ConditionType.JUMP] = new ConditionTypeDefinition(ConditionType.JUMP,"JUMP",JumpCondition,true);
         this.conditionDefinitions[ConditionType.AVOID_JUMP] = new ConditionTypeDefinition(ConditionType.AVOID_JUMP,"AVOID_JUMP",AvoidJumpCondition,false);
         this.conditionDefinitions[ConditionType.STEADINESS] = new ConditionTypeDefinition(ConditionType.STEADINESS,"STEADINESS",SteadinessCondition,true);
         this.conditionDefinitions[ConditionType.MULTIPLIER] = new ConditionTypeDefinition(ConditionType.MULTIPLIER,"MULTIPLIER",MultiplierCondition,false);
         this.conditionDefinitions[ConditionType.STAY_AWAY] = new ConditionTypeDefinition(ConditionType.STAY_AWAY,"STAY_AWAY",StayAwayCondition,true);
         this.conditionDefinitions[ConditionType.IN_GROUP] = new ConditionTypeDefinition(ConditionType.IN_GROUP,"IN_GROUP",InGroupCondition,true);
         this.conditionDefinitions[ConditionType.KILL_ANY] = new ConditionTypeDefinition(ConditionType.KILL_ANY,"KILL_ANY",KillAnyCondition,true);
         this.conditionDefinitions[ConditionType.WEB] = new ConditionTypeDefinition(ConditionType.WEB,"WEB",WebCondition,true);
         this.conditionDefinitions[ConditionType.CLIENT] = new ConditionTypeDefinition(ConditionType.CLIENT,"CLIENT",ClientCondition,true);
         this.conditionDefinitions[ConditionType.CARGO] = new ConditionTypeDefinition(ConditionType.CARGO,"CARGO",CargoCondition,true);
         this.conditionDefinitions[ConditionType.SELL_ORE] = new ConditionTypeDefinition(ConditionType.SELL_ORE,"SELL_ORE",SellOreCondition,true);
         this.conditionDefinitions[ConditionType.LEVEL] = new ConditionTypeDefinition(ConditionType.LEVEL,"LEVEL",LevelCondition,true);
         this.conditionDefinitions[ConditionType.RESTRICT_AMMUNITION_KILL_NPC] = new ConditionTypeDefinition(ConditionType.RESTRICT_AMMUNITION_KILL_NPC,"RESTRICT_AMMUNITION_KILL_NPC",RestrictAmmunitionKillNPCCondition,true);
         this.conditionDefinitions[ConditionType.RESTRICT_AMMUNITION_KILL_PLAYER] = new ConditionTypeDefinition(ConditionType.RESTRICT_AMMUNITION_KILL_PLAYER,"RESTRICT_AMMUNITION_KILL_PLAYER",RestrictAmmunitionKillPlayerCondition,true);
         this.conditionDefinitions[ConditionType.HONOR_REDEMPTION] = new ConditionTypeDefinition(ConditionType.HONOR_REDEMPTION,"HONOR_REDEMPTION",HonorRedemptionCondition,true);
      }
      
      public function createCondition(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:int, param8:String = null) : ICondition
      {
         var _loc9_:ICondition = new this.conditionDefinitions[param1].CLASS();
         _loc9_.definition = this.conditionDefinitions[param1];
         _loc9_.init(param2,param3,param4,param5,param6,param7,param8);
         return _loc9_;
      }
   }
}


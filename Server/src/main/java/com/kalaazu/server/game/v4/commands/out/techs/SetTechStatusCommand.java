package com.kalaazu.server.game.v4.commands.out.techs;

import com.kalaazu.server.game.Packet;
import com.kalaazu.server.game.util.ServerCommands;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SetTechStatusCommand extends TechCommand {
    public static final int TYPE_DEFAULT = 0;
    public static final int TYPE_ENERGY_LEECH_ARRAY = 1;
    public static final int TYPE_ENERGY_CHAIN_IMPULSE = 2;
    public static final int TYPE_ROCKET_PROBABILITY_MAXIMIZER = 3;
    public static final int TYPE_SHIELD_BACKUP = 4;
    public static final int TYPE_BATTLE_REPAIR_BOT = 5;
    public static final int TYPE_SPEED_LEECH = 6;
    public static final int TYPE_CLINGING_IMPULSE_DRONE = 7;
    public static final int NUMBER_OF_TYPES = 7;
    public static final int STATE_DEFAULT = 0;
    public static final int STATE_READY = 1;
    public static final int STATE_ACTIVE = 2;
    public static final int STATE_INACTIVE = 3;

    private final String action = ServerCommands.SET_STATUS;

    /*

         var _loc3_:TechItem = null;
         var _loc2_:Array = [];
         var _loc4_:int = 1;
         var _loc5_:int = 3;
         while(_loc5_ < param1.length)
         {
            _loc3_ = new TechItem();
            _loc3_.type = _loc4_;
            if(int(param1[_loc5_] == 4))
            {
               _loc3_.status = 0;
            }
            else
            {
               _loc3_.status = int(param1[_loc5_]);
            }
            _loc3_.amount = int(param1[_loc5_ + 1]);
            _loc3_.secondsLeft = int(param1[_loc5_ + 2]);
            _loc3_.updateName();
            _loc2_.push(_loc3_);
            _loc4_++;
            _loc5_ += TECH_ATTRIBUTES_COUNT;
         }
         this.techModel.setItems(_loc2_);
     */

    private final long energyLeechArrayStatus;
    private final long energyLeechArrayAmount;
    private final long energyLeechArraySecondsLeft;

    private final long energyChainImpulseStatus;
    private final long energyChainImpulseAmount;
    private final long energyChainImpulseSecondsLeft;

    private final long rocketProbabilityMaximizerStatus;
    private final long rocketProbabilityMaximizerAmount;
    private final long rocketProbabilityMaximizerSecondsLeft;

    private final long shieldBackupStatus;
    private final long shieldBackupAmount;
    private final long shieldBackupSecondsLeft;

    private final long battleRepairBotStatus;
    private final long battleRepairBotAmount;
    private final long battleRepairBotSecondsLeft;

    private final long speedLeechStatus;
    private final long speedLeechAmount;
    private final long speedLeechSecondsLeft;

    private final long clingingImpulseDroneStatus;
    private final long clingingImpulseDroneAmount;
    private final long clingingImpulseDroneSecondsLeft;

    @Override
    public void subWrite(Packet packet) {
        packet.writeLong(energyLeechArrayStatus);
        packet.writeLong(energyLeechArrayAmount);
        packet.writeLong(energyLeechArraySecondsLeft);

        packet.writeLong(energyChainImpulseStatus);
        packet.writeLong(energyChainImpulseAmount);
        packet.writeLong(energyChainImpulseSecondsLeft);

        packet.writeLong(rocketProbabilityMaximizerStatus);
        packet.writeLong(rocketProbabilityMaximizerAmount);
        packet.writeLong(rocketProbabilityMaximizerSecondsLeft);

        packet.writeLong(shieldBackupStatus);
        packet.writeLong(shieldBackupAmount);
        packet.writeLong(shieldBackupSecondsLeft);

        packet.writeLong(battleRepairBotStatus);
        packet.writeLong(battleRepairBotAmount);
        packet.writeLong(battleRepairBotSecondsLeft);

        packet.writeLong(speedLeechStatus);
        packet.writeLong(speedLeechAmount);
        packet.writeLong(speedLeechSecondsLeft);

        packet.writeLong(clingingImpulseDroneStatus);
        packet.writeLong(clingingImpulseDroneAmount);
        packet.writeLong(clingingImpulseDroneSecondsLeft);
    }
}

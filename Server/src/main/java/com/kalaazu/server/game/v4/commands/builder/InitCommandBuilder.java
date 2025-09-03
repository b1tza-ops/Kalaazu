package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.persistence.entity.*;
import com.kalaazu.persistence.service.AccountsConfigurationsAccountsItemsService;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.attributes.CpuHeroInfoCommand;
import com.kalaazu.server.game.v4.commands.out.attributes.UpdateConfigurationCountCommand;
import com.kalaazu.server.game.v4.commands.out.map.ShipInitializationCommand;
import com.kalaazu.server.game.v4.commands.out.techs.SetTechStatusCommand;
import com.kalaazu.server.game.v4.commands.out.user.PrimaryWeaponInfoCommand;
import com.kalaazu.server.game.v4.commands.out.user.SecondaryWeaponInfoCommand;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Init command builder.
 * =====================
 * <p>
 * Command builder for the initial packets sent when a new session starts.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@Component("v4InitCommandBuilder")
@AllArgsConstructor
public class InitCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.InitCommands;

    private final AccountsConfigurationsAccountsItemsService accountsConfigurationsAccountsItemsService;

    /**
     * Builds the necessary commands for the given arguments.
     * <p>
     * Since there's no way to ensure type safety on the arguments
     * be careful of how you use it.
     *
     * @param arguments Command arguments.
     * @return Command for the given arguments.
     */
    @Override
    public List<OutCommand> build(Object[] arguments) {
        var account = (AccountsEntity) arguments[0];
        var hangar = (AccountsHangarsEntity) arguments[1];
        var ship = (AccountsShipsEntity) arguments[2];
        var config = (AccountsConfigurationsEntity) arguments[3];
        var clanId = (Integer) arguments[4];
        var clanTag = (String) arguments[5];

        return List.of(
                buildShipInitialization(account, ship, config, clanId, clanTag),
                buildPrimaryWeaponInfo(account),
                buildSecondaryWeaponInfo(account),
                new UpdateConfigurationCountCommand(config.getConfigurationId()),
                buildSetTechStatus(account),
                buildCpuHeroInfo(config)
        );
    }

    private SecondaryWeaponInfoCommand buildSecondaryWeaponInfo(AccountsEntity account) {
        var items = account.getCalculatedItems();

        return new SecondaryWeaponInfoCommand(
                items.r310(),
                items.plt2026(),
                items.plt2021(),
                items.plt3030(),
                items.pld8(),
                items.dcr_250(),
                items.wiz(),
                items.mine(),
                items.smartbomb(),
                items.instashield(),
                items.emp(),
                items.mine_emp(),
                items.mine_sab(),
                items.mine_ddm()
        );
    }

    private PrimaryWeaponInfoCommand buildPrimaryWeaponInfo(AccountsEntity account) {
        var items = account.getCalculatedItems();

        return new PrimaryWeaponInfoCommand(
                items.lcb10(),
                items.mcb25(),
                items.mcb50(),
                items.ucb100(),
                items.sab50(),
                items.rsb75()
        );
    }

    private ShipInitializationCommand buildShipInitialization(AccountsEntity account, AccountsShipsEntity ship, AccountsConfigurationsEntity config, int clanId, String clanTag) {
        var items = account.getCalculatedItems();

        return new ShipInitializationCommand(
                account.getId(),
                account.getName(),
                ship.getShipsByShipsId().getGfx(),
                config.getSpeed(),
                ship.getShield(),
                config.getShield(),
                ship.getHealth(),
                config.getHealth(),
                (int) items.cargo(),
                ship.getShipsByShipsId().getCargo(),
                ship.getPosition().getX(),
                ship.getPosition().getY(),
                ship.getMapsId(),
                account.getFactionsId(),
                clanId,
                items.ammo(),
                items.rockets(),
                1, // TODO equipment expansion
                account.isPremium(),
                items.exp(),
                items.hon(),
                account.getLevelsId(),
                items.cre(),
                items.uri(),
                (int) items.jpt(),
                account.getRanksId(),
                clanTag,
                0, // TODO account rings
                false // TODO account cloacked
        );
    }

    private SetTechStatusCommand buildSetTechStatus(AccountsEntity account) {
        var items = account.getCalculatedItems();

        return new SetTechStatusCommand(
                items.energyLeechArrayStatus(),
                items.energyLeechArrayAmount(),
                items.energyLeechArraySecondsLeft(),
                items.energyChainImpulseStatus(),
                items.energyChainImpulseAmount(),
                items.energyChainImpulseSecondsLeft(),
                items.rocketProbabilityMaximizerStatus(),
                items.rocketProbabilityMaximizerAmount(),
                items.rocketProbabilityMaximizerSecondsLeft(),
                items.shieldBackupStatus(),
                items.shieldBackupAmount(),
                items.shieldBackupSecondsLeft(),
                items.battleRepairBotStatus(),
                items.battleRepairBotAmount(),
                items.battleRepairBotSecondsLeft(),
                items.speedLeechStatus(),
                items.speedLeechAmount(),
                items.speedLeechSecondsLeft(),
                items.clingingImpulseDroneStatus(),
                items.clingingImpulseDroneAmount(),
                items.clingingImpulseDroneSecondsLeft()
        );
    }

    private CpuHeroInfoCommand buildCpuHeroInfo(AccountsConfigurationsEntity config) {
        var items = accountsConfigurationsAccountsItemsService.findConfiguredShipItemsByItemType(config, ItemType.SPECIAL_EXTRA, ItemType.EXTRA, ItemType.REPAIRBOT);

        var droneRepair = 0L;
        var radar = 0L;
        var jump = 0L;
        var ammobuy = 0L;
        var robot = 0L;
        var hm7 = 0L;
        var smartbomb = 0L;
        var instashield = 0L;
        var mineturbo = 0L;
        var aim = 0L;
        var arol = 0L;
        var cloak = 0L;
        var rllb = 0L;
        var rocketbuy = 0L;
        var advancedJump = 0L;

        var i = items.stream()
                .map(AccountsConfigurationsAccountsItemsEntity::getAccountsItemsByAccountsItemsId)
                .toList();

        for (var item : i) {
            switch (item.getItemsId()) {
                case 195 -> hm7 = item.getAmount();
                case 206, 207 -> droneRepair = item.getAmount();
                case 224 -> radar = item.getAmount();
                case 199 -> ammobuy = item.getAmount();
                case 214, 215 -> jump = item.getAmount();
                case 232, 233, 234, 235 -> robot = item.getAmount();
                case 231 -> smartbomb = item.getAmount();
                case 213 -> instashield = item.getAmount();
                case 216, 217 -> mineturbo = item.getAmount();
                case 196, 197 -> aim = item.getAmount();
                case 202 -> arol = item.getAmount();
                case 203, 204, 205 -> cloak = item.getAmount();
                case 225 -> rllb = item.getAmount();
                case 223 -> rocketbuy = item.getAmount();
                case 198 -> advancedJump = item.getAmount();
            }
        }

        return new CpuHeroInfoCommand(
                droneRepair,
                radar,
                jump,
                ammobuy,
                robot,
                hm7,
                smartbomb,
                instashield,
                mineturbo,
                aim,
                arol,
                cloak,
                rllb,
                rocketbuy,
                advancedJump
        );
    }
}

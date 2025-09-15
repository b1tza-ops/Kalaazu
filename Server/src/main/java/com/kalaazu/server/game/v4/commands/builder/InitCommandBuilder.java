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
 *
 * This class is responsible for creating the initial set of commands sent to the client
 * when a player's session is initialized. It aggregates various pieces of player data
 * (account, ship, configuration, etc.) to construct commands that set up the player's
 * ship, inventory, UI, and other initial states on the client-side.
 *
 * @example
 * ```java
 * // In a service, using a CommandBuilder to get all initialization commands.
 * CommandBuilder commandBuilder = // ... injected instance
 *
 * // Build all commands associated with the InitCommands type.
 * List<OutCommand> initCommands = commandBuilder.buildCommands(
 *     CommandType.InitCommands,
 *     account, hangar, ship, config, clanId, clanTag
 * );
 *
 * // Send the commands to the player.
 * ctx.publishEvent(new SendCommands(session, initCommands));
 * ```
 *
 * @see com.kalaazu.server.game.commands.CommandBuilder
 * @see com.kalaazu.server.game.commands.CommandBuilderInterface
 * @see com.kalaazu.server.game.commands.CommandType
 *
 * @author manulaiko
 */
@Data
@Component("v4InitCommandBuilder")
@AllArgsConstructor
public class InitCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.InitCommands;

    private final AccountsConfigurationsAccountsItemsService accountsConfigurationsAccountsItemsService;

    /**
     * Builds the list of initialization commands for a player session.
     *
     * This method orchestrates the creation of several commands required to set up the player's
     * state on the client, including ship initialization, weapon info, and CPU status. It
     * expects a specific order and type of arguments.
     *
     * @param arguments An array of objects containing the necessary data for building the commands.
     *                  The expected arguments are: `[AccountsEntity, AccountsHangarsEntity,
     *                  AccountsShipsEntity, AccountsConfigurationsEntity, Integer (clanId),
     *                  String (clanTag)]`.
     *
     * @return A `List` of `OutCommand` objects ready to be sent to the client.
     *
     * @throws ClassCastException If the elements in `arguments` are not of the expected types.
     * @throws ArrayIndexOutOfBoundsException If the `arguments` array does not contain all the required elements.
     *
     * @example
     * ```java
     * AccountsEntity account = // ...
     * AccountsHangarsEntity hangar = // ...
     * AccountsShipsEntity ship = // ...
     * AccountsConfigurationsEntity config = // ...
     * int clanId = 1;
     * String clanTag = "CLAN";
     *
     * Object[] args = { account, hangar, ship, config, clanId, clanTag };
     * List<OutCommand> commands = initCommandBuilder.build(args);
     * ```
     */
    @Override
    public List<OutCommand> build(Object[] arguments) {
        var account = (AccountsEntity) arguments[0];
        var hangar = (AccountsHangarsEntity) arguments[1];
        var ship = (AccountsShipsEntity) arguments[2];
        var config = (AccountsConfigurationsEntity) arguments[3];
        var clanId = (Integer) arguments[4];
        var clanTag = (String) arguments[5];

        config.setSpeed((short) 1000);

        return List.of(
                buildShipInitialization(account, ship, config, clanId, clanTag),
                buildPrimaryWeaponInfo(account),
                buildSecondaryWeaponInfo(account),
                new UpdateConfigurationCountCommand(config.getConfigurationId()),
                buildSetTechStatus(account),
                buildCpuHeroInfo(config)
        );
    }

    /**
     * Builds the core ship initialization command.
     *
     * This command contains all the fundamental information about the player's ship and status,
     * such as position, stats, clan info, and resources.
     *
     * @param account The player's account entity.
     * @param ship The player's active ship entity.
     * @param config The player's active configuration entity.
     * @param clanId The ID of the player's clan.
     * @param clanTag The tag of the player's clan.
     *
     * @return A `ShipInitializationCommand` with all the necessary data to create the player's ship on the client.
     *
     * @example
     * ```java
     * AccountsEntity account = // ...
     * AccountsShipsEntity ship = // ...
     * AccountsConfigurationsEntity config = // ...
     * int clanId = 1;
     * String clanTag = "CLAN";
     *
     * ShipInitializationCommand command = initCommandBuilder.buildShipInitialization(account, ship, config, clanId, clanTag);
     * ```
     *
     * @see com.kalaazu.server.game.v4.commands.out.map.ShipInitializationCommand
     */
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

    /**
     * Builds the command to inform the client about the player's primary weapon (laser) ammunition quantities.
     *
     * @param account The player's account entity, used to retrieve calculated item counts.
     *
     * @return A `PrimaryWeaponInfoCommand` populated with the player's laser ammunition data.
     *
     * @example
     * ```java
     * AccountsEntity account = // ...
     * PrimaryWeaponInfoCommand command = initCommandBuilder.buildPrimaryWeaponInfo(account);
     * ```
     *
     * @see com.kalaazu.server.game.v4.commands.out.user.PrimaryWeaponInfoCommand
     * @see com.kalaazu.persistence.entity.AccountsEntity
     */
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

    /**
     * Builds the command to inform the client about the player's secondary weapon and special ammunition quantities.
     *
     * @param account The player's account entity, used to retrieve calculated item counts.
     *
     * @return A `SecondaryWeaponInfoCommand` populated with the player's ammunition data.
     *
     * @example ```java
     * AccountsEntity account = // ...
     * SecondaryWeaponInfoCommand command = initCommandBuilder.buildSecondaryWeaponInfo(account);
     * ```
     * @see com.kalaazu.server.game.v4.commands.out.user.SecondaryWeaponInfoCommand
     * @see com.kalaazu.persistence.entity.AccountsEntity
     */
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

    /**
     * Builds the command to set the status of the player's tech items.
     *
     * @param account The player's account entity, used to retrieve tech item statuses.
     *
     * @return A `SetTechStatusCommand` populated with the player's tech statuses.
     *
     * @example
     * ```java
     * AccountsEntity account = // ...
     * SetTechStatusCommand command = initCommandBuilder.buildSetTechStatus(account);
     * ```
     *
     * @see com.kalaazu.server.game.v4.commands.out.techs.SetTechStatusCommand
     */
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

    /**
     * Builds the command to inform the client about the player's equipped CPU items.
     *
     * It queries the items for the given configuration and maps them to the corresponding CPU types.
     *
     * @param config The player's active configuration entity, used to find equipped CPU items.
     *
     * @return A `CpuHeroInfoCommand` with the quantities of each equipped CPU.
     *
     * @example
     * ```java
     * AccountsConfigurationsEntity config = // ...
     * CpuHeroInfoCommand command = initCommandBuilder.buildCpuHeroInfo(config);
     * ```
     *
     * @see com.kalaazu.server.game.v4.commands.out.attributes.CpuHeroInfoCommand
     * @see com.kalaazu.persistence.service.AccountsConfigurationsAccountsItemsService
     */
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

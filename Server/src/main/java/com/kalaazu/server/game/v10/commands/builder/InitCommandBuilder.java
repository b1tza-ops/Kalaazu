package com.kalaazu.server.game.v10.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsHangarsEntity;
import com.kalaazu.persistence.entity.AccountsShipsEntity;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.util.ServerCommands;
import com.kalaazu.server.game.v10.commands.LegacyPacket;
import com.kalaazu.server.game.v10.commands.out.map.ShipInitializationCommand;
import com.kalaazu.server.game.v10.commands.out.player.BeaconCommand;
import com.kalaazu.server.game.v10.commands.out.player.SetHealthPointsCommand;
import com.kalaazu.server.game.v10.commands.out.player.SetShieldPointsCommand;
import com.kalaazu.server.game.v10.commands.out.player.SetSpeedCommand;
import com.kalaazu.server.service.SessionInitializationService;
import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
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
@Component
public class InitCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V10;
    private final CommandType commandType = CommandType.InitCommands;

    private static ShipInitializationCommand buildShipInitialization(AccountsEntity account, AccountsShipsEntity ship, AccountsConfigurationsEntity config, SessionInitializationService.CalculatedItems items, int clanId, String clanTag) {
        return new ShipInitializationCommand(
                account.getId(),
                account.getName(),
                ship.getShipsByShipsId().getItemsByItemsId().getLootId(),
                config.getSpeed(),
                ship.getShield(),
                config.getShield(),
                ship.getHealth(),
                config.getHealth(),
                (int) items.cargo(),
                ship.getShipsByShipsId().getCargo(),
                ship.getNanohull(),
                ship.getShipsByShipsId().getHealth(),
                ship.getPosition().getX(),
                ship.getPosition().getY(),
                ship.getMapsId(),
                account.getFactionsId(),
                clanId,
                3,
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
                true,
                false, // TODO account cloacked
                new ArrayList<>()
        );
    }

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
        var items = (SessionInitializationService.CalculatedItems) arguments[4];
        var clanId = (Integer) arguments[5];
        var clanTag = (String) arguments[6];

        return List.of(
                buildShipInitialization(account, ship, config, items, clanId, clanTag),
                new LegacyPacket(ServerCommands.SET_STATUS, ServerCommands.CONFIGURATION, config.getConfigurationId()),
                new SetHealthPointsCommand(ship.getHealth(), config.getHealth(), ship.getNanohull(), ship.getShipsByShipsId().getHealth()),
                new SetShieldPointsCommand(ship.getShield(), config.getShield()),
                new SetSpeedCommand(config.getSpeed()),
                new BeaconCommand(1, 1, 1, 1, true, false, false, "equipment_extra_repbot_rep-4", false)
        );
    }
}

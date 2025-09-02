package com.kalaazu.server.game.v4.commands.builder;

import com.kalaazu.model.Version;
import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsHangarsEntity;
import com.kalaazu.persistence.entity.AccountsShipsEntity;
import com.kalaazu.server.game.commands.CommandBuilderInterface;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.commands.OutCommand;
import com.kalaazu.server.game.v4.commands.out.attributes.UpdateConfigurationCountCommand;
import com.kalaazu.server.game.v4.commands.out.map.ShipInitializationCommand;
import com.kalaazu.server.game.v4.commands.out.user.PrimaryWeaponInfoCommand;
import com.kalaazu.server.game.v4.commands.out.user.SecondaryWeaponInfoCommand;
import com.kalaazu.server.service.SessionInitializationService;
import lombok.Data;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.Instant;
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
@Component("v4InitCommandBuilder")
public class InitCommandBuilder implements CommandBuilderInterface {
    private final Version gameVersion = Version.V4;
    private final CommandType commandType = CommandType.InitCommands;

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

        var cmds = new ArrayList<OutCommand>();

        var premium = account.getPremiumDate() != null && account.getPremiumDate().before(Timestamp.from(Instant.now()));

        var clan = account.getClansByClansId();
        var clanId = 0;
        var clanTag = "";

        if (clan != null) {
            clanId = clan.getId();
            clanTag = clan.getTag();
        }

        cmds.add(new ShipInitializationCommand(
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
                premium,
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
        ));
        cmds.add(new PrimaryWeaponInfoCommand(
                items.lcb10(),
                items.mcb25(),
                items.mcb50(),
                items.ucb100(),
                items.sab50(),
                items.rsb75()
        ));
        cmds.add(new SecondaryWeaponInfoCommand(
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
        ));
        cmds.add(new UpdateConfigurationCountCommand(config.getConfigurationId()));

        return cmds;
    }
}

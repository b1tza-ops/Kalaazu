package com.kalaazu.server.service;

import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.AccountsHangarsEntity;
import com.kalaazu.persistence.entity.ItemType;
import com.kalaazu.persistence.service.UsersService;
import com.kalaazu.server.event.EndGameSessionEvent;
import com.kalaazu.server.event.EndGameSessionIfEvent;
import com.kalaazu.server.event.GameSessionStartedEvent;
import com.kalaazu.server.event.SendCommandsEvent;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.netty.GameSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

/**
 * Session initialization service.
 * ===============================
 * <p>
 * Service that contains the logic required to initialize a new GameSession.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class SessionInitializationService {
    private final ApplicationContext ctx;
    private final UsersService users;
    private final CommandBuilder commandBuilder;

    public void initialize(Integer userId, String sessionId, GameSession session) {
        log.info("Incoming login request from userID {} with sessionID {}", userId, sessionId);

        var user = users.find(userId);
        if (user == null) {
            log.info("Invalid user ID {}", userId);

            return;
        }

        var account = user.getAccounts()
                .stream()
                .filter(a -> a.getSessionId().equalsIgnoreCase(sessionId))
                .findFirst()
                .orElse(null);

        if (account == null) {
            log.info("Invalid session ID {}", sessionId);

            ctx.publishEvent(new EndGameSessionEvent(session, this));

            return;
        }

        // End previous sessions of this account.
        ctx.publishEvent(new EndGameSessionIfEvent((s) -> {
            var acc = s.getValue().getAccount();

            return (acc != null && acc.getId() == account.getId());
        }, this));

        session.setAccount(account);

        this.sendInitialPackets(account, session);
        ctx.publishEvent(new GameSessionStartedEvent(session, this));
    }

    private void sendInitialPackets(AccountsEntity account, GameSession session) {
        var settings = commandBuilder.buildCommands(CommandType.SettingsCommand, account.getAccountsSettings());
        ctx.publishEvent(new SendCommandsEvent(session, settings, this));

        var hangar = account.getAccountsHangarsByAccountsHangarsId();
        var ship = hangar.getAccountsShipsByAccountsShipsId();
        var config = hangar.getAccountsConfigurationsByAccountsConfigurationsId();

        session.setShip(ship);
        session.setMapId(ship.getMapsId());
        session.setHangar(hangar);
        session.setConfiguration(config);

        var initialPackets = commandBuilder.buildCommands(CommandType.InitCommands, account, hangar, ship, config, getCalculatedItems(account));
        ctx.publishEvent(new SendCommandsEvent(session, initialPackets, this));
    }

    private CalculatedItems getCalculatedItems(AccountsEntity account) {
        // Stats
        var exp = 0L;
        var hon = 0L;
        var cre = 0L;
        var uri = 0L;
        var jpt = 0L;

        var cargo = 0L;
        var ammo = 0L;
        var rockets = 0L;
        var hellstorm = 0L;
        var mines = 0L;

        var lcb10 = 0L;
        var mcb25 = 0L;
        var mcb50 = 0L;
        var ucb100 = 0L;
        var sab50 = 0L;
        var rsb75 = 0L;

        var r310 = 0L;
        var plt2026 = 0L;
        var plt2021 = 0L;
        var plt3030 = 0L;
        var pld8 = 0L;
        var dcr_250 = 0L;
        var wiz = 0L;
        var mine = 0L;
        var smartbomb = 0L; // TODO add accounts.config.hasExtra()
        var instashield = 0L; // "
        var emp = 0L;
        var mine_emp = 0L;
        var mine_sab = 0L;
        var mine_ddm = 0L;

        for (var item : account.getAccountsItems()) {
            var i = item.getItemsByItemsId();
            var amount = item.getAmount();

            switch (i.getLootId()) {
                case "currency_credits" -> cre = amount;
                case "currency_uridium" -> uri = amount;
                case "currency_jackpot" -> jpt = amount;
                case "stats_experience" -> exp = amount;
                case "stats_honor" -> hon = amount;

                case "ammunition_laser_lcb-10" -> lcb10 = amount;
                case "ammunition_laser_mcb-25" -> mcb25 = amount;
                case "ammunition_laser_mcb-50" -> mcb50 = amount;
                case "ammunition_laser_sab-50" -> sab50 = amount;
                case "ammunition_laser_ucb-100" -> ucb100 = amount;
                case "ammunition_laser_rsb-75" -> rsb75 = amount;

                case "ammunition_rocket_r-310" -> r310 = amount;
                case "ammunition_rocket_plt-2021" ->  plt2021 = amount;
                case "ammunition_rocket_plt-2026" -> plt2026 = amount;
                case "ammunition_rocket_plt-3030" ->  plt3030 = amount;
                case "ammunition_specialammo_dcr-250" ->  dcr_250 = amount;
                case "ammunition_specialammo_pld-8" -> pld8 = amount;
                case "ammunition_specialammo_wiz-x" ->  wiz = amount;
                case "ammunition_mine_acm-01" ->  mine = amount;
                case "ammunition_mine_ddm-01" -> mine_ddm = amount;
                case "ammunition_mine_empm-01" ->  mine_emp = amount;
                case "ammunition_mine_sabm-01" ->  mine_sab = amount;
                case "ammunition_specialammo_emp-01" -> emp = amount;
            }

            switch (i.getType()) {
                case ItemType.RESOURCE:
                    if (i.getId() != 309) { // not xenomit
                        cargo += amount;
                    }
                case ItemType.LASER_AMMO:
                    ammo += amount;
                case ItemType.ROCKET:
                    rockets += amount;
                case ItemType.HELLSTORM_ROCKET:
                    hellstorm += amount;
                case ItemType.MINE:
                    mines += amount;
            }
        }

        return new CalculatedItems(
                exp,
                hon,
                cre,
                uri,
                jpt,
                cargo,
                ammo,
                rockets,
                hellstorm,
                mines,
                lcb10,
                mcb25,
                mcb50,
                ucb100,
                sab50,
                rsb75,
                r310,
                plt2026,
                plt2021,
                plt3030,
                pld8,
                dcr_250,
                wiz,
                mine,
                smartbomb,
                instashield,
                emp,
                mine_emp,
                mine_sab,
                mine_ddm
        );
    }

    public record CalculatedItems(
            long exp,
            long hon,
            long cre,
            long uri,
            long jpt,

            long cargo,
            long ammo,
            long rockets,
            long hellstorm,
            long mines,

            long lcb10,
            long mcb25,
            long mcb50,
            long ucb100,
            long sab50,
            long rsb75,


            long r310,
            long plt2026,
            long plt2021,
            long plt3030,
            long pld8,
            long dcr_250,
            long wiz,
            long mine,
            long smartbomb,
            long instashield,
            long emp,
            long mine_emp,
            long mine_sab,
            long mine_ddm
    ) {
    }
}

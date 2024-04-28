package com.kalaazu.server.service;

import com.kalaazu.persistence.entity.AccountsEntity;
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

        // Cargo
        var prometium = 0L;
        var endurium = 0L;
        var terbium = 0L;
        var prometid = 0L;
        var duranium = 0L;
        var promerium = 0L;
        var xenomit = 0L;
        var seprom = 0L;
        var palladium = 0L;

        var cargo = 0L;

        // Ammo
        var lbc10 = 0L;
        var mvb25 = 0L;
        var mcb50 = 0L;
        var ucb100 = 0L;
        var sab50 = 0L;
        var rsb75 = 0L;
        var cbo100 = 0L;
        var job100 = 0L;

        var ammo = 0L;

        // Rockets
        var r310 = 0L;
        var plt2026 = 0L;
        var plt2021 = 0L;
        var plt3030 = 0L;
        var dcr250 = 0L;
        var bdr1211 = 0L;
        var wizx = 0L;
        var pld8 = 0L;

        var rockets = 0L;

        // Hellstorm
        var cbr100 = 0L;
        var eco10 = 0L;
        var hstrm01 = 0L;
        var sar01 = 0L;
        var sar02 = 0L;
        var ubr100 = 0L;
        var shg01 = 0L;
        var shg02 = 0L;
        var bdr1212 = 0L;

        var hellstorm = 0;

        // Mines
        var acm01 = 0L;
        var ddm01 = 0L;
        var empm01 = 0L;
        var sabm01 = 0L;
        var rb02 = 0L;
        var rbe01 = 0L;
        var rbe02 = 0L;
        var sl01 = 0L;

        var mines = 0L;

        for (var item : account.getAccountsItems()) {
            var i = item.getItemsId();
            var amount = item.getAmount();

            switch (i) {
                case 1 -> cre = amount;
                case 2 -> uri = amount;
                case 3 -> jpt = amount;
                case 4 -> exp = amount;
                case 5 -> hon = amount;

                case 236 -> prometium = amount;
                case 237 -> endurium = amount;
                case 238 -> terbium = amount;
                case 239 -> prometid = amount;
                case 240 -> duranium = amount;
                case 241 -> xenomit = amount;
                case 242 -> promerium = amount;
                case 243 -> seprom = amount;
                case 244 -> palladium = amount;
            }
        }

        cargo = prometium + endurium + terbium + prometid + duranium + promerium + seprom + palladium;

        return new CalculatedItems(
                exp,
                hon,
                cre,
                uri,
                jpt,
                prometium,
                endurium,
                terbium,
                prometid,
                duranium,
                promerium,
                xenomit,
                seprom,
                palladium,
                cargo,
                lbc10,
                mvb25,
                mcb50,
                ucb100,
                sab50,
                rsb75,
                cbo100,
                job100,
                r310,
                plt2026,
                plt2021,
                plt3030,
                dcr250,
                bdr1211,
                wizx,
                pld8,
                cbr100,
                eco10,
                hstrm01,
                sar01,
                sar02,
                ubr100,
                shg01,
                shg02,
                bdr1212,
                acm01,
                ddm01,
                empm01,
                sabm01,
                rb02,
                rbe01,
                rbe02,
                sl01
        );
    }

    public record CalculatedItems(
            long exp,
            long hon,
            long cre,
            long uri,
            long jpt,

            // Cargo
            long prometium,
            long endurium,
            long terbium,
            long prometid,
            long duranium,
            long promerium,
            long xenomit,
            long seprom,
            long palladium,

            long cargo,

            // Ammo
            long lbc10,
            long mvb25,
            long mcb50,
            long ucb100,
            long sab50,
            long rsb75,
            long cbo100,
            long job100,

            // Rockets
            long r310,
            long plt2026,
            long plt2021,
            long plt3030,
            long dcr250,
            long bdr1211,
            long wizx,
            long pld8,

            // Hellstorm
            long cbr100,
            long eco10,
            long hstrm01,
            long sar01,
            long sar02,
            long ubr100,
            long shg01,
            long shg02,
            long bdr1212,

            // Mines
            long acm01,
            long ddm01,
            long empm01,
            long sabm01,
            long rb02,
            long rbe01,
            long rbe02,
            long sl01
    ) {
    }
}

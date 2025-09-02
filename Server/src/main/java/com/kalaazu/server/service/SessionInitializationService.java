package com.kalaazu.server.service;

import com.kalaazu.persistence.entity.AccountsEntity;
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

        for (var item : account.getAccountsItems()) {
            var i = item.getItemsByItemsId();
            var amount = item.getAmount();

            switch (item.getItemsId()) {
                case 1 -> cre = amount;
                case 2 -> uri = amount;
                case 3 -> jpt = amount;
                case 4 -> exp = amount;
                case 5 -> hon = amount;
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
                mines
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
            long mines
    ) {
    }
}

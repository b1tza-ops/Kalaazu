package com.kalaazu.server.service;

import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.service.UsersService;
import com.kalaazu.server.event.EndGameSession;
import com.kalaazu.server.event.EndGameSessionIf;
import com.kalaazu.server.event.GameSessionStarted;
import com.kalaazu.server.event.SendCommands;
import com.kalaazu.server.game.commands.CommandBuilder;
import com.kalaazu.server.game.commands.CommandType;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
public class SessionInitializationService implements Logger {
    private final ApplicationContext ctx;
    private final UsersService users;
    private final CommandBuilder commandBuilder;

    @Getter
    private final LoggingCategory category = LoggingCategory.SERVER;

    public void initialize(int userId, String sessionId, GameSession session) {
        info("Incoming login request from userID {} with sessionID {}", userId, sessionId);

        var user = users.find(userId);
        if (user == null) {
            info("Invalid user ID {}", userId);

            return;
        }

        var account = user.getAccounts()
                .stream()
                .filter(a -> a.getSessionId().equalsIgnoreCase(sessionId))
                .findFirst()
                .orElse(null);

        if (account == null) {
            info("Invalid session ID {}", sessionId);

            ctx.publishEvent(new EndGameSession(session));

            return;
        }

        // End previous sessions of this account.
        ctx.publishEvent(new EndGameSessionIf((s) -> {
            var acc = s.getValue().getAccount();

            return (acc != null && acc.getId() == account.getId());
        }));

        this.sendInitialPackets(account, session);

        session.setAccount(account);
        ctx.publishEvent(new GameSessionStarted(session));
    }

    private void sendInitialPackets(AccountsEntity account, GameSession session) {
        var settings = commandBuilder.buildCommands(CommandType.SettingsCommand, account.getAccountsSettings());
        ctx.publishEvent(new SendCommands(session, settings));

        var hangar = account.getAccountsHangarsByAccountsHangarsId();
        var ship = hangar.getAccountsShipsByAccountsShipsId();
        var config = hangar.getAccountsConfigurationsByAccountsConfigurationsId();

        session.setShip(ship);
        session.setMapId(ship.getMapsId());
        session.setHangar(hangar);
        session.setConfiguration(config);

        var clan = account.getClansByClansId();
        var clanId = 0;
        var clanTag = "";

        if (clan != null) {
            clanId = clan.getId();
            clanTag = clan.getTag();
        }

        var initialPackets = commandBuilder.buildCommands(CommandType.InitCommands, account, hangar, ship, config, clanId, clanTag);
        ctx.publishEvent(new SendCommands(session, initialPackets));
    }
}

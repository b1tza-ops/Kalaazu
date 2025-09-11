package com.kalaazu.server.event;

import com.kalaazu.server.game.netty.GameSession;
import io.netty.channel.ChannelId;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

import java.util.Map;
import java.util.function.Function;

/**
 * End game session if event.
 * ==========================
 * <p>
 * Ends the game session that matches the condition.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class EndGameSessionIf extends ApplicationEvent {
    private final Function<Map.Entry<ChannelId, GameSession>, Boolean> condition;

    public EndGameSessionIf(Function<Map.Entry<ChannelId, GameSession>, Boolean> condition) {
        super(new Object());

        this.condition = condition;
    }
}

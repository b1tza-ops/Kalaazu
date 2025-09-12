package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.AccountsEntity;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.server.game.netty.GameSession;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import lombok.Data;
import lombok.Getter;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

/**
 * Player entity.
 * ==============
 * <p>
 * Represents a player in a map.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@Component
@Scope("prototype")
public class Player implements MovableMapEntity, Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.USER;

    private int id;
    private Vector initialPosition = Vector.ZERO.cpy();
    private Vector position = Vector.ZERO.cpy();
    private Vector destination = Vector.ZERO.cpy();
    private short speed;
    private boolean moving;
    private long endMovementTime;
    private int totalMovementTime;

    private GameSession gameSession;
    private MapsEntity map;
    private AccountsEntity account;

    @Async
    public void tick() {
        this.movementTick();
    }
}

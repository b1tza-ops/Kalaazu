package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.persistence.entity.NpcsEntity;
import lombok.Data;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Npc.
 * ====
 * <p>
 * Represents an NPC in a map.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Data
@Component
@Scope("prototype")
public class Npc implements MovableMapEntity {
    private int id;
    private Vector initialPosition = Vector.ZERO.cpy();
    private Vector position = Vector.ZERO.cpy();
    private Vector destination = Vector.ZERO.cpy();
    private boolean moving;
    private long endMovementTime;
    private long nextMovementTime;
    private int totalMovementTime;
    private short speed;

    private NpcsEntity npc;
    private MapsEntity map;

    @Async
    @Scheduled(fixedDelay = 500)
    public void tick() {
        if (this.isMoving()) {
            this.movementTick();
        } else if (nextMovementTime == 0) {
            nextMovementTime = System.currentTimeMillis() + 5000;
        } else if (nextMovementTime >= System.currentTimeMillis()) {
            nextMovementTime = 0;
            move(position, Vector.random(map.getLimits().margin()));
        }
    }
}

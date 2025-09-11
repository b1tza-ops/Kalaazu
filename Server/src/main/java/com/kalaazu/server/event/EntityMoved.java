package com.kalaazu.server.event;

import com.kalaazu.server.entities.MovableMapEntity;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * Entity moved event.
 * ===================
 * <p>
 * Fired when a map entity has moved.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Getter
public class EntityMoved extends ApplicationEvent {
    private final MovableMapEntity entity;

    public EntityMoved(MovableMapEntity entity) {
        super(new Object());

        this.entity = entity;
    }
}

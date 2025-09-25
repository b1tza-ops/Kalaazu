package com.kalaazu.server.ecs.component;

import com.artemis.Component;
import lombok.Data;
import lombok.experimental.Accessors;

/**
 * Represents the health and shield attributes of an entity.
 * =========================================================
 *
 * This component stores the current and maximum values for both health and shield,
 * which are fundamental for combat and survival mechanics within the game.
 *
 * @author manulaiko
 * @example ```java
 * // Create and configure a HealthComponent for an entity
 * HealthComponent health = new HealthComponent();
 * health.setMaxHealth(100000);
 * health.setHealth(80000);
 * health.setMaxShield(50000);
 * health.setShield(25000);
 *
 * // Later, you can access these values
 * int currentHealth = health.getHealth(); // 80000
 * int currentShield = health.getShield(); // 25000
 * ```
 * @see com.kalaazu.server.game.v4.handler.SelectShipHandler
 * @see com.kalaazu.server.game.v4.commands.out.map.ShipSelectedCommand
 */
@Data
@Accessors(chain = true)
public class HealthComponent extends Component {
    private int health;
    private int maxHealth;
    private int shield;
    private int maxShield;
}

package com.kalaazu.server.ecs.entity;

/**
 * Represents the fundamental category of an entity within the game world.
 * =======================================================================
 *
 * This enumeration is crucial for systems that need to apply different logic
 * or behavior based on an entity's role, such as rendering, AI, or
 * interaction rules. It is typically stored in an {@link com.kalaazu.server.ecs.component.EntityTypeComponent}.
 *
 * @author manulaiko
 * @example ```java
 * // 'world' is an instance of com.artemis.World
 * // 'entityId' is the integer ID of an entity
 * EntityEdit edit = world.edit(entityId);
 *
 * // Get or create the component that holds the entity type
 * EntityTypeComponent typeComponent = edit.create(EntityTypeComponent.class);
 *
 * // Set the type of the entity
 * typeComponent.setType(EntityType.PLAYER);
 *
 * // Later, a system can check this type
 * if (typeComponent.getType() == EntityType.PLAYER) {
 * // Apply player-specific logic
 * }
 * ```
 * @see com.kalaazu.server.ecs.component.EntityTypeComponent
 * @see com.kalaazu.server.game.v4.commands.builder.EntityCreationCommandBuilder
 */
public enum EntityType {
    COLLECTABLE,
    NPC,
    PLAYER,
    PORTAL,
    STATION,
    SHIP,
    PET
}

Warning: truncated output (original token count: 98121)
Total output lines: 9283

-- Kalaazu database v3.0.0
-- 
-- @author Manulaiko <manulaiko@gmail.com>

DROP DATABASE IF EXISTS `kalaazu`;
CREATE DATABASE `kalaazu`;
USE `kalaazu`;

-- Accounts table.
--
-- In-game accounts.
--
CREATE TABLE `accounts`
(
    `id`                  int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `users_id`            int          NOT NULL
        COMMENT 'Account''s owner.',
    `session_id`          varchar(32)  NOT NULL
        COMMENT 'Session ID.',
    `levels_id`           tinyint      NOT NULL DEFAULT 1
        COMMENT 'Current level.',
    `factions_id`         tinyint      NULL     DEFAULT NULL
        COMMENT 'Faction that the account belongs to.',
    `accounts_hangars_id` int          NULL     DEFAULT NULL
        COMMENT 'Active hangar.',
    `clans_id`            int          NULL     DEFAULT NULL,
    `ranks_id`            tinyint      NOT NULL DEFAULT 1,
    `name`                varchar(255) NOT NULL
        COMMENT 'In game name.',
    `ban_date`            timestamp    NULL     DEFAULT NULL
        COMMENT 'Ban expiration date.',
    `premium_date`        timestamp    NULL     DEFAULT NULL
        COMMENT 'Premium expiration date.',
    `date`                timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_login`          timestamp    NULL     DEFAULT NULL
        COMMENT 'Last login date.',
    `skill_points_total`  smallint     NOT NULL DEFAULT 0
        COMMENT 'Total skill points available.',
    `skill_points_free`   smallint     NOT NULL DEFAULT 0
        COMMENT 'Free skill points available.',

    CONSTRAINT `accounts_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'In game accounts.';

CREATE UNIQUE INDEX `accounts_session_id_idx`
    ON `accounts` (`session_id`);
CREATE UNIQUE INDEX `accounts_name_idx`
    ON `accounts` (`name`);
CREATE INDEX `accounts_ranks_id_idx`
    ON `accounts` (`ranks_id`);
CREATE INDEX `accounts_clans_id_idx`
    ON `accounts` (`clans_id`);

-- Initial dump for the `accounts` table.

-- Account banks table.
--
-- Account's internal bank.
--
CREATE TABLE `accounts_banks`
(
    `id`          int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int     NOT NULL,
    `credits`     bigint  NOT NULL DEFAULT 0
        COMMENT 'Credits available in the bank.',
    `uridium`     bigint  NOT NULL DEFAULT 0
        COMMENT 'Uridium available in the bank.',
    `tax_credits` tinyint NOT NULL DEFAULT 5
        COMMENT 'Tax rate for credits.',
    `tax_uridium` tinyint NOT NULL DEFAULT 0
        COMMENT 'Tax rate for uridium.',

    CONSTRAINT `accounts_banks_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s internal bank.';

CREATE UNIQUE INDEX `accounts_banks_accounts_id_idx`
    ON `accounts_banks` (`accounts_id`);

-- Initial dump for the `accounts_banks` table.

-- Account bank's logs table.
--
-- Logs from account's bank.
--
CREATE TABLE `accounts_banks_logs`
(
    `id`                int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `from_accounts_id`  int       NOT NULL,
    `to_accounts_id`    int       NOT NULL,
    `date`              timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `type`              tinyint   NOT NULL DEFAULT 0
        COMMENT 'Log type. 0 = withdraw, 1 = deposit, 2 = donation.',
    `amount`            int       NOT NULL DEFAULT 0
        COMMENT 'Amount of currency logged.',
    `currency`          tinyint   NOT NULL DEFAULT 0
        COMMENT 'Currency of the amount. 0 = credits, 1 = uridium.',
    `accounts_banks_id` int       NULL     DEFAULT NULL,

    CONSTRAINT `accounts_banks_logs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Logs from account''s bank';

CREATE INDEX `accounts_banks_logs_from_accounts_id_idx`
    ON `accounts_banks_logs` (`from_accounts_id`);
CREATE INDEX `accounts_banks_logs_to_accounts_id_idx`
    ON `accounts_banks_logs` (`to_accounts_id`);

-- Initial dump for the `accounts_banks_logs` table.

-- Accounts to clan roles table.
--
-- Many to many relation table.
--
CREATE TABLE `accounts_clans_roles`
(
    `id`             int NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`    int NOT NULL
        COMMENT 'Account ID.',
    `clans_roles_id` int NOT NULL
        COMMENT 'Role ID.',

    CONSTRAINT `accounts_clans_roles_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relation table.';

CREATE INDEX `accounts_clans_roles_accounts_id_idx`
    ON `accounts_clans_roles` (`accounts_id`);
CREATE INDEX `accounts_clans_roles_clans_roles_id_idx`
    ON `accounts_clans_roles` (`clans_roles_id`);

-- Initial dump for the `accounts_clans_roles` table.

-- Account's configurations table.
--
-- Configurations of the accounts.
--
CREATE TABLE `accounts_configurations`
(
    `id`                  int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_hangars_id` int          NOT NULL,
    `configuration_id`    tinyint      NOT NULL DEFAULT 1
        COMMENT 'Configuration ID (1 or 2 (or 3)).',
    `name`                varchar(255) NOT NULL DEFAULT '',
    `shield`              int          NOT NULL DEFAULT 0
        COMMENT 'Max shield calculated in the configuration.',
    `health`              int          NOT NULL DEFAULT 0
        COMMENT 'Max health calculated in the configuration.',
    `speed`               smallint     NOT NULL DEFAULT 0
        COMMENT 'Speed available in the configuration.',
    `damage`              int          NOT NULL DEFAULT 0
        COMMENT 'Damage available in the configuration.',

    CONSTRAINT `accounts_configurations_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Configurations of the accounts.';

CREATE INDEX `accounts_configurations_accounts_hangars_id_idx`
    ON `accounts_configurations` (`accounts_hangars_id`);

-- Initial dump for the `accounts_configurations` table.

-- Account's configuration items table.
--
-- Items of the configuration.
--
CREATE TABLE `accounts_configurations_accounts_items`
(
    `id`                         int NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_configurations_id` int NOT NULL,
    `accounts_items_id`          int NOT NULL,
    `accounts_drones_id`         int NULL DEFAULT NULL,
    `accounts_pets_id`           int NULL DEFAULT NULL,

    CONSTRAINT `accounts_configurations_accounts_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Items of the configuration.';

-- Initial dump for the `accounts_configurations_accounts_items` table.

-- Account destroys table.
--
-- Account's destroy history.
--
CREATE TABLE `accounts_destroys`
(
    `id`          int      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int      NOT NULL,
    `ships_id`    tinyint  NOT NULL,
    `points`      smallint NOT NULL DEFAULT 0
        COMMENT 'Rank points received for destroying this ship.',
    `amount`      smallint NOT NULL DEFAULT 0
        COMMENT 'Times this ship has been destroyed',

    CONSTRAINT `accounts_destroys_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s destroy history.';

CREATE UNIQUE INDEX `accounts_destroys_accounts_id_idx`
    ON `accounts_destroys` (`accounts_id`);

-- Initial dump for the `accounts_destroys` table.

-- Account's drones table.
--
-- Account's drones.
--
CREATE TABLE `accounts_drones`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int       NOT NULL,
    `levels_id`   tinyint   NOT NULL DEFAULT 1,
    `experience`  smallint  NOT NULL DEFAULT 0,
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `accounts_drones_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s drones.';

CREATE UNIQUE INDEX `accounts_drones_accounts_id_idx`
    ON `accounts_drones` (`accounts_id`);

-- Initial dump for the `accounts_drones` table.

-- Account's galaxy gates table.
--
-- Account's build galaxygates.
--
CREATE TABLE `accounts_galaxygates`
(
    `id`             int      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_id` tinyint  NOT NULL,
    `accounts_id`    int      NOT NULL,
    `parts`          tinyint  NOT NULL DEFAULT 0
        COMMENT 'Collected parts.',
    `lifes`          tinyint  NOT NULL DEFAULT -1
        COMMENT 'Available lives (-1 not build yet)',
    `wave`           tinyint  NOT NULL DEFAULT -1
        COMMENT 'Current wave.',
    `times`          smallint NOT NULL DEFAULT 0
        COMMENT 'Times this gate was completed.',

    CONSTRAINT `accounts_galaxygates_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s build galaxygates.';

CREATE INDEX `accounts_galaxygates_galaxygates_id_idx`
    ON `accounts_galaxygates` (`galaxygates_id`);
CREATE INDEX `accounts_galaxygates_accounts_id_idx`
    ON `accounts_galaxygates` (`accounts_id`);

-- Initial dump for the `accounts_galaxygates` table.

-- Account's hangars table.
--
-- Hangars bough by an account.
--
CREATE TABLE `accounts_hangars`
(
    `id`                         int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`                int          NOT NULL,
    `accounts_ships_id`          int          NULL     DEFAULT NULL
        COMMENT 'Ship available in the hangar.',
    `accounts_configurations_id` int          NULL     DEFAULT NULL
        COMMENT 'Equipped configuration.',
    `name`                       varchar(255) NOT NULL DEFAULT 'HANGAR',
    `priority`                   tinyint      NULL     DEFAULT -1
        COMMENT 'Order priority, null = not ordered.',
    `date`                       timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `accounts_hangars_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Hangars bough by an account.';

CREATE INDEX `accounts_hangars_accounts_accounts_id_idx`
    ON `accounts_hangars` (`accounts_id`);
CREATE INDEX `accounts_hangars_accounts_ships_id_idx`
    ON `accounts_hangars` (`accounts_ships_id`);

-- Initial dump for the `accounts_hangars` table.

-- Account history table.
--
-- Account's history events.
--
CREATE TABLE `accounts_history`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int       NOT NULL,
    `type`        tinyint   NOT NULL DEFAULT 0
        COMMENT 'Event type.',
    `message`     text      NOT NULL
        COMMENT 'Event message.',
    `amount`      int       NOT NULL DEFAULT 0
        COMMENT 'For currency related events, the amount of currency.',
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Date when the event occurred.',

    CONSTRAINT `accounts_history_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s history events.';

CREATE UNIQUE INDEX `accounts_history_accounts_id_idx`
    ON `accounts_history` (`accounts_id`);

-- Initial dump for the `accounts_history` table.

-- Account's items table.
--
-- Items bough by an account.
--
CREATE TABLE `accounts_items`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `items_id`    smallint  NOT NULL,
    `accounts_id` int       NOT NULL,
    `levels_id`   tinyint   NOT NULL DEFAULT 1,
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `amount`      bigint    NOT NULL DEFAULT 1
        COMMENT 'Amount of items bough (for stackable items).',

    CONSTRAINT `accounts_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Items bough by an account.';

CREATE INDEX `accounts_items_items_id_idx`
    ON `accounts_items` (`items_id`);
CREATE INDEX `accounts_items_accounts_id_idx`
    ON `accounts_items` (`accounts_id`);
CREATE INDEX `accounts_items_levels_id_idx`
    ON `accounts_items` (`levels_id`);

CREATE UNIQUE INDEX `accounts_items_items_id_accounts_id_idx`
    ON `accounts_items` (`items_id`, `accounts_id`);

-- Initial dump for the `accounts_items` table.

-- Account's messages table.
--
-- Messaging system.
--
CREATE TABLE `accounts_messages`
(
    `id`               int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `from_accounts_id` int          NOT NULL DEFAULT 1,
    `from_status`      tinyint      NOT NULL DEFAULT 1
        COMMENT '0 = unread, 1 = read, 2 = deleted.',
    `to_accounts_id`   int          NOT NULL,
    `to_status`        tinyint      NOT NULL DEFAULT 0
        COMMENT '0 = unread, 1 = read, 2 = deleted.',
    `date`             timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `title`            varchar(255) NOT NULL,
    `text`             text         NOT NULL,

    CONSTRAINT `accounts_messages_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Messaging system.';

CREATE INDEX `accounts_messages_from_accounts_id_idx`
    ON `accounts_messages` (`from_accounts_id`);
CREATE INDEX `accounts_messages_to_accounts_id_idx`
    ON `accounts_messages` (`to_accounts_id`);

-- Initial dump for the `accounts_messages` table.

-- Account's PET table.
--
-- Account's PETs.
--
CREATE TABLE `accounts_pets`
(
    `id`                         int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`                int          NOT NULL,
    `levels_id`                  tinyint      NOT NULL DEFAULT 1,
    `name`                       varchar(255) NOT NULL DEFAULT '',
    `experience`                 int          NOT NULL DEFAULT 0,
    `fuel`                       int          NOT NULL DEFAULT 0,
    `health`                     int          NOT NULL DEFAULT 0,
    `slots_lasers_total`         tinyint      NOT NULL DEFAULT 1,
    `slots_lasers_available`     tinyint      NOT NULL DEFAULT 1,
    `slots_generators_total`     tinyint      NOT NULL DEFAULT 2,
    `slots_generators_available` tinyint      NOT NULL DEFAULT 2,
    `slots_protocols_total`      tinyint      NOT NULL DEFAULT 2,
    `slots_protocols_available`  tinyint      NOT NULL DEFAULT 2,
    `slots_gears_total`          tinyint      NOT NULL DEFAULT 1,
    `slots_gears_available`      tinyint      NOT NULL DEFAULT 1,

    CONSTRAINT `accounts_pets_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account''s PETs.';

CREATE UNIQUE INDEX `accounts_pets_accounts_id_idx`
    ON `accounts_pets` (`accounts_id`);

-- Initial dump for the `accounts_pets` table.

-- Account's quests table.
--
-- Quest status of the account.
--
CREATE TABLE `accounts_quests`
(
    `id`           int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `quests_id`    smallint  NOT NULL,
    `accounts_id`  int       NOT NULL,
    `is_completed` boolean   NOT NULL DEFAULT false
        COMMENT 'Whether the quest has been completed or not.',
    `date`         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Date when the quest was accepted/completed.',

    CONSTRAINT `accounts_quests_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Quest status of the account.';

CREATE INDEX `accounts_quests_quests_id_idx`
    ON `accounts_quests` (`quests_id`);
CREATE INDEX `accounts_quests_accounts_id_idx`
    ON `accounts_quests` (`accounts_id`);

-- Initial dump for the `accounts_quests` table.

-- Account's ranking table.
--
-- Account ranking.
--
CREATE TABLE `accounts_rankings`
(
    `id`                  int      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`         int      NOT NULL
        COMMENT 'Account ID.',
    `points`              int      NOT NULL DEFAULT 0
        COMMENT 'Points in the ranking.',
    `best_points`         int      NOT NULL DEFAULT 0
        COMMENT 'Biggest amount of rank points ever achieved.',
    `destroyed_allies`    smallint NOT NULL DEFAULT 0
        COMMENT 'Destroyed allies.',
    `destroyed_phoenix`   smallint NOT NULL DEFAULT 0
        COMMENT 'Destroyed phoenix.',
    `destroyed_times`     smallint NOT NULL DEFAULT 0
        COMMENT 'Amount of times the account has been destroyed.',
    `destroyed_radiation` smallint NOT NULL DEFAULT 0
        COMMENT 'Amount of times the account has been destroyed by the radiation zone.',

    CONSTRAINT `accounts_rankings_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account ranking.';

CREATE UNIQUE INDEX `accounts_ranking_accounts_id_idx`
    ON `accounts_rankings` (`accounts_id`);

-- Initial dump for the `accounts_rankings` table.

-- Account's settings table.
--
-- In game settings.
--
CREATE TABLE `accounts_settings`
(
    `id`          int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int          NOT NULL,
    `type`        tinyint      NOT NULL DEFAULT 1
        COMMENT 'Settings type (1 = window settings, 2 = game settings...)',
    `name`        varchar(255) NOT NULL
        COMMENT 'Setting name (SET, MINIMAP_SCALE...)',
    `value`       text         NOT NULL,

    CONSTRAINT `accounts_settings_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'In-game account settings.';

CREATE INDEX `accounts_settings_accounts_id_idx`
    ON `accounts_settings` (`accounts_id`);

-- Initial dump for the `accounts_settings` table.

-- Account's ships table.
--
-- Ships bough by an account.
--
CREATE TABLE `accounts_ships`
(
    `id`          int      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int      NOT NULL,
    `ships_id`    tinyint  NOT NULL,
    `maps_id`     smallint NOT NULL,
    `position`    bigint   NOT NULL DEFAULT 0
        COMMENT 'Position on map.',
    `health`      int      NOT NULL DEFAULT 0
        COMMENT 'Current health points',
    `shield`      int      NOT NULL DEFAULT 0
        COMMENT 'Current shield points',
    `nanohull`    int      NOT NULL DEFAULT 0
        COMMENT 'Current nanohull points',
    `gfx`         tinyint  NOT NULL DEFAULT 0
        COMMENT 'Ship graphic (for WIZ-X).',

    CONSTRAINT `accounts_ships_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Ships bough by an account.';

CREATE INDEX `accounts_ships_accounts_id_idx`
    ON `accounts_ships` (`accounts_id`);
CREATE INDEX `accounts_ships_ships_id_idx`
    ON `accounts_ships` (`ships_id`);
CREATE INDEX `accounts_ships_maps_id_idx`
    ON `accounts_ships` (`maps_id`);

-- Initial dump for the `accounts_ships` table.

-- Account's skills table.
--
-- Skilltree for the account.
--
CREATE TABLE `accounts_skills`
(
    `id`                  int      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`         int      NOT NULL
        COMMENT 'Account ID.',
    `skilltree_skills_id` tinyint  NOT NULL
        COMMENT 'Skill ID.',
    `skilltree_levels_id` smallint NOT NULL
        COMMENT 'Skill level.',

    CONSTRAINT `accounts_skills_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Skilltree for the account.';

CREATE INDEX `accounts_skills_accounts_id_idx`
    ON `accounts_skills` (`accounts_id`);

-- Initial dump for the `accounts_skills` table.

-- Account's skylab table.
--
-- Skylab for the account.
--
CREATE TABLE `accounts_skylabs`
(
    `id`                int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`       int       NOT NULL
        COMMENT 'Account ID.',
    `skylab_modules_id` tinyint   NOT NULL
        COMMENT 'Module ID.',
    `levels_id`         tinyint   NOT NULL DEFAULT 1
        COMMENT 'Module level.',
    `space`             int       NOT NULL DEFAULT 0
        COMMENT 'Used space.',
    `upgrade`           timestamp NULL     DEFAULT NULL
        COMMENT 'Date when this module started upgrading.',

    CONSTRAINT `accounts_skylabs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Skylab for the accounts.';

CREATE INDEX `accounts_skylabs_accounts_id_idx`
    ON `accounts_skylabs` (`accounts_id`);
CREATE INDEX `accounts_skylabs_skylab_modules_id_idx`
    ON `accounts_skylabs` (`skylab_modules_id`);

-- Initial dump for the `accounts_skylabs` table.

-- Account's techfactory table.
--
-- Nanotech factory items.
--
CREATE TABLE `accounts_techfactories`
(
    `id`                 int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`        int     NOT NULL
        COMMENT 'Account ID.',
    `slot_unlock_price`  int     NOT NULL DEFAULT 50000
        COMMENT 'Price for unlocking a slot.',
    `slot_unlock_factor` tinyint NOT NULL DEFAULT 2
        COMMENT 'Factor for unlocking a slot.',
    `slots`              tinyint NOT NULL DEFAULT 1
        COMMENT 'Unlocked slots.',

    CONSTRAINT `accounts_techfactory_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Nanotech factory items.';

-- Initial dump for the `accounts_techfactories` table

-- Account's techfactory items.
--
-- Techfactory items from account.
--
CREATE TABLE `accounts_techfactory_items`
(
    `id`                   int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id`          int       NOT NULL
        COMMENT 'Account ID.',
    `techfactory_items_id` tinyint   NOT NULL
        COMMENT 'Item ID.',
    `amount`               smallint  NOT NULL DEFAULT 1
        COMMENT 'Amount of build items.',
    `date`                 timestamp NULL     DEFAULT NULL
        COMMENT 'Date when the item started building.',

    CONSTRAINT `accounts_techfactory_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Techfactory items from account.';

CREATE INDEX `accounts_techfactory_items_accounts_id_idx`
    ON `accounts_techfactory_items` (`accounts_id`);
CREATE INDEX `accounts_techfactory_items_techfactory_items_id_idx`
    ON `accounts_techfactory_items` (`techfactory_items_id`);

-- Initial dump for the `accounts_techfactory_items` table.

-- Clan's table.
--
-- Server clans.
--
CREATE TABLE `clans`
(
    `id`          int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int          NOT NULL
        COMMENT 'Owner ID',
    `factions_id` tinyint      NULL     DEFAULT NULL
        COMMENT 'Clan affiliation faction.',
    `tag`         varchar(4)   NOT NULL DEFAULT ''
        COMMENT 'Name abbreviation.',
    `name`        varchar(255) NOT NULL DEFAULT '',
    `description` text         NOT NULL,
    `logo`        varchar(255) NOT NULL DEFAULT '',
    `status`      tinyint      NOT NULL DEFAULT 1
        COMMENT '0 = closed, 1 = recruiting, 2 = lvl10+, 3 = lvl16+, 4 = FE.',

    CONSTRAINT `clans_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Server clans.';

CREATE UNIQUE INDEX `clans_name_idx`
    ON `clans` (`name`);
CREATE UNIQUE INDEX `clans_tag_idx`
    ON `clans` (`tag`);
CREATE INDEX `clans_accounts_id_idx`
    ON `clans` (`accounts_id`);

-- Initial dump for the `clans` table.

-- Clan applications table.
--
-- Account applications to a clan.
--
CREATE TABLE `clans_applications`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id`    int       NOT NULL
        COMMENT 'Clan ID.',
    `accounts_id` int       NOT NULL
        COMMENT 'Account ID.',
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `text`        text      NOT NULL,

    CONSTRAINT `clans_applications_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Account applications to a clan.';

CREATE INDEX `clans_applications_clans_id_idx`
    ON `clans_applications` (`clans_id`);
CREATE INDEX `clans_applications_accounts_id_idx`
    ON `clans_applications` (`accounts_id`);

-- Initial dump for the `clans_applications` table.

-- Clan's banks table.
--
-- Clan's internal bank.
--
CREATE TABLE `clans_banks`
(
    `id`          int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id`    int     NOT NULL,
    `credits`     bigint  NOT NULL DEFAULT 0
        COMMENT 'Credits available in the bank.',
    `uridium`     bigint  NOT NULL DEFAULT 0
        COMMENT 'Uridium available in the bank.',
    `tax_credits` tinyint NOT NULL DEFAULT 5.0
        COMMENT 'Tax rate for credits.',
    `tax_uridium` tinyint NOT NULL DEFAULT 0.0
        COMMENT 'Tax rate for uridium.',

    CONSTRAINT `clans_banks_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Clan''s internal bank.';

CREATE UNIQUE INDEX `clans_bank_clans_id_idx`
    ON `clans_banks` (`clans_id`);

-- Initial dump for the `clans_banks` table.

-- Clan's banks logs table.
--
-- Logs from clan's bank.
--
CREATE TABLE `clans_banks_logs`
(
    `id`               int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_banks_id`   int       NOT NULL,
    `from_accounts_id` int       NOT NULL
        COMMENT 'Account that made the log.',
    `to_accounts_id`   int       NOT NULL,
    `date`             timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `type`             tinyint   NOT NULL DEFAULT 0
        COMMENT 'Log type. 0 = withdraw, 1 = deposit, 2 = donation.',
    `amount`           int       NOT NULL DEFAULT 0
        COMMENT 'Amount of currency logged.',
    `currency`         tinyint   NOT NULL DEFAULT 0
        COMMENT 'Currency of the amount. 0 = credits, 1 = uridium.',

    CONSTRAINT `clans_banks_logs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Logs from clan''s bank.';

CREATE INDEX `clans_banks_logs_clans_banks_id_idx`
    ON `clans_banks_logs` (`clans_banks_id`);
CREATE INDEX `clans_banks_logs_from_accounts_id_idx`
    ON `clans_banks_logs` (`from_accounts_id`);
CREATE INDEX `clans_banks_logs_to_accounts_id_idx`
    ON `clans_banks_logs` (`to_accounts_id`);

-- Initial dump for the `clans_banks_logs` table.

-- Clan battle stations table.
--
-- Clan CBS.
--
CREATE TABLE `clans_battlestations`
(
    `id`       tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id` int          NULL     DEFAULT NULL
        COMMENT 'Owner of the CBS.',
    `maps_id`  smallint     NOT NULL
        COMMENT 'Map of the CBS.',
    `name`     varchar(255) NOT NULL DEFAULT '',
    `position` varchar(255) NOT NULL DEFAULT '0,0'
        COMMENT 'Position on map.',
    `date`     timestamp    NULL     DEFAULT NULL
        COMMENT 'Date when the CBS was build.',

    CONSTRAINT `clans_battlestations_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Clan CBS.';

CREATE INDEX `clans_battlestations_clans_id_idx`
    ON `clans_battlestations` (`clans_id`);
CREATE INDEX `clans_battlestations_maps_id_idx`
    ON `clans_battlestations` (`maps_id`);

-- Initial dump for the `clans_battlestations` table.

INSERT INTO `clans_battlestations` (`id`, `name`, `maps_id`, `position`)
VALUES (1, 'Aries', 3, '10500,2500'),
       (2, 'Balzar', 4, '4400,9000'),
       (3, 'Fornax', 7, '10500,2500'),
       (4, 'Gemini', 8, '16200,8500'),
       (5, 'Keppler', 11, '10500,2500'),
       (6, 'Lynx', 12, '4400,9000'),
       (7, 'Volan', 13, '10000,5500'),
       (8, 'Wican', 14, '11500,6000'),
       (9, 'Xenitor', 15, '8750,6000'),
       (10, 'Yukian', 16, '9000,6000'),
       (11, 'Cetus', 17, '17200,2500'),
       (12, 'Equlus', 18, '10000,7200'),
       (13, 'Draco', 19, '10000,6200'),
       (14, 'Hydra', 21, '10500,9000'),
       (15, 'Indus', 22, '8800,6400'),
       (16, 'Julius', 23, '10500,5800'),
       (17, 'Mensa', 25, '10700,9000'),
       (18, 'Nashira', 26, '9800,8200'),
       (19, 'Orion', 27, '10500,4600'),
       (20, 'Zerpan', 29, '12000,5600');

-- Clan battlestations' items table.
--
-- Items equipped in the CBS.
--
CREATE TABLE `clans_battlestations_items`
(
    `id`                      int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_battlestations_id` tinyint   NOT NULL
        COMMENT 'CBS where item is equipped.',
    `accounts_items_id`       int       NOT NULL
        COMMENT 'Equipped item.',
    `slot`                    tinyint   NOT NULL DEFAULT 1
        COMMENT 'Position where the item is equipped (A = 9, B = 10).',
    `date`                    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Date when the item was equipped.',

    CONSTRAINT `clans_battlestations_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Items equipped in the CBS.';

CREATE INDEX `clans_battlestations_items_clans_battlestations_id_idx`
    ON `clans_battlestations_items` (`clans_battlestations_id`);
CREATE INDEX `clans_battlestations_items_accounts_items_id_idx`
    ON `clans_battlestations_items` (`accounts_items_id`);

-- Initial dump for the `clans_battlestations_items` table.

-- Clan's battlestations logs table.
--
-- Logs from clan's battlestations.
--
CREATE TABLE `clans_battlestations_logs`
(
    `id`                      int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id`                int       NOT NULL,
    `clans_battlestations_id` tinyint   NOT NULL,
    `message`                 text      NOT NULL,
    `date`                    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `clans_battlestations_logs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Logs from clan''s battlestations.';

CREATE INDEX `clans_battlestations_logs_clans_battlestations_id_idx`
    ON `clans_battlestations_logs` (`clans_battlestations_id`);
CREATE INDEX `clans_battlestations_logs_clans_id_idx`
    ON `clans_battlestations_logs` (`clans_id`);

-- Initial dump for the `clans_battlestations_logs` table.

-- Clan's diplomacies table.
--
-- Diplomacy table for clans.
--
CREATE TABLE `clans_diplomacies`
(
    `id`            int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `from_clans_id` int       NOT NULL
        COMMENT 'Clan that made the request.',
    `to_clans_id`   int       NOT NULL
        COMMENT 'Clan that receives the request.',
    `date`          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Diplomacy creation date.',
    `expires`       timestamp NULL     DEFAULT NULL
        COMMENT 'Date when the diplomacy expires.',
    `status`        tinyint   NOT NULL DEFAULT 0
        COMMENT 'Status of the diplomacy. 0 = not accepted, 1 = accepted, 2 = rejected, 3 = over.',
    `type`          tinyint   NOT NULL DEFAULT 0
        COMMENT 'Diplomacy type. 0 = War, 1 = NAP, 2 = Alliance.',

    CONSTRAINT `clans_diplomacies_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Diplomacy table for clans.';

CREATE INDEX `clans_diplomacies_from_clans_id_idx`
    ON `clans_diplomacies` (`from_clans_id`);
CREATE INDEX `clans_diplomacies_to_clans_id_idx`
    ON `clans_diplomacies` (`to_clans_id`);

-- Initial dump for the `clans_diplomacies` table.trad

-- Clan messages table.
--
-- Messages in the clan.
--
CREATE TABLE `clans_messages`
(
    `id`               int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id`         int          NOT NULL
        COMMENT 'Clan where the message was created',
    `from_accounts_id` int          NOT NULL,
    `from_status`      tinyint      NOT NULL DEFAULT 1
        COMMENT '0 = unread, 1 = read, 2 = deleted.',
    `to_accounts_id`   int          NULL     DEFAULT NULL,
    `to_status`        tinyint      NOT NULL DEFAULT 0
        COMMENT '0 = unread, 1 = read, 2 = unread.',
    `title`            varchar(255) NOT NULL DEFAULT '',
    `text`             text         NOT NULL,
    `date`             timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `clans_messages` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Messages in the clan.';

CREATE INDEX `clans_messages_clans_id_idx`
    ON `clans_messages` (`clans_id`);
CREATE INDEX `clans_messages_from_accounts_id_idx`
    ON `clans_messages` (`from_accounts_id`);
CREATE INDEX `clans_messages_to_accounts_id_idx`
    ON `clans_messages` (`to_accounts_id`);

-- Initial dump for the `clans_messages` table

-- Clan's news table.
--
-- News of the clan.
--
CREATE TABLE `clans_news`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `accounts_id` int       NOT NULL
        COMMENT 'Author.',
    `clans_id`    int       NOT NULL,
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Creation date.',
    `text`        text      NOT NULL
        COMMENT 'News content.',

    CONSTRAINT `clans_news_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'News of the clan.';

CREATE INDEX `clans_news_accounts_id_idx`
    ON `clans_news` (`accounts_id`);
CREATE INDEX `clans_news_clans_id_idx`
    ON `clans_news` (`clans_id`);

-- Initial dump for the `clans_news` table.

-- Clan's ranking table.
--
-- Clan ranking.
--
CREATE TABLE `clans_ranking`
(
    `id`          int NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_id`    int NOT NULL
        COMMENT 'Clan ID.',
    `points`      int NOT NULL DEFAULT 0
        COMMENT 'Points in the ranking.',
    `best_points` int NOT NULL DEFAULT 0
        COMMENT 'Biggest amount of rank points ever achieved.',

    CONSTRAINT `clans_ranking_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Clan ranking.';

CREATE UNIQUE INDEX `clans_ranking_accounts_id_idx`
    ON `clans_ranking` (`clans_id`);

-- Initial dump for the `clans_ranking` table.

-- Clan's roles table.
--
-- Clan's permissions roles.
--
CREATE TABLE `clans_roles`
(
    `id`             int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`           varchar(255) NOT NULL,
    `clans_id`       int          NOT NULL,
    `clans_roles_id` int          NULL     DEFAULT NULL
        COMMENT 'Parent role.',
    `priority`       tinyint      NOT NULL DEFAULT 1,

    CONSTRAINT `clans_roles_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Clan''s roles.';

CREATE INDEX `clans_roles_clans_id_idx`
    ON `clans_roles` (`clans_id`);
CREATE INDEX `clans_roles_name_idx`
    ON `clans_roles` (`name`);

-- Initial dump for the `clans_roles` table.

-- Clan roles' permissions.
--
-- Clan roles' permissions
--
CREATE TABLE `clans_roles_permissions`
(
    `id`             int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `clans_roles_id` int     NOT NULL,
    `permissions_id` tinyint NOT NULL,
    `is_enabled`     boolean NULL DEFAULT NULL
        COMMENT 'Enabled value, null = inherited',

    CONSTRAINT `clans_roles_permissions` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Clan roles'' permissions';

CREATE INDEX `clans_roles_permissions_clans_roles_id_idx`
    ON `clans_roles_permissions` (`clans_roles_id`);
CREATE INDEX `clans_roles_permissions_permissions_id_idx`
    ON `clans_roles_permissions` (`permissions_id`);

-- Initial dump for the `clans_roles_permissions` table.

-- Collectables table.
--
-- Map collectables.
--
CREATE TABLE `collectables`
(
    `id`   tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `gfx`  smallint     NOT NULL DEFAULT 0,
    `type` tinyint      NOT NULL DEFAULT 0
        COMMENT '0 = box, 1 = ore, 2 = beacon, 3 = firework',
    `name` varchar(255) NOT NULL DEFAULT '',

    CONSTRAINT `collectables_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Map collectables.';

-- Initial dump for the `collectables` table.

INSERT INTO `collectables` (`id`, `gfx`, `type`, `name`)
VALUES (1,
        0,
        0,
        'box0'),
       (2,
        1,
        0,
        'box1'),
       (3,
        2,
        0,
        'box2'),
       (4,
        3,
        0,
        'easterEgg'),
       (5,
        5,
        0,
        'bigPumpkin'),
       (6,
        6,
        0,
        'orangePumpkin'),
       (7,
        7,
        0,
        'turkey'),
       (8,
        8,
        0,
        'bigXmasStar'),
       (9,
        9,
        0,
        'stdXmasStar'),
       (10,
        10,
        0,
        'flower_mothersday'),
       (11,
        11,
        0,
        'theItalianBox'),
       (12,
        14,
        0,
        'crestAndStar'),
       (13,
        15,
        0,
        'polishBonusBox'),
       (14,
        16,
        0,
        'winterGiftBox'),
       (15,
        17,
        0,
        'carnival_box'),
       (16,
        19,
        0,
        'bonusBoxSun'),
       (17,
        20,
        0,
        'petWeekBox'),
       (18,
        21,
        0,
        'pirateBootyBox'),
       (19,
        22,
        0,
        'pirateBootyGoldBox'),
       (20,
        23,
        0,
        'hungarianRevolutionBox'),
       (21,
        24,
        0,
        'stpatricksDayBox'),
       (22,
        25,
        0,
        'titanicBonusBox'),
       (23,
        26,
        0,
        'brazilBonusBox'),
       (24,
        27,
        0,
        'victoryFrBonusBox'),
       (25,
        28,
        0,
        'victoryRuBonusBox'),
       (26,
        29,
        0,
        'victoryCzBonusBox'),
       (27,
        30,
        0,
        'boxStar'),
       (28,
        31,
        0,
        'pirateBootyRedBox'),
       (29,
        32,
        0,
        'pirateBootyBlueBox'),
       (30,
        33,
        0,
        'victoryFrBonusBox'),
       (31,
        34,
        0,
        'mexicanBonusBox'),
       (32,
        35,
        0,
        'boxAntec'),
       (33,
        36,
        0,
        'germanUnificationDayBox'),
       (34,
        37,
        0,
        'hispanicDayBox'),
       (35,
        38,
        0,
        'candyBox'),
       (36,
        39,
        0,
        'birthdayBox'),
       (37,
        40,
        0,
        'treasureChest'),
       (38,
        41,
        0,
        'fathersDayBox'),
       (39,
        42,
        0,
        'summerEventBox'),
       (40,
        43,
        0,
        'silverBootyBox'),
       (41,
        44,
        0,
        'britishBox'),
       (42,
        45,
        0,
        'football_box'),
       (43,
        46,
        0,
        'demanerTransporterBootyBox'),
       (44,
        47,
        0,
        'icyBox'),
       (45,
        0,
        1,
        'oreRed'),
       (46,
        1,
        1,
        'oreBlue'),
       (47,
        2,
        1,
        'oreYellow'),
       (48,
        8,
        1,
        'ore_palladium'),
       (49,
        112,
        2,
        'beacon_1_2'),
       (50,
        113,
        2,
        'beacon_1_3'),
       (51,
        121,
        2,
        'beacon_2_1'),
       (52,
        123,
        2,
        'beacon_2_3'),
       (53,
        131,
        2,
        'beacon_3_1'),
       (54,
        132,
        2,
        'beacon_3_2'),
       (55,
        212,
        2,
        'beacon_1_2'),
       (56,
        213,
        2,
        'beacon_1_3'),
       (57,
        221,
        2,
        'beacon_2_1'),
       (58,
        223,
        2,
        'beacon_2_3'),
       (59,
        231,
        2,
        'beacon_3_1'),
       (60,
        232,
        2,
        'beacon_3_2'),
       (61,
        31,
        3,
        'fireworks_box'),
       (62,
        32,
        3,
        'fireworks_box'),
       (63,
        33,
        3,
        'fireworks_box'),
       (64,
        34,
        3,
        'fireworks_box'),
       (65,
        35,
        3,
        'fireworks_box'),
       (66,
        36,
        3,
        'fireworks_box'),
       (67,
        121,
        3,
        'fireworks_box'),
       (68,
        122,
        3,
        'fireworks_box'),
       (69,
        123,
        3,
        'fireworks_box'),
       (70,
        131,
        3,
        'fireworks_box'),
       (71,
        132,
        3,
        'fireworks_box'),
       (72,
        133,
        3,
        'fireworks_box'),
       (73,
        211,
        3,
        'fireworks_box'),
       (74,
        212,
        3,
        'fireworks_box'),
       (75,
        213,
        3,
        'fireworks_box'),
       (76,
        221,
        3,
        'fireworks_box'),
       (77,
        222,
        3,
        'fireworks_box'),
       (78,
        223,
        3,
        'fireworks_box'),
       (79,
        231,
        3,
        'fireworks_box'),
       (80,
        232,
        3,
        'fireworks_box'),
       (81,
        233,
        3,
        'fireworks_box'),
       (82,
        311,
        3,
        'fireworks_box'),
       (83,
        312,
        3,
        'fireworks_box'),
       (84,
        313,
        3,
        'fireworks_box'),
       (85,
        321,
        3,
        'fireworks_box'),
       (86,
        322,
        3,
        'fireworks_box'),
       (87,
        323,
        3,
        'fireworks_box'),
       (88,
        331,
        3,
        'fireworks_box'),
       (89,
        332,
        3,
        'fireworks_box'),
       (90,
        333,
        3,
        'fireworks_box'),
       (91,
        411,
        3,
        'fireworks_box'),
       (92,
        412,
        3,
        'fireworks_box'),
       (93,
        413,
        3,
        'fireworks_box'),
       (94,
        421,
        3,
        'fireworks_box'),
       (95,
        422,
        3,
        'fireworks_box'),
       (96,
        423,
        3,
        'fireworks_box'),
       (97,
        431,
        3,
        'fireworks_box'),
       (98,
        432,
        3,
        'fireworks_box'),
       (99,
        433,
        3,
        'fireworks_box'),
       (100,
        511,
        3,
        'fireworks_box'),
       (101,
        512,
        3,
        'fireworks_box'),
       (102,
        513,
        3,
        'fireworks_box'),
       (103,
        521,
        3,
        'fireworks_box'),
       (104,
        522,
        3,
        'fireworks_box'),
       (105,
        523,
        3,
        'fireworks_box'),
       (106,
        531,
        3,
        'fireworks_box'),
       (107,
        532,
        3,
        'fireworks_box'),
       (108,
        533,
        3,
        'fireworks_box'),
       (109,
        601,
        3,
        'fireworks_box'),
       (110,
        602,
        3,
        'fireworks_box'),
       (111,
        603,
        3,
        'fireworks_box');

-- Events table.
--
-- Contains server's events.
--
CREATE TABLE `events`
(
    `id`          int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`        varchar(255) NOT NULL DEFAULT '',
    `description` text         NOT NULL,
    `start_date`  timestamp    NULL     DEFAULT NULL
        COMMENT 'Event start date.',
    `end_date`    timestamp    NULL     DEFAULT NULL
        COMMENT 'Event end date.',

    CONSTRAINT `events_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Contains server''s events.';

-- Initial dump for the `events` table.
--

-- Factions table.
--
-- Contains server's factions.
--
CREATE TABLE `factions`
(
    `id`                 tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`               varchar(255) NOT NULL DEFAULT '',
    `tag`                varchar(3)   NOT NULL DEFAULT ''
        COMMENT 'Name abbreviation.',
    `description`        text         NOT NULL,
    `is_public`          boolean      NOT NULL DEFAULT true,
    `low_maps_id`        smallint     NOT NULL,
    `low_maps_position`  varchar(255) NOT NULL DEFAULT '0,0'
        COMMENT 'Starting position on map.',
    `high_maps_id`       smallint     NOT NULL,
    `high_maps_position` varchar(255) NOT NULL DEFAULT '0,0'
        COMMENT 'Starting position on map.',

    CONSTRAINT `factions_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Contains server''s factions.';

CREATE UNIQUE INDEX `factions_name_idx`
    ON `factions` (`name`);
CREATE UNIQUE INDEX `factions_tag_idx`
    ON `factions` (`tag`);

-- Initial dump for the `factions` table.
--
INSERT INTO `factions` (`id`, `name`, `tag`, `is_public`, `description`, `low_maps_id`, `low_maps_position`,
                        `high_maps_id`, `high_maps_position`)
VALUES (1, 'Mars Mining Operations', 'mmo', 1,
        'I''m not going to blow smoke up your tush, so I''ll just get straight to the point. We at Mars Mining Operations want you for two reasons: to mine ore and to eradicate all alien scum infecting our galactic sector. Do this successfully and you''ll soon be popping rival pilots for thrills and honor!',
        1, '1000,1000', 20, '1000,6000'),
       (2, 'Earth Industries Corporations', 'eic', 1,
        'Pilot, these are trying times during which only those made of the purest inner steel can prevail! How tough is your mettle? We reward loyalty and impeccable manners with the best lasers Uridium can buy. Join us in the fight to cleanse our sector of all those cretins that stand in our way. For glory and privilege!',
        5, '19000,1000', 24, '10700,1000'),
       (3, 'Venus Resources Unlimited', 'vru', 1,
        'We pride ourselves in our ability to push the envelope of technological advancement, while retaining a communal atmosphere. Some call us a cult desiring galactic domination, but they simply misunderstand our brilliant recruitment methods. We are always looking for talented pilots to help us destroy our enemies and shape humanity''s future!',
        9, '19000,1300', 28, '19000,6000'),
       (4, 'Admins and Mods', 'aam', 0, 'Secret faction for Admins and Mods >:)', 92, '10700,6000', 92, '10700,6000');

-- GalaxyGates table.
--
-- Galaxy gates from the server.
--
CREATE TABLE `galaxygates`
(
    `id`                   tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`                 varchar(255) NOT NULL DEFAULT 'GG-A',
    `galaxygates_waves_id` tinyint      NULL     DEFAULT NULL
        COMMENT 'Starting wave.',
    `parts`                tinyint      NOT NULL DEFAULT 0
        COMMENT 'Necessary parts to build the gate.',

    CONSTRAINT `galaxygates_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Galaxy gates from the server.';

-- Initial dump for the `galaxygates` table.

INSERT INTO `galaxygates` (`id`, `name`, `galaxygates_waves_id`, `parts`)
VALUES (1, 'Alpha', NULL, 34),
       (2, 'Beta', NULL, 48),
       (3, 'Gamma', NULL, 82),
       (4, 'Delta', NULL, 128),
       (5, 'Epsilon', NULL, 99),
       (6, 'Zeta', NULL, 111),
       (7, 'Kappa', NULL, 120),
       (8, 'Lambda', NULL, 45),
       (13, 'Hades', NULL, 45),
       (19, 'Kuiper', NULL, 100);

-- GalaxyGates to GGSpins table.
--
-- Many to many relations for galaxygates and galaxygates_spins.
--
CREATE TABLE `galaxygates_gg_spins`
(
    `id`                   smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_id`       tinyint  NOT NULL,
    `galaxygates_spins_id` tinyint  NOT NULL,

    CONSTRAINT `galaxygates_gg_spins_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations for galaxygates and galaxygates_spins.';

CREATE INDEX `galaxygates_gg_spins_galaxygates_id_idx`
    ON `galaxygates_gg_spins` (`galaxygates_id`);
CREATE INDEX `galaxygates_gg_spins_galaxygates_spins_id_idx`
    ON `galaxygates_gg_spins` (`galaxygates_spins_id`);

-- Initial dump for the `galaxygates_gg_spins` table.

INSERT INTO `galaxygates_gg_spins` (`id`, `galaxygates_id`, `galaxygates_spins_id`)
VALUES (1, 1, 1),
       (2, 1, 2),
       (3, 1, 3),
       (4, 1, 4),
       (5, 1, 5),
       (6, 1, 6),
       (7, 1, 7),
       (8, 1, 8),
       (9, 1, 9),
       (10, 1, 10),
       (11, 1, 11),
       (12, 1, 12),
       (13, 1, 13),
       (14, 1, 14),
       (15, 1, 15),
       (16, 2, 1),
       (17, 2, 2),
       (18, 2, 3),
       (19, 2, 4),
       (20, 2, 5),
       (21, 2, 6),
       (22, 2, 7),
       (23, 2, 8),
       (24, 2, 9),
       (25, 2, 10),
       (26, 2, 11),
       (27, 2, 12),
       (28, 2, 13),
       (29, 2, 14),
       (30, 2, 15),
       (31, 3, 1),
       (32, 3, 2),
       (33, 3, 3),
       (34, 3, 4),
       (35, 3, 5),
       (36, 3, 6),
       (37, 3, 7),
       (38, 3, 8),
       (39, 3, 9),
       (40, 3, 10),
       (41, 3, 11),
       (42, 3, 12),
       (43, 3, 13),
       (44, 3, 14),
       (45, 3, 15),
       (46, 4, 1),
       (47, 4, 2),
       (48, 4, 3),
       (49, 4, 4),
       (50, 4, 5),
       (51, 4, 6),
       (52, 4, 7),
       (53, 4, 8),
       (54, 4, 9),
       (55, 4, 10),
       (56, 4, 11),
       (57, 4, 12),
       (58, 4, 13),
       (59, 4, 14),
       (60, 4, 15),
       (61, 5, 1),
       (62, 5, 2),
       (63, 5, 3),
       (64, 5, 4),
       (65, 5, 6),
       (66, 5, 7),
       (67, 5, 8),
       (68, 5, 9),
       (69, 5, 10),
       (70, 5, 11),
       (71, 5, 12),
       (72, 5, 13),
       (73, 5, 14),
       (74, 5, 15),
       (75, 6, 1),
       (76, 6, 2),
       (77, 6, 3),
       (78, 6, 4),
       (79, 6, 5),
       (80, 6, 6),
       (81, 6, 7),
       (82, 6, 8),
       (83, 6, 9),
       (84, 6, 10),
       (85, 6, 11),
       (86, 6, 12),
       (87, 6, 13),
       (88, 6, 14),
       (89, 6, 15),
       (90, 7, 1),
       (91, 7, 2),
       (92, 7, 3),
       (93, 7, 4),
       (94, 7, 5),
       (95, 7, 6),
       (96, 7, 7),
       (97, 7, 8),
       (98, 7, 9),
       (99, 7, 10),
       (100, 7, 11),
       (101, 7, 12),
       (102, 7, 13),
       (103, 7, 14),
       (104, 7, 15),
       (105, 8, 1),
       (106, 8, 2),
       (107, 8, 3),
       (108, 8, 4),
       (109, 8, 5),
       (110, 8, 6),
       (111, 8, 7),
       (112, 8, 8),
       (113, 8, 9),
       (114, 8, 10),
       (115, 8, 11),
       (116, 8, 12),
       (117, 8, 13),
       (118, 8, 14),
       (119, 8, 15),
       (120, 13, 1),
       (121, 13, 2),
       (122, 13, 3),
       (123, 13, 4),
       (124, 13, 5),
       (125, 13, 6),
       (126, 13, 7),
       (127, 13, 8),
       (128, 13, 9),
       (129, 13, 10),
       (130, 13, 11),
       (131, 13, 12),
       (132, 13, 13),
       (133, 13, 14),
       (134, 13, 15),
       (135, 19, 1),
       (136, 19, 2),
       (137, 19, 3),
       (138, 19, 4),
       (139, 19, 5),
       (140, 19, 6),
       (141, 19, 7),
       (142, 19, 8),
       (143, 19, 9),
       (144, 19, 10),
       (145, 19, 11),
       (146, 19, 12),
       (147, 19, 13),
       (148, 1, 16),
       (149, 1, 17),
       (150, 1, 18),
       (151, 1, 19),
       (152, 1, 20),
       (153, 1, 21),
       (154, 1, 22),
       (155, 1, 23),
       (156, 2, 16),
       (157, 2, 17),
       (158, 2, 18),
       (159, 2, 19),
       (160, 2, 20),
       (161, 2, 21),
       (162, 2, 22),
       (163, 2, 23),
       (164, 3, 16),
       (165, 3, 17),
       (166, 3, 18),
       (167, 3, 19),
       (168, 3, 20),
       (169, 3, 21),
       (170, 3, 22),
       (171, 3, 23),
       (172, 4, 16),
       (173, 4, 17),
       (174, 4, 18),
       (175, 4, 19),
       (176, 4, 20),
       (177, 4, 21),
       (178, 4, 22),
       (179, 4, 23),
       (180, 5, 16),
       (181, 5, 17),
       (182, 5, 18),
       (183, 5, 19),
       (184, 5, 20),
       (185, 5, 21),
       (186, 6, 22),
       (187, 5, 23),
       (188, 6, 16),
       (189, 6, 17),
       (190, 6, 18),
       (191, 6, 19),
       (192, 6, 20),
       (193, 6, 21),
       (194, 6, 22),
       (195, 6, 23),
       (196, 7, 16),
       (197, 7, 17),
       (198, 7, 18),
       (199, 7, 19),
       (200, 7, 20),
       (201, 7, 21),
       (202, 7, 22),
       (203, 7, 23),
       (204, 8, 16),
       (205, 8, 17),
       (206, 8, 18),
       (207, 8, 19),
       (208, 8, 20),
       (209, 8, 21),
       (210, 8, 22),
       (211, 8, 23),
       (212, 13, 16),
       (213, 13, 17),
       (214, 13, 18),
       (215, 13, 19),
       (216, 13, 20),
       (217, 13, 21),
       (218, 13, 22),
       (219, 13, 23),
       (220, 19, 16),
       (221, 19, 17),
       (222, 19, 18),
       (223, 19, 19),
       (224, 19, 20),
       (225, 19, 21),
       (226, 19, 22),
       (227, 19, 23),
       (228, 1, 24),
       (229, 1, 25),
       (230, 1, 26),
       (231, 2, 24),
       (232, 2, 25),
       (233, 2, 26),
       (234, 3, 24),
       (235, 3, 25),
       (236, 3, 26),
       (237, 4, 27),
       (238, 5, 28),
       (239, 6, 29),
       (240, 7, 30),
       (241, 8, 31),
       (242, 13, 32),
       (243, 19, 33);

-- GalaxyGates to Waves table.
--
-- Many to many relations for galaxygates and galaxygates_waves.
--
CREATE TABLE `galaxygates_gg_waves`
(
    `id`                   smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_id`       tinyint  NOT NULL,
    `galaxygates_waves_id` tinyint  NOT NULL,

    CONSTRAINT `galaxygates_gg_waves_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations for galaxygates and galaxygates_waves.';

CREATE INDEX `galaxygates_gg_waves_galaxygates_id_idx`
    ON `galaxygates_gg_waves` (`galaxygates_id`);
CREATE INDEX `galaxygates_gg_waves_galaxygates_waves_id_idx`
    ON `galaxygates_gg_waves` (`galaxygates_waves_id`);

-- Initial dump for the `galaxygates_gg_waves` table.

-- GalaxyGates probabilities table.
--
-- Spin probabilities for the galaxy gates.
--
CREATE TABLE `galaxygates_probabilities`
(
    `id`             tinyint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_id` tinyint NOT NULL
        COMMENT 'The galaxy gate.',
    `type`           tinyint NOT NULL DEFAULT 0
        COMMENT '0 = ammo, 1 = resource, 2 = voucher, 3 = logfile, 4 = part, 5 = special.',
    `probability`    float   NOT NULL DEFAULT 100.00
        COMMENT 'Probability of awarding one spin of this type.',

    CONSTRAINT `galaxygates_probabilities_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Spin probabilities for the galaxy gates.';

-- Initial dump for the `galaxygates_probabilities` table.

INSERT INTO `galaxygates_probabilities` (`id`, `galaxygates_id`, `type`, `probability`)
VALUES (1, 1, 1, 67.00),
       (2, 1, 2, 12.00),
       (3, 1, 3, 3.00),
       (4, 1, 4, 1.00),
       (5, 1, 5, 13.00),
       (6, 1, 6, 4.00),
       (7, 2, 1, 67.00),
       (8, 2, 2, 12.00),
       (9, 2, 3, 3.00),
       (10, 2, 4, 1.00),
       (11, 2, 5, 13.00),
       (12, 2, 6, 4.00),
       (13, 3, 1, 67.00),
       (14, 3, 2, 12.00),
       (15, 3, 3, 3.00),
       (16, 3, 4, 1.00),
       (17, 3, 5, 13.00),
       (18, 3, 6, 4.00),
       (19, 4, 1, 67.00),
       (20, 4, 2, 12.00),
       (21, 4, 3, 3.00),
       (22, 4, 4, 1.00),
       (23, 4, 5, 13.00),
       (24, 4, 6, 4.00),
       (25, 5, 1, 67.00),
       (26, 5, 2, 12.00),
       (27, 5, 3, 3.00),
       (28, 5, 4, 1.00),
       (29, 5, 5, 13.00),
       (30, 5, 6, 4.00),
       (31, 6, 1, 67.00),
       (32, 6, 2, 12.00),
       (33, 6, 3, 3.00),
       (34, 6, 4, 1.00),
       (35, 6, 5, 13.00),
       (36, 6, 6, 4.00),
       (37, 7, 1, 67.00),
       (38, 7, 2, 12.00),
       (39, 7, 3, 3.00),
       (40, 7, 4, 1.00),
       (41, 7, 5, 13.00),
       (42, 7, 6, 4.00),
       (43, 8, 1, 67.00),
       (44, 8, 2, 12.00),
       (45, 8, 3, 3.00),
       (46, 8, 4, 1.00),
       (47, 8, 5, 13.00),
       (48, 8, 6, 4.00),
       (49, 13, 1, 67.00),
       (50, 13, 2, 12.00),
       (51, 13, 3, 3.00),
       (52, 13, 4, 1.00),
       (53, 13, 5, 13.00),
       (54, 13, 6, 4.00),
       (55, 19, 1, 67.00),
       (56, 19, 2, 12.00),
       (57, 19, 3, 3.00),
       (58, 19, 4, 1.00),
       (59, 19, 5, 13.00),
       (60, 19, 6, 4.00);
-- GalaxyGate's wave spawn table.
--
-- Stage spawn for each stage.
--
CREATE TABLE `galaxygates_spawns`
(
    `id`      int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `npcs_id` tinyint NOT NULL
        COMMENT 'NPC to spawn.',
    `amount`  tinyint NOT NULL DEFAULT 20
        COMMENT 'Amount of NPCs to spawn.',

    CONSTRAINT `galaxygates_spawns_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Stage spawn for each stage.';

CREATE INDEX `galaxygates_spawns_npcs_id_idx`
    ON `galaxygates_spawns` (`npcs_id`);

-- Initial dump for the `galaxygates_spawns` table.

-- GalaxyGate's spins table.
--
-- Spins from the galaxy gate.
--
CREATE TABLE `galaxygates_spins`
(
    `id`          tinyint  NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `type`        tinyint  NOT NULL DEFAULT 1
        COMMENT 'Type from `galaxygates_probabilities`',
    `probability` float    NOT NULL DEFAULT '0.0',
    `items_id`    smallint NOT NULL,
    `amount`      smallint NOT NULL DEFAULT 1,

    CONSTRAINT `galaxygates_spins_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Spins from the galaxy gate.';

CREATE INDEX `galaxygates_spins_items_id_idx`
    ON `galaxygates_spins` (`items_id`);

-- Initial dump for the `galaxygates_spins` table.

INSERT INTO `galaxygates_spins` (`id`, `type`, `probability`, `items_id`, `amount`)
VALUES (1, 1, 6.66, 60, 200),
       (2, 1, 6.66, 60, 240),
       (3, 1, 6.66, 60, 280),
       (4, 1, 6.66, 61, 180),
       (5, 1, 6.66, 61, 200),
       (6, 1, 6.66, 61, 240),
       (7, 1, 6.66, 63, 200),
       (8, 1, 6.66, 63, 220),
       (9, 1, 6.66, 63, 240),
       (10, 1, 6.66, 64, 80),
       (11, 1, 6.66, 64, 100),
       (12, 1, 6.66, 64, 120),
       (13, 1, 6.66, 84, 100),
       (14, 1, 6.66, 84, 120),
       (15, 1, 6.66, 65, 100),
       (16, 2, 33.33, 241, 60),
       (17, 2, 33.33, 241, 80),
       (18, 2, 33.33, 241, 100),
       (19, 3, 50.00, 7, 1),
       (20, 3, 50.00, 7, 2),
       (21, 4, 99.99, 229, 1),
       (22, 4, 0.01, 229, 100),
       (23, 6, 100.00, 1, 30000),
       (24, 5, 33.33, 282, 1),
       (25, 5, 33.33, 283, 1),
       (26, 5, 33.33, 284, 1),
       (27, 5, 100.00, 285, 1),
       (28, 5, 100.00, 286, 1),
       (29, 5, 100.00, 287, 1),
       (30, 5, 100.00, 288, 1),
       (31, 5, 100.00, 289, 1),
       (32, 5, 100.00, 290, 1),
       (33, 5, 100.00, 291, 1);

-- GalaxyGate's wave stage table.
--
-- Spawn stage for each wave.
--
CREATE TABLE `galaxygates_stages`
(
    `id`                   int     NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_waves_id` tinyint NOT NULL
        COMMENT 'Wave this stage belongs to',
    `comment`              text    NULL DEFAULT NULL
        COMMENT 'Just so this isn''t that empty',

    CONSTRAINT `galaxygates_stages_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Spawn stage for each wave.';

CREATE INDEX `galaxygates_stages_galaxygates_waves_id_idx`
    ON `galaxygates_stages` (`galaxygates_waves_id`);

-- Initial dump for the `galaxygates_stages` table.

-- Stages to Spawns table.
--
-- Many to many relations for galaxygates_stages and galaxygates_spawns.
--
CREATE TABLE `galaxygates_stages_spawns`
(
    `id`                    int NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `galaxygates_stages_id` int NOT NULL,
    `galaxygates_spawns_id` int NOT NULL,

    CONSTRAINT `galaxygates_stages_spawns_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations for galaxygates_stages and galaxygates_spawns.';

CREATE INDEX `galaxygates_stages_spawns_galaxygates_stages_id_idx`
    ON `galaxygates_stages_spawns` (`galaxygates_stages_id`);
CREATE INDEX `galaxygates_stages_spawns_galaxygates_spawns_id_idx`
    ON `galaxygates_stages_spawns` (`galaxygates_spawns_id`);

-- Initial dump for the `galaxygates_stages_spawns` table.

-- GalaxyGate's waves table.
--
-- Waves of the galaxy gate.
--
CREATE TABLE `galaxygates_waves`
(
    `id`      tinyint  NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `maps_id` smallint NOT NULL
        COMMENT 'Map',
    `seconds` tinyint  NOT NULL DEFAULT 120
        COMMENT 'Seconds to wait between stages',
    `npcs`    tinyint  N…68121 tokens truncated…055),
       (12, 2, 1056),
       (13, 3, 1057),
       (14, 3, 1058),
       (15, 3, 1059),
       (16, 3, 1060),
       (17, 3, 1061),
       (18, 3, 1062),
       (19, 4, 1063),
       (20, 4, 1064),
       (21, 4, 1065),
       (22, 4, 1066),
       (23, 4, 1067),
       (24, 4, 1068),
       (25, 5, 1069),
       (26, 5, 1070),
       (27, 5, 1071),
       (28, 5, 1072),
       (29, 5, 1073),
       (30, 5, 1074),
       (31, 5, 1075),
       (32, 6, 1076),
       (33, 6, 1077),
       (34, 6, 1078),
       (35, 6, 1079),
       (36, 6, 1080),
       (37, 6, 1081),
       (38, 6, 1082),
       (39, 7, 1083),
       (40, 7, 1084),
       (41, 7, 1085),
       (42, 7, 1086),
       (43, 7, 1087),
       (44, 7, 1088),
       (45, 7, 1089),
       (46, 8, 1090),
       (47, 8, 1091),
       (48, 8, 1092),
       (49, 8, 1093),
       (50, 8, 1094),
       (51, 8, 1095),
       (52, 13, 1096),
       (53, 13, 1097),
       (54, 13, 1098),
       (55, 13, 1099),
       (56, 13, 1100),
       (57, 13, 1101),
       (58, 13, 1102),
       (59, 19, 1103),
       (60, 19, 1104),
       (61, 19, 1105),
       (62, 19, 1106),
       (63, 19, 1107),
       (64, 19, 1108),
       (65, 19, 1109),
       (66, 19, 1110),
       (67, 19, 1111);

-- NPC rewards table.
--
-- Many to many relations table.
--
CREATE TABLE `rewards_npcs`
(
    `id`         smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `npcs_id`    tinyint  NOT NULL
        COMMENT 'NPC ID.',
    `rewards_id` smallint NOT NULL
        COMMENT 'Reward to award.',

    CONSTRAINT `rewards_npcs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations.';

CREATE INDEX `rewards_npcs_npcs_id_idx`
    ON `rewards_npcs` (`npcs_id`);
CREATE INDEX `rewards_npcs_rewards_id_idx`
    ON `rewards_npcs` (`rewards_id`);

INSERT INTO `rewards_npcs` (`id`, `npcs_id`, `rewards_id`)
VALUES (1, 1, 1),
       (2, 1, 2),
       (3, 1, 3),
       (4, 1, 4),
       (5, 2, 5),
       (6, 2, 6),
       (7, 2, 7),
       (8, 2, 8),
       (9, 3, 9),
       (10, 3, 10),
       (11, 3, 11),
       (12, 3, 12),
       (13, 4, 13),
       (14, 4, 14),
       (15, 4, 15),
       (16, 4, 16),
       (17, 5, 17),
       (18, 5, 18),
       (19, 5, 19),
       (20, 5, 20),
       (21, 6, 21),
       (22, 6, 22),
       (23, 6, 23),
       (24, 6, 24),
       (25, 7, 25),
       (26, 7, 26),
       (27, 7, 27),
       (28, 7, 28),
       (29, 8, 29),
       (30, 8, 30),
       (31, 8, 31),
       (32, 8, 32),
       (33, 9, 33),
       (34, 9, 34),
       (35, 9, 35),
       (36, 9, 36),
       (37, 10, 37),
       (38, 10, 38),
       (39, 10, 39),
       (40, 10, 40),
       (41, 11, 41),
       (42, 11, 42),
       (43, 11, 43),
       (44, 11, 44),
       (45, 12, 45),
       (46, 12, 46),
       (47, 12, 47),
       (48, 12, 48),
       (49, 13, 49),
       (50, 13, 50),
       (51, 13, 51),
       (52, 13, 52),
       (53, 15, 53),
       (54, 15, 54),
       (55, 15, 55),
       (56, 15, 56),
       (57, 16, 57),
       (58, 16, 58),
       (59, 16, 59),
       (60, 16, 60),
       (61, 17, 61),
       (62, 17, 62),
       (63, 17, 63),
       (64, 17, 64),
       (65, 18, 65),
       (66, 18, 66),
       (67, 18, 67),
       (68, 18, 68),
       (69, 19, 69),
       (70, 19, 70),
       (71, 19, 71),
       (72, 19, 72),
       (73, 20, 73),
       (74, 20, 74),
       (75, 20, 75),
       (76, 20, 76),
       (77, 21, 77),
       (78, 21, 78),
       (79, 21, 79),
       (80, 21, 80),
       (81, 22, 81),
       (82, 22, 82),
       (83, 22, 83),
       (84, 22, 84),
       (85, 23, 85),
       (86, 23, 86),
       (87, 23, 87),
       (88, 23, 88),
       (89, 24, 89),
       (90, 24, 90),
       (91, 24, 91),
       (92, 24, 92),
       (93, 25, 93),
       (94, 25, 94),
       (95, 25, 95),
       (96, 25, 96),
       (97, 26, 97),
       (98, 26, 98),
       (99, 26, 99),
       (100, 26, 100),
       (101, 27, 101),
       (102, 27, 102),
       (103, 27, 103),
       (104, 27, 104),
       (105, 28, 105),
       (106, 28, 106),
       (107, 28, 107),
       (108, 28, 108),
       (109, 29, 109),
       (110, 29, 110),
       (111, 29, 111),
       (112, 29, 112),
       (113, 30, 113),
       (114, 30, 114),
       (115, 30, 115),
       (116, 30, 116),
       (117, 31, 117),
       (118, 31, 118),
       (119, 31, 119),
       (120, 31, 120),
       (121, 32, 121),
       (122, 32, 122),
       (123, 32, 123),
       (124, 32, 124),
       (125, 33, 125),
       (126, 33, 126),
       (127, 33, 127),
       (128, 33, 128),
       (129, 34, 129),
       (130, 34, 130),
       (131, 34, 131),
       (132, 34, 132),
       (133, 35, 133),
       (134, 35, 134),
       (135, 35, 135),
       (136, 35, 136),
       (137, 36, 137),
       (138, 36, 138),
       (139, 36, 139),
       (140, 36, 140),
       (141, 37, 141),
       (142, 37, 142),
       (143, 37, 143),
       (144, 37, 144),
       (145, 38, 145),
       (146, 38, 146),
       (147, 38, 147),
       (148, 38, 148),
       (149, 39, 149),
       (150, 39, 150),
       (151, 39, 151),
       (152, 39, 152),
       (153, 40, 153),
       (154, 40, 154),
       (155, 40, 155),
       (156, 40, 156),
       (157, 41, 157),
       (158, 41, 158),
       (159, 41, 159),
       (160, 41, 160),
       (161, 42, 161),
       (162, 42, 162),
       (163, 42, 163),
       (164, 42, 164),
       (165, 43, 165),
       (166, 43, 166),
       (167, 43, 167),
       (168, 43, 168),
       (169, 44, 169),
       (170, 44, 170),
       (171, 44, 171),
       (172, 44, 172),
       (173, 45, 173),
       (174, 45, 174),
       (175, 45, 175),
       (176, 45, 176),
       (177, 46, 177),
       (178, 46, 178),
       (179, 46, 179),
       (180, 46, 180),
       (181, 47, 181),
       (182, 47, 182),
       (183, 47, 183),
       (184, 47, 184),
       (185, 48, 185),
       (186, 48, 186),
       (187, 48, 187),
       (188, 48, 188),
       (189, 49, 189),
       (190, 49, 190),
       (191, 49, 191),
       (192, 49, 192),
       (193, 68, 193),
       (194, 68, 194),
       (195, 68, 195),
       (196, 68, 196),
       (197, 75, 197),
       (198, 75, 198),
       (199, 75, 199),
       (200, 75, 200);

-- Ship rewards table.
--
-- Many to many relations table.
--
CREATE TABLE `rewards_quests`
(
    `id`         smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `quests_id`  smallint NOT NULL
        COMMENT 'Quest ID.',
    `rewards_id` smallint NOT NULL
        COMMENT 'Reward to award.',

    CONSTRAINT `rewards_quests_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations.';

CREATE INDEX `rewards_quests_quests_id_idx`
    ON `rewards_quests` (`quests_id`);
CREATE INDEX `rewards_quests_rewards_id_idx`
    ON `rewards_quests` (`rewards_id`);

-- Initial dump for the `rewards_quests` table.

-- Ship rewards table.
--
-- Many to many relations table.
--
CREATE TABLE `rewards_ships`
(
    `id`         tinyint  NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `ships_id`   tinyint  NOT NULL
        COMMENT 'Ship ID.',
    `rewards_id` smallint NOT NULL
        COMMENT 'Reward to award.',

    CONSTRAINT `rewards_ships_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations.';

CREATE INDEX `rewards_ships_ships_id_idx`
    ON `rewards_ships` (`ships_id`);
CREATE INDEX `rewards_ships_rewards_id_idx`
    ON `rewards_ships` (`rewards_id`);

-- Initial dump for the `rewards_ships` table.

INSERT INTO `rewards_ships` (`id`, `ships_id`, `rewards_id`)
VALUES (1, 1, 1112),
       (2, 1, 1113),
       (3, 2, 1114),
       (4, 2, 1115),
       (5, 3, 1116),
       (6, 3, 1117),
       (7, 4, 1118),
       (8, 4, 1119),
       (9, 5, 1120),
       (10, 5, 1121),
       (11, 6, 1122),
       (12, 6, 1123),
       (13, 7, 1124),
       (14, 7, 1125),
       (15, 8, 1126),
       (16, 8, 1127),
       (17, 9, 1128),
       (18, 9, 1129),
       (19, 10, 1130),
       (20, 10, 1131),
       (21, 11, 1132),
       (22, 11, 1133),
       (23, 12, 1134),
       (24, 12, 1135),
       (25, 13, 1136),
       (26, 13, 1137);

-- Ship rewards table.
--
-- Many to many relations table.
--
CREATE TABLE `rewards_vouchers`
(
    `id`          smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `vouchers_id` smallint NOT NULL
        COMMENT 'Voucher ID.',
    `rewards_id`  smallint NOT NULL
        COMMENT 'Reward to award.',

    CONSTRAINT `rewards_vouchers_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Many to many relations.';

CREATE INDEX `rewards_vouchers_vouchers_id_idx`
    ON `rewards_vouchers` (`vouchers_id`);
CREATE INDEX `rewards_vouchers_rewards_id_idx`
    ON `rewards_vouchers` (`rewards_id`);

-- Initial dump for the `rewards_vouchers` table.

-- Server logs table.
--
-- Server fired events.
--
CREATE TABLE `server_logs`
(
    `id`    int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `date`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `level` tinyint   NOT NULL DEFAULT 0
        COMMENT 'Log level (0 = emergency, 1 = alert, 2 = critical, 3 = error, 4 = warning, 5 = notice, 6 = info, 7 = debug)',
    `text`  text      NOT NULL,

    CONSTRAINT `server_logs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Server fired events.';

CREATE INDEX `server_logs_level_idx`
    ON `server_logs` (`level`);

-- Initial dump for the `server_logs` table.

-- Ships table.
--
-- Ships table.
--
CREATE TABLE `ships`
(
    `id`         tinyint  NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `items_id`   smallint NOT NULL,
    `health`     int      NOT NULL DEFAULT 0
        COMMENT 'Health points',
    `speed`      smallint NOT NULL DEFAULT 0
        COMMENT 'Base speed.',
    `cargo`      smallint NOT NULL DEFAULT 100
        COMMENT 'Cargo space.',
    `batteries`  smallint NOT NULL DEFAULT 1000
        COMMENT 'Batteries space.',
    `rockets`    smallint NOT NULL DEFAULT 100
        COMMENT 'Rockets space.',
    `lasers`     tinyint  NOT NULL DEFAULT 1
        COMMENT 'Laser slots.',
    `hellstorms` tinyint  NOT NULL DEFAULT 1
        COMMENT 'Laser slots.',
    `generators` tinyint  NOT NULL DEFAULT 1
        COMMENT 'Generator slots.',
    `extras`     tinyint  NOT NULL DEFAULT 1
        COMMENT 'Extras slots.',
    `gfx`        tinyint  NOT NULL DEFAULT 0,

    CONSTRAINT `ships_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Ships table.';

CREATE INDEX `ships_items_id_idx`
    ON `ships` (`items_id`);
CREATE INDEX `ships_gfx_idx`
    ON `ships` (`gfx`);

-- Initial dump for the `ships` table.

INSERT INTO `ships` (`id`, `items_id`, `health`, `speed`, `cargo`, `batteries`, `rockets`, `lasers`, `hellstorms`,
                     `generators`, `extras`, `gfx`)
VALUES (1, 9, 4000, 320, 100, 1000, 100, 1, 1, 1, 1, 1),
       (2, 10, 8000, 340, 200, 2000, 200, 2, 1, 2, 1, 2),
       (3, 11, 12000, 280, 300, 4000, 400, 3, 1, 5, 2, 3),
       (4, 12, 16000, 330, 400, 6000, 600, 4, 1, 6, 2, 4),
       (5, 13, 64000, 360, 500, 10000, 100, 6, 1, 6, 2, 5),
       (6, 14, 64000, 360, 600, 8000, 800, 6, 1, 8, 2, 6),
       (7, 15, 120000, 340, 700, 16000, 800, 7, 1, 10, 3, 7),
       (8, 16, 180000, 380, 1000, 21000, 1000, 10, 1, 10, 2, 0),
       (9, 17, 128000, 280, 800, 18000, 800, 7, 1, 15, 3, 9),
       (10, 18, 256000, 300, 1000, 32000, 3000, 15, 1, 15, 3, 10),
       (11, 20, 275000, 300, 2000, 15000, 3000, 10, 1, 15, 3, 49),
       (12, 21, 550000, 240, 3000, 20000, 2000, 7, 2, 20, 5, 69),
       (13, 19, 100000, 370, 500, 5000, 500, 5, 1, 12, 2, 70);

-- Skilltree levels table.
--
-- Levels a skill can reach.
--
CREATE TABLE `skilltree_levels`
(
    `id`                  smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `skilltree_skills_id` tinyint  NOT NULL
        COMMENT 'The skill.',
    `levels_id`           tinyint  NOT NULL
        COMMENT 'Level to upgrade the skill.',
    `credits`             int      NOT NULL DEFAULT 10000
        COMMENT 'Credits needed to upgrade this skill.',
    `seprom`              smallint NOT NULL DEFAULT 0
        COMMENT 'Seprom needed to upgrade this skill.',
    `points`              tinyint  NOT NULL DEFAULT 1
        COMMENT 'Research points needed to upgrade this skill.',

    CONSTRAINT `skilltree_levels_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Levels a skill can reach.';

-- Initial dump for the `skilltree_levels` table.

-- Skilltree skills table.
--
-- The available skills.
--
CREATE TABLE `skilltree_skills`
(
    `id`           tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`         varchar(255) NOT NULL DEFAULT ''
        COMMENT 'Skill name.',
    `description`  text         NOT NULL
        COMMENT 'Skill description.',
    `type`         tinyint      NOT NULL DEFAULT 1
        COMMENT '0 = blue, 1 = purple, 2 = red.',
    `is_advanced`  boolean      NOT NULL DEFAULT false
        COMMENT 'Whether it''s an advanced skill or not.',
    `bonus_type`   varchar(255) NOT NULL DEFAULT 'health'
        COMMENT 'Type of bonus the skill awards.',
    `bonus_amount` int          NOT NULL DEFAULT 0
        COMMENT 'Amount of bonus the skill awards.',
    `bonus_factor` tinyint      NOT NULL DEFAULT 2
        COMMENT 'Factor the bonus increases with each upgrade.',

    CONSTRAINT `skilltree_skills_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'The available skills.';

CREATE INDEX `skilltree_skills_name_idx`
    ON `skilltree_skills` (`name`);
CREATE INDEX `skilltree_skills_type_idx`
    ON `skilltree_skills` (`type`);
CREATE INDEX `skilltree_skills_is_advanced_idx`
    ON `skilltree_skills` (`is_advanced`);
CREATE INDEX `skilltree_skills_bonus_type_idx`
    ON `skilltree_skills` (`bonus_type`);

-- Initial dump for the `skilltree_skills` table.

-- Skilltree unlocks table
--
-- Requisites needed to unlock a skill upgrade.
--
CREATE TABLE `skilltree_unlocks`
(
    `id`                           smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `upgrade_skilltree_levels_id`  smallint NOT NULL
        COMMENT 'Skill to upgrade.',
    `required_skilltree_levels_id` smallint NOT NULL
        COMMENT 'Required skill level to upgrade.',

    CONSTRAINT `skilltree_unlocks_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Requisites needed to unlock a skill upgrade.';

CREATE INDEX `skilltree_unlocks_upgrade_skilltree_levels_id_idx`
    ON `skilltree_unlocks` (`upgrade_skilltree_levels_id`);
CREATE INDEX `skilltree_unlocks_required_skilltree_levels_id_idx`
    ON `skilltree_unlocks` (`required_skilltree_levels_id`);

-- Initial dump for the `skilltree_unlocks` table.

-- Skylab modules table.
--
-- Different skylab modules.
--
CREATE TABLE `skylab_modules`
(
    `id`                tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`              varchar(255) NOT NULL DEFAULT ''
        COMMENT 'Module name.',
    `production_factor` tinyint      NOT NULL DEFAULT 20
        COMMENT 'Production factor.',
    `production_base`   smallint     NOT NULL DEFAULT 1000
        COMMENT 'Production base.',
    `storage_factor`    smallint     NOT NULL DEFAULT 50
        COMMENT 'Storage factor.',
    `storage_base`      smallint     NOT NULL DEFAULT 20000
        COMMENT 'Storage base.',
    `upgrade_factor`    tinyint      NOT NULL DEFAULT 35
        COMMENT 'Upgrade costs factor.',
    `upgrade_base`      smallint     NOT NULL DEFAULT 5000
        COMMENT 'Upgrade costs base.',
    `energy_factor`     tinyint      NOT NULL DEFAULT 10
        COMMENT 'Energy consumption factor.',
    `energy_base`       tinyint      NOT NULL DEFAULT 10
        COMMENT 'Energy consumption base.',

    CONSTRAINT `skylab_modules` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Different skylab modules.';

CREATE INDEX `skylab_modules_name_idx`
    ON `skylab_modules` (`name`);

-- Initial dump for the `skylab_modules` table.

INSERT INTO `skylab_modules` (`id`, `name`, `production_factor`, `production_base`, `storage_factor`, `storage_base`,
                              `upgrade_factor`, `upgrade_base`, `energy_factor`, `energy_base`)
VALUES (1,
        'Prometium Collector',
        20,
        1000,
        50,
        10000,
        35,
        5000,
        10,
        10),
       (2,
        'Endurium Collector',
        20,
        1000,
        50,
        10000,
        35,
        5000,
        10,
        10),
       (3,
        'Terbium Collector',
        20,
        1000,
        50,
        10000,
        35,
        5000,
        10,
        10),
       (4,
        'Basic Module',
        0,
        0,
        0,
        0,
        30,
        10000,
        5,
        20),
       (5,
        'Solar Module',
        20,
        150,
        20,
        150,
        20,
        6000,
        10,
        10),
       (6,
        'Storage Module',
        0,
        0,
        0,
        0,
        27,
        10000,
        10,
        10),
       (7,
        'Prometid Refinery',
        10,
        100,
        50,
        1000,
        40,
        10000,
        10,
        15),
       (8,
        'Duranium Refinery',
        10,
        100,
        50,
        1000,
        40,
        10000,
        10,
        15),
       (9,
        'Xenomit Refinery',
        10,
        100,
        50,
        1000,
        40,
        10000,
        10,
        15),
       (10,
        'Promerium Refinery',
        7,
        100,
        25,
        1000,
        35,
        5000,
        10,
        10),
       (11,
        'Seprom Refinery',
        20,
        10,
        50,
        100,
        35,
        5000,
        10,
        10);

-- Nanotech Factory costs table.
--
-- Item production costs.
--
CREATE TABLE `techfactory_costs`
(
    `id`                   tinyint  NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `techfactory_items_id` tinyint  NOT NULL
        COMMENT 'Techfactory Item ID.',
    `items_id`             smallint NOT NULL
        COMMENT 'Cost item ID.',
    `amount`               int      NOT NULL
        COMMENT 'Amount of items to build the techfactory item.',

    CONSTRAINT `techfactory_costs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Item production costs.';

-- Initial dump for the `techfactory_costs` table.

INSERT INTO `techfactory_costs` (`id`, `techfactory_items_id`, `items_id`, `amount`)
VALUES (1, 1, 1, 1000000),
       (2, 1, 243, 500),
       (3, 1, 229, 5),
       (4, 2, 1, 500000),
       (5, 2, 243, 200),
       (6, 2, 229, 1),
       (7, 3, 1, 20000),
       (8, 4, 1, 500000),
       (9, 4, 243, 250),
       (10, 4, 229, 2),
       (11, 5, 1, 500000),
       (12, 5, 243, 250),
       (13, 5, 229, 2);

-- Nanotech Factory drones table.
--
-- Drones that can be build in the tech factory.
--
CREATE TABLE `techfactory_drones`
(
    `id`          tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`        varchar(255) NOT NULL
        COMMENT 'Drone name.',
    `description` text         NOT NULL
        COMMENT 'Drone description.',
    `time`        tinyint      NOT NULL DEFAULT 0
        COMMENT 'Seconds it takes to produce the drone.',
    `parts`       tinyint      NOT NULL DEFAULT 45
        COMMENT 'Necessary parts to build the drone.',
    `price`       int          NOT NULL
        COMMENT 'Price for producing the drone.',
    `factor`      tinyint      NOT NULL DEFAULT 5.00
        COMMENT 'Factor the price reduces with each new part.',

    CONSTRAINT `techfactory_drones_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Drones that can be build in the tech factory.';

CREATE INDEX `techfactory_drones_name_idx`
    ON `techfactory_drones` (`name`);

-- Initial dump for the `techfactory_drones` table.

INSERT INTO `techfactory_drones` (`id`, `name`, `description`, `time`, `parts`, `price`, `factor`)
VALUES (1, 'Apis',
        'Every now and then you can find sections of the Apis drone blueprints in pirate booty. Once you have all the sections, you can build the drone. You can also build the drone instantly but this requires Uridium. Each part of the blueprints you find reduces the price of instantly building the drone.',
        0, 45, 1100000, 5),
       (2, 'Zeus',
        'Occasionally you can find sections of the Zeus drone blueprints in the pirate booty. Once you have all the sections, you can build the drone. You can also build the drone instantly but this requires Uridium. Each piece of the blueprints that you find reduces the price of instantly building the drone.',
        0, 45, 1500000, 5);

-- Nanotech Factory items table.
--
-- Items that can be build in the tech factory.
--
CREATE TABLE `techfactory_items`
(
    `id`                 tinyint      NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `name`               varchar(255) NOT NULL
        COMMENT 'Item name.',
    `description`        text         NOT NULL
        COMMENT 'Item description.',
    `effect`             text         NOT NULL
        COMMENT 'Effect description.',
    `duration`           smallint     NOT NULL DEFAULT 900
        COMMENT 'Seconds the effect is active.',
    `cooldown`           smallint     NOT NULL DEFAULT 900
        COMMENT 'Seconds the effect takes to cooldown.',
    `time`               int          NOT NULL
        COMMENT 'Seconds it takes to produce the item.',
    `free_production`    smallint     NOT NULL
        COMMENT 'Free production costs.',
    `instant_production` smallint     NOT NULL
        COMMENT 'Instant production costs.',

    CONSTRAINT `techfactory_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Items that can be build in the tech factory.';

CREATE INDEX `techfactory_items_name_idx`
    ON `techfactory_items` (`name`);

-- Initial dump for the `techfactory_items` table.

INSERT INTO `techfactory_items` (`id`, `name`, `description`, `effect`, `duration`, `cooldown`, `time`,
                                 `instant_production`, `free_production`)
VALUES (1, 'Energy leech',
        'The energy leech transforms 10% of the laser damage you cause into HP and transfers it back to your ship.',
        'Transforms 10% of laser damage into HP and transfers it back to your ship', 900, 900, 43200, 3125, 6500),
       (2, 'Chain impulse',
        'An energy pulse which locks onto one target and then onto up to seven other enemies, thereby causing a chain reaction of shield damage to each and every one.',
        'Can inflict up to 10,000 damage on a maximum of 7 targets', 0, 60, 21600, 900, 1800),
       (3, 'Precision targeter',
        'The precision targeter is a highly accurate targeting system that increases the hit ratio of normal rockets by 100% for a certain time.',
        '100% hit ratio', 900, 300, 7200, 250, 500),
       (4, 'Backup shields', 'The backup shields will bring your ship''s shields back up immediately.',
        '75,000 shield strength', 0, 120, 43200, 1400, 2800),
       (5, 'Battle repair bot',
        'When the battle repair bot is activated, it repairs 10,000 HP per second. It can be used even in the toughest battle situations.',
        '10,000 HP', 10, 120, 43200, 1400, 2800);

-- Trade items table.
--
-- Trade items.
--
CREATE TABLE `trade_items`
(
    `id`          smallint NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `items_id`    smallint NOT NULL,
    `accounts_id` int      NULL     DEFAULT NULL,
    `price`       int      NOT NULL DEFAULT 0,
    `type`        tinyint  NOT NULL DEFAULT 0
        COMMENT '0 = hourly, 1 = daily, 3 = weekly',

    CONSTRAINT `trade_items_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Trade items.';

CREATE INDEX `trade_items_items_id_idx`
    ON `trade_items` (`items_id`);
CREATE INDEX `trade_items_accounts_id_idx`
    ON `trade_items` (`accounts_id`);
CREATE INDEX `trade_items_type_idx`
    ON `trade_items` (`type`);

-- Initial dump for the `trade_items` table.

-- Users table.
--
-- Contains the registered users.
--
CREATE TABLE `users`
(
    `id`                      int          NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `date`                    timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Date when the user registered.',
    `invitation_codes_id`     smallint     NULL     DEFAULT NULL
        COMMENT 'Invitation code used to register',
    `name`                    varchar(255) NOT NULL DEFAULT ''
        COMMENT 'User name.',
    `password`                varchar(255) NOT NULL DEFAULT ''
        COMMENT 'Password hash (argon).',
    `email`                   varchar(255) NOT NULL DEFAULT ''
        COMMENT 'User email.',
    `email_verification_code` varchar(32)  NOT NULL DEFAULT ''
        COMMENT 'Email verification code.',
    `email_verification_date` timestamp    NULL     DEFAULT NULL
        COMMENT 'Date when the user verified its email.',
    `ip`                      varchar(45)  NOT NULL DEFAULT '0.0.0.0'
        COMMENT 'Registration IP.',

    CONSTRAINT `users_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Contains the login information of the registered users.';

CREATE UNIQUE INDEX `users_id_idx`
    ON `users` (`id`);
CREATE UNIQUE INDEX `users_name_idx`
    ON `users` (`name`);
CREATE UNIQUE INDEX `users_email_verification_code_idx`
    ON `users` (`email_verification_code`);

-- Initial dump for `users` table.

-- Vouchers table.
--
-- Voucher codes.
--
CREATE TABLE `vouchers`
(
    `id`   smallint    NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `code` varchar(32) NOT NULL DEFAULT '',
    `max`  tinyint     NOT NULL DEFAULT 1,

    CONSTRAINT `vouchers_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Voucher codes.';

CREATE UNIQUE INDEX `vouchers_code_idx`
    ON `vouchers` (`code`);

-- Initial dump for the `vouchers` table.

-- Invitation codes redeem logs.
--
-- Contains the redeem logs for the invitation codes.
--
CREATE TABLE `vouchers_redeem_logs`
(
    `id`          int       NOT NULL AUTO_INCREMENT
        COMMENT 'Primary Key.',
    `vouchers_id` smallint  NOT NULL
        COMMENT 'Voucher code ID.',
    `accounts_id` int       NOT NULL
        COMMENT 'Account that redeemed the voucher.',
    `date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Date when the voucher was redeemed.',

    CONSTRAINT `vouchers_redeem_logs_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Contains the redeem logs for the voucher codes.';

CREATE INDEX `vouchers_redeem_logs_vouchers_id_idx`
    ON `vouchers_redeem_logs` (`vouchers_id`);
CREATE INDEX `vouchers_redeem_logs_accounts_id_idx`
    ON `vouchers_redeem_logs` (`accounts_id`);

-- Initial dump for the `vouchers_redeem_logs` table.


-- Relations for the `accounts` table.
--
-- An account can belong to a clan.
-- An account belongs to a faction.
-- An account has a rank.
-- An account has a level.
-- An account has an active hangar.
-- An account belongs to an user.

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_clans` FOREIGN KEY `accounts_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_factions` FOREIGN KEY `accounts_factions` (`factions_id`)
        REFERENCES `factions` (`id`);

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_accounts_hangars` FOREIGN KEY `accounts_accounts_hangars` (`accounts_hangars_id`)
        REFERENCES `accounts_hangars` (`id`);

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_levels` FOREIGN KEY `accounts_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_ranks` FOREIGN KEY `accounts_ranks` (`ranks_id`)
        REFERENCES `ranks` (`id`);

ALTER TABLE `accounts`
    ADD CONSTRAINT `accounts_users` FOREIGN KEY `accounts_users` (`users_id`)
        REFERENCES `users` (`id`);

-- Relations for the `accounts_banks` table.
--
-- A bank belongs to an account.

ALTER TABLE `accounts_banks`
    ADD CONSTRAINT `accounts_banks_accounts` FOREIGN KEY `accounts_banks_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_banks_logs` table.
--
-- A log entry is created by an account.
-- A log entry is destined to an account.
-- A log entry belongs to a bank.

ALTER TABLE `accounts_banks_logs`
    ADD CONSTRAINT `accounts_banks_logs_accounts` FOREIGN KEY `accounts_banks_logs_accounts` (`from_accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_banks_logs`
    ADD CONSTRAINT `accounts_banks_logs_to_accounts` FOREIGN KEY `accounts_banks_logs_to_accounts` (`to_accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_banks_logs`
    ADD CONSTRAINT `accounts_banks_logs_accounts_banks` FOREIGN KEY `accounts_banks_logs_accounts_banks` (`accounts_banks_id`)
        REFERENCES `accounts_banks` (`id`);

-- Relations for the `accounts_clans_roles` table.
--
-- An account.
-- A role.

ALTER TABLE `accounts_clans_roles`
    ADD CONSTRAINT `accounts_clans_roles_accounts` FOREIGN KEY `accounts_clans_roles_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_clans_roles`
    ADD CONSTRAINT `accounts_clans_roles_clans_roles` FOREIGN KEY `accounts_clans_roles_clans_roles` (`clans_roles_id`)
        REFERENCES `clans_roles` (`id`);

-- Relations for the `accounts_configurations` table.
--
-- A configuration belongs to an hangar.

ALTER TABLE `accounts_configurations`
    ADD CONSTRAINT `accounts_configurations_accounts_hangars` FOREIGN KEY `accounts_configurations_accounts_hangars` (`accounts_hangars_id`)
        REFERENCES `accounts_hangars` (`id`);

-- Relations for the `accounts_configurations_accounts_items` table.
--
-- A configuration item belongs to a configuration.
-- A configuration item is an item.
-- A configuration item can be equipped on a drone.
-- A configuration item can be equipped on a pet.

ALTER TABLE `accounts_configurations_accounts_items`
    ADD CONSTRAINT `accounts_configurations_accounts_items_accounts_configurations` FOREIGN KEY `accounts_configurations_accounts_items_accounts_configurations` (`accounts_configurations_id`)
        REFERENCES `accounts_configurations` (`id`);

ALTER TABLE `accounts_configurations_accounts_items`
    ADD CONSTRAINT `accounts_configurations_accounts_items_accounts_items` FOREIGN KEY `accounts_configurations_accounts_items_accounts_items` (`accounts_items_id`)
        REFERENCES `accounts_items` (`id`);

ALTER TABLE `accounts_configurations_accounts_items`
    ADD CONSTRAINT `accounts_configurations_accounts_items_accounts_drones` FOREIGN KEY `accounts_configurations_accounts_items_accounts_drones` (`accounts_drones_id`)
        REFERENCES `accounts_drones` (`id`);

ALTER TABLE `accounts_configurations_accounts_items`
    ADD CONSTRAINT `accounts_configurations_accounts_items_accounts_pets` FOREIGN KEY `accounts_configurations_accounts_items_accounts_pets` (`accounts_pets_id`)
        REFERENCES `accounts_pets` (`id`);

-- Relations for the `accounts_destroys` table.
--
-- A destroy history belongs to an account.

ALTER TABLE `accounts_destroys`
    ADD CONSTRAINT `accounts_destroys_accounts` FOREIGN KEY `accounts_destroys_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_destroys`
    ADD CONSTRAINT `accounts_destroys_ships` FOREIGN KEY `accounts_destroys_ships` (`ships_id`)
        REFERENCES `ships` (`id`);

-- Relations for the `accounts_drones` table.
--
-- A drone has a level.
-- A drone belongs to an account.

ALTER TABLE `accounts_drones`
    ADD CONSTRAINT `accounts_drones_accounts` FOREIGN KEY `accounts_drones_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_drones`
    ADD CONSTRAINT `accounts_drones_levels` FOREIGN KEY `accounts_drones_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

-- Relations for the `accounts_galaxygates` table.
--
-- A gate is a galaxy gate.
-- A gate belongs to an account.

ALTER TABLE `accounts_galaxygates`
    ADD CONSTRAINT `accounts_galaxygates_galaxygates` FOREIGN KEY `accounts_galaxygates_galaxygates` (`galaxygates_id`)
        REFERENCES `galaxygates` (`id`);

ALTER TABLE `accounts_galaxygates`
    ADD CONSTRAINT `accounts_galaxygates_accounts` FOREIGN KEY `accounts_galaxygates_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_hangars` table.
--
-- An hangar belongs to an account.
-- An hangar has a ship.
-- An hangar has an active configuration.

ALTER TABLE `accounts_hangars`
    ADD CONSTRAINT `accounts_hangars_accounts` FOREIGN KEY `accounts_hangars_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_hangars`
    ADD CONSTRAINT `accounts_hangars_accounts_ships` FOREIGN KEY `accounts_hangars_accounts_ships` (`accounts_ships_id`)
        REFERENCES `accounts_ships` (`id`);

ALTER TABLE `accounts_hangars`
    ADD CONSTRAINT `accounts_hangars_accounts_configurations` FOREIGN KEY `accounts_hangars_accounts_configurations` (`accounts_configurations_id`)
        REFERENCES `accounts_configurations` (`id`);

-- Relations for the `accounts_history` table.
--
-- A history belongs to an account.

ALTER TABLE `accounts_history`
    ADD CONSTRAINT `accounts_history_accounts` FOREIGN KEY `accounts_history_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_items` table.
--
-- An item belongs to an account.
-- An item is an item.
-- An item has a level.

ALTER TABLE `accounts_items`
    ADD CONSTRAINT `accounts_items_accounts` FOREIGN KEY `accounts_items_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_items`
    ADD CONSTRAINT `accounts_items_items` FOREIGN KEY `accounts_items_items` (`items_id`)
        REFERENCES `items` (`id`);

ALTER TABLE `accounts_items`
    ADD CONSTRAINT `accounts_items_levels` FOREIGN KEY `accounts_items_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

-- Relations for the `accounts_messages` table.
--
-- A message comes from an account.
-- A message goes to an account.

ALTER TABLE `accounts_messages`
    ADD CONSTRAINT `accounts_messages_to_accounts` FOREIGN KEY `accounts_messages_to_accounts` (`to_accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_messages`
    ADD CONSTRAINT `accounts_messages_from_accounts` FOREIGN KEY `accounts_messages_from_accounts` (`from_accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_pets` table.
--
-- A pet has a level.
-- A pet belongs to an account.

ALTER TABLE `accounts_pets`
    ADD CONSTRAINT `accounts_pets_accounts` FOREIGN KEY `accounts_pets_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_pets`
    ADD CONSTRAINT `accounts_pets_levels` FOREIGN KEY `accounts_pets_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

-- Relations for the `accounts_quests` table.
--
-- A quest belongs to an account.
-- A quest is a quest.

ALTER TABLE `accounts_quests`
    ADD CONSTRAINT `accounts_quests_accounts` FOREIGN KEY `accounts_quests_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_quests`
    ADD CONSTRAINT `accounts_quests_quests` FOREIGN KEY `accounts_quests_quests` (`quests_id`)
        REFERENCES `quests` (`id`);

-- Relations for the `accounts_rankings` table.
--
-- A rank belongs to an account.

ALTER TABLE `accounts_rankings`
    ADD CONSTRAINT `accounts_rankings_accounts` FOREIGN KEY `accounts_rankings_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_settings` table.
--
-- Settings belong to an account

ALTER TABLE `accounts_settings`
    ADD CONSTRAINT `accounts_settings_accounts` FOREIGN KEY `accounts_settings_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_ships` table.
--
-- A ship belongs to an account.
-- A ship is a ship.
-- A ship is located in a map.

ALTER TABLE `accounts_ships`
    ADD CONSTRAINT `accounts_ships_accounts` FOREIGN KEY `accounts_ships_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_ships`
    ADD CONSTRAINT `accounts_ships_ships` FOREIGN KEY `accounts_ships_ships` (`ships_id`)
        REFERENCES `ships` (`id`);

ALTER TABLE `accounts_ships`
    ADD CONSTRAINT `accounts_ships_maps` FOREIGN KEY `accounts_ships_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

-- Relations for the `accounts_skills` table.
--
-- A skill belongs to an account.
-- A skill is a skill.
-- A skill has a level.

ALTER TABLE `accounts_skills`
    ADD CONSTRAINT `accounts_skills_accounts` FOREIGN KEY `accounts_skills_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_skills`
    ADD CONSTRAINT `accounts_skills_skilltree_skills` FOREIGN KEY `accounts_skills_skilltree_skills` (`skilltree_skills_id`)
        REFERENCES `skilltree_skills` (`id`);

ALTER TABLE `accounts_skills`
    ADD CONSTRAINT `accounts_skills_skilltree_levels` FOREIGN KEY `accounts_skills_skilltree_levels` (`skilltree_levels_id`)
        REFERENCES `skilltree_levels` (`id`);

-- Relations for the `accounts_skylabs` table.
--
-- A skylab is a skylab module.
-- A skylab has a level.
-- A skylab belongs to an account.

ALTER TABLE `accounts_skylabs`
    ADD CONSTRAINT `accounts_skylabs_accounts` FOREIGN KEY `accounts_skylabs_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_skylabs`
    ADD CONSTRAINT `accounts_skylabs_skylab_modules` FOREIGN KEY `accounts_skylabs_skylab_modules` (`skylab_modules_id`)
        REFERENCES `skylab_modules` (`id`);

ALTER TABLE `accounts_skylabs`
    ADD CONSTRAINT `accounts_skylabs_levels` FOREIGN KEY `accounts_skylabs_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

-- Relations for the `accounts_techfactories` table.
--
-- A techfactory belongs to an account.

ALTER TABLE `accounts_techfactories`
    ADD CONSTRAINT `accounts_techfactories_accounts` FOREIGN KEY `accounts_techfactories_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `accounts_techfactory_items` table.
--
-- An item belongs to an account.
-- An item is a techfactory item.

ALTER TABLE `accounts_techfactory_items`
    ADD CONSTRAINT `accounts_techfactory_items_accounts` FOREIGN KEY `accounts_techfactory_items_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_techfactory_items`
    ADD CONSTRAINT `accounts_techfactory_items_techfactory_items` FOREIGN KEY `accounts_techfactory_items_techfactory_items` (`techfactory_items_id`)
        REFERENCES `techfactory_items` (`id`);

-- Relations for the table `clans`.
--
-- A clan belongs to an account.

ALTER TABLE `clans`
    ADD CONSTRAINT `clans_accounts` FOREIGN KEY `clans_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `clans`
    ADD CONSTRAINT `clans_factions` FOREIGN KEY `clans_factions` (`factions_id`)
        REFERENCES `factions` (`id`);

-- Relations for the `clans_applications` table.
--
-- An application is designated to a clan.
-- An application belongs to an account.

ALTER TABLE `clans_applications`
    ADD CONSTRAINT `clans_applications_clans` FOREIGN KEY `clans_applications_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

ALTER TABLE `clans_applications`
    ADD CONSTRAINT `clans_applications_accounts` FOREIGN KEY `clans_applications_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `clans_banks` table.
--
-- A bank belongs to a clan.

ALTER TABLE `clans_banks`
    ADD CONSTRAINT `clans_banks_clans` FOREIGN KEY `clans_banks_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_banks_logs` table.
--
-- A log entry belongs to a clan bank.
-- A log entry is made by an account.
-- A log entry is made to an account.

ALTER TABLE `clans_banks_logs`
    ADD CONSTRAINT `clans_banks_logs_clans_banks` FOREIGN KEY `clans_banks_logs_clans_banks` (`clans_banks_id`)
        REFERENCES `clans_banks` (`id`);

ALTER TABLE `clans_banks_logs`
    ADD CONSTRAINT `clans_banks_logs_from_accounts` FOREIGN KEY `clans_banks_logs_from_accounts` (`from_accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `clans_banks_logs`
    ADD CONSTRAINT `clans_banks_logs_to_accounts` FOREIGN KEY `clans_banks_logs_to_accounts` (`to_accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `clans_battlestations` table.
--
-- A CBS may belong to a clan.
-- A CBS is located in a map.

ALTER TABLE `clans_battlestations`
    ADD CONSTRAINT `clans_battlestations_clans` FOREIGN KEY `clans_battlestations_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

ALTER TABLE `clans_battlestations`
    ADD CONSTRAINT `clans_battlestations_maps` FOREIGN KEY `clans_battlestations_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

-- Relations for the `clans_battlestations_items` table.
--
-- An item belongs to a CBS.
-- An item is an account's item.

ALTER TABLE `clans_battlestations_items`
    ADD CONSTRAINT `clans_battlestations_items_clans_battlestations` FOREIGN KEY `clans_battlestations_items_clans_battlestations` (`clans_battlestations_id`)
        REFERENCES `clans_battlestations` (`id`);

ALTER TABLE `clans_battlestations_items`
    ADD CONSTRAINT `clans_battlestations_items_accounts_items` FOREIGN KEY `clans_battlestations_items_accounts_items` (`accounts_items_id`)
        REFERENCES `accounts_items` (`id`);

-- Relations for the `clans_battlestations_logs` table.
--
-- A log entry belongs to a clan battle station.
-- A log entry belongs to a clan.

ALTER TABLE `clans_battlestations_logs`
    ADD CONSTRAINT `clans_battlestations_logs_clans_battlestations` FOREIGN KEY `clans_battlestations_logs_clans_battlestations` (`clans_battlestations_id`)
        REFERENCES `clans_battlestations` (`id`);

ALTER TABLE `clans_battlestations_logs`
    ADD CONSTRAINT `clans_battlestations_logs_clans` FOREIGN KEY `clans_battlestations_logs_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_diplomacies` table.
--
-- A diplomacy belongs to a clan.
-- A diplomacy is aimed to a clan.

ALTER TABLE `clans_diplomacies`
    ADD CONSTRAINT `clans_diplomacies_from_clans` FOREIGN KEY `clans_diplomacies_from_clans` (`from_clans_id`)
        REFERENCES `clans` (`id`);

ALTER TABLE `clans_diplomacies`
    ADD CONSTRAINT `clans_diplomacies_to_clans` FOREIGN KEY `clans_diplomacies_to_clans` (`to_clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_messages` table.
--
-- A message belongs to a clan.
-- A message is made by an account.
-- A message may be directed to an account.

ALTER TABLE `clans_messages`
    ADD CONSTRAINT `clans_messages_clans` FOREIGN KEY `clans_messages_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

ALTER TABLE `clans_messages`
    ADD CONSTRAINT `clans_messages_to_accounts` FOREIGN KEY `clans_messages_to_accounts` (`to_accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `clans_messages`
    ADD CONSTRAINT `clans_messages_from_accounts` FOREIGN KEY `clans_messages_from_accounts` (`from_accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for the `clans_news` table.
--
-- A new is made by an account.
-- A new belongs to a clan.

ALTER TABLE `clans_news`
    ADD CONSTRAINT `clans_news_accounts` FOREIGN KEY `clans_news_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `clans_news`
    ADD CONSTRAINT `clans_news_clans` FOREIGN KEY `clans_news_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_ranking` table.
--
-- A rank belongs to a clan.

ALTER TABLE `clans_ranking`
    ADD CONSTRAINT `clans_ranking_clans` FOREIGN KEY `clans_ranking_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_roles` table.
--
-- A role belongs to a clan.

ALTER TABLE `clans_roles`
    ADD CONSTRAINT `clans_roles_clans` FOREIGN KEY `clans_roles_clans` (`clans_id`)
        REFERENCES `clans` (`id`);

-- Relations for the `clans_roles_permissions` table.
--
-- A role permission belongs to a clan.
-- A role permission is a permission

ALTER TABLE `clans_roles_permissions`
    ADD CONSTRAINT `clans_roles_permissions_clans_roles` FOREIGN KEY `clans_roles_permissions_clans_roles` (`clans_roles_id`)
        REFERENCES `clans_roles` (`id`);

ALTER TABLE `clans_roles_permissions`
    ADD CONSTRAINT `clans_roles_permissions_permissions` FOREIGN KEY `clans_roles_permissions_permissions` (`permissions_id`)
        REFERENCES `permissions` (`id`);

-- Relations for the `collectables` table.

-- Relations for the `events` table.
--

-- Relations for the `factions` table.
--
-- A faction has a low starter map.
-- A faction has a high starter map.

ALTER TABLE `factions`
    ADD CONSTRAINT `factions_high_maps` FOREIGN KEY `factions_high_maps` (`high_maps_id`)
        REFERENCES `maps` (`id`);

ALTER TABLE `factions`
    ADD CONSTRAINT `factions_low_maps` FOREIGN KEY `factions_low_maps` (`low_maps_id`)
        REFERENCES `maps` (`id`);

-- Relations for the `galaxygates` table.
--
-- A galaxygate starts in a wave.

ALTER TABLE `galaxygates`
    ADD CONSTRAINT `galaxygates_galaxygates_waves` FOREIGN KEY `galaxygates_galaxygates_waves` (`galaxygates_waves_id`)
        REFERENCES `galaxygates_waves` (`id`);

-- Relations for the `galaxygates_gg_spins` table.

ALTER TABLE `galaxygates_gg_spins`
    ADD CONSTRAINT `galaxygates_gg_spins_galaxygates` FOREIGN KEY `galaxygates_gg_spins_galaxygates` (`galaxygates_id`)
        REFERENCES `galaxygates` (`id`);

ALTER TABLE `galaxygates_gg_spins`
    ADD CONSTRAINT `galaxygates_gg_spins_galaxygates_spins` FOREIGN KEY `galaxygates_gg_spins_galaxygates_spins` (`galaxygates_spins_id`)
        REFERENCES `galaxygates_spins` (`id`);

-- Relations for the `galaxygates_gg_waves` table.

ALTER TABLE `galaxygates_gg_waves`
    ADD CONSTRAINT `galaxygates_gg_waves_galaxygates` FOREIGN KEY `galaxygates_gg_waves_galaxygates` (`galaxygates_id`)
        REFERENCES `galaxygates` (`id`);

ALTER TABLE `galaxygates_gg_waves`
    ADD CONSTRAINT `galaxygates_gg_waves_galaxygates_waves` FOREIGN KEY `galaxygates_gg_waves_galaxygates_waves` (`galaxygates_waves_id`)
        REFERENCES `galaxygates_waves` (`id`);

-- Relations for the `galaxygates_probabilities` table.
--
-- A probability belongs to a gate.

ALTER TABLE `galaxygates_probabilities`
    ADD CONSTRAINT `galaxygates_probabilities_galaxygates` FOREIGN KEY `galaxygates_probabilities_galaxygates` (`galaxygates_id`)
        REFERENCES `galaxygates` (`id`);

-- Relations for the `galaxygates_spawns` table.
--
-- A spawn spawns an NPC.

ALTER TABLE `galaxygates_spawns`
    ADD CONSTRAINT `galaxygates_spawns_npcs` FOREIGN KEY `galaxygates_spawns_npcs` (`npcs_id`)
        REFERENCES `npcs` (`id`);

-- Relations for the `galaxygates_spins` table.
--
-- A spin awards an item.

ALTER TABLE `galaxygates_spins`
    ADD CONSTRAINT `galaxygates_spins_items` FOREIGN KEY `galaxygates_spins_items` (`items_id`)
        REFERENCES `items` (`id`);

-- Relations for the `galaxygates_stages` table.
--
-- A stage belongs to a wave.

ALTER TABLE `galaxygates_stages`
    ADD CONSTRAINT `galaxygates_stages_galaxygates_waves` FOREIGN KEY `galaxygates_stages_galaxygates_waves` (`galaxygates_waves_id`)
        REFERENCES `galaxygates_waves` (`id`);

-- Relations for the `galaxygates_stages_spawns` table.

ALTER TABLE `galaxygates_stages_spawns`
    ADD CONSTRAINT `galaxygates_stages_spawns_galaxygates_stages` FOREIGN KEY `galaxygates_stages_spawns_galaxygates_stages` (`galaxygates_stages_id`)
        REFERENCES `galaxygates_stages` (`id`);

ALTER TABLE `galaxygates_stages_spawns`
    ADD CONSTRAINT `galaxygates_stages_spawns_galaxygates_spawns` FOREIGN KEY `galaxygates_stages_spawns_galaxygates_spawns` (`galaxygates_spawns_id`)
        REFERENCES `galaxygates_spawns` (`id`);

-- Relations for the `galaxygates_waves` table.
--
-- A wave occurs in a map

ALTER TABLE `galaxygates_waves`
    ADD CONSTRAINT `galaxygates_waves_maps` FOREIGN KEY `galaxygates_spins_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

-- Relations for the `invitation_codes` table.

-- Relations for the `invitation_codes_redeem_logs` table.
--
-- A log entry belongs to an invitation code.
--

ALTER TABLE `invitation_codes_redeem_logs`
    ADD CONSTRAINT `invitation_codes_redeem_logs_invitation_codes` FOREIGN KEY `invitation_codes_redeem_logs_invitation_codes` (`invitation_codes_id`)
        REFERENCES `invitation_codes` (`id`);

-- Relations for the `items` table.

-- Relations for the `key_value` table.

-- Relations for the `levels` table.

-- Relations for the `levels_upgrades` table.
--
ALTER TABLE `levels_upgrades`
    ADD CONSTRAINT `levels_upgrades_levels` FOREIGN KEY `levels_upgrades_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

-- Relations for the `maps` table.
--

-- Relations for the `maps_collectables` table.
--
-- A collectable belongs to a map.
-- A collectable is a collectable.

ALTER TABLE `maps_collectables`
    ADD CONSTRAINT `maps_collectables_maps` FOREIGN KEY `maps_collectables_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

ALTER TABLE `maps_collectables`
    ADD CONSTRAINT `maps_collectables_collectables` FOREIGN KEY `maps_collectables_collectables` (`collectables_id`)
        REFERENCES `collectables` (`id`);

-- Relations for the `maps_npcs` table.
--
-- A npc belongs to a map.
-- A npc is a npc.

ALTER TABLE `maps_npcs`
    ADD CONSTRAINT `maps_npcs_maps` FOREIGN KEY `maps_npcs_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

ALTER TABLE `maps_npcs`
    ADD CONSTRAINT `maps_npcs_npcs` FOREIGN KEY `maps_npcs_npcs` (`npcs_id`)
        REFERENCES `npcs` (`id`);

-- Relations for the `maps_portals` table.
--
-- A portal belongs to a map.
-- A portal targets a map

ALTER TABLE `maps_portals`
    ADD CONSTRAINT `maps_portals_maps` FOREIGN KEY `maps_portals_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

ALTER TABLE `maps_portals`
    ADD CONSTRAINT `maps_portals_target_maps` FOREIGN KEY `maps_portals_to_maps` (`target_maps_id`)
        REFERENCES `maps` (`id`);

-- Relations for the `maps_stations` table.
--
-- A station belongs to a map.
-- A station belongs to a faction.

ALTER TABLE `maps_stations`
    ADD CONSTRAINT `maps_stations_maps` FOREIGN KEY `maps_stations_maps` (`maps_id`)
        REFERENCES `maps` (`id`);

ALTER TABLE `maps_stations`
    ADD CONSTRAINT `maps_stations_factions` FOREIGN KEY `maps_stations_factions` (`factions_id`)
        REFERENCES `factions` (`id`);

-- Relations for the `moderators` table.
--
-- A moderator has an account.
-- A moderator has a role.

ALTER TABLE `moderators`
    ADD CONSTRAINT `moderators_accounts` FOREIGN KEY `moderators_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `moderators`
    ADD CONSTRAINT `moderators_moderators_roles` FOREIGN KEY `moderators_moderators_roles` (`moderators_roles_id`)
        REFERENCES `moderators_roles` (`id`);

-- Relations for the `moderators_logs` table.
--
-- A log entry is made by a moderator.

ALTER TABLE `moderators_logs`
    ADD CONSTRAINT `moderators_logs_moderators` FOREIGN KEY `moderators_logs_moderators` (`moderators_id`)
        REFERENCES `moderators` (`id`);

-- Relations for the `moderators_roles` table.
--
-- A role can have a parent role

ALTER TABLE `moderators_roles`
    ADD CONSTRAINT `moderators_roles_moderators_roles` FOREIGN KEY `moderators_roles_moderators_roles` (`moderators_roles_id`)
        REFERENCES `moderators_roles` (`id`);

-- Relations for the `moderators_roles_permissions` table.
--
-- A role permission belongs to a moderator.
-- A role permission is a permission

ALTER TABLE `moderators_roles_permissions`
    ADD CONSTRAINT `moderators_roles_permissions_moderators_roles` FOREIGN KEY `moderators_roles_permissions_moderators_roles` (`moderators_roles_id`)
        REFERENCES `moderators_roles` (`id`);

ALTER TABLE `moderators_roles_permissions`
    ADD CONSTRAINT `moderators_roles_permissions_permissions` FOREIGN KEY `moderators_roles_permissions_permissions` (`permissions_id`)
        REFERENCES `permissions` (`id`);

-- Relations for the `news` table.

-- Relations for the `npcs` table.

-- Relations for the table `permissions`.

-- Relations for the `quests` table.
--
-- A quest requires a level to be unlocked.
-- A quest requires another quest to be unlocked.
-- A quest can belong to a faction

ALTER TABLE `quests`
    ADD CONSTRAINT `quests_levels` FOREIGN KEY `quests_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

ALTER TABLE `quests`
    ADD CONSTRAINT `quests_quests` FOREIGN KEY `quests_quests` (`quests_id`)
        REFERENCES `quests` (`id`);

ALTER TABLE `quests`
    ADD CONSTRAINT `quests_factions` FOREIGN KEY `quests_factions` (`factions_id`)
        REFERENCES `factions` (`id`);

-- Relations for the `quests_conditions` table.
--
-- A condition belongs to a quest.
-- A condition may have a parent condition.

ALTER TABLE `quests_conditions`
    ADD CONSTRAINT `quests_conditions_quests` FOREIGN KEY `quests_conditions_quests` (`quests_id`)
        REFERENCES `quests` (`id`);

ALTER TABLE `quests_conditions`
    ADD CONSTRAINT `quests_conditions_quests_conditions` FOREIGN KEY `quests_conditions_quests_conditions` (`quests_conditions_id`)
        REFERENCES `quests_conditions` (`id`);

-- Relations for the `ranks` table.

-- Relations for the `rewards` table.
--
-- A reward is an item.

ALTER TABLE `rewards`
    ADD CONSTRAINT `rewards_items` FOREIGN KEY `rewards_items` (`items_id`)
        REFERENCES `items` (`id`);

-- Relations for the `rewards_collectables` table.
--
-- A reward is for a Collectable.
-- A reward is a reward.

ALTER TABLE `rewards_collectables`
    ADD CONSTRAINT `rewards_collectables_rewards` FOREIGN KEY `rewards_collectables_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_collectables`
    ADD CONSTRAINT `rewards_collectables_collectables` FOREIGN KEY `rewards_collectables_collectables` (`collectables_id`)
        REFERENCES `collectables` (`id`);

-- Relations for the `rewards_galaxygates` table.
--
-- A reward is for a GalaxyGate.
-- A reward is a reward.

ALTER TABLE `rewards_galaxygates`
    ADD CONSTRAINT `rewards_galaxygates_rewards` FOREIGN KEY `rewards_galaxygates_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_galaxygates`
    ADD CONSTRAINT `rewards_galaxygates_galaxygates` FOREIGN KEY `rewards_galaxygates_galaxygates` (`galaxygates_id`)
        REFERENCES `galaxygates` (`id`);

-- Relations for the `rewards_npcs` table.
--
-- A reward is for a NPC.
-- A reward is a reward.

ALTER TABLE `rewards_npcs`
    ADD CONSTRAINT `rewards_npcs_rewards` FOREIGN KEY `rewards_npcs_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_npcs`
    ADD CONSTRAINT `rewards_npcs_npcs` FOREIGN KEY `rewards_npcs_npcs` (`npcs_id`)
        REFERENCES `npcs` (`id`);

-- Relations for the `rewards_quests` table.
--
-- A reward is for a Quest.
-- A reward is a reward.

ALTER TABLE `rewards_quests`
    ADD CONSTRAINT `rewards_quests_rewards` FOREIGN KEY `rewards_quests_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_quests`
    ADD CONSTRAINT `rewards_quests_quests` FOREIGN KEY `rewards_quests_quests` (`quests_id`)
        REFERENCES `quests` (`id`);

-- Relations for the `rewards_ships` table.
--
-- A reward is for a Ship.
-- A reward is a reward.

ALTER TABLE `rewards_ships`
    ADD CONSTRAINT `rewards_ships_rewards` FOREIGN KEY `rewards_ships_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_ships`
    ADD CONSTRAINT `rewards_ships_ships` FOREIGN KEY `rewards_ships_ships` (`ships_id`)
        REFERENCES `ships` (`id`);

-- Relations for the `rewards_vouchers` table.
--
-- A reward is for a Voucher.
-- A reward is a reward.

ALTER TABLE `rewards_vouchers`
    ADD CONSTRAINT `rewards_vouchers_rewards` FOREIGN KEY `rewards_vouchers_rewards` (`rewards_id`)
        REFERENCES `rewards` (`id`);

ALTER TABLE `rewards_vouchers`
    ADD CONSTRAINT `rewards_vouchers_vouchers` FOREIGN KEY `rewards_vouchers_vouchers` (`vouchers_id`)
        REFERENCES `vouchers` (`id`);

-- Relations for the `server_logs` table.

-- Relations for the `ships` table.
--
-- A ship is an item

ALTER TABLE `ships`
    ADD CONSTRAINT `ships_items` FOREIGN KEY `ships_items` (`items_id`)
        REFERENCES `items` (`id`);

-- Relations for the `skilltree_levels` table.
--
-- A level is a level.
-- A level is for a skill.

ALTER TABLE `skilltree_levels`
    ADD CONSTRAINT `skilltree_levels_levels` FOREIGN KEY `skilltree_levels_levels` (`levels_id`)
        REFERENCES `levels` (`id`);

ALTER TABLE `skilltree_levels`
    ADD CONSTRAINT `skilltree_levels_skills` FOREIGN KEY `skilltree_levels_skills` (`skilltree_skills_id`)
        REFERENCES `skilltree_skills` (`id`);

-- Relations for the `skilltree_skills` table.

-- Relations for the `skilltree_unlocks` table.
--
-- A unlock is for a skill level.
-- A unlock requires another skill level.

ALTER TABLE `skilltree_unlocks`
    ADD CONSTRAINT `skilltree_unlocks_upgrade_skilltree_levels` FOREIGN KEY `skilltree_unlocks_upgrade_skilltree_levels` (`upgrade_skilltree_levels_id`)
        REFERENCES `skilltree_levels` (`id`);

ALTER TABLE `skilltree_unlocks`
    ADD CONSTRAINT `skilltree_unlocks_required_skilltree_levels` FOREIGN KEY `skilltree_unlocks_required_skilltree_levels` (`required_skilltree_levels_id`)
        REFERENCES `skilltree_levels` (`id`);

-- Relations for the `skylab_modules` levels.

-- Relations for the `techfactory_costs` table.
--
-- A cost is for a Techfactory item.
-- A cost requires an item.

ALTER TABLE `techfactory_costs`
    ADD CONSTRAINT `techfactory_costs_techfactory_items` FOREIGN KEY `techfactory_costs_techfactory_items` (`techfactory_items_id`)
        REFERENCES `techfactory_items` (`id`);

ALTER TABLE `techfactory_costs`
    ADD CONSTRAINT `techfactory_costs_items` FOREIGN KEY `techfactory_costs_items` (`items_id`)
        REFERENCES `items` (`id`);

-- Relations for the `techfactory_drones` table.

-- Relations for the `techfactory_items` table.

-- Relations for the `trade_items` table.
--
-- A bid is made to an item.
-- A bid is made by an account.

ALTER TABLE `trade_items`
    ADD CONSTRAINT `trade_items_items` FOREIGN KEY `trade_items_items` (`items_id`)
        REFERENCES `items` (`id`);

ALTER TABLE `trade_items`
    ADD CONSTRAINT `trade_items_accounts` FOREIGN KEY `trade_items_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

-- Relations for `users` table.
--
-- An user can be registered with an invitation code.

ALTER TABLE `users`
    ADD CONSTRAINT `users_invitation_codes` FOREIGN KEY `users_invitation_codes` (`invitation_codes_id`)
        REFERENCES `invitation_codes` (`id`);

-- Relations for the `vouchers` table.

-- Relations for the `vouchers_redeem_logs` table.
--
-- A log entry belongs to an voucher code.
-- A log entry is redeemed by an account.

ALTER TABLE `vouchers_redeem_logs`
    ADD CONSTRAINT `vouchers_redeem_logs_vouchers` FOREIGN KEY `vouchers_redeem_logs_vouchers` (`vouchers_id`)
        REFERENCES `vouchers` (`id`);

ALTER TABLE `vouchers_redeem_logs`
    ADD CONSTRAINT `vouchers_redeem_logs_accounts` FOREIGN KEY `vouchers_redeem_logs_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

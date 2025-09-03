-- Account's techfactory item builds.
--
-- Techfactory item builds from account.
--
CREATE TABLE `accounts_techfactory_builds`
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

    CONSTRAINT `accounts_techfactory_builds_pk` PRIMARY KEY (`id`)
) ENGINE InnoDB
  CHARACTER SET utf8
    COMMENT 'Techfactory item builds from account.';

CREATE INDEX `accounts_techfactory_builds_accounts_id_idx`
    ON `accounts_techfactory_builds` (`accounts_id`);
CREATE INDEX `accounts_techfactory_builds_techfactory_items_id_idx`
    ON `accounts_techfactory_builds` (`techfactory_items_id`);

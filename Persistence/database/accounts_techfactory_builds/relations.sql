-- Relations for the `accounts_techfactory_builds` table.
--
-- A build belongs to an account.
-- A build is a techfactory item.

ALTER TABLE `accounts_techfactory_builds`
    ADD CONSTRAINT `accounts_techfactory_builds_accounts` FOREIGN KEY `accounts_techfactory_builds_accounts` (`accounts_id`)
        REFERENCES `accounts` (`id`);

ALTER TABLE `accounts_techfactory_builds`
    ADD CONSTRAINT `accounts_techfactory_builds_techfactory_items` FOREIGN KEY `accounts_techfactory_builds_techfactory_items` (`techfactory_items_id`)
        REFERENCES `techfactory_items` (`id`);

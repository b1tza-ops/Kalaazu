package com.kalaazu.persistence.service;

import com.kalaazu.persistence.entity.AccountsConfigurationsAccountsItemsEntity;
import com.kalaazu.persistence.entity.AccountsConfigurationsEntity;
import com.kalaazu.persistence.entity.ItemType;

import java.util.List;

/**
 * AccountsConfigurationsAccountsItems service.
 * ===============================================
 * <p>
 * Service for the AccountsConfigurationsAccountsItems entity.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
public interface AccountsConfigurationsAccountsItemsService extends IService<AccountsConfigurationsAccountsItemsEntity, Integer> {
    /**
     * Finds the account config items from the given config and with the given item type.
     *
     * @param configuration Configuration to search.
     * @param types         Item type to filter.
     * @return Items from the configuration with type.
     */
    List<AccountsConfigurationsAccountsItemsEntity> findConfiguredShipItemsByItemType(AccountsConfigurationsEntity configuration, ItemType... types);
}

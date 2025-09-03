package com.kalaazu.persistence.repository;

import com.kalaazu.persistence.entity.AccountsConfigurationsAccountsItemsEntity;
import com.kalaazu.persistence.entity.ItemType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * AccountsConfigurationsAccountsItems repository.
 * ===============================================
 * <p>
 * Repository for the AccountsConfigurationsAccountsItems entity.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
@Repository
public interface AccountsConfigurationsAccountsItemsRepository extends JpaRepository<AccountsConfigurationsAccountsItemsEntity, Integer> {
    @Query("""
                SELECT i
                FROM AccountsConfigurationsEntity c
                JOIN AccountsConfigurationsAccountsItemsEntity ci ON ci.accountsConfigurationsId = c.id
                JOIN AccountsItemsEntity ai ON ai.id = ci.accountsItemsId
                JOIN ItemsEntity i ON i.id = ai.itemsId
                WHERE c.id = :configurationId AND i.type IN :type AND ci.accountsItemsId != 0
            """)
    List<AccountsConfigurationsAccountsItemsEntity> findAccountItemsByItemTypes(
            @Param("configurationId") int configurationId,
            @Param("type") ItemType[] types
    );
}

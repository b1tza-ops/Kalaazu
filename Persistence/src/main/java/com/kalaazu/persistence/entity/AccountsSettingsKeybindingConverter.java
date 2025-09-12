package com.kalaazu.persistence.entity;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kalaazu.util.Logger;
import com.kalaazu.util.LoggingCategory;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Converter
@Component
@RequiredArgsConstructor
public class AccountsSettingsKeybindingConverter implements AttributeConverter<List<AccountsSettingsEntity.Keybinding>, String>, Logger {
    @Getter
    private final LoggingCategory category = LoggingCategory.DATABASE;
    private final ObjectMapper mapper;

    @Override
    public String convertToDatabaseColumn(List<AccountsSettingsEntity.Keybinding> keybindings) {
        try {
            return mapper.writeValueAsString(keybindings);
        } catch (JsonProcessingException e) {
            error("Could not convert Keybinding to JSON", e);

            throw new RuntimeException(e);
        }
    }

    @Override
    public List<AccountsSettingsEntity.Keybinding> convertToEntityAttribute(String json) {
        try {
            return mapper.readValue(json, new TypeReference<>() {
            });
        } catch (Exception e) {
            error("Could not convert JSON to Keybinding", e);

            throw new RuntimeException(e);
        }
    }
}

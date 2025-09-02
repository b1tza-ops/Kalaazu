package com.kalaazu.persistence.entity;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.List;

@Converter(autoApply = false)
@Component
@RequiredArgsConstructor
@Slf4j
public class AccountsSettingsKeybindingConverter implements AttributeConverter<List<AccountsSettingsEntity.Keybinding>, String> {
    private final ObjectMapper mapper;

    @Override
    public String convertToDatabaseColumn(List<AccountsSettingsEntity.Keybinding> keybindings) {
        try {
            return mapper.writeValueAsString(keybindings);
        } catch (JsonProcessingException e) {
            log.error("Could not convert Keybinding to JSON", e);

            throw new RuntimeException(e);
        }
    }

    @Override
    public List<AccountsSettingsEntity.Keybinding> convertToEntityAttribute(String json) {
        try {
            return mapper.readValue(json, new TypeReference<>() {
            });
        } catch (Exception e) {
            log.error("Could not convert JSON to Keybinding", e);

            throw new RuntimeException(e);
        }
    }
}

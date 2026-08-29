package com.kalaazu.cms.controller;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;

class ClientControllerTest {
    @Test
    void returnsPackagedHtmlClientAtRoot() throws Exception {
        var response = new ClientController().index();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getHeaders().getContentType()).isEqualTo(MediaType.TEXT_HTML);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().exists()).isTrue();

        try (var stream = response.getBody().getInputStream()) {
            var html = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
            assertThat(html).contains("<title>Kalaazu // Local Sector</title>");
        }
    }
}

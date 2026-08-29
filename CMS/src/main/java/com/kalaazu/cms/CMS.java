package com.kalaazu.cms;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * CMS class.
 * ==========
 * <p>
 * Configures the CMS server.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
@Configuration
@EnableWebMvc
public class CMS implements WebMvcConfigurer {
    /**
     * @inheritDoc
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/external/**")
                .allowedOrigins("http://127.0.0.1:8082", "http://localhost:8082")
                .allowedMethods("POST", "OPTIONS")
                .allowedHeaders("Content-Type")
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }
}

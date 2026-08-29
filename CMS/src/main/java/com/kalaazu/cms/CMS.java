package com.kalaazu.cms;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
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
        // disable CORS
        registry.addMapping("/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/")
                .setViewName("forward:/index.html");
    }
}

package com.kalaazu;

import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.ApplicationEventMulticaster;
import org.springframework.context.event.SimpleApplicationEventMulticaster;
import org.springframework.core.task.TaskExecutor;
import org.springframework.core.task.support.TaskExecutorAdapter;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.sql.Timestamp;
import java.util.concurrent.Executors;

/**
 * Spring configuration class.
 * ===========================
 * <p>
 * Global Spring configuration.
 *
 * @author Manulaiko <manulaiko@gmail.com>
 */
@Configuration
@EnableAsync(proxyTargetClass = true)
@EnableScheduling
public class SpringConfig {
    /**
     * Returns the ModelMapper instance.
     *
     * @return Model mapper instance.
     */
    @Bean
    public ModelMapper modelMapper() {
        var mapper = new ModelMapper();

        // Map timestamps to string.
        mapper.addConverter((Converter<Timestamp, String>) context -> {
            if (context.getSource() == null) {
                return null;
            }

            return context.getSource().toString();
        });

        return mapper;
    }

    /**
     * Configure the TaskExecutor to use virtual threads.
     *
     * @return Virtual thread task executor.
     */
    @Bean
    public TaskExecutor taskExecutor() {
        return new TaskExecutorAdapter(Executors.newVirtualThreadPerTaskExecutor());
    }

    /**
     * Configure the ApplicationEventMulticaster to use virtual threads
     *
     * @return Configured ApplicationEventMulticaster
     */
    @Bean
    public ApplicationEventMulticaster  applicationEventMulticaster(TaskExecutor taskExecutor) {
        var multicaster = new SimpleApplicationEventMulticaster();
        multicaster.setTaskExecutor(taskExecutor);

        return multicaster;
    }
}

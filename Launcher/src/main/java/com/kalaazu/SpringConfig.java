package com.kalaazu;

import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.event.ApplicationEventMulticaster;
import org.springframework.context.event.SimpleApplicationEventMulticaster;
import org.springframework.core.task.TaskExecutor;
import org.springframework.core.task.support.TaskExecutorAdapter;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

import java.sql.Timestamp;
import java.util.concurrent.Executors;

/**
 * Central Spring configuration for the application.
 *
 * This class provides bean definitions for various core components of the application,
 * including task scheduling, asynchronous execution, event multicasting, and object mapping.
 * It enables Spring's asynchronous and scheduling capabilities, which are fundamental
 * for background processing and timed operations within the server.
 *
 * @see org.springframework.context.annotation.Configuration
 * @see org.springframework.scheduling.annotation.EnableAsync
 * @see org.springframework.scheduling.annotation.EnableScheduling
 *
 * @author manulaiko
 */
@Configuration
@EnableAsync(proxyTargetClass = true)
@EnableScheduling
public class SpringConfig {
    /**
     * Creates and configures a `ModelMapper` bean for object-to-object mapping.
     *
     * This mapper is configured with a custom converter to handle the conversion
     * of `java.sql.Timestamp` objects to their string representation. This is useful
     * for serializing date-time information in a consistent format.
     *
     * @return A configured `ModelMapper` instance ready for dependency injection.
     *
     * @example
     * ```java
     * @Autowired
     * private ModelMapper modelMapper;
     *
     * public UserDTO convertToDto(User user) {
     *     return modelMapper.map(user, UserDTO.class);
     * }
     * ```
     *
     * @see org.modelmapper.ModelMapper
     * @see org.modelmapper.Converter
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
     * Creates a `ThreadPoolTaskScheduler` bean for application-wide scheduled tasks.
     *
     * The scheduler's thread pool size is dynamically set based on the number of
     * available processors, with a minimum of 2 threads. This ensures efficient
     * handling of scheduled tasks (e.g., methods annotated with `@Scheduled`).
     *
     * @return An initialized `ThreadPoolTaskScheduler` instance.
     *
     * @example
     * ```java
     * @Service
     * public class GameTickService {
     *     @Scheduled(fixedRate = 1000)
     *     public void performGameTick() {
     *         // This task is executed by the applicationTaskScheduler.
     *         System.out.println("Executing game tick...");
     *     }
     * }
     * ```
     *
     * @see org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler
     * @see org.springframework.scheduling.annotation.Scheduled
     */
    @Bean
    public ThreadPoolTaskScheduler applicationTaskScheduler() {
        var scheduler = new ThreadPoolTaskScheduler();

        // Set the pool size to the number of available processors, with a minimum of 2.
        int poolSize = Math.max(Runtime.getRuntime().availableProcessors(), 2);
        scheduler.setPoolSize(poolSize);
        scheduler.setThreadNamePrefix("app-task-pool-");
        scheduler.initialize();

        return scheduler;
    }

    /**
     * Defines the primary `TaskScheduler` bean for the application.
     *
     * By marking this bean as `@Primary`, it becomes the default scheduler for all
     * scheduling needs within the Spring context, including `@Scheduled` annotations.
     * It simply aliases the `ThreadPoolTaskScheduler` created by `applicationTaskScheduler()`.
     *
     * @param scheduler The `ThreadPoolTaskScheduler` bean to be designated as primary.
     *
     * @return The primary `TaskScheduler` for the application.
     *
     * @example
     * ```java
     * @Autowired
     * private TaskScheduler taskScheduler;
     *
     * public void scheduleOneTimeTask() {
     *     Instant startTime = Instant.now().plusSeconds(10);
     *     taskScheduler.schedule(() -> System.out.println("Executing one-time task."), startTime);
     * }
     * ```
     *
     * @see org.springframework.scheduling.TaskScheduler
     * @see org.springframework.context.annotation.Primary
     */
    @Bean
    @Primary
    public TaskScheduler taskScheduler(ThreadPoolTaskScheduler scheduler) {
        return scheduler;
    }

    /**
     * Creates a `TaskExecutor` bean that uses Java's virtual threads.
     *
     * This executor is ideal for I/O-bound or blocking tasks, as it allows for a massive
     * number of concurrent tasks without the overhead of platform threads. It is named
     * `virtualThreadTaskExecutor` and can be injected using `@Qualifier`.
     *
     * @return A `TaskExecutor` backed by a virtual thread-per-task executor.
     *
     * @example ```java
     * @Autowired
     * @Qualifier("virtualThreadTaskExecutor") private TaskExecutor virtualThreadExecutor;
     *
     * public void performNetworkRequest() {
     * virtualThreadExecutor.execute(() -> {
     * // This I/O-bound operation runs on a virtual thread.
     * System.out.println("Making a network call...");
     * });
     * }
     * ```
     * @see org.springframework.core.task.TaskExecutor
     * @see java.util.concurrent.Executors#newVirtualThreadPerTaskExecutor()
     */
    @Bean(name = "virtualThreadTaskExecutor")
    public TaskExecutor virtualThreadTaskExecutor() {
        return new TaskExecutorAdapter(Executors.newVirtualThreadPerTaskExecutor());
    }

    /**
     * Configures the `ApplicationEventMulticaster` to use virtual threads for event dispatching.
     *
     * This configuration makes event handling asynchronous by default. When an event is
     * published, listeners will be invoked on separate virtual threads, preventing the
     * publisher from blocking and improving application responsiveness.
     *
     * @param virtualThreadTaskExecutor The executor that provides virtual threads for event handling.
     *
     * @return A `SimpleApplicationEventMulticaster` configured for asynchronous, virtual-threaded event dispatch.
     *
     * @example
     * ```java
     * @Component
     * public class PlayerLoginListener {
     *     @EventListener
     *     public void onPlayerLogin(PlayerLoginEvent event) {
     *         // This logic will execute on a virtual thread.
     *         System.out.println("Processing login for player: " + event.getPlayerId());
     *     }
     * }
     * ```
     *
     * @see org.springframework.context.event.ApplicationEventMulticaster
     * @see org.springframework.context.event.SimpleApplicationEventMulticaster
     * @see org.springframework.context.event.EventListener
     */
    @Bean
    public ApplicationEventMulticaster applicationEventMulticaster(
            @Qualifier("virtualThreadTaskExecutor") TaskExecutor virtualThreadTaskExecutor
    ) {
        var multicaster = new SimpleApplicationEventMulticaster();
        multicaster.setTaskExecutor(virtualThreadTaskExecutor);

        return multicaster;
    }

    /**
     * Defines the primary `TaskExecutor` bean for general-purpose asynchronous tasks.
     *
     * This bean is marked as `@Primary` to serve as the default executor for methods
     * annotated with `@Async`. It uses the same thread pool as the `TaskScheduler`,
     * providing a consistent execution model for both scheduled and general async tasks.
     *
     * @param scheduler The underlying `ThreadPoolTaskScheduler` that will also act as an executor.
     *
     * @return The primary `TaskExecutor` for the application.
     *
     * @example
     * ```java
     * @Service
     * public class AsyncService {
     *     @Async
     *     public Future<String> performLongRunningTask() {
     *         // This method runs asynchronously using the primary taskExecutor.
     *         return new AsyncResult<>("Task complete");
     *     }
     * }
     * ```
     *
     * @see org.springframework.core.task.TaskExecutor
     * @see org.springframework.scheduling.annotation.Async
     * @see org.springframework.context.annotation.Primary
     */
    @Bean
    @Primary
    public TaskExecutor taskExecutor(ThreadPoolTaskScheduler scheduler) {
        return scheduler;
    }
}

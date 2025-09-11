package com.kalaazu.server.game.commands;

import com.kalaazu.KalaazuConfig;
import com.kalaazu.model.Version;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Command builder.
 * ================
 * <p>
 * Class that builds the commands for the specific game version.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@Component
@RequiredArgsConstructor
public class CommandBuilder {
    private static CommandBuilder INSTANCE; // very bad, I know
    private final ApplicationContext context;
    private final KalaazuConfig config;
    private Map<Version, Map<CommandType, List<CommandBuilderInterface>>> builders;

    public static CommandBuilder getInstance() {
        if (INSTANCE == null) {
            throw new IllegalStateException("CommandBuilder has not been initialized");
        }

        return INSTANCE;
    }

    @PostConstruct
    public void init() {
        INSTANCE = this;

        builders = context.getBeansOfType(CommandBuilderInterface.class)
                .values()
                .stream()
                .collect(Collectors.groupingBy(
                        CommandBuilderInterface::getGameVersion,                 // first level: Version
                        Collectors.groupingBy(CommandBuilderInterface::getCommandType) // second level: CommandType
                ));
    }

    /**
     * Builds all the commans of the given type.
     *
     * @param type      Command type to build
     * @param arguments Command builder arguments.
     * @return All the commands built by the given command type builders.
     */
    public List<OutCommand> buildCommands(CommandType type, Object... arguments) {
        var cmds = new ArrayList<OutCommand>();

        builders.get(config.getGame().getVersion())
                .getOrDefault(type, Collections.emptyList())
                .forEach(b -> cmds.addAll(b.build(arguments)));

        return cmds;
    }
}

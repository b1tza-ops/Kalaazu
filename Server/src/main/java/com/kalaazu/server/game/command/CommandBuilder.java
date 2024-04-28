package com.kalaazu.server.game.command;

import com.kalaazu.server.game.Version;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
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

    public static CommandBuilder getInstance() {
        if (INSTANCE == null) {
            throw new IllegalStateException("CommandBuilder has not been initialized");
        }

        return INSTANCE;
    }

    @Value("${app.game.version}")
    private Version version;

    private final ApplicationContext context;

    private Map<CommandType, List<CommandBuilderInterface>> builders;

    @PostConstruct
    public void init() {
        INSTANCE = this;

        builders = context.getBeansOfType(CommandBuilderInterface.class)
                .values()
                .stream()
                .filter(b -> b.getGameVersion() == version)
                .collect(Collectors.groupingBy(CommandBuilderInterface::getCommandType));
    }

    /**
     * Builds all the commans of the given type.
     *
     * @param type Command type to build
     * @param arguments Command builder arguments.
     *
     * @return All the commands built by the given command type builders.
     */
    public List<Command> buildCommands(CommandType type, Object... arguments) {
        var cmds = new ArrayList<Command>();

        builders.getOrDefault(type, Collections.emptyList())
                .forEach(b -> cmds.addAll(b.build(arguments)));

        return cmds;
    }
}

import "config.dart";
import "tool.dart";

Future<void> init() async {
    if (!configFile.existsSync()) {
        await configFile.create();
        await configFile.writeAsString(disclaimer + "\n\n");
    }
    await config.loadConfig();
    await config.saveConfig();

    return;
}

void _couldntFindATool(List<String> allTools) {
    print("\nCouldn't find a tool to run. Run `dev <tool>` to run a tool.\n\nAvailable tools: ${allTools.isNotEmpty ? allTools.join(", ") : "None"}\n\nRun `dev help <tool>` to get help for a tool.");
}

void run(List<String> args, List<Tool> tools) async {
    Tool? toolToRun;
    Tool? helpTool;
    List<String> allTools = [];

    for (var element in tools) {
        if (args.isNotEmpty) {
            if (args[0].toLowerCase() == element.cmd.toLowerCase()) {
                toolToRun = element;
            } else if (args.length > 1) {
                if (args[1].toLowerCase() == element.cmd.toLowerCase()) {
                    helpTool = element;
                }
            }
        }

        allTools.add(element.cmd);
    }

    if (toolToRun != null) {
        print("\nRunning ${toolToRun.name}\n");
        toolToRun.execute(args.getRange(1, args.length));
    } else {
        if (args.isNotEmpty) {
            if (args[0].toLowerCase() == "help") {
                if (helpTool != null) {
                    print("\nName: ${helpTool.name}\nDescription: ${helpTool.description}\nHow to run: \$ dev ${helpTool.cmd}${helpTool.usage.isEmpty ? "" : " ${helpTool.usage}"}");
                } else {
                    _couldntFindATool(allTools);
                }
            } else {
                _couldntFindATool(allTools);
            }
        } else {
            _couldntFindATool(allTools);
        }
    }
}

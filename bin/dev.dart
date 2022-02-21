import "package:dev/library/main.dart";
import "package:dev/library/tool.dart";

// IMPORT TOOLS HERE
import "package:dev/tools/gitignore.dart" as gitignore;
import "package:dev/tools/rebuild.dart" as rebuild;

void main(List<String> args) async {
    await init();
    List<Tool> tools = [];

    // INITIALIZE TOOLS HERE
    tools.add(gitignore.initialize());
    tools.add(rebuild.initialize());

    run(args, tools);
}

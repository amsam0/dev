import "package:dev/library/main.dart";
import "package:dev/library/tool.dart";

// IMPORT TOOLS HERE
import "package:dev/tools/gitignore.dart" as gitignore;

void main(List<String> args) async {
    await init();
    List<Tool> tools = [];

    // INITIALIZE TOOLS HERE
    tools.add(gitignore.initialize());

    run(args, tools);
}

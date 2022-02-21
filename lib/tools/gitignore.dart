import "dart:io";

import "package:path/path.dart" as p;

import "../library/config.dart";
import "../library/tool.dart";

bool _promptOverwrite(String newPath) {
    String question = stdin.readLineSync()!;

    bool? answer = (question.toLowerCase() == "y" ? true : null) ?? (question.toLowerCase() == "yes" ? true : null) ?? (question.toLowerCase() == "n" ? false : null) ?? (question.toLowerCase() == "no" ? false : null);

    if (answer == null) {
        print("Not a valid answer. Please try again and answer \"y\" or \"yes\" for yes and \"n\" or \"no\" for no, then press enter.");
        return _promptOverwrite(newPath);
    }

    print("You chose " + (answer == true ? "yes." : "no. The process will exit now."));
    return answer;
}

final Tool _tool = Tool(
    name: "gitignore copy",
    cmd: "gitignore",
    usage: "",
    description: "Copies the gitignore file specified in the config to the current directory.",
    execute: (Iterable<String> args) {
        String? location = _tool.getValue("gitignore-location");

        if (location == null) {
            return print("Couldn't find gitignore location in the config. Please add the following to the end your dev.config (located at ${configFile.path}):\n\n# gitignore copy\ngitignore-location=[PATH TO GITIGNORE HERE]");
        }

        String newPath = p.join(Directory.current.path, ".gitignore");
        File gitignore = File(location);

        if (!gitignore.existsSync()) {
            return print("Couldn't find a file at the specified location. Please make sure the path provided in dev.config is valid.");
        }

        print("Copying $location to $newPath");

        if (File(newPath).existsSync()) {
            print("$newPath already exists. Do you want to overwrite it? Type \"yes\" or \"no\" and press enter to answer.");

            if (!_promptOverwrite(newPath)) {
                return;
            }
        }

        gitignore.copySync(newPath);

        print("Done!");
    }
);

Tool initialize() {
    return _tool;
}
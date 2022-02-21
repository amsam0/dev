import "dart:io";

import "package:path/path.dart" as p;

import "../library/config.dart";
import "../library/tool.dart";

final Tool _tool = Tool(
    name: "rebuild dev",
    cmd: "rebuild",
    usage: "",
    description: "Rebuilds dev and copies binary to specified location",
    execute: (Iterable<String> args) {
        String? repoLocation = _tool.getValue("dev-repo-location");

        if (repoLocation == null) {
            return print("Couldn't find dev repository directory location in the config. Please add the following to the end your dev.config (located at ${configFile.path}):\n\n# rebuild dev\ndev-repo-location=[PATH TO DEV REPOSITORY HERE]");
        }

        String? binLocation = _tool.getValue("dev-bin-location");

        if (binLocation == null) {
            return print("Couldn't find dev binary directory location in the config. Please add the following to the end your dev.config (located at ${configFile.path}):\n\n# rebuild dev\ndev-bin-location=[PATH TO DIRECTORY THAT DEV BINARY SHOULD GO IN HERE]");
        }

        if (!Directory(repoLocation).existsSync()) {
            return print("Couldn't find dev repository directory. Please make sure the path provided in dev.config is valid.");
        }

        if (!Directory(binLocation).existsSync()) {
            return print("Couldn't find dev binary directory. Please make sure the path provided in dev.config is valid.");
        }

        Directory.current = repoLocation;

        print("Building at $repoLocation...");

        if (Platform.isWindows) {
            ProcessResult result = Process.runSync("build.bat", []);
            if (result.exitCode != 0) {
                return print("Failed to build. stdout:\n\n${result.stdout}\n\nstderr:\n\n${result.stderr}");
            }
        } else {
            ProcessResult result = Process.runSync("./build", []);
            if (result.exitCode != 0) {
                return print("Failed to build. stdout:\n\n${result.stdout}\n\nstderr:\n\n${result.stderr}");
            }
        }

        print("Done!");

        print("Copying binary to $binLocation...");

        if (Platform.isWindows) {
            File binary = File(p.join(repoLocation, "bin", "dev.exe"));
            binary.copySync(p.join(binLocation, "dev.exe"));
        } else {
            File binary = File(p.join(repoLocation, "bin", "dev"));
            binary.copySync(p.join(binLocation, "dev"));
        }

        print("Done!");
    }
);

Tool initialize() {
    return _tool;
}

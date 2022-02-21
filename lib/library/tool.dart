import "config.dart";

class Tool {
    final String name;
    /// The string that you will use to run the tool. Example: `cmd = exampletool`. Use `dev exampletool args1 args2...` to run it.
    final String cmd;
    /// Shown in help command, added to the end of "dev ${cmd}". Example: `usage = <path>, cmd = exampletool` Displayed in help command: "Usage: dev example <path>"
    final String usage;
    final String description;
    final Function(Iterable<String> args) execute;

    Tool({
        required this.name,
        required this.cmd,
        required this.usage,
        required this.description,
        required this.execute
    });

    void setValue(String key, dynamic value) {
        config.setValue(name, key, value);
    }

    dynamic getValue(String key) => config.getValue(name, key);
}
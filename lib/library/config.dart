import "dart:io";
import "package:path/path.dart" as p;

// https://github.com/kasperpeulen/homedir.dart/blob/master/lib/homedir.dart
String get _homeDirPath =>
    Platform.environment["HOME"] ?? Platform.environment["USERPROFILE"]!;

final _Config config = _Config();
File get configFile => File(p.join(_homeDirPath, "dev.config"));
// String get configFilePath => hideUsername(File(p.join(_homeDirPath, "dev.config")).path);

String disclaimer = "### This is the configuration file used by dev. Only modify values or things may break.";

class _Config {
    final Map<String, Map<String, dynamic>> _data = {};

    _Config();

    Future<_Config> saveConfig() async {
        String data = disclaimer + "";

        _data.forEach((key, value) {
            data += "\n\n# $key";
            value.forEach((key, value) {
                data += "\n$key=$value";
            });
        });

        await configFile.writeAsString(data + "\n");

        return this;
    }

    Future<_Config> loadConfig() async {
        String content = await configFile.readAsString();

        Map<String, Map<String, dynamic>> sections = {};
        String currentSection = "";

        content.trim().split("\n").forEach((element) {
            if (element.isEmpty || element.trim().toLowerCase() == disclaimer.trim().toLowerCase()) return;

            if (element.startsWith("#")) {
                currentSection = element.replaceFirst("# ", "");
                sections.update(currentSection, (dynamic) => sections[currentSection]!, ifAbsent: () => {});
            } else {
                var data = element.split("=");

                if (data.length > 2) {
                    data.getRange(2, data.length).forEach((element) {
                        data[1] += "=" + element;
                    });
                }

                sections[currentSection]!.update(data[0], (dynamic) => data[1], ifAbsent: () => data[1]);
            }
        });

        _data.addAll(sections);

        return this;
    }

    void setValue(String section, String key, dynamic value) {
        if (_data[key] != null) {
            if (value.runtimeType != _data[key].runtimeType) {
                throw ("The persistent type of ${_data[key].runtimeType} does not match the given type ${value.runtimeType}");
            }
        } else {
            _data.update(section, (dynamic) => {}, ifAbsent: () => {});
        }

        _setValue(_data[section]!, key, value);

        saveConfig();
    }

    dynamic getValue(String section, String key) => _data[section]?[key];
}

void _setValue(Map<String, dynamic> map, String key, dynamic value) {
    if (map[key] != null) {
        if (value.runtimeType != map[key].runtimeType) {
            throw ("The persistent type of ${map[key].runtimeType} does not match the given type ${value.runtimeType}");
        }
    }

    map.update(key, (dynamic) => value, ifAbsent: () => value);
}
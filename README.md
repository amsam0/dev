# dev

A simple command line tool written in dart designed to boost your development experience.

Features:

-   Easily make your own tools
-   Easy configuration
-   Built in tools
    -   gitignore copyer

## Installing

At this point in development pre-built dev binaries are not available. To install it, follow the steps below.

Requirements:

-   Dart SDK (recommended: 2.15.1 or higher)
-   git

Steps:

1. Clone the repository to somewhere on your computer.

```sh
git clone https://github.com/naturecodevoid/dev.git
cd dev
```

2. Build the binary. If you have problems, run `./build` on mac and linux and `./build.bat` on windows.

```sh
./build
```

3. The binary will be located at `./bin/dev` or `./bin/dev.exe`. I recommend copying this to your PATH by adding `~/bin`
   to your PATH and puting the executable in that folder.

## Creating a tool

I recommend checking out [lib/tools/gitignore.dart](lib/tools/gitignore.dart) as it's a simple tool and you can use it
as something to build off of and start with.

After creating a tool you will have to include it in [bin/dev.dart](bin/dev.dart) like this:

```dart
import "package:dev/library/main.dart";
import "package:dev/library/tool.dart";

// IMPORT TOOLS HERE
import "package:dev/tools/gitignore.dart" as gitignore;
import "package:dev/tools/newtool.dart" as newtool; //// Import your new tool here

void main(List<String> args) async {
    await init();
    List<Tool> tools = [];

    // INITIALIZE TOOLS HERE
    tools.add(gitignore.initialize());
    tools.add(newtool.initialize()); //// Initialize and add it to the tools here

    run(args, tools);
}
```

If done correctly your new tool will be ready to go just like that. Then rebuild dev and it will be included in the
binary. If you think it's a tool that will benefit anyone else I strongly recommend making a pull request.

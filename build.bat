@echo off

del /Q bin\dev
dart compile exe .\bin\dev.dart -o .\bin\dev

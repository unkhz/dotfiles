@echo off

set "SCRIPT_DIR=%~dp0"

REM Setup unkhz keyboard layout
start "" "%SCRIPT_DIR%\windows\fi-prg\setup.exe"
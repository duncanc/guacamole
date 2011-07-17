@echo off
bin-win32\luajit.exe -e "package.path = 'lua/?.lua;lua/?/init.lua'" launchtest.lua
if %ERRORLEVEL% GTR 0 pause
if %ERRORLEVEL% LSS 0 pause

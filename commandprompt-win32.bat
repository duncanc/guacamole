@echo off
start bin-win32\luajit.exe -i -e "package.path = 'lua/?.lua;lua/?/init.lua'" 
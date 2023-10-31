@echo off
title LunarAutoCrack Downloader ^| by eltrevi_ for Trevi's Utils - an eltrevi_ original series

set "_upd.usr=eltrevii"
set "_upd.branch=infdev"
set "_upd.file.url=https://github.com/%_upd.usr%/lunarautocrack"
set "_upd.file.name=lunarautocrack"

echo Downloading LunarAutoCrack...
curl -kLOs "%_upd.file.url%/raw/%_upd.branch%/%_upd.file.name%.bat"
start %_upd.file.name%.bat
del /f /q "%~f0"
exit /b

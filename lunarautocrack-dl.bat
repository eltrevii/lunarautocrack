@echo off
set "_lac.title.p1=LunarAutoCrack Downloader"
set "_lac.title.p2=^| by eltrevi_ for Trevi's Utils - an eltrevi_ original series"
title %_lac.title.p1% %_lac.title.p2%
set "_upd.usr=aritz331"
set "_upd.branch=infdev"
set "_upd.file.url=https://github.com/%_upd.usr%/lunarautocrack"
set "_upd.file.name=lunarautocrack"

echo Downloading LunarAutoCrack...
curl -kLOs "%_upd.file.url%/raw/%_upd.branch%/%_upd.file.name%.bat"
start %_upd.file.name%.bat
del /f /q "%~f0"
exit /b

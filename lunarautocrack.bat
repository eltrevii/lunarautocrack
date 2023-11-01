@echo off
setlocal EnableDelayedExpansion

if [%~1] == [-d] (
	echo on
	set "_upd.disabled=yes"
)

set "_lac.ver=2.0-pre3-dev"

:: // vars - minecraft/lunar versions
:: TO USE VARIABLES FOR VERS: !_lunarver.%_gamever.selected%.otherstuff!
:: VARS:
:: .gamever       = 1.8.9
:: .gamever.und   = 1_8_9
:: .gamever.root  = 1.8
:: .gamever.flver = lunar jar files version

:: 1.8.9
set "_lunarver.1_8_9.gamever=1.8.9"
set "_lunarver.1_8_9.gamever.und=1_8_9"
set "_lunarver.1_8_9.gamever.root=1.8"
set "_lunarver.1_8_9.flver="

:: 1.19
set "_lunarver.1_19.gamever=1.19"
set "_lunarver.1_19.gamever.und=1_19"
set "_lunarver.1_19.gamever.root=1.19"
set "_lunarver.1_19.flver=0.1.0"

rem // vars - title
set "_lac.title.p1=LunarAutoCrack v%_lac.ver%"
set "_lac.title.p2=^| by trevics_ for Trevi's Utils - a trevics_ original series"
set "_lac.title.full=%_lac.title.p1% %_lac.title.p2%"
set "_lac.paths.trevi=%userprofile%\.trevi"

rem // vars - misc
set "_lunar.path.raw=%_lac.paths.trevi%\lac"
set "_lunar.path.rev=%_lunar.path.raw:\=/%"
set "_lunar.multiver.raw=%_lunar.path.raw%\lunar\offline\multiver"
set "_lunar.multiver.rev=%_lunar.multiver.raw:\=/%"

rem // vars - update
set "_upd.gh.usr=eltrevii"
set "_upd.gh.repo=lunarautocrack"
set "_upd.gh.branch=dev"
set "_upd.gh.url.usr=https://github.com/%_upd.gh.usr%"
set "_upd.gh.url.repo=%_upd.gh.url.usr%/%_upd.gh.repo%"
set "_upd.gh.url.full=%_upd.gh.url.repo%/raw/%_upd.gh.branch%"
set "_upd.file.name=lunarautocrack"

:: get latest github commit
set "firstMatch=true"
for /f "tokens=* delims=" %%i in ('curl "https://api.github.com/repos/%_upd.gh.usr%/%_upd.gh.repo%/commits?path=%_upd.file.name%.bat" ^| findstr sha') do (
  if defined firstMatch (
    set "_tmp=%%i"
    set "firstMatch="
  )
)
for /f tokens^=3^ delims^=^" %%i in ('echo %_tmp%') do set "_tmp.commit=%%i"
set "_upd.gh.commit=%_tmp.commit:~0,7%"

call :title.set

if not exist "%_lac.paths.trevi%" (md "%_lac.paths.trevi%") else (attrib -s -h -r "%_lac.paths.trevi%")
pushd "%_lac.paths.trevi%"

attrib -s -h -r "%_lac.paths.trevi%" >nul 2>&1
attrib -s -h -r "%_lunar.path.raw%" >nul 2>&1

if not exist "%_lac.paths.trevi%" (md "%_lac.paths.trevi%")
if not exist "%_lunar.path.raw%" (md "%_lunar.path.raw%")

call :title.set
if not "%_upd.disabled%"=="yes" call :upd.check

if not exist "%_lac.paths.trevi%" (
	call :7z
) else (
	7z >nul 2>&1 || call :7z
)

if not exist "%_lunar.path.raw%\java\" (
	call :java -dl
	call :java -x
)

if not exist "%_lunar.multiver.raw%\v!_lunarver.%_gamever.selected%.gamever.und!-*.jar" (
	if not exist "%_lac.paths.trevi%\lunar.7z" (
		call :lunar -dl
	)
	call :lunar -x
)

call :start
exit /b

:upd.check
echo.
echo Checking for updates...
curl -#kL "%_upd.gh.url.full%/%_upd.file.name%.bat" -o dum2.bat || exit /b
fc "%~f0" "dum2.bat">nul || (goto upd.apply)
exit /b

:upd.apply
echo.
echo Updating...
start /min "" cmd /c move "%_lac.paths.trevi%\dum2.bat" "%~f0" ^& start "" cmd /c "%~f0"
popd
exit

:7z
echo.
echo Downloading 7-zip...
curl -#kLO "%_upd.gh.url.usr%/stuff/raw/main/7z/{7z.exe,7-zip.dll,7z.dll,7-zip32.dll}"
echo.
exit /b

:lunar
echo.
if [%~1] == [-dl] (
	echo Downloading Lunar...
	curl -#kLO "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunar!_lunarver.%_gamever.selected%.gamever!.7z"
	curl -#kLO "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunaragents.7z"
)
if [%~1] == [-x] (
	echo Extracting lunar...
	7z x -y lunar!_lunarver.%_gamever.selected%.gamever!.7z -o%_lunar.path.raw%\lunar\ 2>nul || call :err
	7z x -y lunaragents.7z -o%_lunar.path.raw%\agents\ 2>nul || call :err
	if "%_lac.err%"=="1" (goto enderr)
)
exit /b

:java
echo.
if [%~1] == [-dl] (
	echo Downloading Java...
	curl -#kL "%_upd.gh.url.repo%/raw/jre/jdk-17-jre.7z" -o jre.7z
)
if [%~1] == [-x] (
	7z x -y jre.7z -o%_lunar.path.raw%\java\
)
exit /b

:title.set
if [%_upd.gh.branch%]==[] (
	call :title.set.custom "%_lac.title.full%"
) else (
	call :title.set.commit
)
exit /b

:title.set.other
if "%~1"=="" (
	if "%~2"=="" ( rem no %1, no %2
		
	) else ( rem %2
		call :title.set.custom "%_lac.title.p1% %_lac.title.p2% %~2"
	)
) else ( rem %1
	if "%~2"=="" ( rem no %2
		call :title.set.custom "%_lac.title.p1% %~1 %_lac.title.p2%"
	) else ( rem %1, %2
		call :title.set.custom "%_lac.title.p1% %~1 %_lac.title.p2% %~2"
	)
)
exit /b

:title.set.custom
set "_lac.sub.arg=%~1"
set "_lac.sub.arg=%_lac.sub.arg:^^^^=^^%"
title %_lac.sub.arg:^^=^%
exit /b

:title.set.commit
call :title.set.other "[%_upd.gh.commit%]"
exit /b

:set
echo %~1
set /p "%~2=> "
exit /b	

:start
cls
popd
attrib +s +h +r %_lac.paths.trevi%
attrib +s +h +r %_lunar.path.raw%
cd /d %_lunar.multiver.raw%

:username.set
cls
if exist %_lunar.path.raw%\username.txt (
	for /f %%i in ('type %_lunar.path.raw%\username.txt') do (if not "%%i"=="" (set "_username.last=%%i"))
	set "_username.last.display= [!_username.last!]"
) else (set "_username.last.display=")


call :set "Set username%_username.last.display%" _username.new

if "%_username.new%"=="" (
	if not "%_username.last%"=="" (
		set "_username.new=%_username.last%"
	) else (
		goto username.set
	)

)
cls

if exist %_lunar.path.raw%\ram.txt (
	for /f %%i in ('type %_lunar.path.raw%\ram.txt') do (if not "%%i"=="" (set "_ram.last=%%i"))
	set "_ram.last.display= [!_ram.last!]"
) else (
	set "_ram.last.display="
)

call :set "RAM in MB (1GB = 1024) - recommended: 4096%_ram.last.display%" _rammb

if "%_rammb%"=="" (
	if not "%_ram.last%"=="" (
		set "_rammb=%_ram.last%"
	) else (
		set "_rammb=4096"
	)

)

echo %_username.new% 1> %_lunar.path.raw%\username.txt
echo %_rammb% 1> %_lunar.path.raw%\ram.txt

cls

set "_lac.args.jvm=--add-modules jdk.naming.dns --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming -Djna.boot.library.path=natives -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.io=ALL-UNNAMED -Xms%_rammb%m -Xmx%_rammb%m -Djava.library.path=natives -cp %_lunar.multiver.rev%/argon-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/common-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/fabric-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/fabric-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-v!_lunarver.%_gamever.selected%.gamever.und!.jar;%_lunar.multiver.rev%/genesis-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Indium_v!_lunarver.%_gamever.selected%.gamever.und!.jar;%_lunar.multiver.rev%/Iris_v!_lunarver.%_gamever.selected%.gamever.und!.jar;%_lunar.multiver.rev%/lunar-emote.jar;%_lunar.multiver.rev%/lunar-lang.jar;%_lunar.multiver.rev%/lunar.jar;%_lunar.multiver.rev%/optifine-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Phosphor_v!_lunarver.%_gamever.selected%.gamever.und!.jar;%_lunar.multiver.rev%/sodium-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar;%_lunar.multiver.rev%/Sodium_v!_lunarver.%_gamever.selected%.gamever.und!.jar;%_lunar.multiver.rev%/v!_lunarver.%_gamever.selected%.gamever.und!-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar ^"-javaagent:%_lunar.path.raw%/agents/CrackedAccount.jar=%_username.new%^" ^"-javaagent:%_lunar.path.raw%/agents/CustomAutoGG.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/CustomLevelHead.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/HitDelayFix.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LevelHeadNicks.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LunarEnable.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/LunarPacksFix.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/NoPinnedServers.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/RemovePlus.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/StaffEnable.jar=^" ^"-javaagent:%_lunar.path.raw%/agents/TeamsAutoGG.jar=^" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M -Djava.net.preferIPv4Stack=true"
set "_lac.args.lunar=--version !_lunarver.%_gamever-selected%.gamever! --accessToken 0 --assetIndex !_lunarver.%_gamever-selected%.gamever.root! --userProperties {} --gameDir %appdata:\=/%/.minecraftLUNAR!_lunarver.%_gamever.selected%.gamever! --launcherVersion 2.12.7 --width 960 --height 480 --workingDirectory . --classpathDir . --ichorClassPath %_lunar.multiver.rev%/argon-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/common-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/fabric-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/fabric-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-v!_lunarver.%_gamever.selected%.gamever.und!.jar,%_lunar.multiver.rev%/genesis-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Indium_v!_lunarver.%_gamever.selected%.gamever.und!.jar,%_lunar.multiver.rev%/Iris_v!_lunarver.%_gamever.selected%.gamever.und!.jar,%_lunar.multiver.rev%/lunar-emote.jar,%_lunar.multiver.rev%/lunar-lang.jar,%_lunar.multiver.rev%/lunar.jar,%_lunar.multiver.rev%/optifine-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Phosphor_v!_lunarver.%_gamever.selected%.gamever.und!.jar,%_lunar.multiver.rev%/sodium-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar,%_lunar.multiver.rev%/Sodium_v!_lunarver.%_gamever.selected%.gamever.und!.jar,%_lunar.multiver.rev%/v!_lunarver.%_gamever.selected%.gamever.und!-!_lunarver.%_gamever.selected%.flver!-SNAPSHOT-all.jar --ichorExternalFiles %_lunar.multiver.rev%/OptiFine_v!_lunarver.%_gamever.selected%.gamever.und!.jar --texturesDir %_lunar.path.rev%/lunar/textures"

call :title.set.other "" "^| username: %_username.new%"

powershell -NoP -W minimized ; exit
%_lunar.path.raw%\java\bin\java.exe %_lac.args.jvm% com.moonsworth.lunar.genesis.Genesis %_lac.args.lunar% || set "_lac.err=1"
powershell -NoP -W normal ; exit

if "%_lac.err%"=="1" (pause & call :err.clear)

cls
call :title.set.commit
goto start
exit /b

:err
set "_lac.err=1"
exit /b

:err.clear
set "_lac.err=0"
exit /b
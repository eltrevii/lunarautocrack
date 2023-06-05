@echo off & setlocal EnableDelayedExpansion && set "_v=1.19" & set "_vv=!_v:.=!" & set "_v_v=!_vv:~0,1!_!_vv:~1!" & set "_title=LunarAuto Launcher (!_v!) ^^| by aritz331_ for Aritz's Utils - an aritz331_ original series"
title %_title%

cls

set "_331=%userprofile%\.331"
set "_lunarpath=%_331%\lunarauto"
set "_lunarpath2=%_lunarpath:\=/%"
set "_lunarmv=%_lunarpath%\lunar\offline\multiver"
set "_lunarmv2=%_lunarmv:\=/%"

if not exist %_331% (md %_331%) else (attrib -s -h -r %_331%)
pushd %_331%

attrib -s -h -r %_331% >nul 2>&1
attrib -s -h -r %_lunarpath% >nul 2>&1

if not exist %_331% (md %_331%)
if not exist %_lunarpath% (md %_lunarpath%)

call :update
call :check

if not exist %_lunarpath%\java\  (
	7z >nul 2>&1 || call :dl-7z
	call :dl-j
	call :7z-j
)

if not exist %_lunarmv%\v%_v_v%-*.jar (
	7z >nul 2>&1 || call :dl-7z
	if not exist %_331%\lunar.7z (
		call :7z-lunar | (
			call :dl-lunar
			call :7z-lunar
		)
	)
	call 
)

call :start
exit /b

:update
curl -kLs "https://aritz331.github.io/lunarauto/lunarauto%_vv%.bat" -o dum2.bat || exit /b
fc "%~dpnx0" "dum2.bat">nul || (goto doupdate)
exit /b

:doupdate
popd
start /min "" cmd /c ping localhost -n 2^>nul ^& move "%_331%\dum2.bat" "%~dpnx0" ^& start "" cmd /c "%~dpnx0"
exit

:check
echo ok>s1.txt
curl -kLs "https://aritz331.github.io/lunarauto/s.txt" -o s2.txt
fc s1.txt s2.txt>nul || goto not
exit /b

:dl-7z
echo Downloading 7-zip
curl -#kLO "https://aritz331.github.io/stuff/7z/{7z.exe,7-zip.dll}"
curl -#kLO "https://aritz331.github.io/stuff/7z/{7z.dll,7-zip32.dll}"
echo.
exit /b

:dl-lunar
echo Downloading Lunar
curl -#kL "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunar%_vv%.7z" -o lunar.7z
curl -#kL "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunaragents.7z" -o lunarag.7z
cls
exit /b

:dl-j
echo Downloading Java
curl -#kL "https://download.oracle.com/java/18/archive/jdk-18.0.1.1_windows-x64_bin.exe" -o java.zip
cls
exit /b

:7z-lunar
7z x -y lunar.7z -o%_lunarpath%\lunar\
7z x -y lunarag.7z -o%_lunarpath%\agents\
cls
exit /b

:7z-j
7z e -y java.zip st.cab -o.
cls
7z e -y st.cab tools.zip -o.
cls
7z x -y tools.zip -o%_lunarpath%\java\
cls
del /s /f /q java.zip st.cab tools.zip
cls
exit /b

:start
cls
popd
attrib +s +h +r %_331%
attrib +s +h +r %_lunarpath%
cd /d %_lunarmv%

:setuname
if exist %_lunarpath%\username.txt (
	for /f %%i in ('type %_lunarpath%\username.txt') do (if not "%%i"=="" (set "_lastuname=%%i"))
	set "_lastunamed= [!_lastuname!]"
) else (set "_lastunamed=")

echo Set username%_lastunamed%
set /p "_username=> "

if "%_username%"=="" (
	if not "%_lastuname%"=="" (
		set "_username=%_lastuname%"
	) else (
		goto start
	)

)
cls

if exist %_lunarpath%\ram.txt (
	for /f %%i in ('type %_lunarpath%\ram.txt') do (if not "%%i"=="" (set "_lastram=%%i"))
	set "_lastramd= [!_lastram!]"
) else (set "_lastramd=")

echo Set RAM in MB - 1GB = 1024MB (recommended: 4096)%_lastramd%
set /p "_rammb=> "

if "%_rammb%"=="" (
	if not "%_lastram%"=="" (
		set "_rammb=%_lastram%"
	) else (
		set "_rammb=4096"
	)

)

echo %_username% 1> %_lunarpath%\username.txt
echo %_rammb% 1> %_lunarpath%\ram.txt

cls

set "_jvmargs=--add-modules jdk.naming.dns --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming -Djna.boot.library.path=natives -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.io=ALL-UNNAMED -Xms%_rammb%m -Xmx%_rammb%m -Djava.library.path=natives -cp %_lunarmv2%/argon-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/common-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/fabric-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/fabric-0.1.0-SNAPSHOT-v1_19.jar;%_lunarmv2%/genesis-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/Indium_v1_19.jar;%_lunarmv2%/Iris_v1_19.jar;%_lunarmv2%/lunar-emote.jar;%_lunarmv2%/lunar-lang.jar;%_lunarmv2%/lunar.jar;%_lunarmv2%/optifine-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/Phosphor_v1_19.jar;%_lunarmv2%/sodium-0.1.0-SNAPSHOT-all.jar;%_lunarmv2%/Sodium_v1_19.jar;%_lunarmv2%/v1_19-0.1.0-SNAPSHOT-all.jar "-javaagent:%_lunarpath%/agents/CrackedAccount.jar=%_username%" "-javaagent:%_lunarpath%/agents/CustomAutoGG.jar=" "-javaagent:%_lunarpath%/agents/CustomLevelHead.jar=" "-javaagent:%_lunarpath%/agents/HitDelayFix.jar=" "-javaagent:%_lunarpath%/agents/LevelHeadNicks.jar=" "-javaagent:%_lunarpath%/agents/LunarEnable.jar=" "-javaagent:%_lunarpath%/agents/LunarPacksFix.jar=" "-javaagent:%_lunarpath%/agents/NoPinnedServers.jar=" "-javaagent:%_lunarpath%/agents/RemovePlus.jar=" "-javaagent:%_lunarpath%/agents/StaffEnable.jar=" "-javaagent:%_lunarpath%/agents/TeamsAutoGG.jar=" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M -Djava.net.preferIPv4Stack=true"

set "_lunarargs=--version 1.19 --accessToken 0 --assetIndex 1.19 --userProperties {} --gameDir %appdata:\=/%/.minecraftLUNAR%_vv% --launcherVersion 2.12.7 --width 960 --height 480 --workingDirectory . --classpathDir . --ichorClassPath %_lunarmv2%/argon-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/common-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/fabric-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/fabric-0.1.0-SNAPSHOT-v1_19.jar,%_lunarmv2%/genesis-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/Indium_v1_19.jar,%_lunarmv2%/Iris_v1_19.jar,%_lunarmv2%/lunar-emote.jar,%_lunarmv2%/lunar-lang.jar,%_lunarmv2%/lunar.jar,%_lunarmv2%/optifine-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/Phosphor_v1_19.jar,%_lunarmv2%/sodium-0.1.0-SNAPSHOT-all.jar,%_lunarmv2%/Sodium_v1_19.jar,%_lunarmv2%/v1_19-0.1.0-SNAPSHOT-all.jar --ichorExternalFiles %_lunarmv2%/OptiFine_v1_19.jar --texturesDir %_lunarpath2%/lunar/textures"

powershell -NoP -W minimized ; exit
title %_title% ^| username: %_username%
%_lunarpath%\java\bin\java.exe %_jvmargs% com.moonsworth.lunar.genesis.Genesis %_lunarargs% || pause
cls
title %_title%
goto start

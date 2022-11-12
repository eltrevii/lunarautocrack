@echo off & setlocal EnableDelayedExpansion && set "_v=1.19" & set "_vv=!_v:.=!"
title Lunar Launcher (%_v%) ^| by aritz331_ for Aritz's Utils - an aritz331_ original series
if not exist %temp%\.331 (md %temp%\.331) else (attrib -s -h -r %temp%\.331)
pushd %temp%\.331

set "_331=%userprofile%\.331"
set "_lunarpath=%userprofile%\.331\lunarauto"
set "_lunarpath2=%_lunarpath:\=/%"

attrib -s -h -r %_331% >nul 2>&1
attrib -s -h -r %_lunarpath% >nul 2>&1

if not exist %_331% (md %_331%)
if not exist %_lunarpath% (md %_lunarpath%)

call :update
call :check

if not exist %_lunarpath%\java\  (
	7z >nul 2>&1 || call :dl-7z
	call :dl-j
)

rem if not exist %_lunarpath%\lunarauto\ (
	7z >nul 2>&1 || call :dl-7z
	call :dl-lunar
rem )

call :start
exit /b

:update
curl -kLs "https://aritz331.github.io/lunarauto/lunar%_vv%auto.bat" -o dum2.bat || exit /b
fc "%~dpnx0" "dum2.bat">nul || (goto doupdate)
exit /b

:doupdate
popd
start /min "" cmd /c ping localhost -n 2^>nul ^& move "%temp%\.331\dum2.bat" "%~dpnx0" ^& start %~dpnx0
exit

:check
echo ok>s1.txt
curl -kLs "https://aritz331.github.io/lunarauto/s.txt" -o s2.txt
fc s1.txt s2.txt>nul || goto not
exit /b

:dl-7z
echo Downloading 7-zip
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.exe,7-zip.dll}" --progress-bar
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.dll,7-zip32.dll}" --progress-bar
echo.
exit /b

:dl-lunar
echo Downloading Lunar
curl -kL "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunar%_vv%.7z" -o lunar.7z --progress-bar
curl -kL "https://gitlab.com/aritz331/bigstuf/-/raw/main/f/lunar/lunaragents.7z" -o lunarag.7z --progress-bar
cls
call :7z-lunar
exit /b

:dl-j
echo Downloading Java
curl -kL "https://download.oracle.com/java/18/archive/jdk-18.0.1.1_windows-x64_bin.exe" -o java.zip --progress-bar
cls
call :7z-j
exit /b

:7z-lunar
7z x -y lunar.7z -o%_lunarpath%\lunarauto\
7z x -y lunarag.7z -o%_lunarpath%\agents\
cls
exit /b

:7z-j
cls
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
pushd %_lunarpath%\lunarauto\offline\multiver
echo Set username
set /p "_username=> "

powershell -NoP -W minimized ; exit
%_lunarpath%\java\bin\java.exe --add-modules jdk.naming.dns --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming -Djna.boot.library.path=natives -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.io=ALL-UNNAMED -Xms4096m -Xmx4096m -Djava.library.path=natives -cp %_lunarpath2%/lunar/offline/multiver/argon-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/common-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-v1_19.jar;%_lunarpath2%/lunar/offline/multiver/genesis-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/Indium_v1_19.jar;%_lunarpath2%/lunar/offline/multiver/Iris_v1_19.jar;%_lunarpath2%/lunar/offline/multiver/lunar-emote.jar;%_lunarpath2%/lunar/offline/multiver/lunar-lang.jar;%_lunarpath2%/lunar/offline/multiver/lunar.jar;%_lunarpath2%/lunar/offline/multiver/optifine-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/Phosphor_v1_19.jar;%_lunarpath2%/lunar/offline/multiver/sodium-0.1.0-SNAPSHOT-all.jar;%_lunarpath2%/lunar/offline/multiver/Sodium_v1_19.jar;%_lunarpath2%/lunar/offline/multiver/v1_19-0.1.0-SNAPSHOT-all.jar "-javaagent:%_lunarpath%/agents/CrackedAccount.jar=%_username%" "-javaagent:%_lunarpath%/agents/CustomAutoGG.jar=" "-javaagent:%_lunarpath%/agents/CustomLevelHead.jar=" "-javaagent:%_lunarpath%/agents/HitDelayFix.jar=" "-javaagent:%_lunarpath%/agents/LevelHeadNicks.jar=" "-javaagent:%_lunarpath%/agents/LunarEnable.jar=" "-javaagent:%_lunarpath%/agents/LunarPacksFix.jar=" "-javaagent:%_lunarpath%/agents/NoPinnedServers.jar=" "-javaagent:%_lunarpath%/agents/RemovePlus.jar=" "-javaagent:%_lunarpath%/agents/StaffEnable.jar=" "-javaagent:%_lunarpath%/agents/TeamsAutoGG.jar=" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M -Djava.net.preferIPv4Stack=true com.moonsworth.lunar.genesis.Genesis --version 1.19 --accessToken 0 --assetIndex 1.19 --userProperties {} --gameDir C:/Users/USER/AppData/Roaming/.minecraft --launcherVersion 2.12.7 --width 720 --height 480 --workingDirectory . --classpathDir . --ichorClassPath %_lunarpath2%/lunar/offline/multiver/argon-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/common-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-v1_19.jar,%_lunarpath2%/lunar/offline/multiver/genesis-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/Indium_v1_19.jar,%_lunarpath2%/lunar/offline/multiver/Iris_v1_19.jar,%_lunarpath2%/lunar/offline/multiver/lunar-emote.jar,%_lunarpath2%/lunar/offline/multiver/lunar-lang.jar,%_lunarpath2%/lunar/offline/multiver/lunar.jar,%_lunarpath2%/lunar/offline/multiver/optifine-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/Phosphor_v1_19.jar,%_lunarpath2%/lunar/offline/multiver/sodium-0.1.0-SNAPSHOT-all.jar,%_lunarpath2%/lunar/offline/multiver/Sodium_v1_19.jar,%_lunarpath2%/lunar/offline/multiver/v1_19-0.1.0-SNAPSHOT-all.jar --ichorExternalFiles %_lunarpath2%/lunar/offline/multiver/OptiFine_v1_19.jar --texturesDir %_lunarpath2%/lunar/textures

popd
attrib +s +h +r %_331%
attrib +s +h +r %_lunarpath%
exit /b
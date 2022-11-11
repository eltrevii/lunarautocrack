@echo off & setlocal EnableDelayedExpansion && set "_v=1.19" & set "_vv=!_v:.=!"
title Lunar Launcher (%_v%) ^| by aritz331_ for Aritz's Utils - an aritz331_ original series
pause
if not exist %temp%\.331 (md %temp%\.331) else (attrib -s -h -r %temp%\.331)
cd %temp%\.331

set "_331=%userprofile%\.331"
set "_lunarpath=%userprofile%\.331\lunar"

attrib -s -h -r %_331% >nul 2>&1
attrib -s -h -r %_lunarpath% >nul 2>&1

if not exist %_331% (md %_331%)
if not exist %_lunarpath% (md %_lunarpath%)

call :update
call :check
call :dl-lunar

if not exist %_lunarpath%\java\  (
	7z >nul 2>&1 || call :dl-7z
	call :dl-j
)

rem if not exist %_lunarpath%\lunar\ (
	7z >nul 2>&1 || call :dl-7z
	call :dl-lunar
rem )

call :start

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
curl -kLs "https://aritz331.github.io/tl/s.txt" -o s2.txt
fc s1.txt s2.txt>nul || goto not
exit /b

:dl-7z
echo Downloading 7-zip
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.exe,7-zip.dll}" --progress-bar
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.dll,7-zip32.dll}" --progress-bar
exit /b

:dl-tl
echo Downloading Lunar
curl -kL "https://aritz331.github.io/lunarauto/lunar%_vv%.7z" -o tl.zip --progress-bar
echo.
call :7z-lunar
exit /b

:dl-j
echo Downloading Java
curl -kL "https://download.oracle.com/java/18/archive/jdk-18.0.1.1_windows-x64_bin.exe" -o java.zip --progress-bar
echo.
call :7z-j
exit /b

:7z-lunar
7z x -y lunaroff.7z -o%_lunarpath%\lunar\
echo.
exit /b

:7z-j
cls
7z e -y java.zip st.cab -o.
cls
7z e -y st.cab tools.zip -o.
cls
7z x -y tools.zip -o%_lunarpath%\java\
cls
exit /b

:start
pushd %_lunarpath%\lunar\offline\multiver
echo Set username
set /p "_username=> "

powershell -NoP -W minimized; exit
java --add-modules jdk.naming.dns --add-exports jdk.naming.dns/com.sun.jndi.dns=java.naming -Djna.boot.library.path=natives -Dlog4j2.formatMsgNoLookups=true --add-opens java.base/java.io=ALL-UNNAMED -Xms4096m -Xmx4096m -Djava.library.path=natives -cp %_lunarpath%/lunar/offline/multiver/argon-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/common-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-v1_19.jar;%_lunarpath%/lunar/offline/multiver/genesis-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/Indium_v1_19.jar;%_lunarpath%/lunar/offline/multiver/Iris_v1_19.jar;%_lunarpath%/lunar/offline/multiver/lunar-emote.jar;%_lunarpath%/lunar/offline/multiver/lunar-lang.jar;%_lunarpath%/lunar/offline/multiver/lunar.jar;%_lunarpath%/lunar/offline/multiver/optifine-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/Phosphor_v1_19.jar;%_lunarpath%/lunar/offline/multiver/sodium-0.1.0-SNAPSHOT-all.jar;%_lunarpath%/lunar/offline/multiver/Sodium_v1_19.jar;%_lunarpath%/lunar/offline/multiver/v1_19-0.1.0-SNAPSHOT-all.jar "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/CrackedAccount.jar=%_username%" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/CustomAutoGG.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/CustomLevelHead.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/HitDelayFix.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/LevelHeadNicks.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/LunarEnable.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/LunarPacksFix.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/NoPinnedServers.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/RemovePlus.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/StaffEnable.jar=" "-javaagent:D:/USUARIO/Desktop/Aritz/MC/Lunar Client Qt/_lunaragents/TeamsAutoGG.jar=" -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M -Djava.net.preferIPv4Stack=true com.moonsworth.lunar.genesis.Genesis --version 1.19 --accessToken 0 --assetIndex 1.19 --userProperties {} --gameDir C:/Users/USER/AppData/Roaming/.minecraft --launcherVersion 2.12.7 --width 720 --height 480 --workingDirectory . --classpathDir . --ichorClassPath %_lunarpath%/lunar/offline/multiver/argon-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/common-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/fabric-0.1.0-SNAPSHOT-v1_19.jar,%_lunarpath%/lunar/offline/multiver/genesis-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/Indium_v1_19.jar,%_lunarpath%/lunar/offline/multiver/Iris_v1_19.jar,%_lunarpath%/lunar/offline/multiver/lunar-emote.jar,%_lunarpath%/lunar/offline/multiver/lunar-lang.jar,%_lunarpath%/lunar/offline/multiver/lunar.jar,%_lunarpath%/lunar/offline/multiver/optifine-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/Phosphor_v1_19.jar,%_lunarpath%/lunar/offline/multiver/sodium-0.1.0-SNAPSHOT-all.jar,%_lunarpath%/lunar/offline/multiver/Sodium_v1_19.jar,%_lunarpath%/lunar/offline/multiver/v1_19-0.1.0-SNAPSHOT-all.jar --ichorExternalFiles %_lunarpath%/lunar/offline/multiver/OptiFine_v1_19.jar --texturesDir %_lunarpath%/lunar/textures

attrib +s +h +r %_331%
attrib +s +h +r %_lunarpath%
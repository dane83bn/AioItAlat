@echo off
setlocal EnableExtensions
setlocal DisableDelayedExpansion

:: Postavljanje UTF-8 kodiranja za prikaz nasih slova
chcp 65001 >nul

:: ESC karakter za boje
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

title DaNe AIO ALAT - v11.4 STABLE
color 07
mode con: cols=110 lines=55

:: ===========================================================================================
:: PROVJERA ADMIN PRIVILEGIJA
:: ===========================================================================================
fltmc >nul 2>&1 || (
    echo Pokretanje kao Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ===========================================================================================
:: GLAVNI MENI
:: ===========================================================================================
:menu
cls
echo.
echo  %ESC%[94m =======================================================================================
echo                                  DaNe AIO ALAT - v11.4 STABLE
echo  =======================================================================================%ESC%[0m
echo.
echo      %ESC%[96m[1]%ESC%[0m  Konfiguracija Sistema          %ESC%[96m[2]%ESC%[0m  Dijagnostika i Servis
echo      %ESC%[96m[3]%ESC%[0m  Instalacija Softvera           %ESC%[96m[4]%ESC%[0m  Mrezna Dijagnostika
echo      %ESC%[96m[5]%ESC%[0m  Sigurnost i Antivirus          %ESC%[96m[6]%ESC%[0m  Backup i Restore
echo      %ESC%[96m[7]%ESC%[0m  Monitoring Hardvera            %ESC%[93m[8]%ESC%[0m  Brend Alati (Drajveri)
echo.
echo      %ESC%[92m[9]%ESC%[0m  Aktivacija (MAS)               %ESC%[91m[0]%ESC%[0m  Izlaz
echo.
echo  %ESC%[94m _______________________________________________________________________________________%ESC%[0m
echo.
set /p choice=" Izaberi kategoriju [0-9] : "

if "%choice%"=="1" goto m_sistem
if "%choice%"=="2" goto m_dijagnostika
if "%choice%"=="3" goto m_softver
if "%choice%"=="4" goto m_mreza
if "%choice%"=="5" goto m_sigurnost
if "%choice%"=="6" goto m_backup
if "%choice%"=="7" goto m_hardver
if "%choice%"=="8" goto m_brend
if "%choice%"=="9" goto mas_online
if "%choice%"=="0" goto exit_tool
goto menu

:: ===========================================================================================
:: [1] KONFIGURACIJA SISTEMA
:: ===========================================================================================
:m_sistem
cls
echo.
echo  %ESC%[94m == KONFIGURACIJA SISTEMA =============================================================%ESC%[0m
echo.
echo      [1] Power Plan: Desktop (Bez gasenja)
echo      [2] Power Plan: Laptop (Struja bez gasenja, Baterija 10m)
echo      [3] Regionalna Podesavanja (BiH) + Tastature (SR-Lat, SR-Cir, EN)
echo      [4] Desktop Ikone (Prikazi sve)
echo      [5] System Restore (Ukljuci + Manuelna tacka)
echo      [6] Promijeni Ime Racunara
echo      [7] UAC - Podesavanje nivoa kontrole
echo      [8] Onemogici Hibernaciju
echo      [9] Ugasi BitLocker (C:)
echo      [10] Premjesti USER DATA na D: (Downloads, Desktop, Documents...)
echo      %ESC%[93m[11] Ugasi Windows Telemetriju (Privatnost)%ESC%[0m
echo      %ESC%[93m[12] Kreiraj God Mode (Sva podesavanja na Desktopu)%ESC%[0m
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p sc=" Izaberi opciju : "
if "%sc%"=="1" goto p_desktop
if "%sc%"=="2" goto p_laptop
if "%sc%"=="3" goto regional
if "%sc%"=="4" goto ikone_desktop
if "%sc%"=="5" goto restore
if "%sc%"=="6" goto rename_pc
if "%sc%"=="7" goto uac_nivo
if "%sc%"=="8" goto no_hibernate
if "%sc%"=="9" goto bitlocker
if "%sc%"=="10" goto move_userdata
if "%sc%"=="11" goto telemetry
if "%sc%"=="12" goto godmode
if "%sc%"=="0" goto menu
goto m_sistem

:p_desktop
cls
echo Optimizujem Power Plan za Desktop...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change monitor-timeout-ac 0
echo %ESC%[92m[OK] High Performance plan aktivan (Racunar se ne gasi).%ESC%[0m
pause
goto m_sistem

:p_laptop
cls
echo Optimizujem Power Plan za Laptop...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
:: Na struji (bez gasenja)
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
:: Na bateriji (gasenje ekrana 5m, spavanje 10m)
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-dc 10
powercfg /change hibernate-timeout-dc 0
echo %ESC%[92m[OK] Laptop plan: Na struji bez gasenja, na bateriji sleep 10 min.%ESC%[0m
pause
goto m_sistem

:regional
cls
echo Postavljam regionalne opcije i tastature...
powershell -Command "Set-Culture bs-Latn-BA; Set-WinSystemLocale bs-Latn-BA; Set-WinHomeLocation -GeoId 25; Set-TimeZone -Id 'Central Europe Standard Time'; Set-WinUserLanguageList -LanguageList sr-Latn-RS, sr-Cyrl-RS, en-US -Force"
echo %ESC%[92m[OK] Regija i tastature podesene.%ESC%[0m
pause
goto m_sistem

:ikone_desktop
cls
echo Prikazujem sve desktop ikone...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{21EC2020-3AEA-1069-A2DD-08002B30309D}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe
echo %ESC%[92m[OK] Desktop ikone su uspjesno prikazane.%ESC%[0m
pause
goto m_sistem

:restore
cls
echo Aktivacija System Restore-a i kreiranje tacke...
call :make_restore_point "Rucna_Tacka_%DATE%"
if errorlevel 1 (
    echo %ESC%[91m[GRESKA] Tacka vracanja NIJE kreirana. Razlog je ispisan iznad.%ESC%[0m
) else (
    echo %ESC%[92m[OK] System Restore ukljucen i tacka vracanja kreirana.%ESC%[0m
)
pause
goto m_sistem

:: Zajednicka funkcija za tacku vracanja.
:: Windows po defaultu dozvoljava samo jednu tacku u 24h i tada je TIHO preskace,
:: zato privremeno skidamo to ogranicenje i provjeravamo stvarni rezultat.
:make_restore_point
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t REG_DWORD /d 0 /f >nul 2>&1
powershell -NoProfile -Command "try { Enable-ComputerRestore -Drive 'C:\' -ErrorAction Stop; Checkpoint-Computer -Description '%~1' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop -WarningAction Stop; exit 0 } catch { Write-Host ('  ' + $_.Exception.Message); exit 1 }"
exit /b %errorlevel%

:rename_pc
cls
for /f "usebackq" %%i in (`powershell -Command "Get-Date -Format 'ddMMyy'"`) do set "dformat=PC%%i"
echo  Trenutno ime: %COMPUTERNAME%
echo.
set /p "change_choice= Hocete li promjenu ILI ostavljate trenutno? (D/N): "
if /i not "%change_choice%"=="D" (
    echo [INFO] Zadrzano staro ime.
    pause
    goto m_sistem
)

echo.
set "new_name="
set /p "new_name= Prijedlog: %dformat% (Unesi drugo ime ili pritisni ENTER za prijedlog): "
if not defined new_name set "new_name=%dformat%"

powershell -Command "Rename-Computer -NewName '%new_name%' -Force"
echo %ESC%[92m[OK] Ime ce biti promijenjeno u '%new_name%' nakon restarta.%ESC%[0m
pause
goto m_sistem

:uac_nivo
cls
echo  %ESC%[94m== UAC Podesavanje Nivoa ==%ESC%[0m
echo  Fabricka vrijednost u Windowsu je Nivo 2 (Pita samo kada aplikacije traze promjene).
echo.
echo      [1] MAKSIMUM (Uvijek me pitaj za sve)
echo      [2] FABRICKI (Pitaj samo za aplikacije - Preporuceno za vrijeme instalacija)
echo      [3] ISKLJUCENO (Ne preporucuje se)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p uac_opt=" Koji nivo zelis? : "
if "%uac_opt%"=="1" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 2 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f
    echo %ESC%[92m[OK] UAC postavljen na MAKSIMUM.%ESC%[0m
)
if "%uac_opt%"=="2" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f
    echo %ESC%[92m[OK] UAC vracen na FABRICKI nivo.%ESC%[0m
)
if "%uac_opt%"=="3" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
    echo %ESC%[92m[OK] UAC je ISKLJUCEN.%ESC%[0m
)
if "%uac_opt%"=="0" goto m_sistem
pause
goto m_sistem

:no_hibernate
cls
powercfg /h off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
echo %ESC%[92m[OK] Hibernacija iskljucena.%ESC%[0m
pause
goto m_sistem

:bitlocker
cls
manage-bde -off C:
echo %ESC%[92m[OK] BitLocker dekripcija pokrenuta (ako je bio ukljucen).%ESC%[0m
pause
goto m_sistem

:move_userdata
cls
echo  %ESC%[94m== PREMJESTANJE USER DATA FOLDERA NA D: ==%ESC%[0m
echo.
if not exist "D:\" (
    echo  %ESC%[91m[GRESKA] Particija D: ne postoji na ovom racunaru!%ESC%[0m
    pause
    goto m_sistem
)
echo  %ESC%[93mOva opcija ce premjestiti tvoje licne foldere na D:\USER DATA\%USERNAME%%ESC%[0m
echo  (Desktop, Documents, Downloads, Music, Pictures, Videos, 3D Objects, Contacts, Favorites, Links)
echo.
set /p "confirm= Nastavi sa premjestanjem? (D/N): "
if /i not "%confirm%"=="D" goto m_sistem

echo.
echo  %ESC%[92mFizicki premjestam foldere i azuriram sistemske putanje (molim sacekaj)...%ESC%[0m
set "NEWP=D:\USER DATA\%USERNAME%"
set "REGK=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

:: Automatski kreira odrediste i pravi cut/paste svih fajlova i podfoldera
for %%F in (Desktop Documents Downloads Music Pictures Videos Favorites Contacts Links "3D Objects") do (
    if exist "%USERPROFILE%\%%~F" (
        robocopy "%USERPROFILE%\%%~F" "%NEWP%\%%~F" /E /MOVE >nul 2>&1
        if not exist "%NEWP%\%%~F" mkdir "%NEWP%\%%~F" >nul 2>&1
    ) else (
        mkdir "%NEWP%\%%~F" >nul 2>&1
    )
)

:: Azuriranje Registry putanja da Windows zna gdje su novi folderi
reg add "%REGK%" /v "Desktop" /t REG_EXPAND_SZ /d "%NEWP%\Desktop" /f >nul
reg add "%REGK%" /v "Personal" /t REG_EXPAND_SZ /d "%NEWP%\Documents" /f >nul
reg add "%REGK%" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d "%NEWP%\Downloads" /f >nul
reg add "%REGK%" /v "My Music" /t REG_EXPAND_SZ /d "%NEWP%\Music" /f >nul
reg add "%REGK%" /v "My Pictures" /t REG_EXPAND_SZ /d "%NEWP%\Pictures" /f >nul
reg add "%REGK%" /v "My Video" /t REG_EXPAND_SZ /d "%NEWP%\Videos" /f >nul
reg add "%REGK%" /v "Favorites" /t REG_EXPAND_SZ /d "%NEWP%\Favorites" /f >nul
reg add "%REGK%" /v "{56784854-C6CB-462B-8169-88E350ACB882}" /t REG_EXPAND_SZ /d "%NEWP%\Contacts" /f >nul
reg add "%REGK%" /v "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}" /t REG_EXPAND_SZ /d "%NEWP%\Links" /f >nul
reg add "%REGK%" /v "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}" /t REG_EXPAND_SZ /d "%NEWP%\3D Objects" /f >nul

:: Restartovanje Windows Explorera da bi sistem odmah prihvatio promjene
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo  %ESC%[92m[OK] Svi folderi su uspesno premjesteni na D: i putanje su azurirane!%ESC%[0m
pause
goto m_sistem

:telemetry
cls
echo  %ESC%[93mGasim Windows Telemetriju i pracenje (molim sacekaj)...%ESC%[0m
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
echo  %ESC%[92m[OK] Telemetrija uspjesno ugasena.%ESC%[0m
pause
goto m_sistem

:godmode
cls
echo  %ESC%[92mPravim God Mode folder na Desktopu...%ESC%[0m
mkdir "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" >nul 2>&1
echo  %ESC%[92m[OK] God Mode kreiran! Sva Control Panel podesavanja na jednom mjestu.%ESC%[0m
pause
goto m_sistem

:: ===========================================================================================
:: [2] DIJAGNOSTIKA I SERVIS
:: ===========================================================================================
:m_dijagnostika
cls
echo.
echo  %ESC%[94m == DIJAGNOSTIKA I SERVIS =============================================================%ESC%[0m
echo.
echo      [1]  DISM Popravka Image-a (Novi prozor)
echo      [2]  SFC Scannow (Novi prozor)
echo      [3]  OBOJE: DISM + SFC (Novi prozor)
echo      [4]  SMART Status Diskova
echo      [5]  Disk Cleanup + Brisanje Temp
echo      [6]  Popravka Windows Update-a (Reset servisa i foldera)
echo      [7]  Reset Microsoft Store-a (wsreset)
echo      [8]  Azuriraj sve aplikacije na PC-u (Winget Upgrade All)
echo      [9]  Otvori Optional Updates (Drajveri)
echo      [10] Popravka Print Spooler-a (Brisanje reda cekanja za stampu)
echo      %ESC%[93m[11] Brisanje Windows Bloatware-a (Smece aplikacije)%ESC%[0m
echo      %ESC%[93m[12] Reset lozinke lokalnog korisnika%ESC%[0m
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p dc=" Izaberi opciju : "
if "%dc%"=="1" goto d_dism
if "%dc%"=="2" goto d_sfc
if "%dc%"=="3" goto d_both
if "%dc%"=="4" goto smart
if "%dc%"=="5" goto cleanup
if "%dc%"=="6" goto wu_reset
if "%dc%"=="7" goto store_reset
if "%dc%"=="8" goto upgrade_all
if "%dc%"=="9" goto drv_update
if "%dc%"=="10" goto spooler_fix
if "%dc%"=="11" goto bloatware
if "%dc%"=="12" goto reset_pass
if "%dc%"=="0" goto menu
goto m_dijagnostika

:d_dism
start "DaNe_DISM" cmd /c "echo POKRECEM DISM... & dism /online /cleanup-image /restorehealth & echo. & echo GOTOVO. & pause"
goto m_dijagnostika

:d_sfc
start "DaNe_SFC" cmd /c "echo POKRECEM SFC... & sfc /scannow & echo. & echo GOTOVO. & pause"
goto m_dijagnostika

:d_both
start "DaNe_REPAIR" cmd /c "echo POKRECEM DISM... & dism /online /cleanup-image /restorehealth & echo. & echo POKRECEM SFC... & sfc /scannow & echo. & echo GOTOVO. & pause"
goto m_dijagnostika

:smart
cls
echo  %ESC%[94m== SMART STATUS DISKOVA ==%ESC%[0m
powershell -Command "Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size, HealthStatus, OperationalStatus | Format-Table -AutoSize"
pause
goto m_dijagnostika

:cleanup
cls
echo Ciscenje sistema u toku...
:: cleanmgr /sagerun:1 radi samo ako su kategorije prethodno oznacene (StateFlags0001),
:: pa ih ovdje oznacavamo sve prije pokretanja.
for /f "delims=" %%K in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" 2^>nul') do (
    reg add "%%K" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
)
echo  %ESC%[93mDisk Cleanup radi (moze potrajati nekoliko minuta)...%ESC%[0m
start "" /wait cleanmgr /sagerun:1
:: Brisanje TEMP-a BEZ ove skripte (ona se pokrece iz TEMP-a i brisanjem bi se srusila)
:: i bez dane_apps.bat (moze biti pokrenut u drugom prozoru).
echo  %ESC%[93mBrisem privremene fajlove...%ESC%[0m
powershell -NoProfile -Command "$keep = @('%~nx0', 'dane_apps.bat'); Get-ChildItem -LiteralPath $env:TEMP -Force -ErrorAction SilentlyContinue | Where-Object { $keep -notcontains $_.Name } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
echo %ESC%[92m[OK] Ciscenje zavrseno.%ESC%[0m
pause
goto m_dijagnostika

:wu_reset
cls
echo  %ESC%[93mZaustavljam Windows Update servise...%ESC%[0m
net stop wuauserv >nul 2>&1
net stop cryptSvc >nul 2>&1
net stop bits >nul 2>&1
net stop msiserver >nul 2>&1
echo  %ESC%[93mPreimenujem kesh foldere (brisanje starih gresaka)...%ESC%[0m
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old >nul 2>&1
ren C:\Windows\System32\catroot2 catroot2.old >nul 2>&1
echo  %ESC%[92mPokrecem servise ponovo...%ESC%[0m
net start wuauserv >nul 2>&1
net start cryptSvc >nul 2>&1
net start bits >nul 2>&1
net start msiserver >nul 2>&1
echo  %ESC%[92m[OK] Windows Update je resetovan! Otvaram podesavanja...%ESC%[0m
start ms-settings:windowsupdate-action
pause
goto m_dijagnostika

:store_reset
cls
echo  %ESC%[92mCistim Microsoft Store kesh... (Ovo moze potrajati par sekundi)%ESC%[0m
wsreset.exe
echo  %ESC%[92m[OK] Store je resetovan.%ESC%[0m
pause
goto m_dijagnostika

:upgrade_all
cls
echo  %ESC%[92mTrazim i instaliram azuriranja za SVE aplikacije u novom prozoru...%ESC%[0m
start "DaNe_Upgrade" cmd /c "winget upgrade --all --source winget --include-unknown -h --accept-source-agreements --accept-package-agreements & echo. & echo SVA AZURIRANJA ZAVRSENA! & pause"
pause
goto m_dijagnostika

:drv_update
cls
echo  %ESC%[92mOtvaram Windows Update stranicu za opcionalna azuriranja (Drajveri)...%ESC%[0m
start ms-settings:windowsupdate-optionalupdates
pause
goto m_dijagnostika

:spooler_fix
cls
echo  %ESC%[93mZaustavljam Print Spooler servis...%ESC%[0m
net stop spooler >nul 2>&1
echo  %ESC%[93mBrisem zaglavljene fajlove za stampu...%ESC%[0m
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1
echo  %ESC%[92mPokrecem Print Spooler servis ponovo...%ESC%[0m
net start spooler >nul 2>&1
echo  %ESC%[92m[OK] Print Spooler je uspjesno resetovan i red cekanja je ociscen.%ESC%[0m
pause
goto m_dijagnostika

:bloatware
cls
echo  %ESC%[93mUklanjam Windows Bloatware (TikTok, CandyCrush, Bing, itd.)...%ESC%[0m
powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *tiktok* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *spotify* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *facebook* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxPackage *instagram* | Remove-AppxPackage -ErrorAction SilentlyContinue"
echo  %ESC%[92m[OK] Smece aplikacije uspjesno uklonjene!%ESC%[0m
pause
goto m_dijagnostika

:reset_pass
cls
echo  %ESC%[94m== RESET LOZINKE LOKALNOG KORISNIKA ==%ESC%[0m
echo  Spisak svih lokalnih korisnika na racunaru:
echo  ---------------------------------------------------
:: Get-LocalUser radi isto na svakom jeziku Windowsa (findstr filter je radio samo na engleskom)
powershell -NoProfile -Command "Get-LocalUser | Format-Table Name, Enabled, Description -AutoSize"
echo  ---------------------------------------------------
echo.
set "target_user="
set "new_pass="
set /p "target_user= Unesi TACNO ime korisnika kojem mijenjas sifru (ENTER za nazad): "
if not defined target_user goto m_dijagnostika
set /p "new_pass= Unesi NOVU sifru (ili ostavi prazno za brisanje sifre): "if "%new_pass%"=="" (
    net user "%target_user%" "" >nul 2>&1
) else (
    net user "%target_user%" "%new_pass%" >nul 2>&1
)
if %errorlevel% equ 0 (
    echo  %ESC%[92m[OK] Lozinka za korisnika '%target_user%' je uspjesno azurirana!%ESC%[0m
) else (
    echo  %ESC%[91m[GRESKA] Korisnik nije pronadjen ili nemate ovlascenja.%ESC%[0m
)
pause
goto m_dijagnostika

:: ===========================================================================================
:: [3] INSTALACIJA SOFTVERA
:: ===========================================================================================
:m_softver
cls
echo  %ESC%[93mProvjera sistemskih komponenti (Winget)...%ESC%[0m
winget --version >nul 2>&1
if %errorlevel% equ 0 goto softver_meni

echo.
echo  %ESC%[91m[UPOZORENJE] Winget nije pronadjen - cesta pojava na svjezim Windows instalacijama.%ESC%[0m
echo  %ESC%[92mPokrecem automatsko preuzimanje i instalaciju sa Microsoft GitHub servera...%ESC%[0m
echo  %ESC%[93mOvo moze potrajati par minuta. Molim sacekaj i ne zatvaraj prozor...%ESC%[0m
powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx' -OutFile '%TEMP%\vclibs.appx'; Add-AppxPackage -Path '%TEMP%\vclibs.appx' -ErrorAction SilentlyContinue; Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile '%TEMP%\uixaml.appx'; Add-AppxPackage -Path '%TEMP%\uixaml.appx' -ErrorAction SilentlyContinue; Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile '%TEMP%\winget.msixbundle'; Add-AppxPackage -Path '%TEMP%\winget.msixbundle'"
echo  %ESC%[92m[OK] Winget je uspjesno instaliran! Pokrecem meni...%ESC%[0m
timeout /t 3 /nobreak >nul

:softver_meni
cls
echo.
echo  %ESC%[94m == INSTALACIJA SOFTVERA ==============================================================%ESC%[0m
echo.
echo      %ESC%[96m[1]  INSTALIRAJ SVE PARALELNO (Office + Standardnih Apps)%ESC%[0m
echo           %ESC%[94mOffice krece u novom prozoru, a aplikacije se redaju u pozadini.%ESC%[0m
echo.
echo      %ESC%[96m[2]  Instaliraj samo STANDARDNE Aplikacije (Bez Office)%ESC%[0m
echo           %ESC%[94mSadrzi: Chrome, Firefox, AnyDesk, TeamViewer, VLC, K-Lite, Acrobat, NAPS2, 7zip.%ESC%[0m
echo.
echo      %ESC%[36m[3]  Microsoft Office (Specijalni Meni)%ESC%[0m
echo.
echo      --- Individualne instalacije ---
echo      [4] Browseri (Chrome, Firefox)
echo      [5] SUPORT (AnyDesk, TeamViewer)
echo      [6] Medija (VLC, K-Lite)
echo      [7] PDF i Skeniranje (Acrobat, NAPS2)
echo      [8] Alati (7zip, Notepad++, Everything)
echo      [9] Mrezni alati (AdvIP, WireShark, PuTTY)
echo      [10] Dev alati (Git, VS Code, Python)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p sw=" Izaberi opciju : "

if "%sw%"=="1" (call :restore_silent & call :build_temp_script & goto install_all_parallel)
if "%sw%"=="2" (call :restore_silent & call :build_temp_script & goto apps)
if "%sw%"=="3" (call :restore_silent & goto install_office)
if "%sw%"=="4" goto inst_browseri
if "%sw%"=="5" goto inst_remote
if "%sw%"=="6" goto inst_medija
if "%sw%"=="7" goto inst_pdf
if "%sw%"=="8" goto inst_alati
if "%sw%"=="9" goto inst_mreza_apps
if "%sw%"=="10" goto inst_dev
if "%sw%"=="0" goto menu
goto softver_meni

:restore_silent
echo  %ESC%[93mPravim tacku vracanja prije instalacije...%ESC%[0m
call :make_restore_point "Pre_Instalacije_AIO" >nul 2>&1
if errorlevel 1 (
    echo  %ESC%[91m[UPOZORENJE] Tacka vracanja nije kreirana - nastavljam bez nje.%ESC%[0m
    timeout /t 3 /nobreak >nul
)
exit /b

:: Ciscenje koda: Jedna centralna funkcija za kreiranje app skripte
:build_temp_script
echo @echo off > "%TEMP%\dane_apps.bat"
echo title Instalacija Aplikacija >> "%TEMP%\dane_apps.bat"
echo echo ======================================================== >> "%TEMP%\dane_apps.bat"
echo echo ZAPOCINJEM TIHU INSTALACIJU STANDARDNIH APLIKACIJA... >> "%TEMP%\dane_apps.bat"
echo echo ======================================================== >> "%TEMP%\dane_apps.bat"
echo for %%%%a in (Google.Chrome Mozilla.Firefox AnyDesk.AnyDesk TeamViewer.TeamViewer VideoLAN.VLC CodecGuide.K-LiteCodecPack.Full Adobe.Acrobat.Reader.64-bit Cyanfish.NAPS2.Prerelease 7zip.7zip) do ( >> "%TEMP%\dane_apps.bat"
echo    echo. >> "%TEMP%\dane_apps.bat"
echo    echo [*] Instaliram: %%%%a >> "%TEMP%\dane_apps.bat"
echo    winget install --id %%%%a --source winget -h --silent --accept-source-agreements --accept-package-agreements --force >> "%TEMP%\dane_apps.bat"
echo ) >> "%TEMP%\dane_apps.bat"
echo echo. >> "%TEMP%\dane_apps.bat"
echo echo ======================================================== >> "%TEMP%\dane_apps.bat"
echo echo SVE APLIKACIJE SU ZAVRSENE! >> "%TEMP%\dane_apps.bat"
echo echo ======================================================== >> "%TEMP%\dane_apps.bat"
echo pause >> "%TEMP%\dane_apps.bat"
echo exit >> "%TEMP%\dane_apps.bat"
exit /b

:install_all_parallel
cls
echo  %ESC%[92mPokrecem Office 365 u novom prozoru...%ESC%[0m
start "DaNe_Office_Install" cmd /c "winget install --id Microsoft.Office --source winget -h --silent --accept-source-agreements --accept-package-agreements --force & echo. & echo OFFICE ZAVRSEN! & pause"
echo  %ESC%[92mPokrecem standardne aplikacije u pozadini...%ESC%[0m
start "DaNe_APPS_Install" "%TEMP%\dane_apps.bat"
echo  Procesi su uspesno pokrenuti. Mozete nastaviti rad u ovom meniju.
pause
goto softver_meni

:apps
cls
echo  %ESC%[92mPokrecem instalaciju standardnih aplikacija u novom prozoru...%ESC%[0m
start "DaNe_APPS_Install" "%TEMP%\dane_apps.bat"
pause
goto softver_meni

:install_office
cls
echo.
echo  %ESC%[94m == OFFICE MENI =========================================================================%ESC%[0m
echo.
echo  Koju verziju Office-a zelite instalirati?
echo.
echo      [1] MS Office 365 (Preko Winget-a) - Skida najnoviju zvanicnu verziju sa MS servera.
echo      [2] Moj Lokalni Setup (Pored sata) - Pokrece setup.exe iz foldera 'OfficeSetup'.
echo      [3] Open Office (Apache)           - Besplatan open-source paket.
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p off_opt=" Izaberi Office : "
if "%off_opt%"=="1" start "DaNe_Office" cmd /c "winget install --id Microsoft.Office --source winget -h --silent --accept-source-agreements --accept-package-agreements --force & echo. & echo GOTOVO! & pause"
if "%off_opt%"=="2" goto office_local
if "%off_opt%"=="3" start "DaNe_Office" cmd /c "winget install --id Apache.OpenOffice --source winget -h --silent --accept-source-agreements --accept-package-agreements --force & echo. & echo GOTOVO! & pause"
if "%off_opt%"=="0" goto softver_meni
goto softver_meni

:: Lokalni Office setup. Kao Administrator trenutni folder je C:\Windows\System32,
:: pa relativna putanja nikad nije radila. Trazimo OfficeSetup\setup.exe pored skripte
:: i u korijenu svih diskova (npr. USB), a ako ga nema - nudimo rucni unos putanje.
:office_local
cls
set "office_exe="
if exist "%~dp0OfficeSetup\setup.exe" set "office_exe=%~dp0OfficeSetup\setup.exe"
if not defined office_exe for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not defined office_exe if exist "%%D:\OfficeSetup\setup.exe" set "office_exe=%%D:\OfficeSetup\setup.exe"
)
if not defined office_exe (
    echo  %ESC%[93mFolder 'OfficeSetup' sa 'setup.exe' nije pronadjen ni na jednom disku.%ESC%[0m
    echo.
    set /p "office_exe= Unesi punu putanju do setup.exe (ili ENTER za nazad): "
)
if not defined office_exe goto install_office
set "office_exe=%office_exe:"=%"
if not exist "%office_exe%" (
    echo  %ESC%[91m[GRESKA] Fajl ne postoji: %office_exe%%ESC%[0m
    pause
    goto install_office
)
for %%F in ("%office_exe%") do start "" /D "%%~dpF" "%%~fF"
echo  %ESC%[92m[OK] Pokrenut lokalni setup: %office_exe%%ESC%[0m
pause
goto softver_meni

:: --- Pod-meniji za grupe sa izborom ---

:inst_browseri
cls
echo  [1] Instaliraj OBA (Chrome + Firefox)
echo  [2] Samo Chrome
echo  [3] Samo Firefox
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install Google.Chrome --source winget -h --silent --force & winget install Mozilla.Firefox --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install Google.Chrome --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install Mozilla.Firefox --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_remote
cls
echo  [1] Instaliraj OBA (AnyDesk + TeamViewer)
echo  [2] Samo AnyDesk
echo  [3] Samo TeamViewer
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install AnyDesk.AnyDesk --source winget -h --silent --force & winget install TeamViewer.TeamViewer --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install AnyDesk.AnyDesk --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install TeamViewer.TeamViewer --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_medija
cls
echo  [1] Instaliraj OBA (VLC + K-Lite)
echo  [2] Samo VLC
echo  [3] Samo K-Lite
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install VideoLAN.VLC --source winget -h --silent --force & winget install CodecGuide.K-LiteCodecPack.Full --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install VideoLAN.VLC --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install CodecGuide.K-LiteCodecPack.Full --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_pdf
cls
echo  [1] Instaliraj OBA (Acrobat + NAPS2)
echo  [2] Samo Acrobat Reader
echo  [3] Samo NAPS2
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install Adobe.Acrobat.Reader.64-bit --source winget -h --silent --force & winget install Cyanfish.NAPS2.Prerelease --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install Adobe.Acrobat.Reader.64-bit --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install Cyanfish.NAPS2.Prerelease --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_alati
cls
echo  [1] Instaliraj SVE (7zip + Notepad++ + Everything)
echo  [2] Samo 7zip
echo  [3] Samo Notepad++
echo  [4] Samo Everything
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install 7zip.7zip --source winget -h --silent --force & winget install Notepad++.Notepad++ --source winget -h --silent --force & winget install voidtools.Everything --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install 7zip.7zip --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install Notepad++.Notepad++ --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="4" start "Install" cmd /c "winget install voidtools.Everything --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_mreza_apps
cls
echo  [1] Instaliraj SVE (AdvIP + Wireshark + PuTTY)
echo  [2] Samo Advanced IP Scanner
echo  [3] Samo Wireshark
echo  [4] Samo PuTTY
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install Famatech.AdvancedIPScanner --source winget -h --silent --force & winget install WiresharkFoundation.Wireshark --source winget -h --silent --force & winget install PuTTY.PuTTY --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install Famatech.AdvancedIPScanner --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install WiresharkFoundation.Wireshark --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="4" start "Install" cmd /c "winget install PuTTY.PuTTY --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:inst_dev
cls
echo  [1] Instaliraj SVE (Git + VS Code + Python)
echo  [2] Samo Git
echo  [3] Samo VS Code
echo  [4] Samo Python
echo  %ESC%[91m[0] NAZAD%ESC%[0m
set /p sel=":"
if "%sel%"=="1" start "Install" cmd /c "winget install Git.Git --source winget -h --silent --force & winget install Microsoft.VisualStudioCode --source winget -h --silent --force & winget install Python.Python.3.12 --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="2" start "Install" cmd /c "winget install Git.Git --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="3" start "Install" cmd /c "winget install Microsoft.VisualStudioCode --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="4" start "Install" cmd /c "winget install Python.Python.3.12 --source winget -h --silent --force & echo. & echo GOTOVO! & pause"
if "%sel%"=="0" goto softver_meni
goto softver_meni

:: ===========================================================================================
:: [4] MREZNA DIJAGNOSTIKA
:: ===========================================================================================
:m_mreza
cls
echo.
echo  %ESC%[94m == MREZNA DIJAGNOSTIKA ==============================================================%ESC%[0m
echo.
echo      [1]  Prikazi IP / Mreza Info
echo      [2]  Ping Test (DNS + Gateway)
echo      [3]  Traceroute (do 8.8.8.8)
echo      [4]  DNS Flush + Reset
echo      [5]  Winsock Reset (Popravka mreze)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p nc=" Izaberi opciju : "
if "%nc%"=="1" goto net_info
if "%nc%"=="2" goto net_ping
if "%nc%"=="3" goto net_trace
if "%nc%"=="4" goto net_dns
if "%nc%"=="5" goto net_winsock
if "%nc%"=="0" goto menu
goto m_mreza

:net_info
powershell -Command "Get-NetIPConfiguration | Where-Object {$_.IPv4Address}"
pause
goto m_mreza

:net_ping
ping -n 4 8.8.8.8
pause
goto m_mreza

:net_trace
tracert -d -h 20 8.8.8.8
pause
goto m_mreza

:net_dns
ipconfig /flushdns
ipconfig /registerdns
netsh dns reset
pause
goto m_mreza

:net_winsock
netsh winsock reset
netsh int ip reset
pause
goto m_mreza

:: ===========================================================================================
:: [5] SIGURNOST I ANTIVIRUS
:: ===========================================================================================
:m_sigurnost
cls
echo.
echo  %ESC%[94m == SIGURNOST I ANTIVIRUS ============================================================%ESC%[0m
echo.
echo      [1]  Windows Defender - Brzi Scan
echo      [2]  Windows Defender - Puni Scan
echo      [3]  Defender Update (Definicije)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p sec=" Izaberi opciju : "
if "%sec%"=="1" goto def_quick
if "%sec%"=="2" goto def_full
if "%sec%"=="3" goto def_update
if "%sec%"=="0" goto menu
goto m_sigurnost

:def_quick
start "Defender" cmd /c "powershell -Command Start-MpScan -ScanType QuickScan & pause"
goto m_sigurnost

:def_full
start "Defender" cmd /c "powershell -Command Start-MpScan -ScanType FullScan & pause"
goto m_sigurnost

:def_update
powershell -Command "Update-MpSignature"
pause
goto m_sigurnost

:: ===========================================================================================
:: [6] BACKUP I RESTORE
:: ===========================================================================================
:m_backup
cls
echo.
echo  %ESC%[94m == BACKUP I RESTORE =================================================================%ESC%[0m
echo.
echo      [1]  System Restore - Prikazi Tacke
echo      [2]  Backup Drajvera (Export na Desktop)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p bc=" Izaberi opciju : "
if "%bc%"=="1" powershell -Command "Get-ComputerRestorePoint" & pause & goto m_backup
if "%bc%"=="2" (
    mkdir "%USERPROFILE%\Desktop\Drajveri_Backup" >nul 2>&1
    pnputil /export-driver * "%USERPROFILE%\Desktop\Drajveri_Backup"
    echo Gotovo. Drajveri su na Desktopu.
    pause
    goto m_backup
)
if "%bc%"=="0" goto menu
goto m_backup

:: ===========================================================================================
:: [7] MONITORING HARDVERA
:: ===========================================================================================
:m_hardver
cls
echo.
echo  %ESC%[94m == MONITORING HARDVERA ==============================================================%ESC%[0m
echo.
echo      [1]  Brze Info (CPU, RAM, OS)
echo      [2]  Prikazi Windows Verziju (winver)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p hw=" Izaberi opciju : "
if "%hw%"=="1" (
    powershell -Command "Write-Host 'OS: ' (Get-CimInstance Win32_OperatingSystem).Caption; Write-Host 'CPU: ' (Get-CimInstance Win32_Processor).Name; Write-Host 'RAM: ' ([math]::Round((Get-CimInstance Win32_PhysicalMemory|Measure-Object Capacity -Sum).Sum/1GB,1)) 'GB'"
    pause
    goto m_hardver
)
if "%hw%"=="2" start winver & goto m_hardver
if "%hw%"=="0" goto menu
goto m_hardver

:: ===========================================================================================
:: [8] BREND ALATI (DRAJVERI)
:: ===========================================================================================
:m_brend
cls
echo.
echo  %ESC%[94m == BREND SPECIFICNI ALATI ===========================================================%ESC%[0m
echo.
echo      [1]  HP Support Assistant
echo      [2]  DELL Command Update
echo      [3]  LENOVO Vantage
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p br=" Izaberi brend : "
if "%br%"=="1" start "Brend" cmd /c "winget install HP.HPSupportAssistant --source winget -h --silent & pause"
if "%br%"=="2" start "Brend" cmd /c "winget install Dell.CommandUpdate --source winget -h --silent & pause"
if "%br%"=="3" start "Brend" cmd /c "winget install Lenovo.Vantage --source winget -h --silent & pause"
if "%br%"=="0" goto menu
goto m_brend

:: ===========================================================================================
:: [9] AKTIVACIJA (MAS)
:: ===========================================================================================
:mas_online
cls
echo.
echo  %ESC%[94m == MAS AKTIVACIJA ==================================================================%ESC%[0m
echo.
echo      [1] Pokreni direktno (Moze biti blokirano od strane Antivirusa)
echo      [2] Kopiraj komandu i otvori novi terminal (Sigurna opcija za AV)
echo.
echo      %ESC%[91m[0] NAZAD%ESC%[0m
echo.
set /p mas_opt=" Izaberi opciju : "

if "%mas_opt%"=="1" (
    start powershell -NoProfile -NoExit -Command "irm https://get.activated.win | iex"
    goto menu
)
if "%mas_opt%"=="2" (
    echo irm https://get.activated.win ^| iex | clip
    echo.
    echo  %ESC%[92m[OK] Komanda je kopirana u memoriju!%ESC%[0m
    echo  %ESC%[93mOtvara se novi PowerShell prozor. Kliknite desni klik (Paste) i pritisnite Enter.%ESC%[0m
    pause
    start powershell -NoProfile
    goto menu
)
if "%mas_opt%"=="0" goto menu
goto mas_online

:: ===========================================================================================
:: IZLAZ IZ ALATA (Nasilno gasenje)
:: ===========================================================================================
:exit_tool
cls
echo.
echo  %ESC%[92mHvala na koriscenju! Zatvaram alat i cistim terminal...%ESC%[0m
timeout /t 2 >nul
:: Gasi SAMO PowerShell prozor iz kojeg je alat pokrenut (ako postoji),
:: a ne sve PowerShell procese na racunaru.
powershell -NoProfile -Command "$me = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $PID); $cmd = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $me.ParentProcessId); $p = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $cmd.ParentProcessId); if ($p -and @('powershell.exe','pwsh.exe') -contains $p.Name -and $p.CreationDate -lt $cmd.CreationDate) { Stop-Process -Id $p.ProcessId -Force }" >nul 2>&1
exit
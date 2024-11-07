@echo Off
title TazxPerfomance for Windows 11") 
set Version=Beta 
color a
cls

:: Getting Admin Permissions https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
echo Checking for Administrative Privelages...
timeout /t 3 /nobreak > NUL
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto GotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:GotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:Menu
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d "1" /f >>TazxTweaks_logs.txt
cls
chcp 65001 >nul 2>&1
color a
cls
echo.
echo.
echo.
echo -----------------------------------------------------------------------------------------------------------------------
echo ████████╗ █████╗ ███████╗██╗  ██╗██████╗ ███████╗██████╗ ███████╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗███████╗
echo ╚══██╔══╝██╔══██╗╚══███╔╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝██╔════╝
echo    ██║   ███████║  ███╔╝  ╚███╔╝ ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██╔████╔██║███████║██╔██╗ ██║██║     █████╗  
echo    ██║   ██╔══██║ ███╔╝   ██╔██╗ ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║     ██╔══╝  
echo    ██║   ██║  ██║███████╗██╔╝ ██╗██║     ███████╗██║  ██║██║     ╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╗███████╗
echo    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
echo                                                     Version: %Version%
echo -----------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo.
echo                      [1] Create a Restore Point.                           [2] Unnecessary Services.
echo.
echo                      [3] Tweaks For Device Manager                         [4] Disable Mitigations + BCD Tweaks . 

echo -------------------------------------------------------------------------------------------------------------------------

set /p Option=Select the Option you want to use:
if %Option% opt 1 goto RS
if %Option% opt 2 goto UnS
if %Option% opt 3 goto TDM
if %Option% opt 4 goto Ds

:RS
CLS

echo -----------------------------------------------------------------------------------------------------------------------
echo ████████╗ █████╗ ███████╗██╗  ██╗██████╗ ███████╗██████╗ ███████╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗███████╗
echo ╚══██╔══╝██╔══██╗╚══███╔╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝██╔════╝
echo    ██║   ███████║  ███╔╝  ╚███╔╝ ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██╔████╔██║███████║██╔██╗ ██║██║     █████╗  
echo    ██║   ██╔══██║ ███╔╝   ██╔██╗ ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║     ██╔══╝  
echo    ██║   ██║  ██║███████╗██╔╝ ██╗██║     ███████╗██║  ██║██║     ╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╗███████╗
echo    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
echo                                                     Version: %Version%
echo -----------------------------------------------------------------------------------------------------------------------

:RS
echo Restore Point...
:: RestorePoint
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f  
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'TazxPerfomance'
cls
echo                   [1]Menu
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu


:UnS
echo Disable Services...
:: Services
sc config "wuauserv" start= disabled
net stop "wuauserv"
sc config "werSvc" start= disabled
net stop "werSvc"
sc config "Spooler" start= disabled
net stop "Spooler"
sc config "Fax" start= disabled
net stop "Fax"
sc config "DiagTrack" start= disabled
net stop "DiagTrack"
sc config "DoSvc" start= disabled
net stop "DoSvc"
sc config "WNotification" start= disabled
net stop "WNotification"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost" /v SvcHostSplitThresholdInKB /t REG_DWORD /d 0x3722304989 /f
cls
echo                   [1]Menu
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu

:TDM
echo Tweaks For Device Manager 
:: Install DevManView.exe and Tweaking... 
curl -g -k -L -# -o "C:\Windows\System32\DevManView.exe" "https://github.com/TazxTweaks/TazxPerfomance/raw/refs/heads/main/Bios/DevManView.exe"
cls
DevManView.exe /disable "High Precision Event Timer"
DevManView.exe /disable "Microsoft GS Wavetable Synth"
DevManView.exe /disable "Microsoft RRAS Root Enumerator"
DevManView.exe /disable "Intel Management Engine"
DevManView.exe /disable "Intel Management Engine Interface"
DevManView.exe /disable "Intel SMBus"
DevManView.exe /disable "SM Bus Controller"
DevManView.exe /disable "Amdlog"
DevManView.exe /disable "AMD PSP"
DevManView.exe /disable "System Speaker"
DevManView.exe /disable "Composite Bus Enumerator"
DevManView.exe /disable "Microsoft Virtual Drive Enumerator"
DevManView.exe /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
DevManView.exe /disable "NDIS Virtual Network Adapter Enumerator"
DevManView.exe /disable "Remote Desktop Device Redirector Bus"
DevManView.exe /disable "UMBus Root Bus Enumerator"
DevManView.exe /disable "WAN Miniport (IP)"
DevManView.exe /disable "WAN Miniport (IKEv2)"
DevManView.exe /disable "WAN Miniport (IPv6)"
DevManView.exe /disable "WAN Miniport (L2TP)"
DevManView.exe /disable "WAN Miniport (PPPOE)"
DevManView.exe /disable "WAN Miniport (PPTP)"
DevManView.exe /disable "WAN Miniport (SSTP)"
DevManView.exe /disable "WAN Miniport (Network Monitor)"
DevManView.exe /disable "System Speaker"
DevManView.exe /disable "System Timer"
DevManView.exe /disable "High precision event timer"
DevManView.exe /disable "WAN Miniport (IKEv2)"
DevManView.exe /disable "WAN Miniport (IP)"
DevManView.exe /disable "WAN Miniport (IPv6)"
DevManView.exe /disable "WAN Miniport (L2TP)"
DevManView.exe /disable "WAN Miniport (Network Monitor)"
DevManView.exe /disable "WAN Miniport (PPPOE)"
DevManView.exe /disable "WAN Miniport (PPTP)"
DevManView.exe /disable "WAN Miniport (SSTP)"
DevManView.exe /disable "Direct memory access controller"
DevManView.exe /disable "System CMOS/real time clock"
DevManView.exe /disable "Unknown device"
DevManView.exe /disable "Microsoft Virtual Drive Enumerator"
DevManView.exe /disable "UMBus Root Bus Enumerator"
DevManView.exe /disable "Programmable Interrupt Controller"
DevManView.exe /disable "Composite Bus Enumerator"
DevManView.exe /disable "Numeric Data Processor"
DevManView.exe /disable "Legacy Device"
DevManView.exe /disable "PCI Memory Controller"
DevManView.exe /disable "PCI Simple Communications Controller"
DevManView.exe /disable "SM Bus Controller"
DevManView.exe /disable "PCI Data Acquisition and Signal Processing Controller"
DevManView.exe /disable "Base System Device"
cls
echo                   [1]Menu
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu
:Ds
echo Disable Mitigations + BCD Tweaks ...
::bcdit
bcdedit /set useplatformclock No 
bcdedit /seplatformtick No 
bcdedit /set disabledynamictick Yes
::Mitigations + Microcode
takeown /f "C:\Windows\System32\mcupdate_GenuineIntel.dll" /r /d y 
takeown /f "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /r /d y 
del "C:\Windows\System32\mcupdate_GenuineIntel.dll" /s /f /q 
del "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /s /f /q 
powershell "ForEach($v in (Get-Command -Name \"Set-ProcessMitigation\").Parameters[\"Disable\"].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" 
powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue" 
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f 
cls
echo                   [1]Menu
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu
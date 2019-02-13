@echo off

set binPath=%1
set binFile=%2
set driveName=%3
set options=%4

set drivePath=

for /f %%x in (
    'wmic logicaldisk where "VolumeName='%driveName%'" get DeviceID ^| find ":"'
    ) do set drivePath=%%x
if "%options%" == "-v" (
    echo.Searching for Maxim board at %drivePath%
)
if exist %drivePath%\DETAILS.TXT (
    if "%driveName%" == "BOOTLOADER" if exist %drivePath%\HELP_FAQ.HTM goto found
    if "%driveName%" == "DAPLINK" if exist %drivePath%\MBED.HTM goto found
)
echo.Maxim board not found.
::Exit code 101 to allow Arduino IDE in raising error condition
exit /B 101

:found
    copy /Y /B %binPath%\%binFile% %drivePath%\ >nul
    if "%options%" == "-v" (
        echo.%binPath%\%binFile% -^> %drivePath%\%binFile%
    )
    if not exist %drivePath%\%binFile% (
        echo.Can't upload the file to USB drive.
        exit /B 102
    )

:: Note: Any non-zero exit code allows Arduino IDE to raise an error.

@echo off

set binPath=%1
set binFile=%2
set driveName=%3
set options=%4

set drivePath=

:: get the drive letter matching the volume name. If multiple drives have same name, the last one is picked
for /f %%x in (
    'wmic logicaldisk where "VolumeName='%driveName%'" get DeviceID ^| find ":"'
    ) do set drivePath=%%x

if "%options%" == "-v" echo Expecting a Maxim board at %drivePath% &:: verbose

:: verify that Maxim board is valid before copying(loading) the binary file
if exist %drivePath%\DETAILS.TXT (
    if "%driveName%" == "BOOTLOADER" if exist %drivePath%\HELP_FAQ.HTM goto found
    if "%driveName%" == "DAPLINK" if exist %drivePath%\MBED.HTM goto found
)
if "%options%" == "-v" echo Either %driveName% USB drive doesn't exists or a file on drive is missing. &::verbose
exit /B 100

:found
    if "%options%" == "-v" echo Loading...          &:: verbose
    if "%options%" == "-v" ( set xcopyVerbose=/F ) else set xcopyVerbose=/Q
    xcopy %xcopyVerbose% %binPath%\%binFile% %drivePath%
    if not %ERRORLEVEL% == 0 exit /B 100            &:: verify copy passed
    if "%options%" == "-v" echo Complete.           &:: verbose

    :: verify whether file has been copied
    if "%options%" == "-v" echo Verifying...        &:: verbose
    if not exist %drivePath%\%binFile% (
        if "%options%" == "-v" echo Failed. Check for Write permission on %driveName% USB drive.
        exit /B 100
    ) else (
        if "%options%" == "-v" echo Success.        &:: verbose
    )

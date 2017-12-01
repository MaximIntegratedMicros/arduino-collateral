@echo off

set binPath=%1
set binFile=%2
set options=%3
set drivePath=

for /f "skip=2" %%x in (
    'wmic logicaldisk get deviceid'
    ) do (
        if "%options%" == "-v" (
            echo.Searching for Maxim board at %%x
        )
        if exist %%x\DETAILS.TXT (
            if exist %%x\MBED.HTM (
                set drivePath=%%x
                goto found
            ) else (
                if exist %%x\HELP_FAQ.HTM (
                    set drivePath=%%x
                    goto found
                )
            )
        )
    )
echo.Maxim board not found.
::Exit code 101 to allow Arduino IDE in raising error condition
exit /B 101

:found
    copy /Y /b %binPath%\%binFile% %drivePath%\ >nul
    if "%options%" == "-v" (
        echo.%binPath%\%binFile% -^> %drivePath%\%binFile%
    )
    if not exist %drivePath%\%binFile% (
        echo.Can't upload the file to USB drive.
        exit /B 102
        )
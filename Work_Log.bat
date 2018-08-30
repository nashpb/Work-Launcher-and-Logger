@set _start=%time%
@cls
@echo OFF
set "_ver=v0.4.8"
title Work Logger %_ver%
call :logo
set "_log=C:\Users\Nishadh\OneDrive\Work_Log\worklog.log"
set "_err1=C:\Users\Nishadh\Documents\Work\work_error.log"
set "log=call :log"
taskkill /FI "WINDOWTITLE eq worklog.log - Notepad" >nul 2>&1
%log% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%log% Log from Work Logger %_ver%
%log% Date of Work: %date%
%log% Work started from: %_start%
rem start  C:\"Program Files"\Google\Chrome\Application\chrome.exe & %log% %time%:- Chrome launched
rem start C:\wamp\wampmanager.exe & %log% %time%:- WAMP launched
rem cd "C:\Program Files\NetBeans 8.2\bin\"
rem netbeans.exe --console suppress & %log% %time%:- Netbeans launched
rem cd c:\Users\Nishadh\Desktop
call :opt
%log% -------------------------------
goto :eof

:logo
echo **           **  * *
echo  **         **   * *
echo   **  ***  **    * *
echo    **** ****     * ******
echo     **   **      ********
goto :eof

:log
REM writes the same line to screen and two files
>>%_log% echo(%*
>>%_err1% echo(%*
goto :eof


:opt
set /P "_opt=Enter choice [break/stop]"
if %_opt%==stop (
call :stop
)else if %_opt%==break (
call :break
)else (
echo Wrong Choice
cls
call :logo
call :opt
)
goto :eof

:break
echo Taking a Break

goto :eof

:stop
set STARTTIME=%_start%
set _end=%time%
set ENDTIME=%_end%
set /A STARTTIME=(1%STARTTIME:~0,2%-100)*360000 + (1%STARTTIME:~3,2%-100)*6000 + (1%STARTTIME:~6,2%-100)*100 + (1%STARTTIME:~9,2%-100)
set /A ENDTIME=(1%ENDTIME:~0,2%-100)*360000 + (1%ENDTIME:~3,2%-100)*6000 + (1%ENDTIME:~6,2%-100)*100 + (1%ENDTIME:~9,2%-100)

rem calculating the duration is easy
set /A DURATION=%ENDTIME%-%STARTTIME%

rem we might have measured the time inbetween days
if %ENDTIME% LSS %STARTTIME% set set /A DURATION=%STARTTIME%-%ENDTIME%

rem now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
set /A DURATIONH=%DURATION% / 360000
set /A DURATIONM=(%DURATION% - %DURATIONH%*360000) / 6000
set /A DURATIONS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000) / 100
set /A DURATIONHS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000 - %DURATIONS%*100)

rem some formatting
if %DURATIONH% LSS 10 set DURATIONH=0%DURATIONH%
if %DURATIONM% LSS 10 set DURATIONM=0%DURATIONM%
if %DURATIONS% LSS 10 set DURATIONS=0%DURATIONS%
if %DURATIONHS% LSS 10 set DURATIONHS=0%DURATIONHS%

rem outputing
echo STARTTIME: %_start%
echo ENDTIME: %_end%
echo DURATION: %DURATIONH%:%DURATIONM%:%DURATIONS%:%DURATIONHS%
%log% Work ended at: %_end%
%log% Work Duration: %DURATIONH%:%DURATIONM%:%DURATIONS%:%DURATIONHS%
goto :eof
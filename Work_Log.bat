@set _start=%time%
@cls
@echo OFF
set "_ver=v0.5.1"
set "_btime=0"
set "_bcount=0"
title Work Logger %_ver%
set "_log=C:\Users\Nishadh\OneDrive\Work_Log\worklog.log"
set "_err1=C:\Users\Nishadh\Documents\Work\work_error.log"
set "log=call :log"
taskkill /FI "WINDOWTITLE eq worklog.log *" >nul 2>&1
%log% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%log% Log from Work Logger %_ver%
%log% Date of Work: %date%
%log% Work started from: %_start%
start  C:\"Program Files"\Google\Chrome\Application\chrome.exe & %log% %time%:- Chrome launched
start C:\wamp\wampmanager.exe & %log% %time%:- WAMP launched
cd "C:\Program Files\NetBeans 8.2\bin\"
netbeans.exe --console suppress & %log% %time%:- Netbeans launched
cd c:\Users\Nishadh\Desktop
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
cls
call :logo
set /P "_opt=Enter choice [break/stop]"
if %_opt%==stop (
call :stop
)else if %_opt%==break (
set /A "_bcount+=1"
call :break_on
)else (
echo Wrong Choice
call :opt
)
goto :eof

:break_on
set "_break_on=%time%"
echo Break %_bcount% taken at %_break_on%
%log% Break %_bcount% taken at %_break_on%
call :chkbreak 
goto :eof

:chkbreak
set /P "_chk=Are you back from your break?[y/n]"
if %_chk%==y (
call :break_off
)else (
cls
call :logo
call :chkbreak
)
goto :eof

:break_off
set "_break_off=%time%"
echo Back from break %_bcount% at %_break_off%
%log% Back from break %_bcount% at %_break_off%
call :conv %_break_on%,bon
call :conv %_break_off%,bof
set /A "_bt=(%bof%-%bon%)"
set /A "_btime+=_bt"
call :vnoc %_bt%,h,m,s,ms
if %h% LSS 10 set h=0%h%
if %m% LSS 10 set m=0%m%
if %s% LSS 10 set s=0%s%
if %ms% LSS 10 set ms=0%ms%
%log% Break %_bcount% Duration %h%:%m%:%s%.%ms%
echo Break %_bcount% Duration %h%:%m%:%s%.%ms%
pause
call :opt
goto :eof

:conv 
set "MTIME=%~1"
set /A MTIME=(1%MTIME:~0,2%-100)*360000 + (1%MTIME:~3,2%-100)*6000 + (1%MTIME:~6,2%-100)*100 + (1%MTIME:~9,2%-100)
set "%~2=%MTIME%"
goto :eof

:vnoc
set "DURATION=%~1"
set /A %~2=%DURATION% / 360000
set /A %~3=(%DURATION% - %~2*360000) / 6000
set /A %~4=(%DURATION% - %~2*360000 - %~3*6000) / 100
set /A %~5=(%DURATION% - %~2*360000 - %~3*6000 - %~4*100)
goto :eof

:stop
set _end=%time%
call :conv %_start%,STARTTIME
call :conv %_end%,ENDTIME

rem calculating the duration is easy
set /A DURATION=%ENDTIME%-%STARTTIME%-%_btime%

rem we might have measured the time inbetween days
if %ENDTIME% LSS %STARTTIME% set /A DURATION=%STARTTIME%-%ENDTIME%-%_btime%

rem now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
call :vnoc %DURATION%,DURATIONH,DURATIONM,DURATIONS,DURATIONHS

rem some formatting
if %DURATIONH% LSS 10 set DURATIONH=0%DURATIONH%
if %DURATIONM% LSS 10 set DURATIONM=0%DURATIONM%
if %DURATIONS% LSS 10 set DURATIONS=0%DURATIONS%
if %DURATIONHS% LSS 10 set DURATIONHS=0%DURATIONHS%

rem outputing
cls
call :logo
echo STARTTIME: %_start%
call :vnoc %_btime%,h,m,s,ms
echo Total Breaks Taken: %_bcount%
echo BREAK DURATION: %h%:%m%:%s%.%ms% 
echo ENDTIME: %_end%
echo DURATION: %DURATIONH%:%DURATIONM%:%DURATIONS%.%DURATIONHS%
%log% Total Breaks Taken: %_bcount%
%log% Total BREAK DURATION: %h%:%m%:%s%.%ms%
%log% Work ended at: %_end%
%log% Work Duration: %DURATIONH%:%DURATIONM%:%DURATIONS%.%DURATIONHS%
pause
goto :eof

REM This is part of Very Fast DDS Conversion solution utility on x-plane.org 
REM Free to use. Made by Gaston Reif (gastonreif@gmail.com) from scratch 
REM with usefull tips from Stackoverflow.com board for some uneasy parts of the code
REM Credits for Stopwatch code by Michael Quick, NY (quicksilver.pyc@gmail.com)
@ECHO OFF
pushd "%~dp0"
del timer.txt
del list.txt
del jpgchecklist.txt
del ddschecklist.txt
del missing.inf
cls
set myapp=texconv.exe
set /A texconv1=0
set /A trigger=0
echo.%ch%  
ECHO          VERY FAST DDS CONVERSION SOLUTION 2.5rc1
ECHO     MULTICORE CPU POWERED FOR ATI/AMD/NONCUDA SYSTEMS 
echo.%ch%
echo System informations:
echo CPU cores: %NUMBER_OF_PROCESSORS%
for /F "tokens=* skip=1" %%p in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set GPU_NAME=%%p
echo %GPU_NAME%
echo.%ch%
set /A TOTAL=0
DIR /B *.JPG >list.txt  
for /f %%C in ('Find /V /C "" ^< "list.txt"') do set JPEGs=%%C 
set /A TOTAL=%JPEGs%
set /A ff=11
set /A FF=%JPEGs%*%ff
echo Estimated disk space needed %FF% MB so check your free space
ECHO Conversion started by CPU (minimized in dedicated console) 
TIMEOUT /T 10 >nul
ECHO Conversion Started at %Time% >> timer.txt
REM stopwatch starts here 1 lines
set STARTTIME=%TIME%
REM executing compressor
REM texconv.exe -m 13 -timing -nogpu -f BC1_UNORM *.JPG
REM dont forget to create onlycpunode.cmd
start "CPU compression running.." /MIN onlycpunode.cmd
REM start "Compression on CPU running.." /MIN byCPU.cmd
REM this formula checks timer is active
SET LookForFile=timer.txt
:CheckForFile
color 1E
cls
REM IF EXIST %LookForFile% GOTO FoundIt
IF EXIST %LookForFile% GOTO 0percent
REM If we get here, the file is not found.
ECHO Waiting for conversion start, if takes too long there is an error and hit CTRL+C
TIMEOUT /T 10 >nul
GOTO CheckForFile
REM odtud zacneme nahrazovat progressbar, procedura s timer.txt musi vzdy zustat
REM --------------------------BLUE PROGRESS BAR HERE AS BACKGROUND-------------------------------------
REM :FoundIt
:0percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2 
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: .................... %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM if we hit 25 skip to 25% bar
REM pause
IF %XX% GTR 5 goto 10percent
REM ping -n 1 localhost >nul
REM if we are under 25% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 0percent
:10percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ==.................. %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM if we hit 50 skip to 50% bar
REM pause
REM cls
IF %XX% GTR 10 goto 20percent
REM ping -n 1 localhost >nul
REM if we are under 50% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 10percent
:20percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ====................ %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM if we hit 50 skip to 50% bar
REM pause
REM cls
IF %XX% GTR 20 goto 30percent
REM ping -n 1 localhost >nul
REM if we are under 50% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 20percent
:30percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ======.............. %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 75 skip to 75% bar
REM pause
REM cls
IF %XX% GTR 30 goto 40percent
REM ping -n 1 localhost >nul
REM if we are under 75% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 30percent
:40percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ========............ %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 75 skip to 75% bar
REM pause
REM cls
IF %XX% GTR 40 goto 50percent
REM ping -n 1 localhost >nul
REM if we are under 75% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 40percent
:50percent
cls
REM ping -n 1 localhost >nul
REM timeout /t 1 >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ==========.......... %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 75 skip to 75% bar
REM pause
REM cls
IF %XX% GTR 50 goto 60percent
REM ping -n 1 localhost >nul
REM if we are under 75% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 50percent
:60percent
cls
REM timeout /t 1 >nul
REM ping -n 1 localhost >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ============........ %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 100 skip to 100% bar
REM pause
IF %XX% GTR 60 goto 70percent
REM ping -n 1 localhost >nul
REM if we are under 100% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 60percent
:70percent
cls
REM timeout /t 1 >nul
REM ping -n 1 localhost >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ==============...... %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 100 skip to 100% bar
REM pause
IF %XX% GTR 70 goto 80percent
REM ping -n 1 localhost >nul
REM if we are under 100% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 70percent
:80percent
cls
REM timeout /t 1 >nul
REM ping -n 1 localhost >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ================.... %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 100 skip to 100% bar
REM pause
IF %XX% GTR 80 goto 90percent
REM ping -n 1 localhost >nul
REM if we are under 100% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 80percent
:90percent
cls
REM timeout /t 1 >nul
REM ping -n 1 localhost >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ==================.. %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM ping -n 1 localhost >nul
REM if we hit 100 skip to 100% bar
REM pause
IF %XX% GTR 90 goto 100percent
REM ping -n 1 localhost >nul
REM if we are under 100% wait until we will
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 90percent
:100percent
cls
REM timeout /t 1 >nul
REM ping -n 1 localhost >nul
REM set /A X=0
REM set /A FILES=0
DIR /B *.dds >ddsprogress.txt  
for /f %%H in ('Find /V /C "" ^< "ddsprogress.txt"') do set DDSs=%%H
set /A FILES=%DDSs%
ECHO No. of files processed %FILES%
set /A XX=100*FILES/TOTAL
REM set /A PERCENT=%X%
REM ECHO No of X are %X%
REM pause
REM result example 10=100x1/10 DDS done is 10
REM result example 2
echo.
echo.
echo Converting...
echo ----------------------------------
echo Progress: ==================== %XX%%%
echo ----------------------------------
ping -n 2 localhost >nul
REM pause
IF %XX% EQU 100 goto LASTCHECK1
REM check compressors is running, if not there is error
tasklist | find "%myapp%" > nul
If errorlevel 1 set /A texconv1=2
set /A trigger=%texconv1%
IF %trigger% EQU 2 GOTO LASTCHECK1
GOTO 100percent
:LASTCHECK1
cls
echo.
echo.
echo Waiting for Texconv..
echo ----------------------------------
echo Progress: ==================== 100%%
echo.
echo.
ping -n 2 localhost >nul
tasklist | find "%myapp%" > nul
REM ECHO ERRORLEVEL IS %errorlevel%
If errorlevel 1 set /A texconv1=1 && goto END
REM ECHO %TEXCONV%
REM If errorlevel 1 goto LASTCHECK2
GOTO LASTCHECK1
:END
cls
echo.
echo.
echo Conversion complete...
echo ----------------------------------
echo Progress: ==================== 100%%
echo.
echo.
GOTO CheckCPU
:CheckCPU
color
set CPUDONE=
REM formula gathering times from timer
REM THIS WORKS AND SAVES STRING WITH TIME TO CPUDONE
for /F "delims=" %%Z in ('findstr /I "CPU" timer.txt') do set "CPUDONE=%%Z"
@find /c /i "CPU" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO ALLISDONE
ECHO Waiting for CPU Conversion end, please wait, it can take more than hour
TIMEOUT /T 15 >nul
REM ping -n 2 localhost >nul
GOTO CheckCPU
:ALLISDONE
ECHO ----------------------------------------------------------------------------
REM Checking all is done
for /f %%l in ('Find /V /C "" ^< "timer.txt"') do set DONE=%%l
REM toto pak vypni (echo timer)
REM ECHO timer has %DONE% lines
IF %DONE% EQU 2 ECHO Conversion is DONE
REM IF %DONE% NEQ 6 GOTO :error
IF %DONE% NEQ 2 GOTO :error
for /F "delims=" %%W in ('findstr /I "Started" timer.txt') do set "STARTED=%%W"
@find /c /i "Started" "timer.txt" > NUL
ECHO %STARTED%
ECHO %CPUDONE%
REM stopwatch finish here
set ENDTIME=%TIME%
for /F "tokens=1-4 delims=:.," %%a in ("%STARTTIME%") do (
set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
for /F "tokens=1-4 delims=:.," %%a in ("%ENDTIME%") do (
set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
for /F "tokens=1-4 delims=:.," %%a in ("%ENDTIME%") do ( 
 if %ENDTIME% GTR %STARTTIME% set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
 if %ENDTIME% LSS %STARTTIME% set /A "end=((((%%a+24)*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100" 
 )
set /A elapsed=end-start
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %hh% lss 10 set hh=0%hh%
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
set DURATION=%hh%:%mm%:%ss%,%cc%
ECHO ----------------------------------------------------------------------------
echo Elapsed time: %DURATION% 
ECHO ----------------------------------------------------------------------------
REM stopwatch ended
REM new filecheck algorithm here
ECHO Total JPEGs was %JPEGs%
DIR /B *.dds > finishlist.txt  
for /f %%c in ('Find /V /C "" ^< "finishlist.txt"') do set DDS=%%c
ECHO Total DDS created %DDS%
SETLOCAL ENABLEDELAYEDEXPANSION 
SET "filename0=list.txt"
SET "outfile0=jpgchecklist.txt"
SET "filename1=finishlist.txt"
SET "outfile1=ddschecklist.txt"
REM replace DDS and JPG strings with nothing and saves as new files
(
FOR /f "usebackqdelims=" %%w IN ("%filename0%") DO (
 SET "line=%%w"
 SET "line=!line:.jpg=!"
 ECHO !line!
)
)>"%outfile0%"
(
FOR /f "usebackqdelims=" %%M IN ("%filename1%") DO (
 SET "line=%%M"
 SET "line=!line:.dds=!"
 ECHO !line!
)
)>"%outfile1%"
REM compare the new files and exports result to new file
findstr /vixg:ddschecklist.txt jpgchecklist.txt  >> missing.inf
ECHO -----------------------------------------------------------------------------
echo.%ch%
If %ERRORLEVEL% EQU 1 echo All files converted
If %ERRORLEVEL% EQU 0 echo Warning, some files was not processed due errors, they are listed in missing.inf
ENDLOCAL ENABLEDELAYEDEXPANSION 
REM This is formula for deleting files
:choice
set /P j=should i delete unwanted files[Y/N]?
if /I "%j%" EQU "Y" goto :delete
if /I "%j%" EQU "N" goto :close
goto :choice
:delete
echo "Deleting.."
del *.jpg
del *.exe
del *.dll
del *.txt
del c*.bat
del n*.bat
REM toto pak vypni
pause
exit
:close
echo "You selected NO, exiting and its up to you..."
REM toto pak vypni
pause
REM toto pak zapni
exit
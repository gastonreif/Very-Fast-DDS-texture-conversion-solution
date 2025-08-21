REM This is part of Very Fast DDS Conversion solution utility on x-plane.org 
REM Free to use. Made by Gaston Reif (gastonreif@gmail.com) from scratch 
REM with usefull tips from Stackoverflow.com board for some uneasy parts of the code
REM Credits for Stopwatch code by Michael Quick, NY (quicksilver.pyc@gmail.com)
@ECHO OFF
REM this will prevent using UNC case with current dir in windows folder
pushd "%~dp0"
del timer.txt
del list.txt
del listcpu.txt
del listgpu.txt
del gpunode0.txt
del gpunode1.txt
del gpunode0block1.txt
del gpunode0block2.txt
del gpunode1block1.txt
del gpunode1block2.txt
del jpgchecklist.txt
del ddschecklist.txt
del missing.inf
cls
set myapp=texconv.exe
set myapp2=nvcompress.exe
set /A texconv1=0
set /A nvcompress1=0
set /A trigger=0
echo.%ch%  
ECHO          VERY FAST DDS CONVERSION SOLUTION 2.5rc2
ECHO    HIGH PERFORMANCE COMPUTING VERSION FOR CUDA(4 NODES)
ECHO      USES BOTH CPU AND GPU UNITS AT THE SAME TIME  
echo.%ch%
echo System informations:
echo CPU cores: %NUMBER_OF_PROCESSORS%
REM FOR function allowed only one letter variables
for /F "tokens=* skip=1" %%p in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set GPU_NAME=%%p
echo %GPU_NAME%
echo.%ch%
set /A TOTAL=0
DIR /B *.JPG >list.txt  
for /f %%C in ('Find /V /C "" ^< "list.txt"') do set JPEGs=%%C 
set /A TOTAL=%JPEGs%
ECHO     SPLIT WORK BETWEEN CPU AND GPU BY PERCENTAGE OF FILES TO DO
ECHO     RECOMMENDED PERCENTAGE: (20-60, FIND THE BEST FOR YOUR SYSTEM)
ECHO     60 for TITAN, 1080, 1070, 980
ECHO     50 for 1060, 1050, 960
ECHO     20-40 for others (TOTAL 32 FILES TO RUN IS MINIMUM)
ECHO     IF YOU WANT 100 PERCENT FOR CPU HIT CTRL+C AND USE
ECHO     _CPU_Conversion.cmd, RECOMMENDED FOR AMD/ATI USERS.
ECHO     IF CONVERSION FOR GPU IS RUNNING AND CPU IS DONE
ECHO     YOU NEED TO LOWER THIS NUMBER NEXTIME (CPU IS FASTER)
echo.%ch%
REM echo Little help (dont enter percentage, but number of files as a result from calc)
echo Total files for process: %JPEGs%
set /A ff=11
set /A FF=%JPEGs%*%ff
echo Estimated disk space needed %FF% MB so check your free space
REM set /A e=0
REM set /A EE=0
REM set /A b=2
REM set /A e=%JPEGs%/%b
REM set /A EE=%JPEGs%/(%b*2)
REM echo 50 Percent is %e% for GPU
REM echo 25 Percent is %EE% for GPU
REM start /MIN calc.exe exit
REM echo.%ch%
REM Set /P k=Please enter CPU / GPU Ratio:
Set /P k=Please enter how many %% of files is for GPU processing:
set /A p = 0
REM set /A q = 100
set /A "p=%JPEGs%*(k %% 101)/100"
REM ECHO breakpoint00
REM pause
REM errorcheck for input percentage from the user
If /I %k% LEQ 1 goto :error 
If /I %k% GTR 99 goto :error
REM error check for minimum files
IF %JPEGs% LEQ 16 goto :error
If /I %p% LEQ 16 goto :error
REM function for get half of the files, bigger b means more files to CPU - faster CPU
REM echo Total files for GPU: %p%
REM ECHO breakpoint01
REM pause
REM getting the CPU filelist
for /f "skip=%p%" %%i IN (list.txt) DO @echo %%i >> listcpu.txt
for /f %%D in ('Find /V /C "" ^< "listcpu.txt"') do set JPEGs2=%%D
echo Total files for CPU: %JPEGs2%
echo Process gathering the files started, please wait...    
REM DIFFERENCE BETWEEN LISTS
REM ECHO breakpoint02
REM pause
for /f "delims=" %%g in (list.txt) do (
  find "%%g" <"listcpu.txt" || >>listgpu.txt echo %%g)
ECHO Conversion started from CPU filelist by CPU (minimized)
REM stopwatch starts here 3 lines
REM stopwatch starts here 1 lines
set STARTTIME=%TIME%
echo.%ch% 
start "CPU compression running" /MIN cpunode0.bat
echo.%ch% 
REM CREATING GPU NODES FOR PARALLEL COMPUTING
REM CREATING NODE0and1
set /A o=0
set /A b=2
set /A o=%p%/%b
echo Total files for GPU Node 0: %o%
REM (ted preskoci Pulku GPU a vytvori Node 1 a pak Node 0)
for /f "skip=%o%" %%n IN (listgpu.txt) DO @echo %%n >> gpunode1.txt
for /f %%q in ('Find /V /C "" ^< "gpunode1.txt"') do set Node1=%%q
echo Total files for GPU Node 1: %Node1%
for /f "delims=" %%P in (listgpu.txt) do (
  find "%%P" <"gpunode1.txt" || >>gpunode0.txt echo %%P)
REM ECHO breakpoint02
REM pause
REM CREATING NODE0blocks
REM (ted preskoci Pulku Node 0 a vytvori Block 1 (Node 2)
set /A X=0
set /A b=2
set /A X=%o%/%b
echo Total files for GPU Node 0 block 1: %X%
for /f "skip=%X%" %%t IN (gpunode0.txt) DO @echo %%t >> gpunode0block2.txt
for /f %%d in ('Find /V /C "" ^< "gpunode0block2.txt"') do set Node0block2=%%d
echo Total files for GPU Node 0 block 2: %Node0block2%
for /f "delims=" %%R in (gpunode0.txt) do (
  find "%%R" <"gpunode0block2.txt" || >>gpunode0block1.txt echo %%R)
REM ECHO breakpoint04
REM pause
REM CREATING NODE1blocks
REM (ted preskoci Pulku Node 1 a vytvori Block 1 (Node 4)
set /A Y=0
set /A b=2
set /A Y=%o%/%b
echo Total files for GPU Node 1 block 1: %Y%
for /f "skip=%Y%" %%u IN (gpunode1.txt) DO @echo %%u >> gpunode1block2.txt
for /f %%E in ('Find /V /C "" ^< "gpunode1block2.txt"') do set Node1block2=%%E
echo Total files for GPU Node 1 block 2: %Node1block2%
for /f "delims=" %%S in (gpunode1.txt) do (
  find "%%S" <"gpunode1block2.txt" || >>gpunode1block1.txt echo %%S)
REM ECHO breakpoint05
REM pause
ECHO Conversion started by GPU (minimized in four dedicated consoles) 
ECHO Conversion Started at %Time% >> timer.txt
start "NODE0 on GPU running" /MIN node0.bat
start "NODE1 on GPU running" /MIN node1.bat
start "NODE2 on GPU running" /MIN node2.bat
start "NODE3 on GPU running" /MIN node3.bat
REM ECHO breakpoint06
REM pause
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
tasklist | find "%myapp2%" > nul
If errorlevel 1 set /A nvcompress1=2
set /A trigger=%texconv1%+%nvcompress1%
IF %trigger% EQU 4 GOTO LASTCHECK1
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
If errorlevel 1 set /A texconv1=1 && goto LASTCHECK2
REM ECHO %TEXCONV%
REM If errorlevel 1 goto LASTCHECK2
GOTO LASTCHECK1
:LASTCHECK2
cls
echo.
echo.
echo Waiting for Nvcompress...
echo ----------------------------------
echo Progress: ==================== 100%%
echo.
echo.
ping -n 2 localhost >nul
tasklist | find "%myapp2%" > nul
REM ECHO ERRORLEVEL IS %errorlevel%
If errorlevel 1 set /A nvcompress1=1 && goto LASTCHECK3
REM tasklist | find "%myapp2%" > %NVCOMPRESS
REM ECHO %NVCOMPRESS% 
REM If errorlevel 1 goto installcomplete
REM If errorlevel 1 goto LASTCHECK3
GOTO LASTCHECK2
:LASTCHECK3
cls
REM if both are 1 means ended goto end
IF %texconv1% EQU %nvcompress1% GOTO END
ECHO waiting for compressors being unloaded from memory
ping -n 2 localhost >nul
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
if %ERRORLEVEL% EQU 0 GOTO CheckGPU0
ECHO Waiting for CPU Conversion end, please wait, it can take more than hour
TIMEOUT /T 1 >nul
REM ping -n 2 localhost >nul
GOTO CheckCPU
:CheckGPU0
set GPUDONE0=
REM formula gathering times from timer for GPU0
for /F "delims=" %%m in ('findstr /I "NODE0" timer.txt') do set "GPUDONE0=%%m"
@find /c /i "NODE0" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU1
REM If we get here, the file is not found.
ECHO Waiting for GPU Node 0 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU0
:CheckGPU1
set GPUDONE1=
REM formula gathering times from timer for GPU1
for /F "delims=" %%n in ('findstr /I "NODE1" timer.txt') do set "GPUDONE1=%%n"
@find /c /i "NODE1" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU2
REM If we get here, the file is not found.
ECHO Waiting for GPU Node 1 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU1
:CheckGPU2
set GPUDONE2=
REM formula gathering times from timer for GPU2
for /F "delims=" %%O in ('findstr /I "NODE2" timer.txt') do set "GPUDONE2=%%O"
@find /c /i "NODE2" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU3
REM If we get here, the file is not found.
ECHO Waiting for GPU Node 2 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU2
:CheckGPU3
set GPUDONE3=
REM formula gathering times from timer for GPU3
for /F "delims=" %%Q in ('findstr /I "NODE3" timer.txt') do set "GPUDONE3=%%Q"
@find /c /i "NODE3" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO ALLISDONE
REM If we get here, the file is not found.
ECHO Waiting for GPU Node 3 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU3
:ALLISDONE
ECHO ----------------------------------------------------------------------------
REM Checking all is done
for /f %%l in ('Find /V /C "" ^< "timer.txt"') do set DONE=%%l
REM toto pak vypni (echo timer)
REM ECHO timer has %DONE% lines
IF %DONE% EQU 6 ECHO Conversion is DONE
REM IF %DONE% NEQ 6 GOTO :error
IF %DONE% LSS 6 GOTO :error
for /F "delims=" %%W in ('findstr /I "Started" timer.txt') do set "STARTED=%%W"
@find /c /i "Started" "timer.txt" > NUL
ECHO %STARTED%
ECHO %CPUDONE%
ECHO %GPUDONE0%
ECHO %GPUDONE1%
ECHO %GPUDONE2%
ECHO %GPUDONE3%
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
set /A RATIO=0
set /A RATIO=100-%k%
ECHO CPU/GPU ratio was %RATIO% : %k%
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
echo.%ch%
set /P j=Should i delete unwanted files[Y/N]?
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
del g*.cmd
del c*.cmd
del o*.cmd
pause
exit 
:close
echo You selected NO, exiting and its up to you...
pause
exit 
:error
echo Error occured, check txt files for missing data
pause
exit 






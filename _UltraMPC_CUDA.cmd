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
del gpunodeA.txt
del gpunodeB.txt
del gnodeA0.txt
del gnodeA1.txt
del gnodeB0.txt
del gnodeB1.txt
del jpgchecklist.txt
del ddschecklist.txt
del MPP0bL1.txt
del MPP0bL2.txt
del MPP1bL1.txt
del MPP1bL2.txt
del MPP2bL1.txt
del MPP2bL2.txt
del MPP3bL1.txt
del MPP3bL2.txt
del cuda0mpp0bL1.txt
del cuda0mpp0bL2.txt
del cuda0mpp0bL3.txt
del cuda0mpp0bL4.txt
del cuda0mpp1bL1.txt
del cuda0mpp1bL2.txt
del cuda0mpp1bL3.txt
del cuda0mpp1bL4.txt
del cuda0mpp2bL1.txt
del cuda0mpp2bL2.txt
del cuda0mpp2bL3.txt
del cuda0mpp2bL4.txt
del cuda0mpp3bL1.txt
del cuda0mpp3bL2.txt
del cuda0mpp3bL3.txt
del cuda0mpp3bL4.txt
del missing.inf
cls
set myapp=texconv.exe
set myapp2=nvcompress.exe
set /A texconv1=0
set /A nvcompress1=0
set /A trigger=0
echo.%ch%  
ECHO          VERY FAST DDS CONVERSION SOLUTION 2.5rc2
ECHO    MASSIVE PARALLEL COMPUTING VERSION FOR CUDA (16 NODES)
ECHO      USES BOTH CPU AND GPU UNITS AT THE SAME TIME  
echo.%ch%
echo System informations:
echo CPU cores: %NUMBER_OF_PROCESSORS%
If /I %NUMBER_OF_PROCESSORS% LEQ 16 ECHO WARNING, MINIMUM CPU CORES ARE 16, YOUR SYSTEM CAN BE VERY OVERLOADED!
If /I %NUMBER_OF_PROCESSORS% LEQ 16 ECHO HIT SPACE TO CONTINUE OR CTRL+C TO QUIT AND RUN RATHER _MPC_CUDA.cmd
If /I %NUMBER_OF_PROCESSORS% LEQ 16 pause
REM FOR function allowed only one letter variables
for /F "tokens=* skip=1" %%p in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set GPU_NAME=%%p
echo %GPU_NAME%
echo.%ch%
set /A TOTAL=0
DIR /B *.JPG >list.txt  
for /f %%C in ('Find /V /C "" ^< "list.txt"') do set JPEGs=%%C 
set /A TOTAL=%JPEGs%
ECHO     SPLIT WORK BETWEEN CPU AND GPU BY PERCENTAGE OF FILES TO DO
ECHO     RECOMMENDED PERCENTAGE: (GPU 50-80, FIND THE BEST FOR YOUR SYSTEM)
ECHO     80 for TITAN, 2080, 2070, 1080, 1070, 980 including Ti models
ECHO     70 for 1060, 1050, 960
ECHO     50-60 for others (TOTAL 64 FILES TO RUN IS MINIMUM)
ECHO     IF YOU WANT 100 PERCENT FOR CPU HIT CTRL+C AND USE
ECHO     _CPU_Conversion.cmd, WHICH IS RECOMMENDED FOR AMD/ATI USERS.
ECHO     IF CONVERSION FOR GPU IS STILL RUNNING AND CPU IS DONE
ECHO     YOU NEED TO LOWER THIS NUMBER NEXTIME (CPU IS FASTER)
ECHO     -----------------------------------------------------------------
ECHO     / CHECKLIST-VERY IMPORTANT! hit spacebar every step to continue /
ECHO     / Before starting the conversion ensure you have set            /
ECHO     / 1. CPU and GPU Temperature monitoring ON                      /
ECHO     /    (Nvidia inspector, HW monitor, cpu-z, gpu-z etc.)
pause
ECHO     / 2. CPU and GPU Usage monitors are displayed in background     /
ECHO     /    (task monitor, lasso, cpu-z etc.)
pause
ECHO     / 3. CPU and GPU coolers are running high or can be adjusted    /
pause
ECHO     / 4. CPU and GPU resources are free from other application usage/
pause
ECHO     / last if something goes wrong hit CTRL-C and kill black nodes  /
pause
ECHO     / ..scheduler starting in 5 seconds                            /
ECHO     -----------------------------------------------------------------
TIMEOUT /T 5 >nul
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
IF %JPEGs% LEQ 64 goto :error
If /I %p% LEQ 63 goto :error
REM function for get half of the files, bigger b means more files to CPU - faster CPU
REM echo Total files for GPU: %p%
REM ECHO breakpoint00
REM pause
REM getting the CPU filelist
for /f "skip=%p%" %%i IN (list.txt) DO @echo %%i >> listcpu.txt
for /f %%D in ('Find /V /C "" ^< "listcpu.txt"') do set JPEGs2=%%D
echo Total files for CPU: %JPEGs2%
echo Process gathering the files started, please wait...    
REM DIFFERENCE BETWEEN LISTS
for /f "delims=" %%g in (list.txt) do (
  find "%%g" <"listcpu.txt" || >>listgpu.txt echo %%g)
ECHO Conversion started from CPU filelist by CPU (minimized)
REM stopwatch starts here 1 lines
set STARTTIME=%TIME%
ECHO Conversion Started at %Time% >> timer.txt
REM breakpoint for testing percentage formula
REM ECHO breakpoint0
REM pause
echo.%ch% 
start "CPU compression running" /MIN cpunode0.bat
echo.%ch% 
REM CREATING GPU NODES FOR PARALLEL COMPUTING
REM MODEL 				NODE LEFT NODE RIGHT
REM                NODE A NODE B      NODE C NODE D
REM  GNODEA0 GNODEA1 GNODEB0 GNODEB1  reserved unused unused unused 
REM FOR GNODEA0 MPP0bL1 MPP0bL2    
REM FOR  MPP0bL1 cuda0mpp0bL1 cuda0mpp0bL2         CUDA 0,1
REM FOR  MPP0bL2 cuda0mpp0bL3 cuda0mpp0bL4         CUDA 2,3
REM FOR GNODEA1 MPP1bL1 MPP1bL2
REM FOR  MPP1bL1 cuda0mpp1bL1 cuda0mpp1bL2         CUDA 4,5
REM FOR  MPP1bL2 cuda0mpp1bL3 cuda0mpp1bL4         CUDA 6,7
REM FOR GNODEB0 MPP2bL1 MPP2bL2
REM FOR  MPP2bL1 cuda0mpp2bL1 cuda0mpp2bL2         CUDA 8,9
REM FOR  MPP2bL2 cuda0mpp2bL3 cuda0mpp2bL4         CUDA 10,11
REM FOR GNODEB1 MPP3bL1 MPP3bL2
REM FOR  MPP3bL1 cuda0mpp3bL1 cuda0mpp3bL2         CUDA 12,13
REM FOR  MPP3bL2 cuda0mpp3bL3 cuda0mpp3bL4         CUDA 14,15
REM nodes C and D reserved for future experimental use
REM CREATING NODE A and B
set /A o=0
set /A b=2
set /A o=%p%/%b
echo Total files for GPU Node A: %o%
REM (ted preskoci Pulku GPU a vytvori Node B a pak Node A)
REM ECHO breakpoint1
REM pause
for /f "skip=%o%" %%n IN (listgpu.txt) DO @echo %%n >> gpunodeB.txt
for /f %%q in ('Find /V /C "" ^< "gpunodeB.txt"') do set NodeB=%%q
echo Total files for GPU Node B: %NodeB%
for /f "delims=" %%P in (listgpu.txt) do (
  find "%%P" <"gpunodeB.txt" || >>gpunodeA.txt echo %%P)
REM CREATING NODE A gnodes 0 and 1
set /A Z=0
set /A a=2
set /A Z=%o%/%a
echo Total files for GPU Node A subnode 0: %Z%
REM (ted preskoci Pulku Node A a vytvori gnodeA1 a pak gnodeA0)
REM ECHO breakpoint2
REM pause
for /f "skip=%Z%" %%q IN (gpunodeA.txt) DO @echo %%q >> gnodeA1.txt
for /f %%C in ('Find /V /C "" ^< "gnodeA1.txt"') do set NodeA1=%%C
echo Total files for GPU Node A subnode 1: %NodeA1%
for /f "delims=" %%R in (gpunodeA.txt) do (
  find "%%R" <"gnodeA1.txt" || >>gnodeA0.txt echo %%R)
REM CREATING Massive Parallel Processors blocks on Node A0
REM (ted preskoci Pulku Node A0 a vytvori MPP0Block2 a pak MPP0Block1
set /A X=0
set /A b=2
set /A X=%Z%/%b
echo Total files for GPU Node A0 MPP Block 1: %X%
REM ECHO breakpoint3
REM pause
for /f "skip=%X%" %%t IN (gnodeA0.txt) DO @echo %%t >> MPP0bL2.txt
for /f %%d in ('Find /V /C "" ^< "MPP0bL2.txt"') do set MPP0bL2=%%d
echo Total files for GPU Node A0 MPP Block 2: %MPP0bL2%
for /f "delims=" %%s in (gnodeA0.txt) do (
  find "%%s" <"MPP0bL2.txt" || >>MPP0bL1.txt echo %%s)
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 1 on Node A0
REM (ted preskoci Pulku MPP0Block1 a vytvori cuda0mpp0bL2 a pak cuda0mpp0bL1 (CUDA1,CUDA0)
set /A Y=0
set /A b=2
set /A Y=%X%/%b
echo Total files for CUDA core 0 on GPU Node A0 MPP Block 1: %Y%
REM ECHO breakpoint4
REM pause
for /f "skip=%Y%" %%T IN (MPP0bL1.txt) DO @echo %%T >> cuda0mpp0bL2.txt
for /f %%D in ('Find /V /C "" ^< "cuda0mpp0bL2.txt"') do set cuda0mpp0bL2=%%D
echo Total files for CUDA core 1 on GPU Node A0 MPP Block 1: %cuda0mpp0bL2%
for /f "delims=" %%S in (MPP0bL1.txt) do (
  find "%%S" <"cuda0mpp0bL2.txt" || >>cuda0mpp0bL1.txt echo %%S)
REM use these txt as nvcompress sources
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 2 on Node A0
REM (ted preskoci Pulku MPP0Block2 a vytvori cuda0mpp0bL4 a pak cuda0mpp0bL3 (CUDA3,CUDA2)
set /A A=0
set /A b=2
set /A A=%X%/%b
echo Total files for CUDA core 2 on GPU Node A0 MPP Block 2: %A%
REM ECHO breakpoint5
REM pause
for /f "skip=%A%" %%a IN (MPP0bL2.txt) DO @echo %%a >> cuda0mpp0bL4.txt
for /f %%e in ('Find /V /C "" ^< "cuda0mpp0bL4.txt"') do set cuda0mpp0bL4=%%e
echo Total files for CUDA core 3 on GPU Node A0 MPP Block 2: %cuda0mpp0bL4%
for /f "delims=" %%F in (MPP0bL2.txt) do (
  find "%%F" <"cuda0mpp0bL4.txt" || >>cuda0mpp0bL3.txt echo %%F)
REM first CUDA QUADRANT DONE
REM CREATING Massive Parallel Processors blocks on Node A1
REM (ted preskoci Pulku Node A1 a vytvori MPP1Block2 a pak MPP1Block1
set /A X=0
set /A b=2
set /A X=%Z%/%b
echo Total files for GPU Node A1 MPP Block 1: %X%
REM ECHO breakpoint6
REM pause
for /f "skip=%X%" %%t IN (gnodeA1.txt) DO @echo %%t >> MPP1bL2.txt
for /f %%d in ('Find /V /C "" ^< "MPP1bL2.txt"') do set MPP1bL2=%%d
echo Total files for GPU Node A1 MPP Block 2: %MPP1bL2%
for /f "delims=" %%s in (gnodeA1.txt) do (
  find "%%s" <"MPP1bL2.txt" || >>MPP1bL1.txt echo %%s)
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 1 on Node A1
REM (ted preskoci Pulku MPP1Block1 a vytvori cuda0mpp1bL2 a pak cuda0mpp1bL1 (CUDA5,CUDA4)
set /A Y=0
set /A b=2
set /A Y=%X%/%b
echo Total files for CUDA core 4 on GPU Node A1 MPP Block 1: %Y%
REM ECHO breakpoint7
REM pause
for /f "skip=%Y%" %%T IN (MPP1bL1.txt) DO @echo %%T >> cuda0mpp1bL2.txt
for /f %%D in ('Find /V /C "" ^< "cuda0mpp1bL2.txt"') do set cuda0mpp1bL2=%%D
echo Total files for CUDA core 5 on GPU Node A1 MPP Block 1: %cuda0mpp1bL2%
for /f "delims=" %%S in (MPP1bL1.txt) do (
  find "%%S" <"cuda0mpp1bL2.txt" || >>cuda0mpp1bL1.txt echo %%S)
REM use these txt as nvcompress sources
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 2 on Node A1
REM (ted preskoci Pulku MPP1Block2 a vytvori cuda0mpp1bL4 a pak cuda0mpp1bL3 (CUDA7,CUDA6)
set /A A=0
set /A b=2
set /A A=%X%/%b
echo Total files for CUDA core 6 on GPU Node A1 MPP Block 2: %A%
REM ECHO breakpoint8
REM pause
for /f "skip=%A%" %%a IN (MPP1bL2.txt) DO @echo %%a >> cuda0mpp1bL4.txt
for /f %%e in ('Find /V /C "" ^< "cuda0mpp1bL4.txt"') do set cuda0mpp1bL4=%%e
echo Total files for CUDA core 7 on GPU Node A1 MPP Block 2: %cuda0mpp1bL4%
for /f "delims=" %%F in (MPP1bL2.txt) do (
  find "%%F" <"cuda0mpp1bL4.txt" || >>cuda0mpp1bL3.txt echo %%F)
REM second CUDA QUADRANT DONE
REM CREATING NODE B gnodes 0 and 1
set /A Z=0
set /A a=2
set /A Z=%o%/%a
echo Total files for GPU Node B subnode 0: %Z%
REM (ted preskoci Pulku Node B a vytvori gnodeB1 a pak gnodeB0)
REM ECHO breakpoint9
REM pause
for /f "skip=%Z%" %%q IN (gpunodeB.txt) DO @echo %%q >> gnodeB1.txt
for /f %%C in ('Find /V /C "" ^< "gnodeB1.txt"') do set NodeB1=%%C
echo Total files for GPU Node B subnode 1: %NodeB1%
for /f "delims=" %%R in (gpunodeB.txt) do (
  find "%%R" <"gnodeB1.txt" || >>gnodeB0.txt echo %%R)
REM CREATING Massive Parallel Processors blocks on Node B0
REM (ted preskoci Pulku Node B0 a vytvori MPP2Block2 a pak MPP2Block1
set /A X=0
set /A b=2
set /A X=%Z%/%b
echo Total files for GPU Node B0 MPP Block 1: %X%
REM ECHO breakpoint10
REM pause
for /f "skip=%X%" %%t IN (gnodeB0.txt) DO @echo %%t >> MPP2bL2.txt
for /f %%d in ('Find /V /C "" ^< "MPP2bL2.txt"') do set MPP2bL2=%%d
echo Total files for GPU Node B0 MPP Block 2: %MPP2bL2%
for /f "delims=" %%s in (gnodeB0.txt) do (
  find "%%s" <"MPP2bL2.txt" || >>MPP2bL1.txt echo %%s)
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 1 on Node B0
REM (ted preskoci Pulku MPP2Block1 a vytvori cuda0mpp2bL2 a pak cuda0mpp2bL1 (CUDA9,CUDA8)
set /A Y=0
set /A b=2
set /A Y=%X%/%b
echo Total files for CUDA core 8 on GPU Node B0 MPP Block 1: %Y%
REM ECHO breakpoint11
REM pause
for /f "skip=%Y%" %%T IN (MPP2bL1.txt) DO @echo %%T >> cuda0mpp2bL2.txt
for /f %%D in ('Find /V /C "" ^< "cuda0mpp2bL2.txt"') do set cuda0mpp2bL2=%%D
echo Total files for CUDA core 9 on GPU Node B0 MPP Block 1: %cuda0mpp2bL2%
for /f "delims=" %%S in (MPP2bL1.txt) do (
  find "%%S" <"cuda0mpp2bL2.txt" || >>cuda0mpp2bL1.txt echo %%S)
REM use these txt as nvcompress sources
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 2 on Node B0
REM (ted preskoci Pulku MPP2Block2 a vytvori cuda0mpp2bL4 a pak cuda0mpp2bL3 (CUDA11,CUDA10)
set /A A=0
set /A b=2
set /A A=%X%/%b
echo Total files for CUDA core 10 on GPU Node B0 MPP Block 2: %A%
REM ECHO breakpoint12
REM pause
for /f "skip=%A%" %%a IN (MPP2bL2.txt) DO @echo %%a >> cuda0mpp2bL4.txt
for /f %%e in ('Find /V /C "" ^< "cuda0mpp2bL4.txt"') do set cuda0mpp2bL4=%%e
echo Total files for CUDA core 11 on GPU Node B0 MPP Block 2: %cuda0mpp2bL4%
for /f "delims=" %%F in (MPP2bL2.txt) do (
  find "%%F" <"cuda0mpp2bL4.txt" || >>cuda0mpp2bL3.txt echo %%F)
REM third CUDA QUADRANT DONE
REM CREATING Massive Parallel Processors blocks on Node B1
REM (ted preskoci Pulku Node B1 a vytvori MPP3Block2 a pak MPP3Block1
set /A X=0
set /A b=2
set /A X=%Z%/%b
echo Total files for GPU Node B1 MPP Block 1: %X%
REM ECHO breakpoint13
REM pause
for /f "skip=%X%" %%t IN (gnodeB1.txt) DO @echo %%t >> MPP3bL2.txt
for /f %%d in ('Find /V /C "" ^< "MPP3bL2.txt"') do set MPP3bL2=%%d
echo Total files for GPU Node B1 MPP Block 2: %MPP3bL2%
for /f "delims=" %%s in (gnodeB1.txt) do (
  find "%%s" <"MPP3bL2.txt" || >>MPP3bL1.txt echo %%s)
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 1 on Node B1
REM (ted preskoci Pulku MPP3Block1 a vytvori cuda0mpp3bL2 a pak cuda0mpp3bL1 (CUDA13,CUDA12)
set /A Y=0
set /A b=2
set /A Y=%X%/%b
echo Total files for CUDA core 12 on GPU Node B1 MPP Block 1: %Y%
REM ECHO breakpoint14
REM pause
for /f "skip=%Y%" %%T IN (MPP3bL1.txt) DO @echo %%T >> cuda0mpp3bL2.txt
for /f %%D in ('Find /V /C "" ^< "cuda0mpp3bL2.txt"') do set cuda0mpp3bL2=%%D
echo Total files for CUDA core 13 on GPU Node B1 MPP Block 1: %cuda0mpp3bL2%
for /f "delims=" %%S in (MPP3bL1.txt) do (
  find "%%S" <"cuda0mpp3bL2.txt" || >>cuda0mpp3bL1.txt echo %%S)
REM use these txt as nvcompress sources
REM CREATING Cuda cores on Massive Parallel Processors blocks Level 2 on Node B1
REM (ted preskoci Pulku MPP3Block2 a vytvori cuda0mpp3bL4 a pak cuda0mpp3bL3 (CUDA15,CUDA14)
set /A A=0
set /A b=2
set /A A=%X%/%b
echo Total files for CUDA core 14 on GPU Node B1 MPP Block 2: %A%
REM ECHO breakpoint15
REM pause
for /f "skip=%A%" %%a IN (MPP3bL2.txt) DO @echo %%a >> cuda0mpp3bL4.txt
for /f %%e in ('Find /V /C "" ^< "cuda0mpp3bL4.txt"') do set cuda0mpp3bL4=%%e
echo Total files for CUDA core 15 on GPU Node B1 MPP Block 2: %cuda0mpp3bL4%
for /f "delims=" %%F in (MPP3bL2.txt) do (
  find "%%F" <"cuda0mpp3bL4.txt" || >>cuda0mpp3bL3.txt echo %%F)
REM fourth CUDA QUADRANT DONE
REM ECHO breakpoint16
REM pause
REM pause
ECHO Conversion started by GPU (minimized in eight dedicated consoles) 
REM ECHO Conversion Started at %Time% >> timer.txt
start "CUDA0 on GPU running" /MIN cuda0.cmd
start "CUDA1 on GPU running" /MIN cuda1.cmd
start "CUDA2 on GPU running" /MIN cuda2.cmd
start "CUDA3 on GPU running" /MIN cuda3.cmd
start "CUDA4 on GPU running" /MIN cuda4.cmd
start "CUDA5 on GPU running" /MIN cuda5.cmd
start "CUDA6 on GPU running" /MIN cuda6.cmd
start "CUDA7 on GPU running" /MIN cuda7.cmd
start "CUDA8 on GPU running" /MIN cuda8.cmd
start "CUDA9 on GPU running" /MIN cuda9.cmd
start "CUDA10 on GPU running" /MIN cuda10.cmd
start "CUDA11 on GPU running" /MIN cuda11.cmd
start "CUDA12 on GPU running" /MIN cuda12.cmd
start "CUDA13 on GPU running" /MIN cuda13.cmd
start "CUDA14 on GPU running" /MIN cuda14.cmd
start "CUDA15 on GPU running" /MIN cuda15.cmd
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
for /F "delims=" %%m in ('findstr /I "CUDA00" timer.txt') do set "GPUDONE0=%%m"
@find /c /i "CUDA00" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU1
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 0 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU0
:CheckGPU1
set GPUDONE1=
REM formula gathering times from timer for GPU1
for /F "delims=" %%n in ('findstr /I "CUDA01" timer.txt') do set "GPUDONE1=%%n"
@find /c /i "CUDA01" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU2
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 1 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU1
:CheckGPU2
set GPUDONE2=
REM formula gathering times from timer for GPU2
for /F "delims=" %%O in ('findstr /I "CUDA02" timer.txt') do set "GPUDONE2=%%O"
@find /c /i "CUDA02" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU3
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 2 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU2
:CheckGPU3
set GPUDONE3=
REM formula gathering times from timer for GPU3
for /F "delims=" %%Q in ('findstr /I "CUDA03" timer.txt') do set "GPUDONE3=%%Q"
@find /c /i "CUDA03" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU4
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 3 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU3
:CheckGPU4
set GPUDONE4=
REM formula gathering times from timer for GPU4
for /F "delims=" %%m in ('findstr /I "CUDA04" timer.txt') do set "GPUDONE4=%%m"
@find /c /i "CUDA04" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU5
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 4 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU4
:CheckGPU5
set GPUDONE5=
REM formula gathering times from timer for GPU5
for /F "delims=" %%n in ('findstr /I "CUDA05" timer.txt') do set "GPUDONE5=%%n"
@find /c /i "CUDA05" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU6
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 5 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU5
:CheckGPU6
set GPUDONE6=
REM formula gathering times from timer for GPU6
for /F "delims=" %%O in ('findstr /I "CUDA06" timer.txt') do set "GPUDONE6=%%O"
@find /c /i "CUDA06" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU7
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 6 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU6
:CheckGPU7
set GPUDONE7=
REM formula gathering times from timer for GPU7
for /F "delims=" %%Q in ('findstr /I "CUDA07" timer.txt') do set "GPUDONE7=%%Q"
@find /c /i "CUDA07" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU8
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 7 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU7
:CheckGPU8
set GPUDONE8=
REM formula gathering times from timer for GPU8
for /F "delims=" %%m in ('findstr /I "CUDA08" timer.txt') do set "GPUDONE8=%%m"
@find /c /i "CUDA08" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU9
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 8 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU8
:CheckGPU9
set GPUDONE9=
REM formula gathering times from timer for GPU9
for /F "delims=" %%n in ('findstr /I "CUDA09" timer.txt') do set "GPUDONE9=%%n"
@find /c /i "CUDA09" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU10
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 9 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU9
:CheckGPU10
set GPUDONE10=
REM formula gathering times from timer for GPU10
for /F "delims=" %%O in ('findstr /I "CUDA10" timer.txt') do set "GPUDONE10=%%O"
@find /c /i "CUDA10" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU11
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 10 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU10
:CheckGPU11
set GPUDONE11=
REM formula gathering times from timer for GPU11
for /F "delims=" %%Q in ('findstr /I "CUDA11" timer.txt') do set "GPUDONE11=%%Q"
@find /c /i "CUDA11" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU12
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 11 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU11
:CheckGPU12
set GPUDONE12=
REM formula gathering times from timer for GPU12
for /F "delims=" %%m in ('findstr /I "CUDA12" timer.txt') do set "GPUDONE12=%%m"
@find /c /i "CUDA12" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU13
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 12 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU12
:CheckGPU13
set GPUDONE13=
REM formula gathering times from timer for GPU13
for /F "delims=" %%n in ('findstr /I "CUDA13" timer.txt') do set "GPUDONE13=%%n"
@find /c /i "CUDA13" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU14
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 13 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU13
:CheckGPU14
set GPUDONE14=
REM formula gathering times from timer for GPU14
for /F "delims=" %%O in ('findstr /I "CUDA14" timer.txt') do set "GPUDONE14=%%O"
@find /c /i "CUDA14" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO CheckGPU15
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 14 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU14
:CheckGPU15
set GPUDONE15=
REM formula gathering times from timer for GPU15
for /F "delims=" %%Q in ('findstr /I "CUDA15" timer.txt') do set "GPUDONE15=%%Q"
@find /c /i "CUDA15" "timer.txt" > NUL
REM ERRORLEVEL0 IS SUCCESS
if %ERRORLEVEL% EQU 0 GOTO ALLISDONE
REM If we get here, the file is not found.
ECHO Waiting for GPU CUDA 15 Conversion end, please wait, it can take some time
TIMEOUT /T 1 >nul
GOTO CheckGPU15
:ALLISDONE
ECHO ----------------------------------------------------------------------------
REM Checking all is done
for /f %%l in ('Find /V /C "" ^< "timer.txt"') do set DONE=%%l
REM toto pak vypni (echo timer)
REM ECHO timer has %DONE% lines
IF %DONE% EQU 18 ECHO Conversion is DONE
REM IF %DONE% NEQ 10 GOTO :error
IF %DONE% LSS 18 GOTO :error
for /F "delims=" %%W in ('findstr /I "Started" timer.txt') do set "STARTED=%%W"
@find /c /i "Started" "timer.txt" > NUL
ECHO %STARTED%
ECHO %CPUDONE%
ECHO %GPUDONE0%
ECHO %GPUDONE1%
ECHO %GPUDONE2%
ECHO %GPUDONE3%
ECHO %GPUDONE4%
ECHO %GPUDONE5%
ECHO %GPUDONE6%
ECHO %GPUDONE7%
ECHO %GPUDONE8%
ECHO %GPUDONE9%
ECHO %GPUDONE10%
ECHO %GPUDONE11%
ECHO %GPUDONE12%
ECHO %GPUDONE13%
ECHO %GPUDONE14%
ECHO %GPUDONE15%
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






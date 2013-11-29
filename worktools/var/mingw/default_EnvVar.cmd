@echo off

rem if not "x%PROCESSOR_ARCHITECTURE%" == "xAMD64" goto _NotX64
rem set COMSPEC=%WINDIR%\SysWOW64\cmd.exe
rem %COMSPEC% /c %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
rem :_NotX64
rem set MSYSCON=sh.exe
rem set MSYSTEM=MINGW32

set CC=gcc
set CXX=g++
set MAKE_TOOL=mingw32-make
set /a JOB_COUNT=%NUMBER_OF_PROCESSORS%+1
set WORK_DISK=C
set WORK_DIR=%WORK_DISK%:\worktools
set LIB_SRC_DIR=%WORK_DIR%\libsources
set PROJECT=%WORK_DIR%\project
set BUILD_DIR=%WORK_DIR%\build
set MSYS_PATH=%WORK_DIR%\msys
set LIB_DIR=%WORK_DIR%\libs
set VAR_DIR=%WORK_DIR%\var\mingw


set MWORK_DIR=/%WORK_DISK%/worktools
set MMSYS_PATH=%MWORK_DIR%/msys
set MMLIB_SRC_DIR=%MWORK_DIR%/libsources
set MPROJECT=%MWORK_DIR%/project
set MBUILD_DIR=%MWORK_DIR%/build
set MLIB_DIR=%MWORK_DIR%/libs
set MVAR_DIR=%MWORK_DIR%/var/mingw

set PLBITS=%~1
if "PLBITS" == "" set PLBITS=32 
set MARCH_TUNE=-m32 -march=i686
if "%PLBITS%" == "64" set MARCH_TUNE=-m64 -march=x86-64 -msse3

set LIB_DIR=%LIB_DIR%\x%PLBITS%\shared\mingw
set MLIB_DIR=%MLIB_DIR%/x%PLBITS%/shared/mingw
set COMPILE_DIR=%WORK_DIR%\mingw_x%PLBITS%

set MARCH_TUNE=%MARCH_TUNE% -mtune=core2
set MARCH_TUNE=%MARCH_TUNE% -mcx16
set MARCH_TUNE=%MARCH_TUNE% -msahf
set MARCH_TUNE=%MARCH_TUNE% -mfpmath=sse+387
set MARCH_TUNE=%MARCH_TUNE% -mmmx
set MARCH_TUNE=%MARCH_TUNE% -msse2
set MARCH_TUNE=%MARCH_TUNE% -mms-bitfields
set MARCH_TUNE=%MARCH_TUNE% -mpe-aligned-commons
set MARCH_TUNE=%MARCH_TUNE% -malign-double

set MARCH_OPTIMAZE=-O3
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fms-extensions
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -frename-registers
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fomit-frame-pointer
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fno-align-functions
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fno-align-jumps
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fno-align-labels
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fno-align-loops
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wl,-flto
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -flto
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wall
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wl,--as-needed
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wl,--strip-all
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fno-asynchronous-unwind-tables
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -fdata-sections
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -ffunction-sections
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wl,--gc-sections
set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -Wno-unused-local-typedefs
if "%PLBITS%" == "32" set set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -D_WIN32_WINNT=0x0500 -DWINVER=0x0500
rem set MARCH_OPTIMAZE=%MARCH_OPTIMAZE% -pipe

set CFLAGS=%MARCH_TUNE% %MARCH_OPTIMAZE%

set CXXFLAGS=%MARCH_TUNE% %MARCH_OPTIMAZE% 
rem -fexceptions
set CXXFLAGS=%CXXFLAGS% -fvisibility-ms-compat
set CXXFLAGS=%CXXFLAGS% -ftemplate-depth-256
rem set CXXFLAGS=%CXXFLAGS% -U__STRICT_ANSI__
set CXXFLAGS=%CXXFLAGS% -std=c++0x


call :set_values zlib
call :set_values lpng
call :set_values icu
call :set_values sqlite
call :set_values openssl
call :set_values Qt
call :set_values boost
call :set_values log4cplus
call :set_values postgree


set INCLUDE=%MYINCLUDE%;%INCLUDE%
set PATH=%COMPILE_DIR%\bin;%MYBIN%;%PATH%;%WORK_DIR%\tools\bin;%WORK_DIR%\tools\python;%WORK_DIR%\tools\ruby\bin;
set CPATH=%CPATH%;%INCLUDE%
set LIBRARY_PATH=%LIBRARY_PATH%;%MYLIB%
set LIB=%LIB%;%LIBRARY_PATH%

exit /b 

:set_values
set name=%~1
set %name%DIR=%LIB_DIR%\%name%
set MYINCLUDE=%MYINCLUDE%;%LIB_DIR%\%name%\include
set MYBIN=%MYBIN%;%LIB_DIR%\%name%\bin
set MYLIB=%MYLIB%;%LIB_DIR%\%name%\lib
exit /b
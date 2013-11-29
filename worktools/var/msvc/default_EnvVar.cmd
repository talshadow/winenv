@echo off

rem if not "x%PROCESSOR_ARCHITECTURE%" == "xAMD64" goto _NotX64
rem set COMSPEC=%WINDIR%\SysWOW64\cmd.exe
rem %COMSPEC% /c %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
rem :_NotX64
rem set MSYSCON=sh.exe
rem set MSYSTEM=MINGW32

set CC=cl
set CXX=cl
set /a JOB_COUNT=%NUMBER_OF_PROCESSORS%+1
set WORK_DISK=C
set WORK_DIR=%WORK_DISK%:\worktools
set LIB_SRC_DIR=%WORK_DIR%\libsources
set PROJECT=%WORK_DIR%\project
set BUILD_DIR=%WORK_DIR%\build
set MSYS_PATH=%WORK_DIR%\msys
set LIB_DIR=%WORK_DIR%\libs
set VAR_DIR=%WORK_DIR%\var\msvc

set MWORK_DIR=/%WORK_DISK%/worktools
set MMSYS_PATH=%MWORK_DIR%/msys
set MMLIB_SRC_DIR=%MWORK_DIR%/libsources
set MPROJECT=%MWORK_DIR%/project
set MBUILD_DIR=%MWORK_DIR%/build
set MLIB_DIR=%MWORK_DIR%/libs
set MVAR_DIR=%MWORK_DIR%/var/msvc

set PLBITS=%~1
rem if "PLBITS" == "" set PLBITS=32 
rem set MARCH_TUNE=-m32 -march=i686
rem if "%PLBITS%" == "64" set MARCH_TUNE=-m64 -march=x86-64 -msse3

set LIB_DIR=%LIB_DIR%\x%PLBITS%\shared\msvc
set MLIB_DIR=%MLIB_DIR%/x%PLBITS%/shared/msvc
set COMPILE_DIR=%WORK_DIR%\msvc%PLBITS%
set MAKE_TOOL=nmake


set QTVER=5.0.1
set BOOST_VER=1_53
set BOOST_SO_VER=0
set OSSL_VER=1.0.1

call :set_values zlib
call :set_values lpng
call :set_values icu
call :set_values sqlite
call :set_values log4cplus
call :set_values openssl
call :set_values Qt
call :set_values boost
call :set_values log4cplus


set INCLUDE=%MYINCLUDE%;%INCLUDE%
set PATH=%COMPILE_DIR%\bin;%MYBIN%;%PATH%;%WORK_DIR%\tools\bin;%WORK_DIR%\tools\python;%WORK_DIR%\tools\ruby\bin;
set CPATH=%CPATH%;%INCLUDE%
set LIBRARY_PATH=%LIBRARY_PATH%;%MYLIB%
set LIB=%LIB%;%MYLIB%

exit /b 

:set_values
set name=%~1
set %name%DIR=%LIB_DIR%\%name%
set MYINCLUDE=%MYINCLUDE%;%LIB_DIR%\%name%\include
set MYBIN=%MYBIN%;%LIB_DIR%\%name%\bin
set MYLIB=%MYLIB%;%LIB_DIR%\%name%\lib
exit /b
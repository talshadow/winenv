@echo off
set  curdir=%CD%
set libname=qt
call %VAR_DIR%\script\preparesources.cmd %libname% 	|| goto :error
cd %BUILD_DIR%\%libname%_src || goto :error
rem append depedicies 

if /i "%CXX%" EQU "g++" set QT_settings= -platform "win32-g++"
if /i "%CXX%" EQU "cl" set QT_settings= -platform "win32-msvc2013"
set QT_settings=%QT_settings% -opensource
set QT_settings=%QT_settings% -shared
set QT_settings=%QT_settings% -c++11
set QT_settings=%QT_settings% -prefix %LIB_DIR%\%libname%
set QT_settings=%QT_settings% -arch windows
set QT_settings=%QT_settings% -release
set QT_settings=%QT_settings% -nomake examples
set QT_settings=%QT_settings%  -nomake tests
set QT_settings=%QT_settings% -opensource -confirm-license
set QT_settings=%QT_settings% -shared
set QT_settings=%QT_settings% -qt-pcre
set QT_settings=%QT_settings% -no-plugin-manifests
set QT_settings=%QT_settings% -audio-backend
set QT_settings=%QT_settings% -no-qml-debug
set QT_settings=%QT_settings% -mp
set QT_settings=%QT_settings% -sse2
set QT_settings=%QT_settings% -sse2
IF "%PLBITS%" == "64" ( set QT_settings=%QT_settings% -sse3 ) ELSE ( set QT_settings=%QT_settings% -no-sse3 )
set QT_settings=%QT_settings% -no-ssse3
set QT_settings=%QT_settings% -no-sse4.1
set QT_settings=%QT_settings% -no-sse4.2
set QT_settings=%QT_settings% -no-avx
set QT_settings=%QT_settings% -no-avx2
set QT_settings=%QT_settings% -ltcg
set QT_settings=%QT_settings% -system-sqlite
set QT_settings=%QT_settings% -system-zlib
set QT_settings=%QT_settings% -system-libpng
set QT_settings=%QT_settings% -qt-libjpeg
set QT_settings=%QT_settings% -openssl
set QT_settings=%QT_settings% -opengl desktop
set QT_settings=%QT_settings% -iconv
IF "%PLBITS%" == "64" ( set QT_settings=%QT_settings% -openssl ) else ( set QT_settings=%QT_settings% -no-openssl )
set QT_settings=%QT_settings% -icu
set QT_settings=%QT_settings% -audio-backend
set QT_settings=%QT_settings% -I %LIB_DIR%\sqlite\include
set QT_settings=%QT_settings% -L %LIB_DIR%\sqlite\lib

call configure.bat  %QT_settings% >> %BUILD_DIR%\%libname%.log || goto error:
if /i "%CXX%" EQU "g++" ( call %MAKE_TOOL% -j%JOB_COUNT%>> %BUILD_DIR%\%libname%.log || goto error: ) else ( call %MAKE_TOOL% >> %BUILD_DIR%\%libname%.log || goto error: )
call %VAR_DIR%\script\clera_install_place.cmd %libname% >> %BUILD_DIR%\%libname%.log
call %MAKE_TOOL% install >> %BUILD_DIR%\%libname%.log || goto error:
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd %libname%
exit /b 0
:error
cd %curdir%
exit /b 2
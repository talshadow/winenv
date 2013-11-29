@echo off
set libname=openssl
set curdir=%CD%
call %VAR_DIR%\script\preparesources.cmd %libname% 	|| goto :error
cd %BUILD_DIR%\%libname%_src || goto :error

if /i "%CXX%" EQU "g++" goto make_by_gcc:
if /i "%CXX%" EQU "cl" goto make_by_msvc:
:make_by_msvc
goto error:
goto finish:
:make_by_gcc
set openssl_settings=mingw
if "%PLBITS%" == "64" set openssl_settings=%openssl_settings%64
set openssl_settings=%openssl_settings% --prefix=%MLIB_DIR%/openssl shared threads zlib-dynamic
call :msys_add
echo Configure %libname%
call bash Configure %openssl_settings% >>%BUILD_DIR%\%libname%.log ||call :msys_del &&  goto error:
rem echo Make depend %libname%
rem call make depend >>%BUILD_DIR%\%libname%.log || call :msys_del &&  goto error:
echo Make %libname%
call make  >>%BUILD_DIR%\%libname%.log || call :msys_del &&  goto error:
call %VAR_DIR%\script\clera_install_place.cmd %libname%
echo Make Install %libname%
call make install >>%BUILD_DIR%\%libname%.log || call :msys_del && goto error:
call :msys_del
move %LIB_DIR%\%libname%\lib\*.dll %LIB_DIR%\%libname%\bin\
set err=0
goto finish:
:error
echo %libname% build error see %BUILD_DIR%\%libname%.log
cd %curdir%
exit /b 2
:finish
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd %libname%
exit /b 0
rem ***************************************************************************************
:msys_add
set PATH_SAVE=%PATH%
set PATH=%MSYS_PATH%\bin;%PATH%
exit /b
rem ***************************************************************************************
:msys_del
set PATH=%PATH_SAVE%
exit /b
rem ***************************************************************************************
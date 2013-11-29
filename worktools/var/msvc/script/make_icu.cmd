@echo off
set  curdir=%CD%
set libname=icu
call %VAR_DIR%\script\preparesources.cmd %libname% 	|| goto :error
mkdir %BUILD_DIR%\%libname%_build
cd %BUILD_DIR%\%libname%_build || goto :error

if /i "%CXX%" EQU "gcc" goto make_by_gcc:
if /i "%CXX%" EQU "cl" goto make_by_msvc:
:make_by_msvc
if "%PLBITS%" EQU "x64"(set params=/p:platform=x64)else( set params=/p:platform=Win32)
call msbuild /maxcpucount:%JOB_COUNT% ..\%libname%_src\source\allinone\allinone.sln /p:configuration=Release  %params% >> %BUILD_DIR%\%libname%.log || goto error:
call %VAR_DIR%\script\clera_install_place.cmd %libname%
mkdir %LIB_DIR%\%libname% >> %BUILD_DIR%\%libname%.log || goto error:
xcopy /Y /E /I /Q %BUILD_DIR%\%libname%_src\include %LIB_DIR%\%libname%\include >> %BUILD_DIR%\%libname%.log || goto error:
xcopy /Y /E /I /Q %BUILD_DIR%\%libname%_src\bin\*.dll %LIB_DIR%\%libname%\bin >> %BUILD_DIR%\%libname%.log || goto error:
xcopy /Y /E /I /Q %BUILD_DIR%\%libname%_src\lib\*.lib %LIB_DIR%\%libname%\lib >> %BUILD_DIR%\%libname%.log || goto error:
mkdir %LIB_DIR%\%libname%\data
copy /Y %BUILD_DIR%\%libname%_src\source\data\out\*.dat %LIB_DIR%\%libname%\data\ >> %BUILD_DIR%\%libname%.log || goto error:
goto finish:
:make_by_gcc

:error
cd %curdir%
exit /b 2
:finish
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd %libname%
exit /b 0
@echo off
set  curdir=%CD%
set libname=sqlite
if /i "%CXX%" EQU "gcc" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
if /i "%CXX%" EQU "cl" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles"
call %VAR_DIR%\script\preparesources.cmd %libname% 	|| goto :error
copy /Y  %VAR_DIR%\%libname%\CMakeLists.txt %BUILD_DIR%\%libname%_src
mkdir %BUILD_DIR%\%libname%_build
cd %BUILD_DIR%\%libname%_build || goto :error
cmake ../%libname%_src -DCMAKE_INSTALL_PREFIX=%LIB_DIR%\%libname% %CMAKE_RELEASE% >> %BUILD_DIR%\%libname%.log || goto :error
%MAKE_TOOL% >> %BUILD_DIR%\%libname%.log || goto :error
call %VAR_DIR%\script\clera_install_place.cmd %libname%
%MAKE_TOOL% install >> %BUILD_DIR%\%libname%.log || goto :error
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd %libname%
exit /b 0
:error
cd %curdir%
exit /b 2
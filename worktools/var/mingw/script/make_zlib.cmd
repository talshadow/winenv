@echo off
set  curdir=%CD%
if /i "%CXX%" EQU "g++" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
if /i "%CXX%" EQU "cl" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles"
call %VAR_DIR%\script\preparesources.cmd zlib 	|| goto :error
mkdir %BUILD_DIR%\zlib_build
cd %BUILD_DIR%\zlib_build || goto :error
cmake ../zlib_src -DCMAKE_INSTALL_PREFIX=%LIB_DIR%\zlib %CMAKE_RELEASE% >> %BUILD_DIR%\zlib.log || goto :error
%MAKE_TOOL% >> %BUILD_DIR%\zlib.log || goto :error
call %VAR_DIR%\script\clera_install_place.cmd zlib
%MAKE_TOOL% install >> %BUILD_DIR%\zlib.log || goto :error
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd zlib
exit /b 0
:error
cd %curdir%
exit /b 2
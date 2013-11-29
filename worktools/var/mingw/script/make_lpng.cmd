@echo off
set  curdir=%CD%
if /i "%CXX%" EQU "g++" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
if /i "%CXX%" EQU "cl" set CMAKE_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles"
call %VAR_DIR%\script\preparesources.cmd lpng 	|| goto :error
mkdir %BUILD_DIR%\lpng_build
cd %BUILD_DIR%\lpng_build || goto :error
cmake ../lpng_src -DCMAKE_INSTALL_PREFIX=%LIB_DIR%\lpng %CMAKE_RELEASE% >> %BUILD_DIR%\lpng.log || goto :error
%MAKE_TOOL% >> %BUILD_DIR%\lpng.log || goto :error
call %VAR_DIR%\script\clera_install_place.cmd lpng
%MAKE_TOOL% install >> %BUILD_DIR%\lpng.log || goto :error
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd lpng
exit /b 0
:error
cd %curdir%
exit /b 2
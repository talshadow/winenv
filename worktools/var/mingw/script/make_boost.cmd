@echo off
set  curdir=%CD%
set libname=boost
call %VAR_DIR%\script\preparesources.cmd %libname% 	|| goto :error
cd %BUILD_DIR%\%libname%_src || goto :error
set tmpdirs=%CD%
cd %tmpdirs%\tools\build\v2\engine || goto error:

set boost_settings=--prefix=%LIB_DIR%\boost
if /i "%CXX%" EQU "g++" set boost_settings=%boost_settings% toolset=gcc
if /i "%CXX%" EQU "cl" set boost_settings=%boost_settings% toolset=msvc
set boost_settings=%boost_settings% link=shared
set boost_settings=%boost_settings% threading=multi
set boost_settings=%boost_settings% runtime-link=shared
set boost_settings=%boost_settings% -sICU_PATH=%LIB_DIR%\icu
set boost_settings=%boost_settings% --without-mpi
set boost_settings=%boost_settings% -sHAVE_ICU=1
if /i "%CXX%" EQU "g++" set boost_settings=%boost_settings% -sICU_LINK="-L$ICU_PATH/lib -licuuc -licuin -licudt" 
if /i "%CXX%" EQU "cl" set boost_settings=%boost_settings% -sICU_LINK="/LIBPATH:%LIB_DIR%\icu\lib icuuc.lib icuin.lib icudt.lib"
set boost_settings=%boost_settings% --without-context
set boost_settings=%boost_settings% --without-coroutine
set boost_settings=%boost_settings% --without-graph
set boost_settings=%boost_settings% --without-graph_parallel
set boost_settings=%boost_settings% --without-python
rem set boost_settings=%boost_settings% --without-test
if /i "%CXX%" EQU "g++" set boost_settings_release=%boost_settings% release cxxflags="%CXXFLAGS%" --std=c++0x stage
if /i "%CXX%" EQU "cl" set boost_settings_release=%boost_settings% release stage

set boost_bjam_settings=msvc
if /i "%CXX%" EQU "g++" set boost_bjam_settings=gcc
set boost_bjam_build_dir=bin.ntx86
if "%PLBITS%"=="64" set boost_bjam_build_dir=%boost_bjam_build_dir%_64
call build.bat %boost_bjam_settings% >> %BUILD_DIR%\%libname%.log  || goto error:
move  /Y .\%boost_bjam_build_dir%\bjam.exe %tmpdirs%\ || goto error:
cd %tmpdirs%
call bjam.exe -j %JOB_COUNT% %boost_settings_release% >> %BUILD_DIR%\%libname%.log || goto error:
echo  Clear install place for %libname%
call %VAR_DIR%\script\clera_install_place.cmd %libname% >> %BUILD_DIR%\%libname%.log
echo  Make installs dirs for %libname%
MKDIR %LIB_DIR%\boost && MKDIR %LIB_DIR%\boost\bin && MKDIR %LIB_DIR%\boost\lib && MKDIR %LIB_DIR%\boost\include  || exit /b 2
xcopy /Y /E /I /Q %BUILD_DIR%\%libname%_src\boost %LIB_DIR%\boost\include\boost >>%BUILD_DIR%\%libname%.log || exit /b 2
move /Y %BUILD_DIR%\%libname%_src\stage\lib\*.dll %LIB_DIR%\boost\bin >>%BUILD_DIR%\%libname%.log|| exit /b 2
move /Y %BUILD_DIR%\%libname%_src\stage\lib\*.* %LIB_DIR%\boost\lib >>%BUILD_DIR%\%libname%.log|| exit /b 2
cd %curdir%
call %VAR_DIR%\script\clear_tmp_dirs.cmd %libname%
exit /b 0
:error
cd %curdir%
exit /b 2
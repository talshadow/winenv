@echo off
call %VAR_DIR%\script\settings.cmd || echo not found settings.cmd && exit /B 252
setlocal ENABLEDELAYEDEXPANSION
@echo off
set projname=%~1
set logfile=%BUILD_DIR%\%projname%_build.log
if "%projname%"=="" echo Missing parameter projectname && exit /B 252)
call :%projname% || echo Don't know how build %projname% && exit /B 2
goto :finish
rem ***************************************************************************************
:msys_add
set PATH_SAVE=%PATH%
set PATH=%MSYS_PATH%\bin;%PATH%
exit /B
rem ***************************************************************************************
:msys_del
set PATH=%PATH_SAVE%
exit /b
rem ***************************************************************************************
:PREPARE_SOURCES_LINK_IN_PLACE
if "%GLOBAL_USE_LINK%"=="" ( xcopy /Y /E /I /Q %LIB_SRC_DIR%\%~1%~2 %BUILD_DIR%\%~1_src || exit /b 2 ) else  ( mklink /J %BUILD_DIR%\%~1_src %LIB_SRC_DIR%\%~1%~2 || exit /b 2 )
cd %BUILD_DIR%\%~1_src || exit /b 2
exit /b
rem ***************************************************************************************
:PREPARE_SOURCES_LINK
if "%GLOBAL_USE_LINK%"=="" ( xcopy /Y /E /I /Q %LIB_SRC_DIR%\%~1%~2 %BUILD_DIR%\%~1_src || exit /b 2 ) else  ( mklink /J %BUILD_DIR%\%~1_src %LIB_SRC_DIR%\%~1%~2 || exit /b 2 )
mkdir  %BUILD_DIR%\%~1 || exit /b 2
cd %BUILD_DIR%\%~1 || exit /b 2
exit /b
rem ***************************************************************************************
:CLEAR_BUILD_TEMPS
RD /S /Q %BUILD_DIR%\%~1 || exit /b 2
if "%GLOBAL_USE_LINK%"=="" ( RD /Q /S %BUILD_DIR%\%~1_src || exit /b 2 ) else ( RD /Q %BUILD_DIR%\%~1_src || exit /b 2 )
exit /b
rem ***************************************************************************************
:PREPARE_SOURCES_LINK_CPY
xcopy /Y /E /I /Q %LIB_SRC_DIR%\%~1%~2 %BUILD_DIR%\%~1_src
cd %BUILD_DIR%\%~1_src || exit /b 2
exit /b
rem ***************************************************************************************
:CLEAR_BUILD_TEMPS_CPY
RD /Q /S %BUILD_DIR%\%~1_src
exit /b
rem ***************************************************************************************
:CONFIG_ONLY
set LocVar=%2
call set LocVar=!%LocVar%!
%1 %locVar% || cd .. && exit /b 2
exit /b
:BUILD_ONLY
call mingw32-make -j%JOB_COUNT% || cd .. && exit /b 2
call mingw32-make install || cd .. && exit /b 2
exit /b
:CONFIG_BUILD_AND_INSTALL
set LocVar=%2
call set LocVar=!%LocVar%!
%1 %locVar% || cd .. && exit /b 2
call jom.exe || cd .. && exit /b 2
call mingw32-make install || cd .. && exit /b 2
exit /b
rem ***************************************************************************************
:MOVE_LIB_DLL_TO_BIN
set tmppath=%~1
move /Y %tmppath%\lib\*.dll %tmppath%\bin\ || exit /b 2
exit /b
rem ***************************************************************************************
:CONFIG_BUILD_AND_INSTALL_SH
call :msys_add
set err=2
set LocVar=%2
call set LocVar=!%LocVar%!
call bash ../%~3_src/%1 %locVar% >> %logfile% ||goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
call make >> %logfile% || goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
call make install >> %logfile% || goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
set err=0
:CONFIG_BUILD_AND_INSTALL_SH_ERROR
call :msys_del
cd .. 
if %err%=="0" exit /b
exit /b %err%
rem ***************************************************************************************
:CREATE_QT_MAKESPACS
rem echo on
echo %CD%
rem mkdir .\qtbase\mkspecs\win32-g++mingw || exit /b 2
rem xcopy /Y .\qtbase\mkspecs\win32-g++\qplatformdefs.h ".\qtbase\mkspecs\win32-g++mingw" || exit /b 2 
rem xcopy /Y .\qtbase\mkspecs\win32-g++\qmake.conf ".\qtbase\mkspecs\win32-g++mingw" || exit /b 2 
rem echo include(../win32-g++/qmake.conf) > .\qtbase\mkspecs\win32-g++mingw\qmake.conf || exit /b 2 
echo QMAKE_CFLAGS_RELEASE += %CFLAGS% >> .\qtbase\mkspecs\win32-g++\qmake.conf || exit /b 2
echo QMAKE_CXXFLAGS_RELEASE += %CXXFLAGS:~0,-11% >> .\qtbase\mkspecs\win32-g++\qmake.conf || exit /b 2
exit /b
:CONFIG_BUILD_AND_INSTALL_SH_CPY
call :msys_add
set err=2
set LocVar=%2
call set LocVar=!%LocVar%!
call bash %1 %locVar% >> %logfile% ||goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
make >> %logfile% || goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
make install >> %logfile% || goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
set err=0
goto CONFIG_BUILD_AND_INSTALL_SH_ERROR
rem ***************************************************************************************
:zlib
call :PREPARE_SOURCES_LINK  "zlib" "-%zlib_ver%" || exit /b 2
call :CONFIG_BUILD_AND_INSTALL cmake  zlib_settings && cd .. || exit /b2
call :CLEAR_BUILD_TEMPS "zlib" || exit /b 2
exit /b 
:lpng 
call :PREPARE_SOURCES_LINK "lpng" "%lpng_ver%" || exit /b 2
call :CONFIG_BUILD_AND_INSTALL cmake  lpng_settings && cd .. || exit /b2
call :CLEAR_BUILD_TEMPS "lpng" || exit /b 2
exit /b 
rem :jpeg
rem call :PREPARE_SOURCES_LINK "jpeg" "-%jpeg_ver%" || exit /b 2
rem call :CONFIG_BUILD_AND_INSTALL_SH configure  jpeg_settings "jpeg" && cd .. || exit /b2
rem call :CLEAR_BUILD_TEMPS "jpeg" || exit /b 2
rem exit /b
:sqlite
call :PREPARE_SOURCES_LINK "sqlite" "-%sqlite_ver%" || exit /b 2
call :CONFIG_BUILD_AND_INSTALL_SH configure  sqlite_settings "sqlite" && cd .. || exit /b2
call :CLEAR_BUILD_TEMPS "sqlite" || exit /b 2
exit /b
:icu 
call :PREPARE_SOURCES_LINK "icu" "" || exit /b 2
call :CONFIG_BUILD_AND_INSTALL_SH source/runConfigureICU  icu_settings "icu" && cd .. || exit /b2
call :CLEAR_BUILD_TEMPS "icu" || exit /b 2
call :MOVE_LIB_DLL_TO_BIN "%LIB_DIR%\icu" || exit /b 2
exit /b
:openssl 
call :PREPARE_SOURCES_LINK_CPY "openssl" "%openssl_ver%" || exit /b 2
call :CONFIG_BUILD_AND_INSTALL_SH_CPY "Configure"  openssl_settings && cd .. || exit /b2
call :CLEAR_BUILD_TEMPS_CPY "openssl" || exit /b 2
exit /b
:boost 
call :PREPARE_SOURCES_LINK_CPY "boost" "%boost_ver%" || exit /b 2
rem cd %BUILD_DIR%\boost_src || exit /b 2
set tmpdirs=%CD%
cd %tmpdirs%\tools\build\v2\engine || cd %tmpdirs% && exit /b 2
call build.bat %boost_bjam_settings% >> %logfile% || cd %tmpdirs% && exit /b 2
move  /Y .\%boost_bjam_build_dir%\bjam.exe %tmpdir%\ || cd %tmpdirs% && exit /b 2
cd %tmpdirs%
call bjam.exe -j %JOB_COUNT% %boost_settings_release% >> %logfile% || exit /b 2
MKDIR %LIB_DIR%\boost && MKDIR %LIB_DIR%\boost\bin && MKDIR %LIB_DIR%\boost\lib && MKDIR %LIB_DIR%\boost\include  || exit /b 2
xcopy /Y /E /I /Q .\boost %LIB_DIR%\boost\include\boost || exit /b 2
move /Y .\stage\lib\*.dll %LIB_DIR%\boost\bin || exit /b 2
move /Y .\stage\lib\*.* %LIB_DIR%\boost\lib || exit /b 2
cd ..
call :CLEAR_BUILD_TEMPS_CPY "boost" || exit /b 2
exit /b
:qt
call ::PREPARE_SOURCES_LINK_IN_PLACE "qt" "%qt_ver%" || exit /b 2
call :CREATE_QT_MAKESPACS
call :CONFIG_ONLY configure.bat  qt_settings "qt" || exit /b2
call :BUILD_ONLY || exit /b2
call :CLEAR_BUILD_TEMPS_CPY "qt" || exit /b 2
exit /b
:finish



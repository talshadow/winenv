@echo off
set GLOBAL_USE_LINK=
set SYSTEM_CROSS_PARAM=
if "%PLBITS%" == "64" set SYSTEM_CROSS_PARAM=--target=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --build=x86_64-w64-mingw32 

	

set CMAKE_FOR_MINGW_RELEASE=-DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
set zlib_settings=../zlib_src -DCMAKE_INSTALL_PREFIX=%LIB_DIR%\zlib %CMAKE_FOR_MINGW_RELEASE%
set zlib_ver=1.2.7

set lpng_settings= ../lpng_src -DCMAKE_INSTALL_PREFIX=%LIB_DIR%\lpng %CMAKE_FOR_MINGW_RELEASE%
set lpng_ver=1513

set sqlite_settings=--prefix=%MLIB_DIR%/sqlite --enable-threadsafe %SYSTEM_CROSS_PARAM%
set sqlite_ver=autoconf-3071401

set icu_settings=MinGW --prefix=%MLIB_DIR%/icu --disable-tests --disable-samples --enable-shared --disable-static --enable-auto-cleanup %SYSTEM_CROSS_PARAM%
set icu_ver=

set openssl_settings=mingw
if "%PLBITS%" == "64" set openssl_settings=%openssl_settings%64
set openssl_settings=%openssl_settings% --prefix=%MLIB_DIR%/openssl shared threads zlib-dynamic
set openssl_ver=-1.0.1

set boost_settings=--prefix=%LIB_DIR%\boost
set boost_settings=%boost_settings% toolset=gcc
set boost_settings=%boost_settings% link=shared
set boost_settings=%boost_settings% threading=multi
set boost_settings=%boost_settings% runtime-link=shared
set boost_settings=%boost_settings% -sICU_PATH=%LIB_DIR%\icu
set boost_settings=%boost_settings% --without-mpi
set boost_settings=%boost_settings% -sHAVE_ICU=1
set boost_settings=%boost_settings% -sICU_LINK="-L$ICU_PATH/lib -licuuc -licuin -licudt"
set boost_settings=%boost_settings% --without-context
set boost_settings=%boost_settings% --without-graph
set boost_settings=%boost_settings% --without-graph_parallel
set boost_settings=%boost_settings% --without-python
set boost_settings=%boost_settings% --without-test
set boost_settings_release=%boost_settings% release cxxflags="%CXXFLAGS%" --std=c++0x stage
set boost_bjam_settings=mingw
set boost_bjam_build_dir=bin.ntx86
if "%PLBITS%"=="64" set boost_bjam_build_dir=%boost_bjam_build_dir%_64
set boost_ver=_1_53_0

set QT_ver=-everywhere-opensource-src-5.0.1
set QT_settings= -platform "win32-g++"
set QT_settings=%QT_settings% -opensource
set QT_settings=%QT_settings% -shared
set QT_settings=%QT_settings% -prefix %QTDIR%
set QT_settings=%QT_settings% -arch windows
set QT_settings=%QT_settings% -release
set QT_settings=%QT_settings% -nomake examples
set QT_settings=%QT_settings% -nomake demos
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
set QT_settings=%QT_settings% -openssl
set QT_settings=%QT_settings% -icu
set QT_settings=%QT_settings% -audio-backend
set QT_settings=%QT_settings% -I %LIB_DIR%\sqlite\include
set QT_settings=%QT_settings% -L %LIB_DIR%\sqlite\lib


rem qmake ..\qt-creator-2.6.2-src\qtcreator.pro -r -spec win32-g++ CONFIG+=release CONFIG+="INSTALL_ROOT=F:\QtCreator" // set INSTALL_ROOT=F:\QtCreator
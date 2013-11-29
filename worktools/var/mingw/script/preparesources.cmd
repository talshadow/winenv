@echo off
rem  1 имя библиотеки
set  tmp_name=
for /f "Tokens=1* Delims=" %%i in ('dir /b /A-D  %LIB_SRC_DIR%\%~1*.*') do (
	set tmp_name=%%i
)

echo prepare sources for %~1 as %tmp_name%
if "%tmp_name%" NEQ "" goto :unpack
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %LIB_SRC_DIR%\%~1*') do (
	set tmp_name=%%i 
)
if "%tmp_name%" NEQ "" goto :copysrc
echo Lib %1 not found
exit /b 3

:unpack
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %BUILD_DIR%\%~1*') do (
	 RD /Q /S %BUILD_DIR%\%%i>> %BUILD_DIR%\%1.log 
)

7z x %LIB_SRC_DIR%\%tmp_name% -o%BUILD_DIR% >> NUL || exit /b 2
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %BUILD_DIR%\%~1*') do (
	 move %BUILD_DIR%\%%i %BUILD_DIR%\%1_src >>%BUILD_DIR%\%1.log || exit /b 2
)
goto end:

:copysrc
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %BUILD_DIR%\%~1*') do (
	 RD /Q /S %BUILD_DIR%\%%i>> %BUILD_DIR%\%1.log 
)
xcopy /Y /E /I /Q %LIB_SRC_DIR%\%tmp_name% %BUILD_DIR%\%~1_src >>%BUILD_DIR%\%1.log  || exit /b 2

:end
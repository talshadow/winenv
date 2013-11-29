@echo off
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %LIB_DIR%\%~1*') do (
	 RD /Q /S %LIB_DIR%\%%i>> %BUILD_DIR%\%1.log 
)
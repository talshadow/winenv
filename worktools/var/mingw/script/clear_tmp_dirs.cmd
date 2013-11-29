@echo off
for /f "Tokens=1* Delims=" %%i in ('dir /b /AD  %BUILD_DIR%\%~1*') do (
	 RD /Q /S %BUILD_DIR%\%%i>> %BUILD_DIR%\%1.log 
)
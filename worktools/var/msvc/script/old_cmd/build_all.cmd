call %VAR_DIR%\script\project_build.cmd zlib 	|| exit /b 2
call %VAR_DIR%\script\project_build.cmd lpng 	|| exit /b 2
call %VAR_DIR%\script\project_build.cmd icu  	|| exit /b 2
call %VAR_DIR%\script\project_build.cmd sqlite	|| exit /b 2
call %VAR_DIR%\script\project_build.cmd openssl || exit /b 2
call %VAR_DIR%\script\project_build.cmd boost	|| exit /b 2
call %VAR_DIR%\script\project_build.cmd qt	|| exit /b 2

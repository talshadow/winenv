call %VAR_DIR%\script\make_zlib.cmd	|| exit /b 2
call %VAR_DIR%\script\make_lpng.cmd || exit /b 2
call %VAR_DIR%\script\make_icu.cmd || exit /b 2
call %VAR_DIR%\script\make_sqlite.cmd || exit /b 2
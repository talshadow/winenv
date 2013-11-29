@echo off
set TEMP=V:\temp
set TMP=V:\temp
set TMPDIR=V:\temp
%WORK_DISK%:
call default_EnvVar.cmd 64
@echo %BUILD_DIR%
cd %BUILD_DIR%
cmd /k
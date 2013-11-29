@echo off
rem call EnvVar_x64.cmd
set TEMP=V:\temp
set TMP=V:\temp
set TMPDIR=V:\temp
%WORK_DISK%:
call default_EnvVar.cmd 32
@echo %BUILD_DIR%
cd %BUILD_DIR%
cmd /k
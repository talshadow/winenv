set TEMP=V:\temp
set TMP=V:\temp
set TMPDIR=V:\temp
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat" x32
%WORK_DISK%:
call default_EnvVar.cmd 32
cd %BUILD_DIR%
cmd /k
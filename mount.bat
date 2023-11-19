@echo off
set "sourceFolder=D:\Project\Git\blog\wenshitaiyi.blog"
set "targetFolder=D:\Project\Git\blog\wenshitaiyi.github.io"

for /d %%i in ("%sourceFolder%\*") do (
    mklink /J "%targetFolder%\%%~nxi" "%%i"
)

REM for %%i in ("%sourceFolder%\*.*") do (
	REM echo "%%i"
	REM echo "%targetFolder%\%%~nxi"
    REM mklink /H "%targetFolder%\%%~nxi" "%%i"
REM )


echo Symbolic links created successfully.

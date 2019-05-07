@echo off
setlocal

rem ##!! [Used for C++ projects, Default=0] Switch to clear fully assets register cache.
rem ## When disabling will be cleared only old source files cache data (*.vsxproj, *.vsxproj.filters)
set CLRASTCACHE=0

rem ##!! [Used for C++ projects, Default=1] Switch for enabling(1)\disabling(0) of using of generating project files for Visual Studio.
set USEGENBIN=1

rem ## When enabled window will be closed  automatically with end of process if is has done.
set DOSILENCE=0
rem ## Get latest actual version on https://github.com/KaptnWayne/ClearAssetsCacheData


:start
cls
echo Clear project assets data ...

rem ## Check is bat file is in project root path; get project file name.
echo.
pushd "%~dp0\"
for /f  %%a in ('dir /b *.uproject') do (
set PRJNAME=%%~na
set NAME=%%~nxa
)
popd
if not exist "%NAME%" goto Error_MissingProjectRootPath
echo [STATUS] %NAME%


rem ## Clear Binaries folder.
:RemoveBinariesFolder
rem Skip binaries if is does't exist.
if not exist "./Binaries" goto RemoveIntermadiateAssetsData
echo.
echo [STATUS] Clear: Binaries ...
rmdir /s /q "./Binaries"


rem ## Clear Unreal assets intermediate folders.
rem ## Will be clean up full assets registry cache if CLRASTCACHE is ON. Can be include off by CLRASTCACHE switching (1-on\0-off).
:RemoveIntermadiateAssetsData
echo.
if %CLRASTCACHE%==1 (
echo [STATUS] Clear: Intermediate ...
pushd "%~dp0/Intermediate/"
if exist "Build" rmdir /s /q "Build"
if exist "AssetRegistryCache" rmdir /s /q "AssetRegistryCache"
if exist "ReimportCache" rmdir /s /q "ReimportCache"
if exist "ProjectFiles" rmdir /s /q "ProjectFiles"
if exist "*.bin" del /s /q "*.bin"
)
if %CLRASTCACHE%==0 (
echo [STATUS] Clear: Old source cache ...
pushd "%~dp0/Intermediate/ProjectFiles/"
if exist "%PRJNAME%.vcxproj" del /s /q "%PRJNAME%.vcxproj"
if exist "%PRJNAME%.vcxproj.filters" del /s /q "%PRJNAME%.vcxproj.filters"
if exist "%PRJNAME%.vcxproj.filters" del /s /q "%PRJNAME%.vcxproj.filters"
)
popd
if ERRORLEVEL 1 goto EndError


rem ## Generate VS Project files.
rem Skip generate VS project files
if %USEGENBIN%==0 goto Done

:GenerateVSProjectFiles
echo.
echo [STATUS] Generating: VisualStudio project files ...
rem Get genproj execution bat file using registry cache.
rem Skip fist 2 tokens (Name'Icon',Type'REG_SZ') and get Data only.
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCR\Unreal.ProjectFile\shell\rungenproj" /v "Icon"') do SET GENBIN=%%B
rem Run genbin file for "NAME.uproject".
%GENBIN% /projectfiles "%~dp0\%NAME%"
rem Get GENBIN process status.
if ERRORLEVEL 1 goto EndError

if %DOSILENCE%==1 goto exit
goto EndDone



rem ## STATUS SECTIONS

:Error_MissingProjectRootPath
echo.
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red "Failed to find ProjectName.uproject file. Place bat file into your Project root path and try again."

:EndError
echo.
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Red "[STATUS] ERORR. Wait for a keypress before quitting."
echo.
pause
goto exit

:EndDone
echo.
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor Green "[STATUS] DONE. Wait for a keypress before quitting."
echo.
pause
goto exit

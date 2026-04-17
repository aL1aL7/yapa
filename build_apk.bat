@echo off
setlocal enabledelayedexpansion

:: Read current version from pubspec.yaml (e.g. "1.0.2+5")
for /f "tokens=2 delims= " %%v in ('findstr /b "version:" pubspec.yaml') do set CURRENT=%%v

:: Split into version name and build number
for /f "tokens=1,2 delims=+" %%a in ("!CURRENT!") do (
    set VERSION_NAME=%%a
    set BUILD_NUM=%%b
)

:: Increment build number
set /a NEW_BUILD=%BUILD_NUM% + 1
set NEW_VERSION=%VERSION_NAME%+%NEW_BUILD%

:: Update pubspec.yaml
powershell -Command "(Get-Content pubspec.yaml) -replace '^version: .*', 'version: %NEW_VERSION%' | Set-Content pubspec.yaml"

echo Building %VERSION_NAME% (build %NEW_BUILD%)...

call flutter build apk --release
if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

:: Rename APK
set APK_SRC=build\app\outputs\flutter-apk\app-release.apk
set APK_DST=build\app\outputs\flutter-apk\yapa-%NEW_VERSION%.apk
move /y "%APK_SRC%" "%APK_DST%"

echo.
echo Done: %APK_DST%  (build %NEW_BUILD%)

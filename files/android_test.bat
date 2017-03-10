@echo off
set failures=
setlocal enableDelayedExpansion
set wrapper_bin_dir=test_bin

call:assert_fails "bogus"
call:assert_generated_command_equals "avdmanager list avd" "list avd"
call:assert_generated_command_equals "avdmanager create avd" "create avd"
call:assert_generated_command_equals "avdmanager list avd" "list avd"
call:assert_generated_command_equals "avdmanager create avd" "create avd"
call:assert_generated_command_equals "avdmanager move avd" "move avd"
call:assert_generated_command_equals "avdmanager delete avd" "delete avd"
call:assert_fails "bogus avd"
call:assert_generated_command_equals "avdmanager list target" "list target"
call:assert_generated_command_equals "avdmanager list device" "list device"
call:assert_generated_command_equals "avdmanager -foo list avd -bar -baz" "-foo list avd -bar -baz"
call:assert_fails "-foo list avd -bar --fail"

call:assert_generated_command_equals "sdkmanager --list --verbose" "list sdk --use-sdk-wrapper"
echo n|call android list sdk >nul 2>&1 && set failures=!failures!#Expected prompt
set USE_SDK_WRAPPER=true
call:assert_generated_command_equals "sdkmanager --list --verbose" "list sdk"
call:assert_generated_command_equals "sdkmanager --list --verbose" "list sdk -foo -bar"
call:assert_fails "update sdk -n"
call:assert_fails "update sdk -bogus"
call:assert_generated_command_equals "sdkmanager --update" "update sdk"
call:assert_generated_command_equals "sdkmanager --update" "update sdk -u"
call:assert_generated_command_equals "sdkmanager --update" "update sdk --no-ui"
call:assert_generated_command_equals "sdkmanager --include_obsolete --update" "update sdk -a"
call:assert_generated_command_equals "sdkmanager --include_obsolete --update" "update sdk --all"
call:assert_generated_command_equals "sdkmanager --no_https --update" "update sdk -s"
call:assert_generated_command_equals "sdkmanager --no_https --update" "update sdk --no-https"
call:assert_generated_command_equals "sdkmanager --proxy_port=1234 --proxy=http --proxy_host=foo --update" "update sdk --proxy-port 1234 --proxy-host foo"
call:assert_generated_command_equals ^
    "sdkmanager tools platform-tools docs lldb;1.0 build-tools;2.3 ndk-bundle platforms;android-25 platforms;android-O" ^
    "update sdk -t tool,platform-tool,doc,lldb-1.0,build-tools-2.3,ndk,android-25,android-O"
call:assert_generated_command_equals "sdkmanager tools platform-tools" "update sdk -t tools,platform-tools"
call:assert_fails "update sdk -t bogus"
call:assert_fails "update sdk bogus"
call:assert_fails "update sdk --fail"

if "%failures%"=="" (
  echo Success
  exit /b 0
)
set LF=^


rem Two blank lines are needed above for LF to be set correctly

echo %failures:#=!LF!%
exit /b 1

:assert_generated_command_equals
  setlocal enableDelayedExpansion
  set command_failed=""
  for /f "delims=" %%a in ('call android %~2 2^>^&1 ^>nul ^|^| echo Command failed unexpectedly') do set result=%%a
  if not "%~1"=="!result!" (
    endlocal & set failures=!failures!#args '%~2' should have run '%~1' but instead ran '%result%'
  )
  goto:eof

:assert_fails
  setlocal enableDelayedExpansion
  call android %~1 >nul 2>&1 && (
    endlocal & set failures=!failures!#args '%~1` should have resulted in failure but succeeded
  )
  goto:eof


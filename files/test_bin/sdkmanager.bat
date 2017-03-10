@echo off
setlocal enableDelayedExpansion
echo sdkmanager %*>&2

:loop
  set arg="%~1"
  shift
  if !arg!=="" goto:done
  if !arg!=="--fail" exit /b 1
  goto:loop

:done
exit /b 0

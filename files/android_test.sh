#!/bin/bash

failures=""

function assert_generated_command_equals {
  result=$(sdk/files/android $2 2>&1 >/dev/null)
  if [[ $1 != $result ]] ; then
    failures=$failures"
args \"$2\" should have run \"$1\" but instead ran \"$result\""
  fi
  if (( $? != 0 )); then
    failures=$failures"
args \"$2\" should have resulted in success but failed"
  fi
}

function assert_fails {
  if sdk/files/android $1 &>/dev/null; then
    failures=$failures"
args \"$1\" should have resulted in failure but succeeded"
  fi
}

export ANDROID_WRAPPER_BIN_DIR=sdk/files/test_bin
export ANDROID_WRAPPER_SDK_TIMEOUT=1

assert_fails "bogus"
assert_generated_command_equals "avdmanager list avd" "list avd"
assert_generated_command_equals "avdmanager create avd" "create avd"
assert_generated_command_equals "avdmanager move avd" "move avd"
assert_generated_command_equals "avdmanager delete avd" "delete avd"
assert_fails "bogus avd"
assert_generated_command_equals "avdmanager list target" "list target"
assert_generated_command_equals "avdmanager list device" "list device"
assert_generated_command_equals "avdmanager -foo list avd -bar -baz" "-foo list avd -bar -baz"
assert_fails "-foo list avd -bar --fail"

assert_generated_command_equals "sdkmanager --list --verbose" "list sdk --use-sdk-wrapper"
assert_fails "list sdk"
export USE_SDK_WRAPPER=true
assert_generated_command_equals "sdkmanager --list --verbose" "list sdk"
assert_generated_command_equals "sdkmanager --list --verbose" "list sdk -foo -bar"
assert_fails "update sdk -n"
assert_fails "update sdk -bogus"
assert_generated_command_equals "sdkmanager --update" "update sdk"
assert_generated_command_equals "sdkmanager --update" "update sdk -u"
assert_generated_command_equals "sdkmanager --update" "update sdk --no-ui"
assert_generated_command_equals "sdkmanager --include_obsolete --update" "update sdk -a"
assert_generated_command_equals "sdkmanager --include_obsolete --update" "update sdk --all"
assert_generated_command_equals "sdkmanager --no_https --update" "update sdk -s"
assert_generated_command_equals "sdkmanager --no_https --update" "update sdk --no-https"
assert_generated_command_equals "sdkmanager --proxy_port=1234 --proxy=http --proxy_host=foo --update" "update sdk --proxy-port 1234 --proxy-host foo"
assert_generated_command_equals "sdkmanager tools platform-tools docs lldb;1.0 build-tools;2.3 ndk-bundle platforms;android-25 platforms;android-O extras;google;play_billing extras;android;m2repository" \
          "update sdk -t tool,platform-tool,doc,lldb-1.0,build-tools-2.3,ndk,android-25,android-O,extra-google-play_billing,extra-android-m2repository"
assert_generated_command_equals "sdkmanager tools platform-tools" "update sdk -t tools,platform-tools"
assert_fails "update sdk -t bogus"
assert_fails "update sdk bogus"

if [[ $failures ]]; then
  cat << EOF
  $failures
EOF
  exit 1
fi
exit 0

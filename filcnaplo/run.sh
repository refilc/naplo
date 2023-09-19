#!/bin/fish

function get_version
  cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1
end


if test -e /mnt/enc/keys/filc3.properties
  set -x ANDROID_SIGNING /mnt/enc/keys/filc3.properties 
end

flutter run --debug --dart-define=APPVER=(get_version)

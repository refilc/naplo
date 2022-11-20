#!/usr/bin/env fish

# With build number
function get_version_bn
  cat pubspec.yaml | grep version: | cut -d' ' -f2
end

function get_version
  cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1
end

if test -e ~/keys/filc3.properties
  set -x ANDROID_SIGNING ~/keys/filc3.properties
end

flutter build apk --release --dart-define=APPVER=(get_version) --no-tree-shake-icons
cp -v "build/app/outputs/flutter-apk/app-release.apk" ~/"Desktop/hu.filc.naplo_"(get_version_bn).apk

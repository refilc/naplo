#!/usr/bin/env sh

# With build number
function get_version_bn
  cat pubspec.yaml | grep version: | cut -d' ' -f2
end

function get_version
  cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1
end

flutter build apk --release --dart-define=APPVER=(get_version) --no-tree-shake-icons

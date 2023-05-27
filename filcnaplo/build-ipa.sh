#!/bin/sh

flutter build ipa --release --dart-define=APPVER=$(cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1) --no-tree-shake-icons

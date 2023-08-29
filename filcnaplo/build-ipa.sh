#!/bin/sh

flutter clean
dart pub get
flutter doctor -v

flutter build ipa --release --dart-define=APPVER=$(cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1) --no-tree-shake-icons

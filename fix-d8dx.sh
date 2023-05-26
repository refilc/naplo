#!/bin/sh

cd $ANDROID_SDK/build-tools/31.0.0 &&
  mv -v d8 dx &&
  cd lib &&
  mv -v d8.jar dx.jar

#!/bin/sh

cd filcnaplo && pwd && flutter clean && flutter pub get && cd ..
cd filcnaplo_kreta_api && pwd && flutter clean && flutter pub get && cd ..
cd filcnaplo_mobile_ui && pwd && flutter clean && flutter pub get && cd ..
cd filcnaplo_desktop_ui && pwd && flutter clean && flutter pub get && cd ..

echo Fixed pub.
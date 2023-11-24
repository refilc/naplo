#!/bin/bash

# Mappák
directories=("filcnaplo" "filcnaplo_kreta_api" "filcnaplo_mobile_ui" "filcnaplo_desktop_ui" "filcnaplo_premium")

for dir in "${directories[@]}"; do
  # zsa bele a mappaba, flutter upgrade.
  (cd "$dir" && flutter pub upgrade)
done
# loop vege, vissza az elozo mappaba.

echo "Upgraded pub."

#!/bin/bash
# Снимает экраны на запущенном iOS-симуляторе или Android-эмуляторе:
#   ./integration_test/screenshots.sh [out_dir]
# Для Google Play нужен AVD с экраном 9:16 (напр. 1080x1920): скриншоты
# снимаются как есть, без обрезки.
set -eu
OUT=${1:-build/screenshots}; mkdir -p "$OUT"
ADB=${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb
if [ -n "$("$ADB" devices 2>/dev/null | grep -w device || true)" ]; then
  DEV=$("$ADB" devices | grep -w device | head -1 | cut -f1)
  snap() { "$ADB" -s "$DEV" exec-out screencap -p > "$OUT/$1.png"; }
else
  DEV=$(xcrun simctl list devices booted | grep -oE '[0-9A-F-]{36}' | head -1)
  snap() { xcrun simctl io booted screenshot "$OUT/$1.png" >/dev/null 2>&1; }
fi
flutter test integration_test/screenshots_test.dart -d "$DEV" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    [[ $line =~ SHOT:([a-z]+) ]] && snap "${BASH_REMATCH[1]}" || true
  done

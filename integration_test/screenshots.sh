#!/bin/bash
# Снимает экраны на запущенном симуляторе: ./integration_test/screenshots.sh [out_dir]
set -eu
OUT=${1:-build/screenshots}; mkdir -p "$OUT"
flutter test integration_test/screenshots_test.dart -d "$(xcrun simctl list devices booted | grep -oE '[0-9A-F-]{36}' | head -1)" 2>&1 |
  while IFS= read -r line; do
    echo "$line"
    [[ $line =~ SHOT:([a-z]+) ]] && xcrun simctl io booted screenshot "$OUT/${BASH_REMATCH[1]}.png" >/dev/null 2>&1 || true
  done

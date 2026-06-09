#!/usr/bin/env bash

PORT=5900
MONITOR_NAME=$(hyprctl monitors all -j | python3 -c "
import sys, json
data = json.load(sys.stdin)
headless = [m for m in data if m.get('name', '').startswith('HEADLESS')]
if headless:
    print(headless[-1]['name'])
")

echo "Terminating wayvnc..."
pkill -f "wayvnc --output=$MONITOR_NAME" 2>/dev/null || pkill wayvnc 2>/dev/null

if [ -n "$MONITOR_NAME" ]; then
    echo "Removing virtual monitor $MONITOR_NAME..."
    hyprctl output remove "$MONITOR_NAME"
fi

echo "Clearing ADB reverse mappings..."
adb reverse --remove tcp:$PORT 2>/dev/null

echo "Cleanup complete."

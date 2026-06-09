#!/usr/bin/env bash

PORT=5900

echo "Checking for connected Android devices via USB..."
if ! adb devices | grep -q -E "device$"; then
    echo "ERROR: No authorized Android device detected. Plug in your USB-C cable and allow debugging."
    exit 1
fi

echo "Setting up ADB reverse port forwarding on port $PORT..."
adb reverse tcp:$PORT tcp:$PORT

echo "Creating virtual headless monitor..."
hyprctl output create headless

sleep 0.3

MONITOR_NAME=$(hyprctl monitors all -j | python3 -c "
import sys, json
data = json.load(sys.stdin)
headless = [m for m in data if m.get('name', '').startswith('HEADLESS')]
if headless:
    print(headless[-1]['name'])
")

if [ -z "$MONITOR_NAME" ]; then
    echo "ERROR: Could not find the headless monitor."
    exit 1
fi

echo "Detected monitor: $MONITOR_NAME"

hyprctl keyword monitor "$MONITOR_NAME,1920x1080@60,auto-right,1"

echo "Setting up workspace 10 on the secondary screen..."
hyprctl dispatch moveworkspacetomonitor 10 "$MONITOR_NAME"
hyprctl dispatch focusmonitor "$MONITOR_NAME"
hyprctl dispatch workspace 10
hyprctl dispatch focusmonitor eDP-1

echo "Starting wayvnc..."
wayvnc --output="$MONITOR_NAME" --config=<(echo -e "enable_auth=false\naddress=0.0.0.0\nport=$PORT") > /dev/null 2>&1 &

echo "--------------------------------------------------------"
echo "Success! Open AVNC on your phone."
echo "Connect to Host: 127.0.0.1  |  Port: $PORT"
echo "--------------------------------------------------------"

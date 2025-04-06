#!/bin/bash

# Start ADB server
adb start-server

# Start QEMU Android emulator in background (full system view on VNC :0)
qemu-system-x86_64 \
    -m 2048 \
    -hda android-disk.qcow2 \
    -net nic -net user,hostfwd=tcp::5555-:5555 \
    -vnc :0 \
    -daemonize

# Wait for emulator to boot (adjust sleep based on VPS performance)
sleep 30

# Connect ADB to emulator
adb connect localhost:5555

# Install demo APK
adb -s localhost:5555 install /android/demo.apk

# Start VNC server for full system view (port 5900)
tightvncserver :0 -geometry 1280x720 -depth 24 &

# Start a second VNC server for emulator-only view (port 5901)
# This uses a minimal X session focused on the emulator
xterm -e "qemu-system-x86_64 -m 2048 -hda android-disk.qcow2 -net nic -net user,hostfwd=tcp::5555-:5555 -vnc :1" &
tightvncserver :1 -geometry 800x600 -depth 24 &

# Keep container running
tail -f /dev/null

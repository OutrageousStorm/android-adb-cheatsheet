# 🐚 Advanced ADB Shell Tricks

One-liners and shell techniques that go beyond basic ADB.

## One-liner collection

### Find the largest files on device
```bash
adb shell "find /data /sdcard -type f -size +10M -exec ls -lh {} \; | sort -k5 -h | tail -20"
```

### Monitor CPU temperature in real time
```bash
adb shell "while true; do cat /sys/devices/virtual/thermal/thermal_zone0/temp; sleep 1; done"
```

### Watch app memory usage as it increases
```bash
adb shell "watch -n 1 'dumpsys meminfo com.example.app | grep TOTAL'"
```

### Kill an app every time it starts (for testing)
```bash
adb shell "pm disable com.example.app && pm enable com.example.app"
adb shell "while true; do am force-stop com.example.app; sleep 1; done"
```

### Log all network connections in real time (root)
```bash
adb shell "while true; do netstat -tulnp 2>/dev/null | grep ESTABLISHED; sleep 2; done"
```

### Dump all installed APKs and their sizes
```bash
adb shell "pm list packages -f | sed 's/^package://' | while read pkg; do du -h "$pkg"; done | sort -h"
```

### Extract SQLite database and pull to PC
```bash
# Find databases
adb shell "find /data -name '*.db' -type f"
# Copy one to accessible location
adb shell "cp /data/data/com.example.app/databases/app.db /sdcard/"
adb pull /sdcard/app.db ./
# Open with: sqlite3 app.db
```

### Monitor battery drain live (top consumers)
```bash
adb shell "dumpsys batterystats --reset && sleep 60 && dumpsys batterystats | grep 'UID' | sort -k2 -nr | head -10"
```

### Capture network packets on device (tcpdump)
```bash
adb shell "tcpdump -i any -w /sdcard/capture.pcap" &
# Let it run, then:
adb pull /sdcard/capture.pcap
# View in Wireshark
```

### Trigger emergency mode (airplane on)
```bash
adb shell "settings put global airplane_mode_on 1 && am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"
```

### Stress test CPU
```bash
adb shell "while true; do timeout 2 /system/bin/sh -c 'while :; do :; done' & done"
```

### Clear all caches without uninstalling apps
```bash
adb shell "pm trim-caches 10G"
```

### List all running services and their memory usage
```bash
adb shell "dumpsys meminfo --local | grep Service"
```

## Shell scripting on device

Run a multi-line shell script directly:
```bash
adb shell << 'EOF'
#!/bin/sh
# Count total app data size
total=0
for dir in /data/data/*/; do
    size=$(du -s "$dir" | awk '{print $1}')
    total=$((total + size))
done
echo "Total app data: $((total / 1024 / 1024)) MB"
EOF
```

## Recursive directory operations

```bash
# Delete all .cache files recursively
adb shell "find /sdcard -name '.cache' -type d -exec rm -rf {} \;"

# Rename all .tmp files to .bak
adb shell "find /sdcard -name '*.tmp' -exec sh -c 'mv "$1" "${1%.tmp}.bak"' _ {} \;"

# Count files by type
adb shell "find /sdcard -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn"
```

## Debugging tricks

### View last 100 lines of logcat with timestamps
```bash
adb logcat -v time | tail -n 100
```

### Filter logcat to specific app with colors
```bash
adb logcat --pid=$(adb shell pidof com.example.app) | grep --color=auto ""
```

### Monitor app crashes in real time
```bash
adb logcat | grep -i "FATAL\|Exception\|ANR"
```

### Capture a crash log to file
```bash
adb logcat > crash_$(date +%s).log &
# Let the crash happen
# Kill the background logcat: pkill -f "adb logcat"
```

## Performance monitoring

### CPU % per process
```bash
adb shell "top -n 1 | head -20"
```

### Memory stats with graphs
```bash
adb shell "dumpsys meminfo --unreachable"
```

### Frame drops (jank) on screen
```bash
adb shell "dumpsys gfxinfo com.example.app framestats"
```

### Check if app is ANR-ing (hung)
```bash
adb shell "dumpsys anr | grep com.example.app"
```

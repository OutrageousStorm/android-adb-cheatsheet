# Advanced ADB Commands

Professional-grade ADB techniques for power users.

## Remote ADB (wireless)

```bash
# Enable on device (Settings → Developer Options → Wireless debugging)
adb pair <device-ip>:<pair-port> <pair-code>
adb connect <device-ip>:5555

# Or via local method
adb tcpip 5555
adb connect <device-ip>:5555
adb tcpip 0          # disable tcpip, revert to USB
```

## Profiling & debugging

```bash
# Method tracing (trace app function calls)
adb shell am trace-ipc start
# Use app normally
adb shell am trace-ipc stop --async
adb pull /data/anr/

# Memory profiling
adb shell dumpsys meminfo --unreachable

# CPU profiling
adb shell cmd package dump-profiles com.example.app

# ANR stack traces
adb shell cat /data/anr/anr_*  # crash logs
```

## System-level debugging

```bash
# SELinux audit logs
adb shell cat /proc/fs/selinux/avc

# Kernel messages
adb shell dmesg | grep -i error

# System event log
adb shell dumpsys eventlog

# Thermal info
adb shell dumpsys thermalservice
adb shell cat /sys/class/thermal/thermal_zone*/temp
```

## Advanced networking

```bash
# PCAP traffic dump (requires root or Magisk)
adb shell su -c "tcpdump -i any -w /sdcard/capture.pcap -s 0"

# Monitor active connections in real-time
adb shell watch -n 1 'netstat -tulnp | grep ESTABLISHED'

# DNS query logs
adb shell nslookup example.com
adb shell cat /proc/net/dns_resolver
```

## SQLite database inspection

```bash
# Access app database (rooted)
adb shell su -c "sqlite3 /data/data/com.example.app/databases/db.db"
sqlite> .tables
sqlite> SELECT * FROM table_name LIMIT 10;

# Or pull and inspect locally
adb pull /data/data/com.example.app/databases/ ./
sqlite3 db.db ".dump" > dump.sql
```

## Monkey stress testing

```bash
# Send 10,000 random events
adb shell monkey -p com.example.app -v 10000

# Test specific activity
adb shell monkey -p com.example.app -c android.intent.category.LAUNCHER 100

# Watch for crashes
adb shell monkey -p com.example.app --throttle 500 10000 2>&1 | grep -i crash
```

## Battery & thermal

```bash
# Fake battery level (testing)
adb shell dumpsys battery set level 30

# Thermal throttling
adb shell dumpsys thermalservice | grep "Current throttling level"
adb shell settings put global max_cpu_freq 1500000  # limit CPU (MHz)

# Doze testing
adb shell dumpsys battery set status 2  # simulate unplugged
adb shell dumpsys deviceidle force-idle  # force doze
adb shell dumpsys deviceidle step light  # light doze
```

## Intent inspection

```bash
# Monitor all sent intents
adb shell dumpsys activity intents | grep "mAction"

# Log broadcasts
adb shell dumpsys activity broadcasts

# Find all exported Activities
adb shell dumpsys package com.example.app | grep "exported"
```

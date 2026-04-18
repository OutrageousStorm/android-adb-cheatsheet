# ADB Performance & Profiling Commands

## CPU & Thermal

```bash
# Current CPU frequency
adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# Max CPU frequency
adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq

# Available governors
adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors

# Switch governor (requires root)
adb shell su -c "echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

# CPU temperature
adb shell cat /sys/class/thermal/thermal_zone0/temp

# Thermal throttling info
adb shell dumpsys thermalmanager

# Top CPU consumers
adb shell top -n 1 | head -20

# Per-process CPU stats
adb shell ps aux | head -10
```

## Memory Profiling

```bash
# Total memory usage
adb shell dumpsys meminfo | head -20

# Per-app memory
adb shell dumpsys meminfo com.example.app

# Heap dumps
adb shell am dumpheap com.example.app /data/anr/heap.hprof
adb pull /data/anr/heap.hprof ./

# Available memory
adb shell cat /proc/meminfo | grep Available

# Memory pressure
adb shell cat /proc/pressure/memory
```

## Disk I/O

```bash
# I/O stats per device
adb shell cat /proc/diskstats

# Currently open files
adb shell lsof | head -20

# Find largest files on device
adb shell find /data -type f -size +100M
```

## Frame Rate & Rendering

```bash
# Enable HW rendering profiling
adb shell setprop debug.hwui.profile true

# Check current frame rate
adb shell getprop ro.surface_flinger.display_primary_fps

# Force frame rate limit
adb shell settings put secure hz 60
```

## Battery Profiling

```bash
# Reset battery stats
adb shell dumpsys batterystats --reset

# Let device run for 2–4 hours, then collect
adb bugreport bugreport.zip

# Upload to: https://bathist.ef.lc/
```

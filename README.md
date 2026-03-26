# 📋 Android ADB Cheatsheet

150+ ADB commands for Android power users. No root required unless noted.

---

## Setup

```bash
# Install ADB (Linux)
sudo apt install adb

# Install ADB (Mac)
brew install android-platform-tools

# Install ADB (Windows)
# Download SDK Platform Tools: https://developer.android.com/studio/releases/platform-tools

# Enable on device: Settings → Developer Options → USB Debugging
adb devices          # list connected devices
adb -s <serial> <cmd>  # target specific device
```

---

## 📱 Device info

```bash
adb shell getprop ro.product.model          # device model
adb shell getprop ro.build.version.release  # Android version
adb shell getprop ro.product.cpu.abi        # CPU architecture
adb shell getprop ro.serialno               # serial number
adb shell getprop ro.build.fingerprint      # build fingerprint
adb shell wm size                           # screen resolution
adb shell wm density                        # screen DPI
adb shell cat /proc/meminfo | head -5       # RAM info
adb shell df -h /data                       # storage info
adb shell getprop ro.build.version.sdk      # API level
```

---

## 📦 App management

```bash
adb install app.apk                              # install APK
adb install -r app.apk                           # reinstall (keep data)
adb install -d app.apk                           # allow downgrade
adb uninstall com.example.app                    # uninstall
adb shell pm list packages                       # list all packages
adb shell pm list packages -3                    # list user-installed only
adb shell pm list packages -s                    # list system packages
adb shell pm list packages | grep facebook       # search packages
adb shell pm uninstall -k --user 0 com.pkg.name  # disable system app (no root)
adb shell cmd package install-existing com.pkg   # re-enable system app
adb shell pm clear com.example.app               # clear app data + cache
adb shell am force-stop com.example.app          # force stop app
adb shell pm disable-user --user 0 com.pkg       # disable app for user
adb shell pm enable com.pkg                      # re-enable app
adb pull $(adb shell pm path com.pkg | cut -d: -f2) ./app.apk  # extract APK
```

---

## 🔐 Permissions

```bash
adb shell dumpsys package com.example.app | grep permission   # list permissions
adb shell pm grant com.example.app android.permission.CAMERA  # grant permission
adb shell pm revoke com.example.app android.permission.CAMERA # revoke permission
adb shell appops set com.pkg CAMERA deny                      # deny via AppOps
adb shell appops set com.pkg READ_CLIPBOARD deny              # block clipboard read
adb shell appops set com.pkg RECORD_AUDIO deny                # block mic
adb shell appops set com.pkg COARSE_LOCATION deny             # block coarse location
adb shell appops set com.pkg FINE_LOCATION deny               # block fine location
```

---

## ⚙️ Settings

```bash
# System settings
adb shell settings get system <key>
adb shell settings put system <key> <value>

# Secure settings
adb shell settings get secure <key>
adb shell settings put secure <key> <value>

# Global settings
adb shell settings get global <key>
adb shell settings put global <key> <value>

# Useful examples
adb shell settings put system screen_brightness 128         # brightness 0-255
adb shell settings put system screen_brightness_mode 0      # manual brightness
adb shell settings put global airplane_mode_on 1            # airplane mode
adb shell settings put global wifi_on 0                     # disable WiFi
adb shell settings put system font_scale 0.85               # smaller font
adb shell settings put global development_settings_enabled 1 # enable dev options
adb shell settings put secure enabled_accessibility_services # list accessibility
adb shell settings put global limit_ad_tracking 1           # disable ad tracking
adb shell settings put secure location_mode 0               # disable location
adb shell settings put secure location_mode 3               # enable high accuracy
```

---

## 📁 File operations

```bash
adb push local_file.txt /sdcard/           # push file to device
adb pull /sdcard/file.txt ./               # pull file from device
adb pull /sdcard/DCIM/ ./photos/           # pull entire folder
adb shell ls /sdcard/                      # list files
adb shell rm /sdcard/file.txt              # delete file
adb shell mkdir /sdcard/newfolder          # create folder
adb shell cp /sdcard/a.txt /sdcard/b.txt  # copy file
adb shell mv /sdcard/a.txt /sdcard/b.txt  # move file
adb shell find /sdcard -name "*.jpg"       # find files
adb shell du -sh /sdcard/DCIM             # folder size
```

---

## 📡 Network

```bash
adb shell ip addr                          # network interfaces
adb shell ip route                         # routing table
adb shell netstat -tulnp                   # open ports
adb forward tcp:8080 tcp:8080              # port forward host→device
adb reverse tcp:8080 tcp:8080              # port reverse device→host
adb shell nslookup google.com              # DNS lookup
adb shell ping -c 4 8.8.8.8               # ping
adb shell wget -O- https://example.com     # HTTP request
adb shell settings put global http_proxy host:port  # set HTTP proxy
adb shell settings put global http_proxy :0          # clear proxy
```

---

## 📸 Screen capture

```bash
adb exec-out screencap -p > screenshot.png             # screenshot (fast)
adb shell screencap -p /sdcard/screen.png && adb pull /sdcard/screen.png
adb shell screenrecord /sdcard/video.mp4               # record screen
adb shell screenrecord --time-limit 30 /sdcard/v.mp4  # 30 second limit
adb shell screenrecord --size 720x1280 /sdcard/v.mp4  # custom resolution
```

---

## 🖥️ Display & UI

```bash
adb shell wm size 1080x1920               # set resolution
adb shell wm size reset                   # reset resolution
adb shell wm density 420                  # set DPI
adb shell wm density reset                # reset DPI
adb shell input tap 500 500               # tap at coordinates
adb shell input swipe 200 800 200 200     # swipe up
adb shell input text "hello world"        # type text
adb shell input keyevent 26               # power button
adb shell input keyevent 3                # home button
adb shell input keyevent 4                # back button
adb shell input keyevent 24               # volume up
adb shell input keyevent 25               # volume down
adb shell service call phone 5            # end call
```

---

## 🔋 Battery

```bash
adb shell dumpsys battery                          # battery info
adb shell dumpsys batterystats | head -50          # battery stats
adb shell dumpsys batterystats --reset             # reset stats
adb shell settings put global low_power 1          # enable battery saver
adb shell settings put global low_power 0          # disable battery saver
adb shell dumpsys battery set level 50             # fake battery level (testing)
adb shell dumpsys battery reset                    # restore real battery
```

---

## 🧠 Memory & CPU

```bash
adb shell cat /proc/meminfo                        # memory details
adb shell cat /proc/cpuinfo                        # CPU details
adb shell top -n 1 | head -20                      # top processes
adb shell ps -A | grep -i chrome                   # find process
adb shell dumpsys meminfo com.example.app          # app memory usage
adb shell am kill com.example.app                  # kill background app
adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq  # CPU freq
adb shell cat /sys/class/thermal/thermal_zone0/temp # temperature (÷1000 = °C)
```

---

## 🔃 Fastboot commands

```bash
# Reboot into fastboot
adb reboot bootloader

fastboot devices                      # list devices
fastboot oem unlock                   # unlock bootloader (wipes data)
fastboot flashing unlock              # newer unlock method
fastboot flash recovery twrp.img      # flash recovery
fastboot flash boot boot.img          # flash boot partition
fastboot boot twrp.img                # temp boot (no flash)
fastboot flash system system.img      # flash system
fastboot erase userdata               # wipe data
fastboot erase cache                  # wipe cache
fastboot reboot                       # reboot
fastboot reboot recovery              # reboot to recovery
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot getvar all                   # all device variables
fastboot getvar current-slot          # A/B slot
fastboot set_active other             # switch A/B slot
```

---

## 🐚 Useful shell one-liners

```bash
# List all installed APKs with names
adb shell pm list packages -f | sed "s/.*=//" | sort

# Get all app permissions in use
adb shell dumpsys package | grep "uses-permission"

# Find large files on sdcard
adb shell find /sdcard -size +100M -exec ls -lh {} \;

# Watch logcat filtered to one app
adb logcat --pid=$(adb shell pidof com.example.app)

# Backup all APKs
adb shell pm list packages -3 | cut -d: -f2 | while read pkg; do
  adb pull $(adb shell pm path $pkg | cut -d: -f2) ./$pkg.apk
done

# Enable wireless ADB (Android 11+)
adb tcpip 5555
adb connect <device-ip>:5555
```

---

*See also: [android-tweaks-toolkit](https://github.com/OutrageousStorm/android-tweaks-toolkit)*  
*Maintained by [OutrageousStorm](https://github.com/OutrageousStorm)*

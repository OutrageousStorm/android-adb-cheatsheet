# Input Commands

Simulate user input via ADB — taps, swipes, text, keys.

```bash
# Tap at coordinates
adb shell input tap 540 960

# Swipe (from x1,y1 to x2,y2 over duration_ms)
adb shell input swipe 540 1500 540 500 300

# Type text (replaces spaces with %s)
adb shell input text "hello%sworld"

# Key event codes
adb shell input keyevent 3       # HOME
adb shell input keyevent 4       # BACK
adb shell input keyevent 26      # POWER
adb shell input keyevent 24      # VOL_UP
adb shell input keyevent 25      # VOL_DOWN
adb shell input keyevent 66      # ENTER
adb shell input keyevent 67      # DELETE
adb shell input keyevent 187     # APP_SWITCH (recent apps)

# Full keycode reference:
# https://developer.android.com/reference/android/view/KeyEvent
```

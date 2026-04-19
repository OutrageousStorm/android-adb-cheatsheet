#!/usr/bin/env python3
import subprocess

PRESETS = {
    "battery": "dumpsys battery | grep -E \'level|status|temp\'",
    "screen": "wm size; wm density",
    "memory": "cat /proc/meminfo | head -5",
    "cpu": "cat /proc/cpuinfo | grep Hardware",
    "processes": "ps -A | head -15",
}

def adb(cmd):
    r = subprocess.run(f"adb shell {cmd}", shell=True, capture_output=True, text=True)
    return r.stdout.strip()

def main():
    print("\n📱 ADB REPL — type command or preset name\n")
    while True:
        try:
            inp = input("adb> ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\nBye!")
            break
        if not inp: continue
        if inp in ["q", "quit"]: break
        if inp == "help":
            print("Presets:", ", ".join(PRESETS.keys()))
            continue
        cmd = PRESETS.get(inp, inp)
        print()
        result = adb(cmd)
        print(result if result else "(no output)")
        print()

if __name__ == "__main__":
    main()

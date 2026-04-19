#!/bin/bash
# adb.sh -- Bash wrapper around ADB cheatsheet commands
# Interactive menu-driven ADB command runner
# Usage: ./adb.sh

set -e

BOLD='\033[1m'; CYAN='\033[0;36m'; GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'

show_menu() {
    cat << EOF

${BOLD}${CYAN}ADB Cheatsheet Menu${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1) Device Info          5) Permissions        9) Network
2) Apps & Packages     6) Settings          10) Screenshot/Record
3) Files & Storage     7) Battery & Power   11) Fastboot
4) System Monitor      8) Display & UI      0) Exit

EOF
    read -rp "Choose: " choice
    case $choice in
        1) show_device_info ;;
        2) show_apps ;;
        3) show_storage ;;
        4) show_system ;;
        5) show_permissions ;;
        6) show_settings ;;
        7) show_battery ;;
        8) show_display ;;
        9) show_network ;;
        10) show_screen ;;
        11) show_fastboot ;;
        0) exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
    show_menu
}

show_device_info() {
    echo -e "\n${BOLD}Device Information${NC}"
    echo "Model: $(adb shell getprop ro.product.model)"
    echo "Brand: $(adb shell getprop ro.product.brand)"
    echo "Android: $(adb shell getprop ro.build.version.release)"
    echo "API Level: $(adb shell getprop ro.build.version.sdk)"
    echo "Security Patch: $(adb shell getprop ro.build.version.security_patch)"
    echo "CPU Arch: $(adb shell getprop ro.product.cpu.abi)"
}

show_apps() {
    echo -e "\n${BOLD}Apps & Packages${NC}"
    echo "  1) List user apps"
    echo "  2) List system apps"
    echo "  3) Find app by keyword"
    echo "  4) Uninstall app"
    read -rp "Choose: " sub
    case $sub in
        1) adb shell pm list packages -3 | cut -d: -f2 | nl ;;
        2) adb shell pm list packages -s | cut -d: -f2 | nl ;;
        3) read -rp "Keyword: " kw; adb shell pm list packages | grep "$kw" ;;
        4) read -rp "Package name: " pkg; adb uninstall "$pkg" ;;
    esac
    read -p "Press Enter to continue..."
}

show_storage() {
    echo -e "\n${BOLD}Storage${NC}"
    adb shell df -h /data /sdcard
}

show_system() {
    echo -e "\n${BOLD}System Monitor${NC}"
    echo "Top CPU processes:"
    adb shell top -n 1 | head -10
    read -p "Press Enter to continue..."
}

show_permissions() {
    echo -e "\n${BOLD}Permissions${NC}"
    read -rp "Package name: " pkg
    echo "Dangerous permissions for $pkg:"
    adb shell dumpsys package "$pkg" | grep -i permission | head -10
}

show_settings() {
    echo -e "\n${BOLD}Settings${NC}"
    echo "  1) Enable/Disable WiFi"
    echo "  2) Set brightness"
    echo "  3) Enable developer options"
    read -rp "Choose: " sub
    case $sub in
        1) read -rp "Enable? (1/0): " val; adb shell settings put global wifi_on "$val" ;;
        2) read -rp "Brightness (0-255): " val; adb shell settings put system screen_brightness "$val" ;;
        3) adb shell settings put global development_settings_enabled 1 ;;
    esac
}

show_battery() {
    echo -e "\n${BOLD}Battery & Power${NC}"
    adb shell dumpsys battery | head -15
}

show_display() {
    echo -e "\n${BOLD}Display${NC}"
    echo "Resolution: $(adb shell wm size)"
    echo "DPI: $(adb shell wm density)"
}

show_network() {
    echo -e "\n${BOLD}Network${NC}"
    echo "IP Address: $(adb shell ip route | grep src | awk '{print $NF}')"
    echo "WiFi Info: $(adb shell dumpsys wifi | grep 'SSID' | head -1)"
}

show_screen() {
    echo -e "\n${BOLD}Screenshot & Recording${NC}"
    echo "  1) Take screenshot"
    echo "  2) Record screen (30s)"
    read -rp "Choose: " sub
    case $sub in
        1) adb exec-out screencap -p > "screenshot_$(date +%s).png" && echo "Saved screenshot" ;;
        2) adb shell screenrecord --time-limit 30 /sdcard/video.mp4 && adb pull /sdcard/video.mp4 ;;
    esac
}

show_fastboot() {
    echo -e "\n${BOLD}Fastboot${NC}"
    echo "  1) List fastboot devices"
    echo "  2) Reboot bootloader"
    echo "  3) Reboot recovery"
    read -rp "Choose: " sub
    case $sub in
        1) fastboot devices ;;
        2) adb reboot bootloader ;;
        3) adb reboot recovery ;;
    esac
}

main() {
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}adb not found. Install Android SDK Platform Tools.${NC}"
        exit 1
    fi
    if ! adb devices | grep -q device$; then
        echo -e "${RED}No device connected.${NC}"
        exit 1
    fi
    show_menu
}

main

# ADB autocompletion for bash
complete -W "devices push pull install uninstall shell logcat reboot help" adb
complete -W "pm dumpsys am settings input input-text getprop" adb_shell

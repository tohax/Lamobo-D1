#!/bin/sh
2>/dev/null if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
2>/dev/null if pgrep dropbear; then killall -9 dropbear; fi

#!/bin/sh
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
if pgrep dropbear; then killall -9 dropbear; fi

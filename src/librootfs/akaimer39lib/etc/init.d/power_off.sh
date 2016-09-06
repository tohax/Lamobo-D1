#!/bin/sh
/etc/init.d/wifi_led.sh r_led off
/etc/init.d/wifi_led.sh g_led off
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
rm -rf /var/run/wpa_supplicant
if pgrep dropbear; then killall -9 dropbear; fi
if [ ! `pgrep record_video` ]; then
/etc/init.d/camera.sh &
fi

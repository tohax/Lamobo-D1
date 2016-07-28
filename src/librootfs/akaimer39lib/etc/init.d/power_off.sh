#!/bin/sh
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
rm -rf /var/run/wpa_supplicant
if pgrep dropbear; then killall -9 dropbear; fi
#ifdown wlan0
if [[ "`pgrep camera.sh`" = "" ]]; then
/etc/init.d/camera.sh fi
echo 1 > /sys/class/leds/g_led/brightness
/etc/init.d/wifi_led.sh r_led blink 1000 900
fi

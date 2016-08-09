
#!/bin/sh
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
rm -rf /var/run/wpa_supplicant
if pgrep dropbear; then killall -9 dropbear; fi
#/etc/init.d/camera.sh

if [ ! `pgrep record_video` ]; then 
/etc/init.d/camera.sh &
/etc/init.d/wifi_led.sh g_led on
/etc/init.d/wifi_led.sh r_led blink 1000 900
fi


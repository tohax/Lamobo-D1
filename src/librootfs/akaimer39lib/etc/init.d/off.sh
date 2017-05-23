#!/bin/sh
echo -e  "\n---------------------------\n PowerOff `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
/etc/init.d/wifi_led.sh r_led off
/etc/init.d/wifi_led.sh g_led off
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
if pgrep dropbear; then kill `pgrep dropbear`; fi
rmmod 8192cu
if [ ! `pidof record_video` ]; then
/etc/init.d/camera.sh &
fi

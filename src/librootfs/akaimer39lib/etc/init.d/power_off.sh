#!/bin/sh
echo -e  "\n---------------------------\n PowerOff `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
/etc/init.d/wifi_led.sh r_led off
/etc/init.d/wifi_led.sh g_led off
if pgrep wpa_supplicant; then kill -2 `pgrep wpa_supplicant`; fi
#rm -rf /var/run/wpa_supplicant
if pgrep dropbear; then kill -2 `pgrep dropbear`; fi
rmmod 8192cu
if [ ! `pgrep record_video` ]; then
/etc/init.d/camera.sh &
fi

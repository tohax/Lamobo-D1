#!/bin/bash
sleep 1
echo 0 > /sys/class/leds/r_led/brightness
echo 0 > /sys/class/leds/g_led/brightness
if pgrep on.sh; then kill `pgrep on.sh`; fi
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
if pgrep dropbear; then kill `pgrep dropbear`; fi
modprobe -r 8192cu
if /bin/dmesg | tail -3 | grep SurpriseRemoved; then /sbin/reboot; fi
echo -e  "\n PowerOFF `date +"%x"" ""%X"`\n" >> /etc/`hostname`.txt
if [ ! `pidof record_video` ]; then
 /etc/init.d/camera.sh &
fi

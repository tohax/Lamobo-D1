#!/bin/sh
echo -e  "\n PowerOFF `date +"%x"" ""%X"`\n" >> /etc/`hostname`.txt
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
if pgrep dropbear; then kill `pgrep dropbear`; fi
rmmod 8192cu
if [ ! `pidof record_video` ]; then
 /etc/init.d/camera.sh &
fi

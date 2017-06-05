#!/bin/sh
source /etc/profile
if pidof on.sh; then kill `pidof on.sh`; fi
echo 0 > /sys/class/leds/r_led/brightness
echo 0 > /sys/class/leds/g_led/brightness
 for pid in $(pidof power.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi
 done
if [ ! `lsmod | grep 8192cu` ]; then modprobe 8192cu; fi
sleep 5
if [ -d /sys/class/net/wlan0 ]; then

	/etc/init.d/on.sh &
else

	/etc/init.d/off.sh &
fi

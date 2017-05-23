#!/bin/sh
/etc/init.d/wifi_led.sh r_led off
/etc/init.d/wifi_led.sh g_led off

for pid in $(pidof power.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi
done

modprobe 8192cu
sleep 10
if [ -d /sys/class/net/wlan0 ]; then
        /etc/init.d/on.sh
else
        /etc/init.d/off.sh
fi


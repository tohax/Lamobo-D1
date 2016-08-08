#!/bin/sh
while [ ! -d /sys/class/net/wlan0 ]
do
/mnt/record_video -t 30 -P 1 -w 1280 -h 720 -r 1 -l 0 -v 0 -q 40 -m 0 -b 100000 -a 2
done


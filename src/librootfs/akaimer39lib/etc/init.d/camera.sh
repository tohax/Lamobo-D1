#!/bin/sh
if [ ! -d /mnt/`date +%Y%m%d`/`hostname` ]; then mkdir /mnt/`date +%Y%m%d`/`hostname`; chmod 755 /mnt/`date +%Y%m%d`/`hostname`; fi
RECORD_PATH=/mnt/`date +%Y%m%d`/`hostname`
while [ ! -d /sys/class/net/wlan0 ]
do
/mnt/record_video -t 300 -p $RECORD_PATH -P 1 -w 640 -h 480 -r 1 -l 0 -v 0 -q 40 -m 0 -b 100000 -a 2
rm -f $RECORD_PATH/*index
done

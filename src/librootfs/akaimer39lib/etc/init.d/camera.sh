#!/bin/sh
export HOME=/etc
RECORD_PATH=/mnt/`date +%Y%m%d`/`hostname`
if [ ! -d $RECORD_PATH ]; then
 mkdir -p $RECORD_PATH
 chmod 755 $RECORD_PATH
fi
while true
 do
TIME=`date +%H`
if [ $TIME -ge 23 ] && [ $TIME -le 5 ]; then exit; fi
 /etc/init.d/record_video -t 300 -p $RECORD_PATH -P 2 -w 640 -h 480 -r 1 -l 0 -v 0 -q 40 -m 0 -b 10000 -a 2 2>/dev/null
 echo 3 > /proc/sys/vm/drop_caches
 sync
done


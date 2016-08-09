
#!/bin/sh
RECORD_PATH=/mnt/`hostname`/`date +%Y%m%d`/`hostname`
if [ ! -d $RECORD_PATH ]; then 
mkdir -p $RECORD_PATH 
chmod 755 $RECORD_PATH
fi
while true
do
/etc/init.d/record_video -t 300 -p $RECORD_PATH -P 1 -w 640 -h 480 -r 1 -l 0 -v 0 -q 40 -m 0 -b 100000 -a 2 2>/dev/null
done


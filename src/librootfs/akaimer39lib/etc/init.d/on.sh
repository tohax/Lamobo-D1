#!/bin/bash
if pidof camera.sh; then kill `pidof camera.sh`; fi
if pidof record_video; then kill -SIGINT `pidof record_video`; fi
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
Server=10.10.10.1
modprobe 8192cu
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
/etc/init.d/wifi.sh
sleep 1
dropbear -R -B
rdate -s $Server
hwclock --systohc
echo heartbeat > /sys/class/leds/r_led/trigger
sleep 1
echo heartbeat > /sys/class/leds/g_led/trigger
time=`date +%Y%m%d`
echo `date` > /etc/_ON_`hostname`.txt
find /mnt/ -name "*index" -exec rm {} \;
rsync -av --remove-source-files --password-file=/etc/.rsync /etc/_ON_`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
rsync -av --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/ root@$Server::video/oneday/
rsync -av --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
find /mnt/[1-9]* -type d -delete 2>/dev/null
echo none > /sys/class/leds/g_led/trigger
echo none > /sys/class/leds/r_led/trigger
echo 0 > /sys/class/leds/g_led/brightness
echo 1 > /sys/class/leds/r_led/brightness

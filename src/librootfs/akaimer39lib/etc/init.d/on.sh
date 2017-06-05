#!/bin/sh
Server=10.10.10.1
AP=Avtobus
export HOME=/etc PWD=/etc
echo -e "\nPowerOn `date +"%x"" ""%X"`\n" >> /etc/`hostname`.txt
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
 if iwlist wlan0 scan | grep -i $AP; then
	/etc/init.d/wifi.sh
	until iwconfig wlan0 | grep $AP
	do
	sleep 3
	echo "Try again"
	done
	echo `iwconfig wlan0 | grep ESSID`
	if pgrep dropbear; then kill `pgrep dropbear`; fi
	dropbear -R -B
	if pidof camera.sh; then kill `pidof camera.sh`; fi
	if pidof record_video; then kill -SIGINT `pidof record_video`; fi
	#echo 3 > /proc/sys/vm/drop_caches
	#sync
	echo "Updating time"
	ntpd -q -p 1.ru.pool.ntp.org
	sleep 10
	echo `date`
	echo heartbeat > /sys/class/leds/r_led/trigger
	sleep 1
	echo heartbeat > /sys/class/leds/g_led/trigger
	time=`date +%Y%m%d`
	echo `date` > /etc/_ON_`hostname`.txt
	find /mnt/ -name "*index" -exec rm {} \;
	rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/_ON_`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
	rsync -av --no-o --no-g --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/ root@$Server::video/oneday/
	rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
	find /mnt/[1-9]* -type d -delete
	echo none > /sys/class/leds/g_led/trigger
	echo none > /sys/class/leds/r_led/trigger
	echo 0 > /sys/class/leds/g_led/brightness
 	echo 1 > /sys/class/leds/r_led/brightness
 else
	/etc/init.d/off.sh &
 fi

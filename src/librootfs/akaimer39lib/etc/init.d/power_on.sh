#!/bin/sh
AP=bus
Server=10.10.10.2
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
insmod /etc/8192cu.ko
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
	/etc/init.d/wifi
	export HOME=/etc
	Signal=$(iwconfig wlan0 | grep Signal | cut -d "-" -f 2 | cut -d " " -f 1)
		if [ $Signal -le 80 ] > /dev/null; then
			killall -9 camera.sh record_video
			#kill -2 `pgrep record_video`
			# network restart
			#sleep 2
			#if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
			#rm -rf /var/run/wpa_supplicant
			#if pgrep dropbear; then killall -9 dropbear; fi
			#rmmod 8192cu
			#sleep 1
			#insmod /etc/8192cu.ko
			#wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
			#/etc/init.d/wifi
			#end network restart
			dropbear -B
			ntpd -q -p time.windows.com
			while [ `date +%Y` -le 2015 ]
			do
			sleep 3
			done
			hwclock --systohc
			#здесь запуск rsync
			echo heartbeat > /sys/class/leds/r_led/trigger
			sleep 1
			echo heartbeat > /sys/class/leds/g_led/trigger
			echo `hwclock` > /etc/on_`hostname`.txt
			find /mnt/`hostname` -name "*index" -exec rm {} \;
			# copy on.txt
			rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/on_`hostname`.txt root@$Server::video/Avtobus/`date +%Y%m%d`/
			# copy main files
			rsync -avm --no-o --no-g --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/`hostname`/ root@$Server::video/oneday/
			# copy log file
			rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@$Server::video/Avtobus/`date +%Y%m%d`/
			find /mnt/`hostname`/[2-9]* -type d -delete
			if [ -d /mnt/`hostname`/[2-9]* ]; then
			sync
			reboot
			fi
			/etc/init.d/wifi_led.sh r_led on
			/etc/init.d/wifi_led.sh g_led off
			# конец rsync
		else
		/etc/init.d/wifi_led.sh r_led on
		if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
		rm -rf /var/run/wpa_supplicant
		if pgrep dropbear; then killall -9 dropbear; fi
		rmmod 8192cu
		if [ ! `pgrep record_video` ]; then
		/etc/init.d/camera.sh &
		fi
		fi
else
		/etc/init.d/wifi_led.sh r_led on
		if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
		rm -rf /var/run/wpa_supplicant
		if pgrep dropbear; then killall -9 dropbear; fi
		rmmod 8192cu
		if [ ! `pgrep record_video` ]; then
		/etc/init.d/camera.sh &
		fi

fi

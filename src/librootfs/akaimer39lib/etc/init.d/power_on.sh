#!/bin/sh
AP=Avtobus
Server=10.10.10.1
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
insmod /etc/8192cu.ko
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
 /etc/init.d/wifi
 export HOME=/etc
 Signal=$(iwconfig wlan0 | grep Signal | cut -d "-" -f 2 | cut -d " " -f 1)
	if [ $Signal -le 85 ] > /dev/null; then
		killall -9 camera.sh record_video
		if pgrep dropbear; then killall -9 dropbear; fi
		sleep 3
		dropbear -B
		hwclock --systohc
		#здесь запуск rsync
		echo heartbeat > /sys/class/leds/r_led/trigger
		sleep 1
		echo heartbeat > /sys/class/leds/g_led/trigger
		echo `hwclock` > /etc/on_`hostname`.txt
		umount -l /mnt
		mount /dev/mmcblk0p1 /mnt
		find /mnt/ -name "*index" -exec rm {} \;
		# copy on.txt
		time=`date +%Y%m%d`
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/on_`hostname`.txt root@$Server::video/Avtobus/$time/
		ssh -i /etc/dropbear/dropbear_rsa_host_key root@$Server "bash -c '/root/dropbox_uploader.sh upload /mnt/hdd/Avtobus/$time/on_`hostname`.txt  /Avtobus/$time/`hostname`/on_`hostname`.txt'"
		# copy main files
		rsync -av --no-o --no-g --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/ root@$Server::video/oneday/
		# copy log file
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@$Server::video/Avtobus/$time/
		ssh -i /etc/dropbear/dropbear_rsa_host_key root@$Server "bash -c '/root/dropbox_uploader.sh upload /mnt/hdd/Avtobus/$time/`hostname`.txt  /Avtobus/$time/`hostname`/`hostname`.txt'"
		find /mnt/[2-9]* -type d -delete
		if [ -d /mnt/[2-9]* ]; then
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

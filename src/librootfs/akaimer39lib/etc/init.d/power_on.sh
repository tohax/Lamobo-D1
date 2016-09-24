#!/bin/sh
AP=bus
Server=10.10.10.2
find /mnt/`hostname` -name "*index" -exec rm {} \;
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
#/etc/init.d/wifi_led.sh g_led on
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
	/etc/init.d/wifi
	export HOME=/etc
	Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
		if [ $Signal -ge 30 ] > /dev/null; then
			if pgrep ash; then kill -TERM `pgrep ash` && kill -2 `pgrep record_video`; fi
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
			rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/on_`hostname`.txt root@10.10.10.2::video/Avtobus/`date +%Y%m%d`/
			rsync -avm --no-o --no-g --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/`hostname`/ root@10.10.10.2::video/oneday/
			#rsync -avrc --remove-source-files --log-file=/etc/rsync.txt -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /mnt/`hostname`/ root@$Server:/mnt/hdd/oneday/
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@10.10.10.2::video/Avtobus/`date +%Y%m%d`/
			#rsync -avR --remove-source-files -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /etc/rsync.txt root@$Server:/mnt/hdd/rsync/`hostname`/
			find /mnt/`hostname`/[1-9]* -type d -delete
			#rm -rf /mnt/`hostname`/*
			/etc/init.d/wifi_led.sh r_led on
			/etc/init.d/wifi_led.sh g_led off
			# конец rsync
		else
		/etc/init.d/wifi_led.sh g_led on
		if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
		rm -rf /var/run/wpa_supplicant
		if pgrep dropbear; then killall -9 dropbear; fi
		if [ ! `pgrep record_video` ]; then
		/etc/init.d/camera.sh &
		fi
		fi
else
		/etc/init.d/wifi_led.sh g_led on
		if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
		rm -rf /var/run/wpa_supplicant
		if pgrep dropbear; then killall -9 dropbear; fi
		if [ ! `pgrep record_video` ]; then
		/etc/init.d/camera.sh &
		fi

fi

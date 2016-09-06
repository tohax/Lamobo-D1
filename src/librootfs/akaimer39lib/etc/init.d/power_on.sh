#!/bin/sh
AP=bus
Server=10.10.10.2
find /mnt/`hostname` -name "*index" -exec rm {} \;
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/rsync.txt
#/etc/init.d/wifi_led.sh g_led on
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
	/etc/init.d/wifi
	export HOME=/etc
	Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
		if [ $Signal -ge 40 ] > /dev/null; then
			if pgrep ash; then kill -TERM `pgrep ash` && kill -2 `pgrep record_video`; fi
			dropbear -B
			ntpd -q -p time.windows.com
			while [ `date +%Y` -le 2015 ]
			do
			sleep 3
			done
			#здесь запуск rsync
			echo heartbeat > /sys/class/leds/r_led/trigger
			sleep 1
			echo heartbeat > /sys/class/leds/g_led/trigger
		rsync -av --no-o --no-g --remove-source-files --log-file=/etc/rsync.txt --password-file=/etc/.rsync /mnt/`hostname`/ root@10.10.10.2::video/oneday/
			#rsync -avrc --remove-source-files --log-file=/etc/rsync.txt -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /mnt/`hostname`/ root@$Server:/mnt/hdd/oneday/
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/rsync.txt root@10.10.10.2::video/rsync/`hostname`/
			#rsync -avR --remove-source-files -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /etc/rsync.txt root@$Server:/mnt/hdd/rsync/`hostname`/
			#rm -rf /mnt/`hostname`/*
			/etc/init.d/wifi_led.sh r_led on
			/etc/init.d/wifi_led.sh g_led off
			# конец rsync
		else
		/etc/init.d/wifi_led.sh g_led on
		ifdown wlan0
		/etc/init.d/power_off.sh
		fi
else
		/etc/init.d/wifi_led.sh g_led on
		ifdown wlan0
		/etc/init.d/power_off.sh
fi

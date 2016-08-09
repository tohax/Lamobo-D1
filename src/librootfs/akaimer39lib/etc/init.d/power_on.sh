#!/bin/sh
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/rsync.txt
echo 0 >/sys/class/leds/r_led/brightness
AP=bus
Server=10.10.10.2
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
	/etc/init.d/wifi
	export HOME=/etc
	Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
		if [ $Signal -ge 30 ] && ssh -i /etc/dropbear/dropbear_rsa_host_key root@$Server 'exit' > /dev/null; then
			if pgrep camera.sh; then killall -9 camera.sh; killall -9 record_video; fi
			dropbear -B
			ntpd -q -p time.windows.com
			while [ `date +%Y` -le 2015 ]
			do
			sleep 3
			done
			#здесь запуск rsync
			echo heartbeat > /sys/class/leds/r_led/trigger
			sleep 0.5
			echo heartbeat > /sys/class/leds/g_led/trigger
			rsync -avz --remove-source-files --log-file=/etc/rsync.txt -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /mnt/ root@$Server:/mnt/hdd/oneday/
			scp /etc/rsync.txt -i /etc/dropbear/dropbear_rsa_host_key root@10.10.10.2:/mnt/hdd/rsync/`hostname`/
			rm -f /etc/rsync.txt
			echo default-on > /sys/class/leds/r_led/trigger
			echo 0 > /sys/class/leds/g_led/brightness
			#конец rsync
		else
			/etc/init.d/power_off.sh
		fi
else
	/etc/init.d/power_off.sh
fi

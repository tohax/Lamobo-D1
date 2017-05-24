#!/bin/sh
AP=Avtobus
Server=10.10.10.1
echo -e  "\n---------------------------\n PowerOn `date +"%x"" ""%X"`\n---------------------------\n" >> /etc/`hostname`.txt
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP; then
/etc/init.d/wifi
sleep 3
export HOME=/etc
	if ping -c4 $Server > /dev/null; then
		if pidof camera.sh; then kill `pidof camera.sh`; fi
                if pidof record_video; then kill `pidof record_video`;fi
		echo 3 > /proc/sys/vm/drop_caches
		if pgrep dropbear; then kill `pgrep dropbear`; fi
		dropbear -R -B
		ntpd -q -p pool.ntp.org #time.windows.com
		sleep 10
		echo heartbeat > /sys/class/leds/r_led/trigger
		sleep 1
		echo heartbeat > /sys/class/leds/g_led/trigger
		time=`date +%Y%m%d`
		echo `date` > /etc/_ON_`hostname`.txt
		find /mnt/ -name "*index" -exec rm {} \;
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/_ON_`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
		rsync -av --no-o --no-g --remove-source-files --log-file=/etc/`hostname`.txt --password-file=/etc/.rsync /mnt/ root@$Server::video/oneday/
		rsync -av --no-o --no-g --remove-source-files --password-file=/etc/.rsync /etc/`hostname`.txt root@$Server::video/ya.disk/Avtobus/$time/
		if [[ -d /mnt/[1-9]* ]]; then find /mnt/[2-9]* -type d -delete; fi
		/etc/init.d/wifi_led.sh r_led on
		/etc/init.d/wifi_led.sh g_led off
	else
		/etc/init.d/wifi_led.sh r_led on
		if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
		if pgrep dropbear; then kill `pgrep dropbear`; fi
		rmmod 8192cu
		if [ ! `pidof record_video` ]; then
		/etc/init.d/camera.sh &
		fi
	fi
else
		/etc/init.d/wifi_led.sh r_led on
		if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
		if pgrep dropbear; then kill `pgrep dropbear`; fi
		rmmod 8192cu
		if [ ! `pidof record_video` ]; then
		/etc/init.d/camera.sh &
		fi
fi
